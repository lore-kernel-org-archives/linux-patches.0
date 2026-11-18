Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017403;
	b=vhwOmvUhRBeDR52g/vwGcL4a8tcIyATnqZJ9LiAlheimisdNnCzzBDFm2FiWd5RZkhOa
	 RxJGTMLB3kNO6VudOzIciq8M7a6MpXCxrekY+8OO5+Fisw6T2YFhIWuuN1fhlTvmPfLV4
	 GAoMH27LzNI6Awgqf/zJ5CruoGSIKB1jFl0sdHSPVITOthuvjOgratolUGZFh+JoPNEER
	 c9cqul+WLTx4ZeJJmKC2Rg2gA8F0aRI4E4frgDUqOnxaKDjp/XSmuLx/7uup6twfuuFfr
	 AKvfjrKA9I2hIP3zGd8jQ/ZL5T/0QT4KA66qoExPkI6ZvK9LBBV3a5QvbNiCaukRw9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M1BGve7hvS4akwMbYmuHe3vDdula1pCBlQ2t61oCZ24=;
	b=TEeVq2VXNEi3AzxIlBjiEJhvrHfwGPYULZvVCwx40jPhp6ChM2ZIm8uekzmwLJn7wHAo
	 OPNwIEXL4gyPN8YOftVAC2VoeWDtef56H4Xp3BuF4CNC/5I1XA1eeFkn83bgZCvRBwgRK
	 iV4BS4PHv/9PrlxS8WeMVXpH37QivyufXjTIisbmc6y1rWSuV8jzMn39LfvZzfvAMHd+o
	 rUUDIIATlg5b8gug+eHVTbv1m/G2eL6tzYwymW3j6UdoxGanOEGQS5GgZ1HNOu/fflGoK
	 XorwrCNjq2cGA+SI4UCFkfip5JCwYBQ9sW+VjiRK5Y/9AXIR4sKtLY8VSsF8tdRlZTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WzZv5WX3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73A1606A330;
	Wed, 18 Nov 2026 15:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WzZv5WX3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 419431F000C4;
	Wed, 18 Nov 2026 15:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017402;
	bh=M1BGve7hvS4akwMbYmuHe3vDdula1pCBlQ2t61oCZ24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WzZv5WX3scrImdWhvUVKK/peX6e8HPiIlWg8MC3Fm+SagvcavGWrVd4plR/lix6TI
	 74TD1yPD3hC26pGVcoGMxObOGwmafjrafsayGWJDR3rSbJuPKKMtLE6cjapNllDoDz
	 bOgMwOt/K6PUDEBrr++oON8SvcafEO6Bd+U/WaJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0832/2651] arm64: dts: qcom: x1-crd: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:34:32 +0100
Message-ID: <20261118150317.836809340@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 099cd579fa73c142fde2f7e3ea473f334792a249 ]

GPIO 65 from TLMM is connected to the embedded controller's active-high
reset line. Asserting it causes the fans to run at full speed during
reset and leaves the keyboard non-functional afterwards.

Reserve it to prevent Linux from requesting or reconfiguring it.

Fixes: bd50b1f5b6f3 ("arm64: dts: qcom: x1e80100: Add Compute Reference Device")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922-dts-qcom-hamoa-reserve-ec-reset-gpio-v3-1-fde7f8a53382@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1-crd.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1-crd.dtsi b/arch/arm64/boot/dts/qcom/x1-crd.dtsi
index 60db83b8985fe..d1bed84725e89 100644
--- a/arch/arm64/boot/dts/qcom/x1-crd.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1-crd.dtsi
@@ -1531,6 +1531,7 @@ right_tweeter: speaker@0,1 {
 &tlmm {
 	gpio-reserved-ranges = <34 2>, /* Unused */
 			       <44 4>, /* SPI (TPM) */
+			       <65 1>, /* EC reset */
 			       <238 1>; /* UFS Reset */
 
 	ec_int_n_default: ec-int-n-state {
-- 
2.53.0



