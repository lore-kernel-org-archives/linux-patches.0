Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91F437647B;
	Tue, 21 Jul 2026 17:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653429; cv=none; b=KmVm5pbvn5fr9DE+PrIQbGBg5nL/CgTbusLGeVp2nguVJoeNtUDeKKKXE/fjcbmJ8uWJFSmksJ/sYAntaWe0l2ZMpRg7KAB7vjYicKIt/Oas0YkveQub+P5izhNdITv228+mcP6XwsInA2PzL6bzZoy3olf/482KfjLZpRD1ekU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653429; c=relaxed/simple;
	bh=8McXY5oB8Asq9aIw4UvAglNmJ5qJbZ4qzy7xNHzAlUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AbF+EabFO4Zxywd1qEABawFF006oQE4l/SRpDXwngboNOYaeDlaZR8slMggG1uvzAVspoRnkwyHHijN4bYEY1zj1KMiiAbjlTVatJqYZN+p03/Hi+EhvpUaotfVGH4aoUKceio01lXc0cQlJmixzFXlCFYkBCRmo8E7D+VoUTh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PJ1YGXY4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJ1YGXY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB641F000E9;
	Tue, 21 Jul 2026 17:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653427;
	bh=FLA6nQ1FgkLrCuNjukyUeuq9DHXIYvih7CPiH6iTWVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PJ1YGXY4QOjhwtNZ3EWIyt6n9DYvB3iAdlNv9Gs+3etRgA2gBLr6gX1Kdp+N/xkAg
	 xYxSpg3eLhcD6YVRK36WXI7YklHhhfOi9s2JoIJ+gEaX0JKA2ZlPF3R5f2m48MSMYb
	 H0TP2mEv6HorvpOWC280h//cX6oews3CTRnAKLUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1322/2077] ASoC: codecs: lpass-va-macro: Fix LPASS Codec Version for SC7280
Date: Tue, 21 Jul 2026 17:16:35 +0200
Message-ID: <20260721152623.998922780@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 0773610eef71c30df3cb4c113c8215625d2a7c23 ]

According to both the static definition in downstream...

  yupik-audio-overlay.dtsi: qcom,bolero-version = <4>;
  #define BOLERO_VERSION_2_0 0x0004)

and the runtime detection:

  CDC_VA_TOP_CSR_CORE_ID_0=0x1
  CDC_VA_TOP_CSR_CORE_ID_1=0xf

SC7280 has LPASS Codec Version 2.0 and not, as declared with
sm8250_va_data LPASS_CODEC_VERSION_1_0.

Create new va_macro_data with .version not set to use the runtime
detection and correctly get .version = LPASS_CODEC_VERSION_2_0.

Fixes: 77212f300bfd ("ASoC: codecs: lpass-va-macro: set the default codec version for sm8250")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260526-sc7280-va-macro-2-0-v1-1-2c1b572fa388@fairphone.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-va-macro.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/lpass-va-macro.c b/sound/soc/codecs/lpass-va-macro.c
index 528d5b167ecffe..58a5798823d7fd 100644
--- a/sound/soc/codecs/lpass-va-macro.c
+++ b/sound/soc/codecs/lpass-va-macro.c
@@ -244,6 +244,11 @@ static const struct va_macro_data sm8250_va_data = {
 	.version = LPASS_CODEC_VERSION_1_0,
 };
 
+static const struct va_macro_data sc7280_va_data = {
+	.has_swr_master = false,
+	.has_npl_clk = false,
+};
+
 static const struct va_macro_data sm8450_va_data = {
 	.has_swr_master = true,
 	.has_npl_clk = true,
@@ -1755,7 +1760,7 @@ static const struct dev_pm_ops va_macro_pm_ops = {
 };
 
 static const struct of_device_id va_macro_dt_match[] = {
-	{ .compatible = "qcom,sc7280-lpass-va-macro", .data = &sm8250_va_data },
+	{ .compatible = "qcom,sc7280-lpass-va-macro", .data = &sc7280_va_data },
 	{ .compatible = "qcom,sm6115-lpass-va-macro", .data = &sm8450_va_data },
 	{ .compatible = "qcom,sm8250-lpass-va-macro", .data = &sm8250_va_data },
 	{ .compatible = "qcom,sm8450-lpass-va-macro", .data = &sm8450_va_data },
-- 
2.53.0



