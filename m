Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0658528E;
	Tue, 21 Oct 2025 20:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076895; cv=none; b=kWgfaBxSXUhw7y4CBBi6AW+QXmBcX9TvKSvbzzXmmutrOdFNarRAHPMLXjFFK9Adb1+Mkd/ffL+qNSWreAf7EmKtAeRlxmT7cmpsrSs3lOttCmd9zt90rOh9nPwYuClpE4SPLRbNpVh5WPVQ8Ub7MaIJS+Y5lnJde55gCfODHMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076895; c=relaxed/simple;
	bh=TV3xv+NAvv3cVfZNdmZwD/ZoIxFiTqlxEM+JZdtVwTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWgcFbLxWNpFmRIf4rBNkYsm2waQt2nmRjawiyUM7QqgZ64e6U83LXQ1Um6QQSUsQx4txS0ytQ+VtoA3o8kDv5/h/+KKJj+uIGqsZ5Ky3mZPp88P12XEN60AsWIbAJ9Fcs4gd2u5NZb4VcSKTsCRmwc0+n13AmjPvnQx18X0U/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u3qyW3i/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u3qyW3i/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C51C4CEF1;
	Tue, 21 Oct 2025 20:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076894;
	bh=TV3xv+NAvv3cVfZNdmZwD/ZoIxFiTqlxEM+JZdtVwTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u3qyW3i/locDH/6kJloRB5E+1QuhW9LdBX8AQDgHeKrtDmbZeXKVIbPK8vR9zOOXj
	 RWXcTEHKZoJ9FTpyR8eRYlMql34UaiTmwaiLMgYuc8gIq/NTclU57TQUek4sbnEQyq
	 jnCUJznyyd/3ykLff7eRpQPQQX2nQ8H4+udY62IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 071/136] ASoC: codecs: Fix gain setting ranges for Renesas IDT821034 codec
Date: Tue, 21 Oct 2025 21:50:59 +0200
Message-ID: <20251021195037.680566241@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cb7a68c799f8f..401d0897b8ab4 100644
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



