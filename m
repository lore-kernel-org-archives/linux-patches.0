Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773811;
	b=ma20TN2e8Qi+Ya5bIuPh5LaxmqsoBt9NfpFE1LTvN9Yh9r/70VyjsnZspk1PDe8RviPf
	 jXgPTX5uVMS22psXcfrlA1GCeWjUDy+6ubVz8+TpREr4X8b66YgnWNd6GZ2/qOtStaU8a
	 Wh3yd32KY3PQgeRNWb/pKS5Jbt4cdUvaYXrvJcodAlIP37CDOYCIT5Ffoo9BXEqIQpffw
	 R3vt5bkVHGgKffLcBchGkqBSnK6541tTuyM+KAIdVIK1Wj2CsB6RzbMg41HzgXArgu/nT
	 cDPVxTBy/foUYeb6TCKkb+CDCvm8uIJh3QqIgoWAsDRa+yNQuGrO0C54/t2qzLigotw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XbeDFA5oFt2TODcwfDu/gXyj53103h9HB79LKkYHs7g=;
	b=2RIbNiNDPdv95DfN2O+92lUm8Ji6AYuUB+8PNRhkJ2noz8/9HzIaHr3AOxein9vNNdDe
	 XcKK1LB8QypKZ09eh5b5fxFMr7sEUN8TzCAQ+S9+9ilnLFcBiY9GlNV1c9gFfBAe+cuop
	 /URFxuposyuAhu23zEdfdejxW/t37RfApUpzq/VLLgVGieK1/baZz8A6oRoUJxBw2nR7M
	 lzJIStQ8fNjzq8e+TDjlCfr0env5h9bNDOR6g5ntlQ9uyXFVx9X54OqwfBDZmdW+QPTsw
	 pCIC+uyJqgE5dd0C/ib0M44ntRb0L/HV/eg/G9QW4eH9WLYpst5O7PktXcfAmSEfdfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PjPSjY8S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FA1606A31A;
	Fri, 23 Oct 2026 16:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PjPSjY8S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA0A1F01825;
	Fri, 23 Oct 2026 16:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773810;
	bh=XbeDFA5oFt2TODcwfDu/gXyj53103h9HB79LKkYHs7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PjPSjY8SGLQ3G1qwY9Mt6LN1ouTd70aTn03o9McWDAMuoU1DbQYgZuZjFN+Ypuxsr
	 xVaHtr5TzjyUKRFdAjOJ4xEB8ZLdUKHXaM2etShbQ9A27Sdk3nDB5tYDIytPdvfg5w
	 s5l8Rqosy5/VqURgM7UTXEKi/1mdZMBOQxSak3n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adriel Santos <adriel@adriel.eu>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 024/193] pinctrl: qcom: ipq5018: replace gcc_plltest with pwm2 on gpio12
Date: Fri, 23 Oct 2026 18:35:01 +0200
Message-ID: <20261023163714.774377222@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adriel Santos <adriel@adriel.eu>

[ Upstream commit 709ba1c547eaf37da36ded2ecf3ea4e304cdfa9a ]

The pingroup table has gcc_plltest at function 5 of gpio12 and does not
offer pwm2 on that pin, so the pinmux core rejects a request for pwm2 on
gpio12 as an invalid group. On the hardware, function 5 of gpio12
carries the PWM2 output: the Xiaomi AX3000T v2 drives its blue status
LED from PWM2 on gpio12.

The vendor kernel shipped on that router (Linux 4.4, stock firmware
2.0.28) has pwm2 in this slot. Its pingroup table, as read from the
firmware image, lists these functions for gpio12:

  gpio, blsp0_spi, blsp0_i2c, blsp1_uart0, _, pwm2, qdss_tracedata_a,
  _, _, _

and has pwm3 at function 4 of gpio13, matching commit c6c159fcdb4e
("pinctrl: qcom: ipq5018: add missing pwm3 function on gpio13").

Measured on the board: with gpio12 set to each of the 16 function
values in turn, and PWM2 held at 0% and then at 100% duty, the pad
level read back from GPIO_IN follows PWM2 only at function 5. There it
does not follow PWM channels 0, 1 or 3, and the LED switches with PWM2.
Functions 4 and 7, which the table leaves empty, do not carry PWM2.

Put pwm2 in function 5 of gpio12 and list gpio12 in pwm2_groups. Drop
gpio12 from gcc_plltest_groups: none of its functions is gcc_plltest
any more, and selecting it would trigger the WARN_ON() in
msm_pinmux_set_mux().

Fixes: 725d1c891658 ("pinctrl: qcom: Add IPQ5018 pinctrl driver")
Assisted-by: LLM
Signed-off-by: Adriel Santos <adriel@adriel.eu>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20261002160958.908424-1-adriel@adriel.eu
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-ipq5018.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-ipq5018.c b/drivers/pinctrl/qcom/pinctrl-ipq5018.c
index 4e1f033ee2d62..c6e52615b36ec 100644
--- a/drivers/pinctrl/qcom/pinctrl-ipq5018.c
+++ b/drivers/pinctrl/qcom/pinctrl-ipq5018.c
@@ -363,7 +363,7 @@ static const char * const blsp1_uart0_groups[] = {
 };
 
 static const char * const gcc_plltest_groups[] = {
-	"gpio10", "gpio12",
+	"gpio10",
 };
 
 static const char * const gcc_tlmm_groups[] = {
@@ -557,7 +557,7 @@ static const char * const qdss_cti_trig_in_b0_groups[] = {
 };
 
 static const char * const pwm2_groups[] = {
-	"gpio44",
+	"gpio12", "gpio44",
 };
 
 static const char * const qdss_cti_trig_out_b1_groups[] = {
@@ -690,7 +690,7 @@ static const struct msm_pingroup ipq5018_groups[] = {
 	PINGROUP(9, sdc1_clk, qspi_clk, _, qdss_tracedata_a, _, _, _, _, _),
 	PINGROUP(10, blsp0_spi, blsp1_uart0, led0, gcc_plltest, qdss_tracedata_a, _, _, _, _),
 	PINGROUP(11, blsp0_spi, blsp1_uart0, _, gcc_tlmm, qdss_tracedata_a, _, _, _, _),
-	PINGROUP(12, blsp0_spi, blsp0_i2c, blsp1_uart0, _, gcc_plltest, qdss_tracedata_a, _, _, _),
+	PINGROUP(12, blsp0_spi, blsp0_i2c, blsp1_uart0, _, pwm2, qdss_tracedata_a, _, _, _),
 	PINGROUP(13, blsp0_spi, blsp0_i2c, blsp1_uart0, pwm3, qdss_tracedata_a, _, _, _, _),
 	PINGROUP(14, pcie0_clk, _, _, cri_trng0, qdss_tracedata_a, _, _, _, _),
 	PINGROUP(15, _, _, cri_trng1, qdss_tracedata_a, _, _, _, _, _),
-- 
2.53.0



