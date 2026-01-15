Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B1D2D640D;
	Thu, 15 Jan 2026 17:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496416; cv=none; b=WdlxQgnw9Wt4uL0+s/z/0ibDKMnjPnHietk8khr3PGSUt8C8fDa7ZxF3QFSlzvksYhRB8nkvE4ppIgfQh5iMxZnV2/n9I6wbtDc/V8DceD6Vaf6ae6pSqL67OZ+aDwNoaV73THTynu/r90+NT+GsjLQAnWoI3dVSvSH8wPHbjuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496416; c=relaxed/simple;
	bh=APM0nu4F2DRGi4IOwA3+mJoGkE+dY56TaR3yRlK9/oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqoexMT3Fcd/WosUp4xzLfS8kpzU2UJ0NsITjabPQrKCpfRGYjqMl3FD3CMlIouXmrLRpSEgaFB9yHwLZ5Jfibi7rBoSYXXjn6IabwjgobfEOmo7b71QSjEJmONrNerUQXo74REDSKvggn6xTAP8rhYPGdUFyyU+Gj3016pgZp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NsfT5CKC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NsfT5CKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCA5C16AAE;
	Thu, 15 Jan 2026 17:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496413;
	bh=APM0nu4F2DRGi4IOwA3+mJoGkE+dY56TaR3yRlK9/oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NsfT5CKCk/RYUI/WLKL2Oq2X/7aqHcVu8ktIM3KsBvqSTlaik6y0xOxrJ6/N4UWO2
	 WnXTK+36dn8gLUrcR+XC1NfnZUDRgQbQdvJyjIvrQSRDYy4/H6AidYpO0dHXGE1Bmq
	 k8KnYWR1fSr/h0eKhOTjWXVt9ZfxdIapvKY4XFDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 179/181] ASoC: fsl_sai: Add missing registers to cache default
Date: Thu, 15 Jan 2026 17:48:36 +0100
Message-ID: <20260115164208.776257229@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 90ed688792a6b7012b3e8a2f858bc3fe7454d0eb ]

Drivers does cache sync during runtime resume, setting all writable
registers. Not all writable registers are set in cache default, resulting
in the erorr message:
  fsl-sai 30c30000.sai: using zero-initialized flat cache, this may cause
  unexpected behavior

Fix this by adding missing writable register defaults.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://patch.msgid.link/20251216102246.676181-1-alexander.stein@ew.tq-group.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_sai.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 86730c2149146..2fa14fbdfe1a8 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -1081,6 +1081,7 @@ static const struct reg_default fsl_sai_reg_defaults_ofs0[] = {
 	{FSL_SAI_TDR6, 0},
 	{FSL_SAI_TDR7, 0},
 	{FSL_SAI_TMR, 0},
+	{FSL_SAI_TTCTL, 0},
 	{FSL_SAI_RCR1(0), 0},
 	{FSL_SAI_RCR2(0), 0},
 	{FSL_SAI_RCR3(0), 0},
@@ -1104,12 +1105,14 @@ static const struct reg_default fsl_sai_reg_defaults_ofs8[] = {
 	{FSL_SAI_TDR6, 0},
 	{FSL_SAI_TDR7, 0},
 	{FSL_SAI_TMR, 0},
+	{FSL_SAI_TTCTL, 0},
 	{FSL_SAI_RCR1(8), 0},
 	{FSL_SAI_RCR2(8), 0},
 	{FSL_SAI_RCR3(8), 0},
 	{FSL_SAI_RCR4(8), 0},
 	{FSL_SAI_RCR5(8), 0},
 	{FSL_SAI_RMR, 0},
+	{FSL_SAI_RTCTL, 0},
 	{FSL_SAI_MCTL, 0},
 	{FSL_SAI_MDIV, 0},
 };
-- 
2.51.0



