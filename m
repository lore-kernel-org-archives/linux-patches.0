Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209911;
	b=y4uJ4IDGfm7rB8N1tdnuGQy12uUbWgKgIbRjaxb85VPLGcFBx7FowmfB+Ai+Jx9jjZQI
	 8F3eMlSna1AD5btnVxuT2ysMq+WcNKk944ubYV86lSCCyNJlUQE07F4G7ZHIdJDqnk+UX
	 Ac57oKhRukuSsO8kToP+e+7pPiCmRzFZjOR7E8xMkTqsc1fsOAAK/N4CvUc+c1ScqKuiC
	 ddGoKr+OubwN1h9iPL/VSNIrKaqrSVUqmZhT1Zquq+1kzsUNj8nC45yk2VIUF1HzKcjiI
	 7mQ68kg7qWxsvjg5XVbT8CD/8XG9eXwPrYOVNdzjsLPjlKkbvDcVZXZIsTlIvRDFLdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209911;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4l4Ag+PIEvBel36pVNKf3SV5Oxx8+gZP7PrICmMG30I=;
	b=XL/UEqMziLCc+f+WIGuNu1XBSg7Pfl1waP9I1pHP/UFFtcI40W9nM0VcLdIjrNrnQ/pm
	 ii/zFBh8ySUXAonyDr2glqSKuzwgWOa35bKAt+KSDSoQf86OAFMshTdMx2VwJ771rYLSd
	 Z/JNhRPoQTbT0jlxzAyqb77UYr0LmMxwcP/QWCBxIsVn41EUshrBZbYLAyVzPcg60laAq
	 QE6gpMpFdrccvh1s3s8eATfUMEjX1dhstQ1rbDrcNeqE1AdqutbJdOwi2mTqfv4dvXhY2
	 r1TDnFqXhinbyH4GnEmHybcR75Zk6n3MNzZs97fFxz5EN6ykKfQzuWvqGJcucN5k2wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="aFnO/mmr";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1EB606A322;
	Wed, 28 Oct 2026 17:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aFnO/mmr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8C21F031E0;
	Wed, 28 Oct 2026 17:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209911;
	bh=4l4Ag+PIEvBel36pVNKf3SV5Oxx8+gZP7PrICmMG30I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aFnO/mmrjrY00bAVtGMz40IMurEOVve5NuEBZH0UOEaS5Gw7+UF5/3yDI2PImDkxX
	 ZDUlXj8F+b03vGW8LMIIbEqNQo5hotgtnH6aIK5EQxUEwEurp5RnW4CboIfiPabxbq
	 FWzQZpXWIrbBVKiozP9UxklW8n3FTzGZfFITwhvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adriel Santos <adriel@adriel.eu>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/168] pinctrl: qcom: ipq5018: replace gcc_plltest with pwm2 on gpio12
Date: Wed, 28 Oct 2026 17:59:07 +0100
Message-ID: <20261028165943.365137745@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 18e68f7185bd5..2bbc409924f8b 100644
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



