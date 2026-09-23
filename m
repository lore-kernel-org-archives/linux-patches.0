Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8D2332EC5;
	Wed, 23 Sep 2026 14:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174724; cv=none; b=Cc2JIrUTCJ7+ekmH45PqyBFTCS+BNON8q1GkYQPpn9S/pMPU8SUe872NOFHxb4I9G8t24/LOPM4kJ/vbr+5KaKNe4oL3/B0CVkD+sVC5jivoTGFpVNx+xrQI4Sanuv6YPkXABharft20VO8SkG8RaKLWMEAioDt4pgmh1e1PZwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174724; c=relaxed/simple;
	bh=Vad0Xoyu5sISXLQu/RCTWc5nrUMhKXpzXGN+pZOG5wU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxqLJZzgmkfVjRLZbJ8uukAYhBOp59Mil0oEcE3Av1PT7ALE1Zpl1S449kIJJLL0Qx5K1TXFuk/Uk4//ltHSC65HalTdFsbc8Od22+wpNlPQToeChZod5Z42gfBtGqIICQkI3GcySfQkv3FdBQion8D9yvvcDXgaJXfJTZJOi8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KaZRfDig; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KaZRfDig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140D81F000FF;
	Wed, 23 Sep 2026 14:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174722;
	bh=7O5qKwbw58XIRej9yiF4ae73oFWdtKztpAh9vMZ89jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KaZRfDigCVvDs4ZemBu64f+2zqMK/lGOTx1q7ITI1b5yb6wNTP/m9+7/GgnSF/MS/
	 4u5a+38QEe3r8B6ChDELBFoP8XRzjAkDm0pTYZWyQI2ZuwjWC0eJXzKYCZ6glRqJVq
	 dn/vYr725S4ybKCo6Gv4Ak96k24cyZQNYOERvyfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 174/398] ASoC: amd: acp: fix ffs() operator precedence for SoundWire link ID
Date: Wed, 23 Sep 2026 16:04:08 +0200
Message-ID: <20260923140647.941361932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 27098aaf28b96ab4e6891709062c343566d4882b ]

ffs(link_mask - 1) computes ffs on (link_mask - 1) instead of
subtracting 1 from the result of ffs(link_mask). For a typical
power-of-2 link_mask this returns the wrong link ID, causing cpu_pin_id
lookup to select the incorrect SoundWire manager.

Fix the operator precedence to ffs(link_mask) - 1 in both
acp-sdw-sof-mach.c and acp-sdw-legacy-mach.c.

Fixes: 6d8348ddc56e ("ASoC: amd: acp: refactor SoundWire machine driver code")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20260910161728.1452808-4-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-sdw-legacy-mach.c | 4 ++--
 sound/soc/amd/acp/acp-sdw-sof-mach.c    | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/amd/acp/acp-sdw-legacy-mach.c b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
index 1eebdaa2f80b9..53567fdf3e2d6 100644
--- a/sound/soc/amd/acp/acp-sdw-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
@@ -201,7 +201,7 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 
 		switch (amd_ctx->acp_rev) {
 		case ACP63_PCI_REV:
-			ret = get_acp63_cpu_pin_id(ffs(soc_end->link_mask - 1),
+			ret = get_acp63_cpu_pin_id(ffs(soc_end->link_mask) - 1,
 						   *be_id, &cpu_pin_id, dev);
 			if (ret)
 				return ret;
@@ -209,7 +209,7 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 		case ACP70_PCI_REV:
 		case ACP71_PCI_REV:
 		case ACP72_PCI_REV:
-			ret = get_acp70_cpu_pin_id(ffs(soc_end->link_mask - 1),
+			ret = get_acp70_cpu_pin_id(ffs(soc_end->link_mask) - 1,
 						   *be_id, &cpu_pin_id, dev);
 			if (ret)
 				return ret;
diff --git a/sound/soc/amd/acp/acp-sdw-sof-mach.c b/sound/soc/amd/acp/acp-sdw-sof-mach.c
index 5eeadeaf6453d..4081cccb9050c 100644
--- a/sound/soc/amd/acp/acp-sdw-sof-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-sof-mach.c
@@ -132,7 +132,7 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 		}
 		switch (amd_ctx->acp_rev) {
 		case ACP63_PCI_REV:
-			ret = get_acp63_cpu_pin_id(ffs(sof_end->link_mask - 1),
+			ret = get_acp63_cpu_pin_id(ffs(sof_end->link_mask) - 1,
 						   *be_id, &cpu_pin_id, dev);
 			if (ret)
 				return ret;
@@ -140,7 +140,7 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 		case ACP70_PCI_REV:
 		case ACP71_PCI_REV:
 		case ACP72_PCI_REV:
-			ret = get_acp70_cpu_pin_id(ffs(sof_end->link_mask - 1),
+			ret = get_acp70_cpu_pin_id(ffs(sof_end->link_mask) - 1,
 						   *be_id, &cpu_pin_id, dev);
 			if (ret)
 				return ret;
-- 
2.53.0



