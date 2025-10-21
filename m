Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992F12737E7;
	Tue, 21 Oct 2025 19:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076558; cv=none; b=O7+M41YP/RXYmO8iqsEZBSkZO3dtuc+Z/PQBdP3mva9EX3XlM9KwBmbzj9WPbfk/30clM8pLTmakf3vjH4BTqnIzMu20Gyx/ziqjiU2KrCqxTmDNvcsqQu/4E4cS0GX1WCqVvexpu5Nm4cMCmLcWfh3rPUJvHqPEM8WLinw2jKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076558; c=relaxed/simple;
	bh=ExSU1DjHuJzI0UcFDp/bMKnzqO7zbB/dy80FVglzCOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izaU5f+2CcrVYWYHf8g+Eb1OVPyWrraw/pnbJxFaDi5k+RLQzd5hbAGuDf+MYQPJUMGgU3KauWglHve1TsawUPAKqfS6wGujcR6qMk7/wNk5vkFeVKxXm0V7jdlnCOx9Lvgfw8ivNg6EjK2XmkodIWB1oo4pkezWpqC6fs5iKOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dgby0rhl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dgby0rhl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A4EC4CEF7;
	Tue, 21 Oct 2025 19:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076558;
	bh=ExSU1DjHuJzI0UcFDp/bMKnzqO7zbB/dy80FVglzCOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dgby0rhlFU1sWAc3cuWHwPeEVqn9C73CxDhr4capb/5jlXDarKhg8dE6INTIoJLGI
	 uaXPbm+3jdqV5fGkaqQDJU6vdl3CaLOFwMROtlaneXluyAKsQ4FaRMDgGBt8VxrJt5
	 2lLpjGt+oXYvP6KbGjNTEjeycSinJMyVEoT8GYas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/105] ASoC: codecs: Fix gain setting ranges for Renesas IDT821034 codec
Date: Tue, 21 Oct 2025 21:51:04 +0200
Message-ID: <20251021195022.985126114@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 6370a996f308ea3276030769b7482b346e7cc7c1 ]

The gain ranges specified in Renesas IDT821034 codec documentation
are [-3dB;+13dB] in the transmit path (ADC) and [-13dB;+3dB] in the
receive path (DAC). Allthough the registers allow programming values
outside those ranges, the signal S/N and distorsion are only
guaranteed in the specified ranges.

Set ranges to the specified ones.

Fixes: e51166990e81 ("ASoC: codecs: Add support for the Renesas IDT821034 codec")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://patch.msgid.link/2bd547194f3398e6182f770d7d6be711c702b4b2.1760029099.git.christophe.leroy@csgroup.eu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/idt821034.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/idt821034.c b/sound/soc/codecs/idt821034.c
index 2cc7b9166e695..068a5448e273e 100644
--- a/sound/soc/codecs/idt821034.c
+++ b/sound/soc/codecs/idt821034.c
@@ -548,14 +548,14 @@ static int idt821034_kctrl_mute_put(struct snd_kcontrol *kcontrol,
 	return ret;
 }
 
-static const DECLARE_TLV_DB_LINEAR(idt821034_gain_in, -6520, 1306);
-#define IDT821034_GAIN_IN_MIN_RAW	1 /* -65.20 dB -> 10^(-65.2/20.0) * 1820 = 1 */
-#define IDT821034_GAIN_IN_MAX_RAW	8191 /* 13.06 dB -> 10^(13.06/20.0) * 1820 = 8191 */
+static const DECLARE_TLV_DB_LINEAR(idt821034_gain_in, -300, 1300);
+#define IDT821034_GAIN_IN_MIN_RAW	1288 /* -3.0 dB -> 10^(-3.0/20.0) * 1820 = 1288 */
+#define IDT821034_GAIN_IN_MAX_RAW	8130 /* 13.0 dB -> 10^(13.0/20.0) * 1820 = 8130 */
 #define IDT821034_GAIN_IN_INIT_RAW	1820 /* 0dB -> 10^(0/20) * 1820 = 1820 */
 
-static const DECLARE_TLV_DB_LINEAR(idt821034_gain_out, -6798, 1029);
-#define IDT821034_GAIN_OUT_MIN_RAW	1 /* -67.98 dB -> 10^(-67.98/20.0) * 2506 = 1*/
-#define IDT821034_GAIN_OUT_MAX_RAW	8191 /* 10.29 dB -> 10^(10.29/20.0) * 2506 = 8191 */
+static const DECLARE_TLV_DB_LINEAR(idt821034_gain_out, -1300, 300);
+#define IDT821034_GAIN_OUT_MIN_RAW	561 /* -13.0 dB -> 10^(-13.0/20.0) * 2506 = 561 */
+#define IDT821034_GAIN_OUT_MAX_RAW	3540 /* 3.0 dB -> 10^(3.0/20.0) * 2506 = 3540 */
 #define IDT821034_GAIN_OUT_INIT_RAW	2506 /* 0dB -> 10^(0/20) * 2506 = 2506 */
 
 static const struct snd_kcontrol_new idt821034_controls[] = {
-- 
2.51.0



