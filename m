Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC3613B798;
	Tue, 27 Feb 2024 13:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040600; cv=none; b=NrsM0D2/sGdwAqQX3IX0kiwH7y191Pwa8gqlgw52J/mKTxW81gZ4JcuSlRT3qcpCjXKCp4OQx2yjO+m921yQkF6DM8Twm7bou8NuKS1cpEy2NZB1yaIcHZzNIU0VB0U8qGA5nMv2slEd96zl8k4H2RHUllzgrx8c9UnAaeb0zgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040600; c=relaxed/simple;
	bh=AchEwDFrhVgg37yBwWQF+OYZohFuG6CXeU22IQeDrXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JeJqamumn3Tv1qCeLV5CRkpQ9MZ4QI4dguk0+Bhc7JY+oJXRKcw3ms14EOTLIvEzSNFEWj7dlbU1NmXnvRQ3Hy364CRFnzXGVT4un6w68bSSUGrmunQt6FnbBoNc0YIlfJL0dAJ70FNrgI2fg5KKR8dpvb5fN8sETDM7eLsHikc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LlgwphV3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LlgwphV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C88C433F1;
	Tue, 27 Feb 2024 13:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040600;
	bh=AchEwDFrhVgg37yBwWQF+OYZohFuG6CXeU22IQeDrXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LlgwphV3qNq9yJbE+SuqyYilkk3DsF89Y3a6wP1miOfLbkMoMGR1vCuPFY/hynNwq
	 ZoWor32ozGRKIOaGJ3eRS5QlLwWX+uwuJwgu4PxZ591XV4fzFy1oSZDxIwN7bvjvVQ
	 RpgK6w57cZQGQ9qYe3YxH/sN8bXb0uiu/lREYht0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Salvaterra <rsalvaterra@gmail.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 042/334] ALSA: hda: Replace numeric device IDs with constant values
Date: Tue, 27 Feb 2024 14:18:20 +0100
Message-ID: <20240227131631.942805173@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 2276adc844784..66f013ee160d2 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1729,8 +1729,8 @@ static int default_bdl_pos_adj(struct azx *chip)
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



