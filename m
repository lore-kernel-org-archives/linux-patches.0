Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C883B14534D;
	Tue, 27 Feb 2024 13:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041703; cv=none; b=j11oj/9xa9VXfExP7F1OJ75NyHEyX7BBNCd9Zqf4XSwyPPWMb/g00LAaKOtPnupukk7fGtxW95Zi+03ynYrWZTqPJC0mAMC6M0rhT+rU0cA3c5qqI5DmVOo5Dv9tFy38oSfCo60xbp6yaVuMRLd5gLTWYOYTJOhwErpcB/4quI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041703; c=relaxed/simple;
	bh=LDfaOADzCJFllYX/WK8XocJHFVpo/67Ka8xiaQ+9oCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nKugx42PkEAcCDaNr90mnnx1nQm/X3EK2tpEeZ4QOPI6SgTOsmdZ7BEWApLvCGXq+6fkUWs3JQlPFYwedtolbUWZQ2bwMf3ZCgj7SYSn50BuxajdAGA843dSgGOT5VcTKRrUHia+8OdLWN+XkdfcN6BwL4IM+F7UIsmgzUEUgCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cDd3HI6+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cDd3HI6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57BE3C433C7;
	Tue, 27 Feb 2024 13:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041703;
	bh=LDfaOADzCJFllYX/WK8XocJHFVpo/67Ka8xiaQ+9oCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cDd3HI6+oxUoPnRbTXbMBCyV6Jk/KnSi6010FKy9V7jXa8X271sAJF1eEsqEBmS2W
	 FZEZV9frfXbVErWKR0tWadCopuwI1loKx+3/bsXFvctrk57N2mNXLz0MCuRpgMtVUk
	 XVYmENLw96MasEwMUwMNQofu61rPQG4bvWVrcYa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Salvaterra <rsalvaterra@gmail.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/299] ALSA: hda: Replace numeric device IDs with constant values
Date: Tue, 27 Feb 2024 14:22:32 +0100
Message-ID: <20240227131627.308014163@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rui Salvaterra <rsalvaterra@gmail.com>

[ Upstream commit 3526860f26febbe46960f9b37f5dbd5ccc109ea8 ]

We have self-explanatory constants for Intel HDA devices, let's use them instead
of magic numbers and code comments.

Signed-off-by: Rui Salvaterra <rsalvaterra@gmail.com>
Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20240122114512.55808-2-rsalvaterra@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 55d3a78112e05..1596157556862 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1735,8 +1735,8 @@ static int default_bdl_pos_adj(struct azx *chip)
 	/* some exceptions: Atoms seem problematic with value 1 */
 	if (chip->pci->vendor == PCI_VENDOR_ID_INTEL) {
 		switch (chip->pci->device) {
-		case 0x0f04: /* Baytrail */
-		case 0x2284: /* Braswell */
+		case PCI_DEVICE_ID_INTEL_HDA_BYT:
+		case PCI_DEVICE_ID_INTEL_HDA_BSW:
 			return 32;
 		}
 	}
-- 
2.43.0



