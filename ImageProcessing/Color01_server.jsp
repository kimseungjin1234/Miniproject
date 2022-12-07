<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.oreilly.servlet.*"%>
<%@ page import="com.oreilly.servlet.multipart.*"%>
<%@ page import="javax.imageio.*"%>
<%@ page import="java.awt.image.*"%>
<%@ page import="java.lang.Math"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Color Image Processing - Server (RC 1)</title>
</head>
<body>
	<%!///////////////////////
	// 전역 변수부
	///////////////////////
	int[][][] inImage;
	int inH, inW;
	int[][][] outImage;
	int outH, outW;
	File inFp, outFp;

	// Parameter Variable
	String algo, para1, para2;
	String inFname, outFname;

	///////////////////////
	// 영상처리 함수부
	///////////////////////
	public void reverseImage() { //반전
		// 반전 영상
		// (중요!) 출력 영상의 크기 결정 (알고리즘에 의존)
		outH = inH;
		outW = inW;
		outImage = new int[3][outH][outW];
		/// ** Image Processing Algorithm **
		for (int rgb = 0; rgb < 3; rgb++) {
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					outImage[rgb][i][k] = 255 - inImage[rgb][i][k];
				}
			}
		}
	}

	public void addImage() {//밝기조절
		// Add Image 영상
		// (중요!) 출력 영상의 크기 결정 (알고리즘에 의존)
		outH = inH;
		outW = inW;
		outImage = new int[3][outH][outW];
		/// ** Image Processing Algorithm **
		int value = Integer.parseInt(para1);
		for (int rgb = 0; rgb < 3; rgb++) {
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					if (inImage[rgb][i][k] + value > 255)
						outImage[rgb][i][k] = 255;
					else if (inImage[rgb][i][k] + value < 0)
						outImage[rgb][i][k] = 0;
					else
						outImage[rgb][i][k] = inImage[rgb][i][k] + value;
				}
			}
		}
	}

	public void mulImage() {//곱하기
		// (중요!) 출력 영상의 크기 결정 (알고리즘에 의존)
		outH = inH;
		outW = inW;
		outImage = new int[3][outH][outW];
		/// ** Image Processing Algorithm **
		int value = Integer.parseInt(para1);
		for (int rgb = 0; rgb < 3; rgb++) {
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					if (inImage[rgb][i][k] * value > 255)
						outImage[rgb][i][k] = 255;
					else if (inImage[rgb][i][k] * value < 0)
						outImage[rgb][i][k] = 0;
					else
						outImage[rgb][i][k] = inImage[rgb][i][k] * value;
				}
			}
		}
	}

	public void divImage() {//나누기
		// Add Image 영상
		// (중요!) 출력 영상의 크기 결정 (알고리즘에 의존)
		outH = inH;
		outW = inW;
		outImage = new int[3][outH][outW];
		/// ** Image Processing Algorithm **
		int value = Integer.parseInt(para1);
		for (int rgb = 0; rgb < 3; rgb++) {
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					if (inImage[rgb][i][k] / value > 255)
						outImage[rgb][i][k] = 255;
					else if (inImage[rgb][i][k] / value < 0)
						outImage[rgb][i][k] = 0;
					else
						outImage[rgb][i][k] = inImage[rgb][i][k] / value;
				}
			}
		}
	}

	public void paracap() {//파라볼라(캡)
		outH = inH;
		outW = inW;
		outImage = new int[3][outH][outW];
		//** Image Processing Algorithm **
		for (int rgb = 0; rgb < 3; rgb++) {
			for (int i = 0; i < outH; i++) {
				for (int k = 0; k < outW; k++) {
					outImage[rgb][i][k] = (int) (255 * Math.pow((inImage[rgb][i][k] / 127.0 - 1), 2));
				}
			}
		}
	}

	public void paracup() {//파라볼라(컵)
		outH = inH;
		outW = inW;
		outImage = new int[3][outH][outW];
		//** Image Processing Algorithm **
		for (int rgb = 0; rgb < 3; rgb++) {
			for (int i = 0; i < outH; i++) {
				for (int k = 0; k < outW; k++) {
					outImage[rgb][i][k] = (int) (255 - (255 * Math.pow((inImage[rgb][i][k] / 127.0 - 1), 2)));
				}
			}
		}
	}

	public void gammaImage() {//감마
		//감마
		outH = inH;
		outW = inW;
		// 메모리 할당
		outImage = new int[3][outH][outW];
		/// ** Image Processing Algorithm **
		double value = Integer.parseInt(para1);
		if (value < 0)
			value = 1 / (1 - value);
		else
			value += 1;

		//감마 변환
		for (int rgb = 0; rgb < 3; rgb++) {
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					double result = (Math.pow((double) (inImage[rgb][i][k] / 255.0), (double) (value)) * 255 + 0.5);
					if (result < 0)
						result = 0;
					else if (result > 255)
						result = 255;
					outImage[rgb][i][k] = (int) result;
				}
			}
		}
	}

	public void lrImage() { //좌우반전
		//영상 상하반전
		outH = inH;
		outW = inW;
		outImage = new int[3][outH][outW];

		//** Image Processing Algorithm **
		for (int rgb = 0; rgb < 3; rgb++) {
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					outImage[rgb][i][k] = inImage[rgb][inH - i - 1][k];
				}
			}
		}
	}

	public void udImage() {//상하반전
		//영상 상하반전
		outH = inH;
		outW = inW;
		outImage = new int[3][outH][outW];

		//** Image Processing Algorithm **
		for (int rgb = 0; rgb < 3; rgb++) {
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					outImage[rgb][i][k] = inImage[rgb][i][inW - k - 1];
				}
			}
		}
	}

	public void swapImage() {
		//영상이동
		int x = Integer.parseInt(para1);
		int y = Integer.parseInt(para1);
		outH = inH;
		outW = inW;
		outImage = new int[3][outH][outW];
		//** Image Processing Algorithm **
		for (int rgb = 0; rgb < 3; rgb++) {
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					if ((i + y) < outH && (k + x) < outW)
						outImage[rgb][i + y][k + x] = inImage[rgb][i][k];
					else
						break;
				}
			}
		}
	}

	public void embossImage() {
		// 엠보싱 알고리즘
		outH = inH;
		outW = inW;
		int[][] mask1 = { { -1, 0, 0 }, { 0, 0, 0 }, { 0, 0, 1 } };
		int[][][] tmpImage1 = new int[3][inH + 2][inW + 2];

		for (int rgb = 0; rgb < 3; rgb++)
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					tmpImage1[rgb][i][k] = 127;
				}
			}
		for (int rgb = 0; rgb < 3; rgb++)
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					tmpImage1[rgb][i + 1][k + 1] = inImage[rgb][i][k];
				}
			}

		// 메모리 할당
		outImage = new int[3][outH][outW];
		// 진짜 영상처리 알고리즘
		for (int rgb = 0; rgb < 3; rgb++)
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					int x = 0;
					for (int m = 0; m < 3; m++) {
						for (int n = 0; n < 3; n++) {
							x += mask1[m][n] * tmpImage1[rgb][i + m][k + n];
						}
					}
					x += 127;
					if (x > 255)
						x = 255;
					if (x < 0)
						x = 0;
					outImage[rgb][i][k] = x;
				}
			}
	}

	public void blurrImage() {
		outH = inH;
		outW = inW;
		double[][] mask2 = { { 1.0 / 9.0, 1.0 / 9.0, 1.0 / 9.0 }, { 1.0 / 9.0, 1.0 / 9.0, 1.0 / 9.0 },
				{ 1.0 / 9.0, 1.0 / 9.0, 1.0 / 9.0 } };
		int[][][] tmpImage2 = new int[3][inH + 2][inW + 2];

		for (int rgb = 0; rgb < 3; rgb++)
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					tmpImage2[rgb][i + 1][k + 1] = inImage[rgb][i][k];
				}
			}

		// 메모리 할당
		outImage = new int[3][outH][outW];
		// 진짜 영상처리 알고리즘
		for (int rgb = 0; rgb < 3; rgb++)
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					double x = 0.0;
					for (int m = 0; m < 3; m++) {
						for (int n = 0; n < 3; n++) {
							x += mask2[m][n] * tmpImage2[rgb][i + m][k + n];
						}
					}
					if (x > 255)
						x = 255;
					if (x < 0)
						x = 0;
					outImage[rgb][i][k] = (int) x;
				}
			}
	}

	public void gausImage() {
		// 가우시안 필터 알고리즘
		outH = inH;
		outW = inW;
		double[][] mask3 = { { 1.0 / 16.0, 1.0 / 8.0, 1.0 / 16.0 }, { 1.0 / 8.0, 1.0 / 4.0, 1.0 / 8.0 },
				{ 1.0 / 16.0, 1.0 / 8.0, 1.0 / 16.0 } };
		int[][][] tmpImage3 = new int[3][inH + 2][inW + 2];

		for (int rgb = 0; rgb < 3; rgb++)
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					tmpImage3[rgb][i + 1][k + 1] = inImage[rgb][i][k];
				}
			}

		// 메모리 할당
		outImage = new int[3][outH][outW];
		// 진짜 영상처리 알고리즘
		for (int rgb = 0; rgb < 3; rgb++)
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					double x = 0.0;
					for (int m = 0; m < 3; m++) {
						for (int n = 0; n < 3; n++) {
							x += mask3[m][n] * tmpImage3[rgb][i + m][k + n];
						}
					}
					if (x > 255)
						x = 255;
					if (x < 0)
						x = 0;
					outImage[rgb][i][k] = (int) x;
				}
			}
	}

	public void shapImage() {
		// 샤프닝 알고리즘
		outH = inH;
		outW = inW;
		double[][] mask4 = { { 0.0, -1.0, 0.0 }, { -1.0, 5.0, -1.0 }, { 0.0, -1.0, 0.0 } };
		int[][][] tmpImage4 = new int[3][inH + 2][inW + 2];

		for (int rgb = 0; rgb < 3; rgb++)
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					tmpImage4[rgb][i + 1][k + 1] = inImage[rgb][i][k];
				}
			}

		// 메모리 할당
		outImage = new int[3][outH][outW];
		// 진짜 영상처리 알고리즘
		for (int rgb = 0; rgb < 3; rgb++)
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					double x = 0.0;
					for (int m = 0; m < 3; m++) {
						for (int n = 0; n < 3; n++) {
							x += mask4[m][n] * tmpImage4[rgb][i + m][k + n];
						}
					}
					if (x > 255)
						x = 255;
					if (x < 0)
						x = 0;
					outImage[rgb][i][k] = (int) x;
				}
			}
	}

	public void EdgeImage() {
		// 경계선 검출 알고리즘
		outH = inH;
		outW = inW;
		double[][] maskW = { { -1.0, -1.0, -1.0 }, { 0.0, 0.0, 0.0 }, { 1.0, 1.0, 1.0 } };
		double[][] maskH = { { 1.0, 0.0, -1.0 }, { 1.0, 0.0, -1.0 }, { 1.0, 0.0, -1.0 } };
		int[][][] tmpImageW = new int[3][inH + 2][inW + 2];
		int[][][] tmpImageH = new int[3][inH + 2][inW + 2];
		int[][][] tmpImageW2 = new int[3][inH][inW];
		int[][][] tmpImageH2 = new int[3][inH][inW];

		for (int rgb = 0; rgb < 3; rgb++)
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					tmpImageW[rgb][i + 1][k + 1] = inImage[rgb][i][k];
					tmpImageH[rgb][i + 1][k + 1] = inImage[rgb][i][k];
				}
			}

		// 메모리 할당
		outImage = new int[3][outH][outW];
		// 진짜 영상처리 알고리즘
		for (int rgb = 0; rgb < 3; rgb++)
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					double x = 0.0, y = 0.0;
					for (int m = 0; m < 3; m++) {
						for (int n = 0; n < 3; n++) {
							x += maskW[m][n] * tmpImageW[rgb][i + m][k + n];
							y += maskH[m][n] * tmpImageW[rgb][i + m][k + n];
						}
					}
					int v = (int) Math.sqrt(x * x + y * y);
					if (v > 255)
						v = 255;
					else if (v < 0)
						v = 0;
					outImage[rgb][i][k] = v;
				}
			}

	}

	public void usaImage() {
		// 유사연산자 알고리즘
		outH = inH;
		outW = inW;
		int[][][] tmpImage6 = new int[3][inH + 2][inW + 2];

		for (int rgb = 0; rgb < 3; rgb++)
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					tmpImage6[rgb][i + 1][k + 1] = inImage[rgb][i][k];
				}
			}

		// 메모리 할당
		outImage = new int[3][outH][outW];
		// 진짜 영상처리 알고리즘
		for (int rgb = 0; rgb < 3; rgb++)
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					double max = 0.0;
					double x = 0.0;
					for (int m = 0; m < 3; m++) {
						for (int n = 0; n < 3; n++) {
							x = Math.abs(tmpImage6[rgb][i + 1][k + 1] - tmpImage6[rgb][i + m][k + n]);
							if (x >= max)
								max = x;
						}
					}
					if (max > 255)
						max = 255;
					if (max < 0)
						max = 0;
					outImage[rgb][i][k] = (int) max;
				}
			}
	}

	public void carImage() {
		// 차연산자 알고리즘
		outH = inH;
		outW = inW;
		int[][][] tmpImage7 = new int[3][inH + 2][inW + 2];

		for (int rgb = 0; rgb < 3; rgb++)
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					tmpImage7[rgb][i + 1][k + 1] = inImage[rgb][i][k];
				}
			}

		// 메모리 할당
		outImage = new int[3][outH][outW];
		// 진짜 영상처리 알고리즘
		for (int rgb = 0; rgb < 3; rgb++)
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					double max = 0.0;
					int x = 0;
					x = Math.abs(tmpImage7[rgb][i][k] - tmpImage7[rgb][i + 2][k + 2]);
					if (x >= max)
						max = x;
					x = Math.abs(tmpImage7[rgb][i][k + 1] = tmpImage7[rgb][i + 2][k + 1]);
					if (x >= max)
						max = x;
					x = Math.abs(tmpImage7[rgb][i][k + 2] = tmpImage7[rgb][i + 2][k]);
					if (x >= max)
						max = x;
					x = Math.abs(tmpImage7[rgb][i + 1][k + 2] = tmpImage7[rgb][i + 1][k]);
					if (x >= max)
						max = x;
					if (max > 255)
						max = 255;
					if (max < 0)
						max = 0;
					outImage[rgb][i][k] = (int) max;
				}
			}
	}

	public void LogImage() {
		// LOG 알고리즘
		outH = inH;
		outW = inW;
		int[][] mask8 = { { 0, 0, -1, 0, 0 }, { 0, -1, -2, -1, 0 }, { -1, -2, 16, -2, -1 }, { 0, -1, -2, -1, 0 },
				{ 0, 0, -1, 0, 0 } };
		int[][][] tmpImage8 = new int[3][inH + 4][inW + 4];

		for (int rgb = 0; rgb < 3; rgb++)
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					tmpImage8[rgb][i + 2][k + 2] = inImage[rgb][i][k];
				}
			}

		// 메모리 할당
		outImage = new int[3][outH][outW];
		// 진짜 영상처리 알고리즘
		for (int rgb = 0; rgb < 3; rgb++)
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					int x = 0;
					for (int m = 0; m < 5; m++) {
						for (int n = 0; n < 5; n++) {
							x += mask8[m][n] * tmpImage8[rgb][i + m][k + n];
						}
					}
					if (x > 255)
						x = 255;
					if (x < 0)
						x = 0;
					outImage[rgb][i][k] = x;
				}
			}
	}

	public void DogImage() {

		// DOG 알고리즘
		outH = inH;
		outW = inW;
		int[][] mask9 = { { 0, 0, -1, -1, -1, 0, 0 }, { 0, -2, -3, -3, -3, -2, 0 }, { -1, -3, 5, 5, 5, -3, -1 },
				{ -1, -3, 5, 16, 5, -3, -1 }, { -1, -3, 5, 5, 5, -3, -1 }, { 0, -2, -3, -3, -3, -2, 0 },
				{ 0, 0, -1, -1, -1, 0, 0 } };
		int[][][] tmpImage9 = new int[3][inH + 6][inW + 6];

		for (int rgb = 0; rgb < 3; rgb++)
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					tmpImage9[rgb][i + 3][k + 3] = inImage[rgb][i][k];
				}
			}

		// 메모리 할당
		outImage = new int[3][outH][outW];
		// 진짜 영상처리 알고리즘
		for (int rgb = 0; rgb < 3; rgb++)
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					int x = 0;
					for (int m = 0; m < 7; m++) {
						for (int n = 0; n < 7; n++) {
							x += mask9[m][n] * tmpImage9[rgb][i + m][k + n];
						}
					}
					if (x > 255)
						x = 255;
					if (x < 0)
						x = 0;
					outImage[rgb][i][k] = x;
				}
			}
	}

	public void LapImage() {

		// 라플라시안 알고리즘
		outH = inH;
		outW = inW;
		double[][] mask10 = { { 0.0, 1.0, 0.0 }, { 1.0, -4.0, 1.0 }, { 0.0, 1.0, 0.0 } };
		int[][][] tmpImage10 = new int[3][inH + 2][inW + 2];

		for (int rgb = 0; rgb < 3; rgb++)
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					tmpImage10[rgb][i + 1][k + 1] = inImage[rgb][i][k];
				}
			}

		// 메모리 할당
		outImage = new int[3][outH][outW];
		// 진짜 영상처리 알고리즘
		for (int rgb = 0; rgb < 3; rgb++)
			for (int i = 0; i < inH; i++) {
				for (int k = 0; k < inW; k++) {
					double x = 0.0;
					for (int m = 0; m < 3; m++) {
						for (int n = 0; n < 3; n++) {
							x += mask10[m][n] * tmpImage10[rgb][i + m][k + n];
						}
					}
					if (x > 255)
						x = 255;
					if (x < 0)
						x = 0;
					outImage[rgb][i][k] = (int) x;
				}
			}
	}
	
		public void ZoomOut(){
			// 이미지 확대 알고리즘
			outH = inH*Integer.parseInt(para1);
			outW = inW*Integer.parseInt(para1);
			// 메모리 할당
			outImage = new int[3][outH][outW];
			// 진짜 영상처리 알고리즘
			for (int rgb=0; rgb<3; rgb++)
				for(int i=0; i<outH; i++){
					for(int k=0; k<outW; k++){
						outImage[rgb][i][k] = inImage[rgb][i / Integer.parseInt(para1)][k / Integer.parseInt(para1)];
					}
				}

			}
	
		public void MyengImage(){
			// 명암 대비 알고리즘
			outH = inH;
			outW = inW;
			// 메모리 할당
			outImage = new int[3][outH][outW];
			int value = Integer.parseInt(para1);
			if(value>0){
				value = (value+10)/10;
				// 진짜 영상처리 알고리즘
				for (int rgb=0; rgb<3; rgb++)
				for(int i=0; i<inH; i++){
					for (int k=0; k<inW; k++) {
						int pixel = inImage[rgb][i][k];
						if (pixel > 127){
							if(pixel * value > 255 )
								pixel = 255;
							pixel *= value;
						}						
						else
							pixel /= value;
						outImage[rgb][i][k] = pixel;
					}
				}
			}
			else{
				value = -(value - 10) / 10;
				// 진짜 영상처리 알고리즘
				for (int rgb=0; rgb<3; rgb++)
				for(int i=0; i<inH; i++){
					for (int k=0; k<inW; k++) {
						int pixel = inImage[rgb][i][k];
						if (pixel > 127){
							if(pixel / value < 127 )
								pixel = 127;
							pixel /= value;
						}						
						else{
							if(pixel * value > 127);
								pixel /= value;
						}	
						outImage[rgb][i][k] = pixel;
					}
				}
			}
		}
	public void endInImage(){
		// 엔드인 알고리즘
		outH = inH;
		outW = inW;
		
		int low;
		int high;
		// 메모리 할당
		outImage = new int[3][outH][outW];
		
		low = inImage[0][0][0];
		high = inImage[0][0][0];
		
		// 진짜 영상처리 알고리즘
		for (int rgb=0; rgb<3; rgb++)
		for(int i=0; i<inH; i++){
			for(int k=0; k<inW; k++){
				int pixel = inImage[rgb][i][k];
				if(pixel < low)
					low = pixel;
				else if(pixel > high)
					high = pixel;
			}
		}
		low +=50;
		high -=50;
		for (int rgb=0; rgb<3; rgb++)
		for(int i=0; i<inH; i++){
			for(int k=0; k<inW; k++){
			int inValue = inImage[rgb][i][k];
			int outValue = (inValue - low)/(high-low)*255;
			if(outValue >255)
				outValue = 255;
			else if(outValue < 0)
				outValue = 0;
			outImage[rgb][i][k] = outValue;
			}
		}
	}
	

	%>
	<%
		///////////////////////
		// 메인 코드부
		///////////////////////
		// (0) 파라미터 넘겨 받기
		MultipartRequest multi = new MultipartRequest(request, "C:/Upload", 5 * 1024 * 1024, "utf-8",
				new DefaultFileRenamePolicy());

		String tmp;
		Enumeration params = multi.getParameterNames(); //주의! 파라미터 순서가 반대
		tmp = (String) params.nextElement();
		para1 = multi.getParameter(tmp);
		tmp = (String) params.nextElement();
		algo = multi.getParameter(tmp);
		// File
		Enumeration files = multi.getFileNames(); // 여러개 파일
		tmp = (String) files.nextElement(); // 첫 파일 한개
		String filename = multi.getFilesystemName(tmp);// 파일명을 추출

		// (1)입력 영상 파일 처리
		inFp = new File("c:/Upload/" + filename);
		BufferedImage bImage = ImageIO.read(inFp);

		// (2) 파일 --> 메모리
		// (중요!) 입력 영상의 폭과 높이를 알아내야 함!
		inW = bImage.getHeight();
		inH = bImage.getWidth();
		// 메모리 할당
		inImage = new int[3][inH][inW];

		// 읽어오기
		for (int i = 0; i < inH; i++) {
			for (int k = 0; k < inW; k++) {
				int rgb = bImage.getRGB(i, k); // F377D6 
				int r = (rgb >> 16) & 0xFF; // >>2Byte --->0000F3 & 0000FF --> F3
				int g = (rgb >> 8) & 0xFF; // >>1Byte --->00F377 & 0000FF --> 77			
				int b = (rgb >> 0) & 0xFF; // >>0Byte --->F377D6 & 0000FF --> D6
				inImage[0][i][k] = r;
				inImage[1][i][k] = g;
				inImage[2][i][k] = b;
			}
		}

		// Image Processing
		switch (algo) {
		case "101": //반전
			reverseImage();
			break;
		case "102": // 밝기조절
			addImage();
			break;
		case "103": // 곱하기
			mulImage();
			break;
		case "104": // 나누기
			divImage();
			break;
		case "105": //흑백
			divImage();
			break;
		case "106": // 파라볼라캡
			paracap();
			break;
		case "107": //파라볼라 컵
			paracup();
			break;
		case "108": // 감마조절
			gammaImage();
			break;
		case "109": // 좌우반전
			lrImage();
			break;
		case "110": // 상하반전
			udImage();
			break;
		case "111": // 영상 이동
			swapImage();
			break;
		case "112": // 엠보싱
			embossImage();
			break;
		case "113": // 블러링
			blurrImage();
			break;
		case "114": // 가우스블러
			gausImage();
			break;
		case "115": // 샤프닝
			shapImage();
			break;
		case "116": // 경계선검출
			EdgeImage();
			break;
		case "117": //유사 연산자 
			usaImage();
			break;
		case "118": //차 연산자
			carImage();
			break;
		case "119": // 로그이미지
			LogImage();
			break;
		case "120": // 도그 이미지
			DogImage();
			break;
		case "121": //라플라시안
			LapImage();
			break;
		case "122": // 확대
			ZoomOut();
		case "123": // 확대
			MyengImage();
		case "124": // 확대
			endInImage();
		

		//(4) 결과를 파일로 저장하기
		outFp = new File("c:/out/" + "out_" + filename);
		BufferedImage oImage = new BufferedImage(outH, outW, BufferedImage.TYPE_INT_RGB); // Empty Image
		//Memory --> File
		for (int i = 0; i < inH; i++) {
			for (int k = 0; k < inW; k++) {
				int r = outImage[0][i][k]; // F3
				int g = outImage[1][i][k]; // 77
				int b = outImage[2][i][k]; // D6
				int px = 0;
				px = px | (r << 16); // 000000 | (F30000) --> F30000
				px = px | (g << 8); // F30000 | (007700) --> F37700
				px = px | (b << 0); // F37700 | (0000D6) --> F377D6
				oImage.setRGB(i, k, px);
			}
		}
		ImageIO.write(oImage, "jpg", outFp);

		out.println("<h1>" + filename + " 영상 처리 완료 !! </h1>");
		String url = "<p><h2><a href='http://192.168.56.101:8080/";
		url += "GrayImageProcessing/download.jsp?file=";
		url += "out_" + filename + "'> !! 다운로드 !! </a></h2>";

		out.println(url);
	%>
</body>
</html>
