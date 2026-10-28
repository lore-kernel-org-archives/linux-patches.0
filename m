Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207462;
	b=IsXZ2AmeJeblB45hm7SeKZrJWJan79/w/4fFGjKhLJqNwxrIT4ifI3yzFFMubME3/zls
	 mHmPh3XzDo+Y0iUtKkRu82uvx0MFgza923hSCb/gz0RrAtK3n/rIiE8zY3uEXyscVc1wv
	 m3s871Sg/a98E3vlFiWLdN9iq36wCYRggvUFbFWmOANmEISTmU/2+PmkZAJZrk3CdLrGm
	 9CRAPZ4vVd83Nty9ZvTPDw86EJBFvr3hatASzUeUdupXK+etHdiVk0ePQUboY5ph8Wa2H
	 UCJzCXHavlISeTxPG1s/ZHMZbTfz8KoAiguGJ61iV03kEfKCH/1q2QQMCUyNxYkmawA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y4suVTT+3U1bX9t9B7XuJ3f4V+vRZixs4onf6j6k2Xk=;
	b=FQ/D3PUTgXi4zfyD/N8p4ap6QanH5zZwAD+vXp/rHnjNQWd2YsMGz2H+p/W8F6qJ68bG
	 8sYMixqlj3yfPIpqyg2zLBwcokJ7hUYSyxF2qqtfsvrUigXwE8gUB16/1XItOiWLlJqjK
	 ACyhsmFyBGnW7W334Tlp9W57YcrVJ5HARBK6ixfoMo5vE67/YUWN2Y3bQQ7HjQzxLlc8y
	 gmHelsSM/aTqvkXClJ7jQTMh8VqbX2tTvyFou5XbZ+CBf9q6eXhrmJusWZC9DjOxrMhm+
	 +IuFob818RjWRF+FMeCSW4ZGaLwyDShRerPRW/4PS103OfxmipUXoICxzBkT86a+dUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fEQfeE9N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741FC606A31A;
	Wed, 28 Oct 2026 17:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fEQfeE9N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86991F01825;
	Wed, 28 Oct 2026 17:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207462;
	bh=y4suVTT+3U1bX9t9B7XuJ3f4V+vRZixs4onf6j6k2Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fEQfeE9N1pJWbS9vNY1DcLRF4/wmSCT9bTAGIrD2fqvRaa0ksdWvWsI1AhhwhTRF0
	 mB3dzhb5E+QnYtrWEMUca2o66dwY1dhg5sYxm0NWlk/jghe4zVIl7ItreLAy7dgYlH
	 7mivKiHjSIzBjX7YJQQ/CAAOHEIA5ntgFQzrth7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adriel Santos <adriel@adriel.eu>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/247] pinctrl: qcom: ipq5018: replace gcc_plltest with pwm2 on gpio12
Date: Wed, 28 Oct 2026 17:57:08 +0100
Message-ID: <20261028165947.962418090@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



