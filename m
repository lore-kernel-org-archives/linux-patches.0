Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C09EEA8;
	Sat, 30 May 2026 17:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161097; cv=none; b=tHn99ALD8TuszO9MM4r/NwwFnSkEpWRthY7vAAT5+RzuGFDGY07B5mHjJOeyUaThWH4QL96d0LU+a9oGWuhkkMWr+LJabdznNKZjA5MuIi0WZNzLrMMxw0ZQ7BmV8It3zmvCnryqOZuyR6XEOBTxZTAs4RlOkjLn49co1ngZUN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161097; c=relaxed/simple;
	bh=X557aFJjD7wunDvJXwn1nDwfoP2PSFI+JxmTzgQK6bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dB/KJI9VjdGWvFp/dCmBmIo4YPnRxrvoN1nnMJz+QOn+wkSKrFc/CyHVsy8ytuOGcvZlIuEfAkTOXdCyrPRHFw8/5/JjGZU05JyiwOO2n9QOqpdwuxXkhgqfj9lgINXNqb8SsvcqKv3dQ9BTpUSQhWlCuL5qkzmfM/FVuG4PEi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OO3W9n2f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OO3W9n2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2201F00893;
	Sat, 30 May 2026 17:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161096;
	bh=SF7JJ9ylhNK54OxfIFHpcXEVD1/Hli/heFZhpT5bx8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OO3W9n2fMHsUtcxbUcVf+Y7Lu3yDYDZ1NSNHPELX/pdCaLKeODAigpkcVIIwexv8x
	 /KIg9Vm7MKO3g2xGOBR4++nKZWrEa2b9IYYcFd1vGNCFOhxr/nrm7SBNyuQ1PTeLhO
	 zMrhHpbS7ede4DA6nhMxl8S6iQSJTL4bBVLy1E4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 524/969] ALSA: hda/realtek: Whitespace fix
Date: Sat, 30 May 2026 18:00:48 +0200
Message-ID: <20260530160314.823854155@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0889dfd80fa44..9bda2f43394cb 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6040,7 +6040,7 @@ static void alc_fixup_headset_mode_alc255_no_hp_mic(struct hda_codec *codec,
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



