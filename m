Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018153793D2;
	Tue, 21 Jul 2026 15:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649235; cv=none; b=t/DEmrgpxM3/zjESSjUHdJkIQneZxgr57uoDBNH6r3nIYmCyLuWYu0YLmrAMc9wYNHGLB5UKmKu/kovu1OSvTNqKWOy561aOOIsZ1Ani+vrOF9NFzCA8YY2g+WK++GWtKG/QHVYBnzwjQvYN8w1rgEsuAABOZBZzS9Idb8QYP8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649235; c=relaxed/simple;
	bh=7AFudpNFAnE5Vu/Gk86cRUBwb98RhCHxN5N7ZKAOsi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LH/uhN+YzTjwGhYSrM+z4b1Ii/n9ELIPon5XG64+ot5J4t0ZC6Hsq1bacaMMHWMwOEjgjq6tRAtBBxFsqkQCVrJ9deRKazWmM0lpGsF03UDt1ZRajaYbC6lHWfaaxMTj6rADej8JHdrYXIVld4t2ZuP/PebfCkW8zGmjeIVGPQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2jHELfg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2jHELfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674FE1F00A3A;
	Tue, 21 Jul 2026 15:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649233;
	bh=leyAcQYPeL0pLoVUIywWk6g8Pz3Gf5P35DQqn6I4L+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A2jHELfgS5YnEzDyhP9WhC9MkcjVYKtbCv/XLIQLPfWvlTNGT0JGZI9nYorwx+6ji
	 cVoCXemNbOc9QB4Jb+aJcFP/7z8Zrbz8WqGmC71sYlbbzZ0rM+WbARRM+S+fLZsU8F
	 mapcuxhEjO/TIf5Q+c6T0XHs9xr4E6OTClsfkleA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0499/2077] ALSA: hda: fix Kconfig dependency of HD Audio PCI
Date: Tue, 21 Jul 2026 17:02:52 +0200
Message-ID: <20260721152604.583697808@linuxfoundation.org>
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
index 72855f2df45148..5d6a77e68588e7 100644
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



