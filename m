Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E328DFC19;
	Thu, 25 Jul 2024 14:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918893; cv=none; b=Lb09bwtsniVw5qG7my9rbbPZ1XKHaXyBHSzan3dXQWbuMZbO41w2fePB7YZjNhi/MuQP+K0nufG23haWXY1VjwXhEScL21JxS6GphTIMhHb7DWGKiuNgHRPZlvAnLsOmDidxcISmKXeu6/hjvI1h8Rly7kNY184SBfLLmGGhoRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918893; c=relaxed/simple;
	bh=3TK13e+SVkhw8E/KGnTENazwPWIkS/Ez/4wWVtR0j7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ls7VkCX4ZYzk7CNE+nk8f2uC1aLu1g54TR/ivJ4BfEF+XWI2oZFGUke4+21IVIdSca8xOcfyzlPTRUa7Px7ZLeepUZSgBTU1WwbPd3WUhFy4mdkZquft+PdAvUxXzknXEx6tb2OHLIqm8H3UWrh6H3ERnsm8z1flQk2d7sUCt9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1z5HNrQ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1z5HNrQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53295C116B1;
	Thu, 25 Jul 2024 14:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918892;
	bh=3TK13e+SVkhw8E/KGnTENazwPWIkS/Ez/4wWVtR0j7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1z5HNrQ1PVxv2C6wqhJ8kPjWZLxbyjYe7NezHydYhKvsYM3btVhSYLQzSpH+8E1Fy
	 KvXR5hT8ojCIyREWlpLeiQbeDVgiRk/2gBcz0t1slvukTE1EoeEipFgy+ULNbo2Mjl
	 0fhoU79vAQ0gsv6WV6cPCOxwH8HA1BIP3ziOiGxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 20/59] ALSA: hda/realtek: Add more codec ID to no shutup pins list
Date: Thu, 25 Jul 2024 16:37:10 +0200
Message-ID: <20240725142734.026562706@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit 70794b9563fe011988bcf6a081af9777e63e8d37 ]

If it enter to runtime D3 state, it didn't shutup Headset MIC pin.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/r/8d86f61e7d6f4a03b311e4eb4e5caaef@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 669937bae570e..fdbc76eaf233e 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -578,10 +578,14 @@ static void alc_shutup_pins(struct hda_codec *codec)
 	switch (codec->core.vendor_id) {
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x10ec0257:
 	case 0x19e58326:
 	case 0x10ec0283:
+	case 0x10ec0285:
 	case 0x10ec0286:
+	case 0x10ec0287:
 	case 0x10ec0288:
+	case 0x10ec0295:
 	case 0x10ec0298:
 		alc_headset_mic_no_shutup(codec);
 		break;
-- 
2.43.0



