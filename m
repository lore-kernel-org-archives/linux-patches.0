Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA3039478D;
	Sat, 30 May 2026 18:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164107; cv=none; b=Tu+143JPPFG411eownsQiq49pFtEgm89Mqso1wostyqGp8bcYPpithXwcAKVnJ8eny93sYRgB8YZBSAEDRLjZDr1yuww6KxzTFD34Y+NOFOsl5gOsIgK4n/yb9xBHfdQ/GV+oLiR51ZcXQRQgw3o0/mXeqIWCodjam3qDGl6tzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164107; c=relaxed/simple;
	bh=l0pauLJ9E0yRZ8YG17knLkrNFaxcJqRLZSBqzd+dKEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkrVdieW3Dl8a8wTIo2r4XnBXQ7eB9mKoxT2JnD+Da5srFhxNqpKoAc7yXBy0gcVnXk9/SSyxG8cPtJq0ccec++kcMFiDBd07mDU5/T5ANDjEIFwcFyJ0UWL0KDkhFoOFmu5ceWMF1wvSVvKxOpIhK0Z1E478m2rJcBegjvE/8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qu1NKn8c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qu1NKn8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE851F00893;
	Sat, 30 May 2026 18:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164106;
	bh=edA+lTVJMQvY2h9qJB2rjhzASVcbE3oyEsXzREHKK/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qu1NKn8cl68y2Vw92niVLgwStLABwqPg4vKFuMbxIuxKAlhXh6BDYeXLPoPmENfqK
	 4MRqWpuzBtOmqDM9RIjstQ42R8kbWHUTQC+a0JOHsRBtCKCXoZxX9uy8Y94rayzG3G
	 bgQgwTIZKG8zlZxP8Q0fpByqXWRxY5bag9IuKYII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 456/776] ALSA: hda/realtek: Whitespace fix
Date: Sat, 30 May 2026 18:02:50 +0200
Message-ID: <20260530160252.159747025@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luke D. Jones <luke@ljones.dev>

[ Upstream commit 72cea3a3175b50a4875b3c112fb13df20c6218a5 ]

Remove an erroneous whitespace.

Fixes: 31278997add6 ("ALSA: hda/realtek - Add headset quirk for Dell DT")
Signed-off-by: Luke D. Jones <luke@ljones.dev>
Link: https://lore.kernel.org/r/20230704044619.19343-6-luke@ljones.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: d1888bf848ad ("ALSA: hda/realtek: fix code style (ERROR: else should follow close brace '}')")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 9cb5705577f72..c847e9ab36b31 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6011,7 +6011,7 @@ static void alc_fixup_headset_mode_alc255_no_hp_mic(struct hda_codec *codec,
 		struct alc_spec *spec = codec->spec;
 		spec->parse_flags |= HDA_PINCFG_HEADSET_MIC;
 		alc255_set_default_jack_type(codec);
-	} 
+	}
 	else
 		alc_fixup_headset_mode(codec, fix, action);
 }
-- 
2.53.0



