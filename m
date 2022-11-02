Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245EF7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17F1C433D6;
	Wed,  2 Nov 2022 02:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667356502;
	bh=KmdDaoZ4hGu/NWFVxaEx21483ahDP2pe25EnS3BxNZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GgJGp1LODeEotjSoFyQj5sg0vwL+hydfWxBT1jK6qUd4DSEH5zFgrnuDTUF+cfMRD
	 ONMjxLWubY29ElzgaqmCsG+Cpmr96Yw1lE/No9lmg0pUhkR4J4Y/+vfT53psXgsqvO
	 sczVFRA3Nh0Rr271ObnBmipUWm/eKGOLe9S6VCyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.0 011/240] ALSA: hda/realtek: Use snd_ctl_rename() to rename a control
Date: Wed,  2 Nov 2022 03:29:46 +0100
Message-Id: <20221102022111.663733576@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

commit b51c225376a684d02fb58b49cf0ce3d693b6f14b upstream.

With the recent addition of hashed controls lookup it's not enough to just
update the control name field, the hash entries for the modified control
have to be updated too.

snd_ctl_rename() takes care of that, so use it instead of directly
modifying the control name.

Fixes: c27e1efb61c5 ("ALSA: control: Use xarray for faster lookups")
Cc: stable@vger.kernel.org
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Link: https://lore.kernel.org/r/37496bd80f91f373268148f877fd735917d97287.1666296963.git.maciej.szmigiero@oracle.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2141,7 +2141,7 @@ static void rename_ctl(struct hda_codec
 
 	kctl = snd_hda_find_mixer_ctl(codec, oldname);
 	if (kctl)
-		strcpy(kctl->id.name, newname);
+		snd_ctl_rename(codec->card, kctl, newname);
 }
 
 static void alc1220_fixup_gb_dual_codecs(struct hda_codec *codec,


