Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD74C31AF1F;
	Tue, 13 Oct 2026 12:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895532; cv=none; b=in4L/CcsTzslny3XglagFADfm+893Xv+Id2nzokQuA1pe/s5qOtdDdJvADQh2IhNodjbqB3B1PwAJVlirf5TYCf7X5pip9Udc6qSxfepvdi1ikxTQShLdaEl2fsrPX1dedsfCJXm2DSWYKZC0e14Wl+0c7LqJ9r73lQWV9liiPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895532; c=relaxed/simple;
	bh=pEOpVTtpUtLoVKNfOfvrfNOBc7Y2HnKfykMUB17RYLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8sPXdoGx9XmLb6jc0EoEYht0CMm52KSxVhfvDR5DxF3ELndYl/+iccN/euhloR5pmPS+lpDLVkQiDr0+zaVoTwnH3fwy7DoOaJ7aXv1Sxtv1hHUx7aYx5tzTL3kvWZAhmbA/oo0yz3aWB5p9scntf3Okap6vUtfjcN9MOkctWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6byYq8/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6byYq8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF411F000FF;
	Tue, 13 Oct 2026 12:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895531;
	bh=hH2N/UMaYKm70fFd3OcIXL1V/3EqS422OblT1uTDdpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F6byYq8/alDBXsBIS1tahsHbguzC6DqZykiZXAJzamyuLlls67fono97uBQM2u9Jm
	 Tw16EQd8w/EgcT2HGxXJRKNC4yg9FZef+1wgdhEqCVaGXPlawS8W1BNB66jW+pec4K
	 oSMw+/jR72ib17uT5aeplSOmVektpX4yg92o3lsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 305/497] ALSA: hda/tegra: Re-enable SDO workaround for Tegra194
Date: Tue, 13 Oct 2026 13:37:52 +0200
Message-ID: <20261013112915.135984403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Aaron Kling <webgeek1234@gmail.com>

[ Upstream commit 89365897f4210979966aa808d7b013edf4080558 ]

This workaround was originally added for Tegra194, but no longer gets
applied for it. Commit 615d43540043 ("ALSA: hda/tegra: fix tegra-hda on
tegra30 soc") changed the guard to tegra30-hda, which worked because all
affected archs had the fallback compatible. However, commit 7f0ea5acfc19
("arm64: tegra: Use correct compatible string for Tegra194 HDA") removed
the fallback compatible for Tegra194, causing this to break.

Fixes: 7f0ea5acfc19 ("arm64: tegra: Use correct compatible string for Tegra194 HDA")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Link: https://patch.msgid.link/20260926-tegra194-hda-sdo-v1-1-f7a636a07a58@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_tegra.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_tegra.c b/sound/pci/hda/hda_tegra.c
index 12a144a269ee8..de47ea7b9ee13 100644
--- a/sound/pci/hda/hda_tegra.c
+++ b/sound/pci/hda/hda_tegra.c
@@ -376,7 +376,8 @@ static int hda_tegra_first_init(struct azx *chip, struct platform_device *pdev)
 	 * in powers of 2, next available ratio is 16 which can be
 	 * used as a limiting factor here.
 	 */
-	if (of_device_is_compatible(np, "nvidia,tegra30-hda"))
+	if (of_device_is_compatible(np, "nvidia,tegra30-hda") ||
+	    of_device_is_compatible(np, "nvidia,tegra194-hda"))
 		chip->bus.core.sdo_limit = 16;
 
 	/* codec detection */
-- 
2.53.0



