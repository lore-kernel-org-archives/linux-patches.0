Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DDF46EC93;
	Tue, 21 Jul 2026 17:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656345; cv=none; b=H46CA24I9kHFA0CZ6GsgyJDKtJD0HtemphJd/c3MBGbTCFLH1voyWHijf2A11egfva0wAbrSBb+LAnajDg3t28Su8dmPQtQAR01g7fWMxWqud+5W4e2VpoBymMtxnTNBjasR6jym7nIrMHQEi1YXjy5oegY4MvGSYgovKcvx3Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656345; c=relaxed/simple;
	bh=Ig9x58715W3eAq1mVwonaeSIxhCwovJg+deuwBCDR/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6LI+Ysgr+OtTJrIC7F4Am3/BsnaoZAh6ulrIBcJTTw4EoFfYyqEm0lvj2kXRoSGY2ewinOBpScUU8u+eWRbbNdGY32Z8pByNIDwVwejGuo+T9uSrcjlsMiVadckua9EODmow0qx5VNVP2FA25CFQdanW0m7LI2wUkhXQQPAzlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EixHCdtx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EixHCdtx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2557C1F000E9;
	Tue, 21 Jul 2026 17:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656344;
	bh=WFXPX9opu3o3CyvLYhRqnLezBeyXLxFxsx5MtB/2pdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EixHCdtxM+Ya6O3aFIsPFAvevrZwZ/hRnPOUuDB/cNSrPVLp8ZnNsuSMVHjn1092V
	 NqL73mnsuZZ5c6xmnlwIuOsQinjt7pdJq7LKFXba+uexibNxtJ09YPorJGJOCUgTq0
	 w5FpOt2U/QxFTXM0vZ+VtN3VPsCMkkGnX+T6Oc5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0352/1611] ALSA: hda: fix Kconfig dependency of HD Audio PCI
Date: Tue, 21 Jul 2026 17:07:48 +0200
Message-ID: <20260721152523.052280742@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Oliver Hartkopp <socketcan@hartkopp.net>

[ Upstream commit 1516134cb65526aba5319bb446c296fc8a192f84 ]

With commit 2d9223d2d64c ("ALSA: hda: Move controller drivers into
sound/hda/controllers directory") the HD Audio drivers have been moved
from linux/sound/pci/hda to linux/sound/hda.

But the Kconfig dependency for SND_HDA_INTEL stayed on SND_PCI instead of
depending on PCI directly. To make the "HD Audio PCI" configuration entry
visible it is currently needed to enable "PCI sound devices" although
no PCI device in the submenu needs to be selected.

Make SND_HDA_INTEL directly depending on hardware/architecture like the
other entries in this Kconfig.

Fixes: 2d9223d2d64c ("ALSA: hda: Move controller drivers into sound/hda/controllers directory")
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20260529-hda-kconfig-v1-1-4a2c6a0efd56@hartkopp.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/controllers/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/hda/controllers/Kconfig b/sound/hda/controllers/Kconfig
index 34721f50b055af..39b934365aee3b 100644
--- a/sound/hda/controllers/Kconfig
+++ b/sound/hda/controllers/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config SND_HDA_INTEL
 	tristate "HD Audio PCI"
-	depends on SND_PCI
+	depends on PCI
 	select SND_HDA
 	select SND_INTEL_DSP_CONFIG
 	help
-- 
2.53.0



