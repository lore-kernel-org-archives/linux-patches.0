Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774359;
	b=tAo8ek6cVON4WTGd2EK68SP01GjAarNfHKYLKA/4nJD56d1FHvIXV1PDscw2Fxgc4D2Y
	 w94Hxh0dGnEiILZPit39aM1fgY/uZvjjDXhpk1BZgq/Zzhi43PohVZJmMBI2mynel0II4
	 owDanUp6n1MgvddkKINHn0mlhKsjfcthoarjJ+5JGYV3PNCJyJLcAB0mmaqLbIbN9FVEf
	 YLBaB340Djwbh1lv/P/Hc2PrAVUkD0ED4YojcV7WQvdcDIEkfq8gTet3bIafGcJ3aM5QT
	 h3EBPeDlVapz0CBDxNM05Sux+ZfBIs+qhHAPE+XwjYTwAneUTneUdKCCmeBN0lgdBiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774359;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RPJt8IJhM/dkz9Tx8QPnL1ejV0DCSF66+a9pJYMA0UU=;
	b=UTKCvKkQkVhjNiRELU8gaRRADR7vCXgLwvoaIx8ZdoEJey4AVmki+omb3LD7YcZgI/Sf
	 JAS7JIjPzVG+7HifIvAsAsWcm7Ixf5jk93f+7GkkQHRVg15RKj42cxNMmvvk7evhMIFvu
	 HGDYrrd4aU2Ixz/LpM0eG2sybDkjuSqVGS+mZWkGmlLTjX2j4/DbrBApSW6nYv97CZGHF
	 uo5h/TD/B9P09MAqFE7dw9/w02eeOBEZnoq4i3tAItvwMm+1NjMZZ6HxBJI3tHz9QvQ1z
	 sZKKWY7+hOPkkAB46J1RUgORL/1rlgiv4PrAvplFdjyTnbU2pd9RVJpKHWllGfiNVew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AcUz3jhv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C899606A31A;
	Fri, 23 Oct 2026 16:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AcUz3jhv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82481F031E0;
	Fri, 23 Oct 2026 16:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774359;
	bh=RPJt8IJhM/dkz9Tx8QPnL1ejV0DCSF66+a9pJYMA0UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AcUz3jhvX7VfUY7PWUYTBh2nuPNrwcCLQBBtwwGa7EfkQBPj9yJ960oGteZfGcw58
	 5SKD5nvxTbuPZQf4xbOqoIoI1spRqbo3KJTsm5vAe+2X0aIEUs2EhTEy2Oeprf1Ou6
	 77LUgrrOS6lhdFr0eMDJ527coJsY644Vnkcr+O/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gilberto Conde <gilbertorconde@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 015/242] pinctrl: qcom: ipq5018: add missing pwm3 function on gpio13
Date: Fri, 23 Oct 2026 18:37:37 +0200
Message-ID: <20261023163714.151298088@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gilberto Conde <gilbertorconde@gmail.com>

[ Upstream commit c6c159fcdb4e9a678eda0831f971e4a3a488ec47 ]

GPIO13 supports the PWM3 function at mux select value 4, but the
pingroup table leaves that slot empty and gpio13 is not listed in
pwm3_groups. Selecting pwm3 on gpio13 is therefore rejected by the
pinmux core:

  ipq5018-tlmm: invalid group "gpio13" for function "pwm3"

The GL.iNet GL-X2000 drives its fan from PWM3 on this pin, and the
vendor firmware muxes it with select value 4:

  gpio13 : out low  func4 8mA no pull

Add pwm3 to the fourth function slot of gpio13 and list gpio13 in
pwm3_groups. With this the pin muxes as expected:

  pin 13 (GPIO_13): device 1941010.pwm function pwm3 group gpio13

Fixes: 725d1c891658 ("pinctrl: qcom: Add IPQ5018 pinctrl driver")
Signed-off-by: Gilberto Conde <gilbertorconde@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260921093419.2870168-1-gilbertorconde@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-ipq5018.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-ipq5018.c b/drivers/pinctrl/qcom/pinctrl-ipq5018.c
index 03cfba9534f84..84392fe258c9f 100644
--- a/drivers/pinctrl/qcom/pinctrl-ipq5018.c
+++ b/drivers/pinctrl/qcom/pinctrl-ipq5018.c
@@ -563,7 +563,7 @@ static const char * const qdss_cti_trig_out_b1_groups[] = {
 };
 
 static const char * const pwm3_groups[] = {
-	"gpio45",
+	"gpio45", "gpio13",
 };
 
 static const char * const qdss_cti_trig_in_b1_groups[] = {
@@ -689,7 +689,7 @@ static const struct msm_pingroup ipq5018_groups[] = {
 	PINGROUP(10, blsp0_spi, blsp1_uart0, led0, gcc_plltest, qdss_tracedata_a, _, _, _, _),
 	PINGROUP(11, blsp0_spi, blsp1_uart0, _, gcc_tlmm, qdss_tracedata_a, _, _, _, _),
 	PINGROUP(12, blsp0_spi, blsp0_i2c, blsp1_uart0, _, gcc_plltest, qdss_tracedata_a, _, _, _),
-	PINGROUP(13, blsp0_spi, blsp0_i2c, blsp1_uart0, _, qdss_tracedata_a, _, _, _, _),
+	PINGROUP(13, blsp0_spi, blsp0_i2c, blsp1_uart0, pwm3, qdss_tracedata_a, _, _, _, _),
 	PINGROUP(14, pcie0_clk, _, _, cri_trng0, qdss_tracedata_a, _, _, _, _),
 	PINGROUP(15, _, _, cri_trng1, qdss_tracedata_a, _, _, _, _, _),
 	PINGROUP(16, pcie0_wake, _, _, cri_trng, qdss_tracedata_a, _, _, _, _),
-- 
2.53.0



