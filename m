Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8060B392811
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301013; cv=none; b=d6HjtFDs2fHAD/llIf17P585hvwdD3OPCMDbJIYhHbQMpX667zrqz0LdumMKxDlk30lqYAiif3c1Qpqw4KJEkdeo82JEzSzAdXd7Dmfie6Ep2iYeLRVNXt1H1s2vPH3SZzev0AMgdHlv6pIhEqDj1xQmySADYzlaCHi44TbzclU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301013; c=relaxed/simple;
	bh=NdXViqIbCeFA1neOMXmS37bkZswVpAtJBaOwzenjfL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcUx2MlevnuC/gZCBqAuEtEYtlL73wUxqmk69MFULyRW3WU420QucwxOmxjwuvbXf8/T9sM+WUMK4FT3VE1teDn5C+olE2rw1zbX+e0BOYfgHTyKRZcVwzvc2WKbsaeCNplZISNDX/UjYN4CiN1kiWF62FJcgmODIomrLQCE6ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fjUcdJHO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fjUcdJHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2A8C19423;
	Sat, 28 Feb 2026 17:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301013;
	bh=NdXViqIbCeFA1neOMXmS37bkZswVpAtJBaOwzenjfL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjUcdJHOZ2DA7RwAH7g6Z4UhKwpyDKFXxHJVAkZwAccnvEfD/TLmh4PeHw+/0WYZE
	 w45Fa+EMN5ghqHT/vQ9Z/G/pwl70YYrKVEVOdsSU3NSKojC9nOGXZUjovqocGgTrqd
	 QXALzTrN5mgY271mbxTWcid3xP6HdD5bLUN4zSzgHtatuquL0QIWoShIIeZMJRHijd
	 2W9eboMtgYNfjpgNPoQb7NDWmubws4iWllqBMGlo+CAuMYMMn02FSyU8Tgg1GRksmE
	 CMjBLRUKhDXPuTWNmK66cHKSqucis5YT/883PzsOajKXu3BG+bUjnHA8Db2UUf9p9J
	 wBIelkjsZtPJA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 148/752] ASoC: wm8962: Add WM8962_ADC_MONOMIX to "3D Coefficients" mask
Date: Sat, 28 Feb 2026 12:37:39 -0500
Message-ID: <20260228174750.1542406-148-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

[ Upstream commit 66c26346ae30c883eef70acf9cf9054dfdb4fb2f ]

This bit is handled by a separate control.

Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260105-wm8962-l5-fixes-v1-1-f4f4eeacf089@puri.sm
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8962.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index 08c8ec3aeb449..6491e098bd212 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -1760,7 +1760,7 @@ SND_SOC_BYTES("EQR Coefficients", WM8962_EQ24, 18),
 
 
 SOC_SINGLE("3D Switch", WM8962_THREED1, 0, 1, 0),
-SND_SOC_BYTES_MASK("3D Coefficients", WM8962_THREED1, 4, WM8962_THREED_ENA),
+SND_SOC_BYTES_MASK("3D Coefficients", WM8962_THREED1, 4, WM8962_THREED_ENA | WM8962_ADC_MONOMIX),
 
 SOC_SINGLE("DF1 Switch", WM8962_DF1, 0, 1, 0),
 SND_SOC_BYTES_MASK("DF1 Coefficients", WM8962_DF1, 7, WM8962_DF1_ENA),
-- 
2.51.0

