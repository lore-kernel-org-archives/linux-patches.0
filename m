Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419C81E1A25;
	Wed,  6 Nov 2024 13:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898376; cv=none; b=Swfs9AtyD7C5+jVDb5cQU4ovZ0QVacmRNhXSpebqXkGntvf4Rs7NHLonkm0nbEGFi/6TMqDGP76Yd6c6KbxfidZ1cIyDuWxX1IC62xWAqzl8Vt+EwPeW9ukOzLoDWiiI7KPTJ56DyrnUMbfU5PMz1U1QpskiWwzbKAkXp+pyuL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898376; c=relaxed/simple;
	bh=TqeKsJKxxwErvNjn83VnUKvMXbLzMEb4OMGvf7gjqWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QljuNX/lzjkkXJemWGyxTDar4rlJObuA7LfU3T41jOWDN4YHISGuXSm96JKv/V5NciLTfXHQxnknuhX/14umU3KTmFC+ehoHjieGWrsPoV5pVqcXzwVLZibqE6tm+vFOyUoCGtpqgzTbNBPmJ6+gz7UoxPiD70eoIKZTjeV6LOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZaJGKTi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZaJGKTi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DAB2C4CED8;
	Wed,  6 Nov 2024 13:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898375;
	bh=TqeKsJKxxwErvNjn83VnUKvMXbLzMEb4OMGvf7gjqWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZaJGKTiuxlAoNPV0v7zQO4quPqpkRUa7b4ICNcaVk1ozKG79zCKTeFXUCVlP0N/y
	 seRlOxDVz1uV4q/rf+PE2YQpZ7Jx/sewlbBgF01V41hBh/LOaUCywkOFZ/xpegNqZj
	 ihc7VjjJlOkdR1988rImnmntR/hpT3naQFWwbypE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oder Chiou <oder_chiou@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 190/462] ALSA: hda/realtek: Fix the push button function for the ALC257
Date: Wed,  6 Nov 2024 13:01:23 +0100
Message-ID: <20241106120336.207607829@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index fbd8b4206bad8..f32c3c3752417 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -520,6 +520,7 @@ static void alc_shutup_pins(struct hda_codec *codec)
 	switch (codec->core.vendor_id) {
 	case 0x10ec0236:
 	case 0x10ec0256:
+	case 0x10ec0257:
 	case 0x19e58326:
 	case 0x10ec0283:
 	case 0x10ec0285:
-- 
2.43.0



