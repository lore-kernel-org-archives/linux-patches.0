Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF23F1ABEC7;
	Mon, 14 Oct 2024 15:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918749; cv=none; b=a+tvuDCTkqAGNB1UaSYXyn6nMOKFLmo2MbpQIbGkpEwkeOVtoqjNMZU2At+COjbWGBsKYJkCJy5B5PzLl7+TK1b9iPy+lbP1qYThIT/7JrFuU3EbmmvFSlNFLqvs3Z7OYcrXoIsqFAp7id3UvRh/OgvLsJbKIzSmW/IOiBTyQO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918749; c=relaxed/simple;
	bh=qavlB+OyE74pNQH1K1/YIZqL6vphtFjjDfrdcAAATpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVzO4BFU1KctssePsuAZaUk4PshHM3SK4gHmbx6BPQZ16OqxR8jilTvx0wYFG/gjralpzqKq+zIwNokwiiPu0PSSl5y5jrstdhIDvEqYeztWJOG56p+XzzzOmfDDY0l8Ituenq2O/Wa60S0J4091HjP25Y7JzREKvW4rMdvkaDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sNp2aSM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sNp2aSM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FA7C4CED0;
	Mon, 14 Oct 2024 15:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918749;
	bh=qavlB+OyE74pNQH1K1/YIZqL6vphtFjjDfrdcAAATpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sNp2aSM56HUcl0gCEr1CRk5sOGcI2U1Kh73wNJiGvQA1sC5wmE1YuE/MKjT9I2vnS
	 fgIG7NDBkwrr3CzsvGh3Yry0E2ZkFOGb0Bp9wZsavLQgzaB+fyp00VFzVfuo38Ju7/
	 wWpIkj6lzM3G4BJU+FBF3XAmAwAOkFBSM6FoxLdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oder Chiou <oder_chiou@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 412/798] ALSA: hda/realtek: Fix the push button function for the ALC257
Date: Mon, 14 Oct 2024 16:16:06 +0200
Message-ID: <20241014141234.136488517@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oder Chiou <oder_chiou@realtek.com>

[ Upstream commit 05df9732a0894846c46d0062d4af535c5002799d ]

The headset push button cannot work properly in case of the ALC257.
This patch reverted the previous commit to correct the side effect.

Fixes: ef9718b3d54e ("ALSA: hda/realtek: Fix noise from speakers on Lenovo IdeaPad 3 15IAU7")
Signed-off-by: Oder Chiou <oder_chiou@realtek.com>
Link: https://patch.msgid.link/20240930105039.3473266-1-oder_chiou@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 277303cbe96de..cb6a13504d322 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -583,6 +583,7 @@ static void alc_shutup_pins(struct hda_codec *codec)
 	switch (codec->core.vendor_id) {
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x10ec0257:
 	case 0x19e58326:
 	case 0x10ec0283:
 	case 0x10ec0285:
-- 
2.43.0



