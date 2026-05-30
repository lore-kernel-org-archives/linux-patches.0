Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562623AB285;
	Sat, 30 May 2026 18:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166338; cv=none; b=bMYWO86w+HgyA541Ax9ZkAPoqmQtOXM4F7x1aOrihkLRuAfV6/NhIhOLq9AXOtQco0UxkIxFmJRYpU4pIMONroMHe13VM407X3lszACERTTFs0j8kxopn0KQQeVQDT+DvaODrrjVX1Eoo/PzM+P9APPdYjIpPElhJS3mBCIRPY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166338; c=relaxed/simple;
	bh=4XSO+x9znw/EXfVYV2vOXNl9l9W95Q3U4TnPd47+UtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYYuuL+zRbdlnIDroawRo7IfO+0l59jKZWR6Vm6MB1+t1+BEj+q+rqDcKKQVgekpgl2I5O4DtDZFJ0Z0mywBpfz87MhT8M6RZqiZlWr3C3QQFLFHCIAle3lNTXsM9OX0krE1YyKjvA3lQy/IkQ4ukHxDGGO0njuOOVBEFnfjAKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E61KnKHg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E61KnKHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933241F00893;
	Sat, 30 May 2026 18:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166337;
	bh=RhjUlBIiQouKCfV7pSLFComhQj2amm6/1t92h4pCBuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E61KnKHg0WqpZZIGsI2oMSgnutb9UJTfSOS2YkF6+YksDIh/IquJE+HRxw7ezN9W2
	 IL4LjVVR0l1aQHeTEBxwPDYHCiWY526ddEel7FgBUIcr3ce1PRnNOTtxqS8YhV7RjE
	 VMdSSLGdd0W9mAR7vC87HkBzPYPDOsatLSbG5d1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Huang <huanglei@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 343/589] ALSA: hda/realtek: fix code style (ERROR: else should follow close brace })
Date: Sat, 30 May 2026 18:03:44 +0200
Message-ID: <20260530160233.903091982@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lei Huang <huanglei@kylinos.cn>

[ Upstream commit d1888bf848ade6a9e71c7ba516fd215aa1bd8d65 ]

Fix checkpatch code style errors:

  ERROR: else should follow close brace '}'
  #2300: FILE: sound/hda/codecs/realtek/alc269.c:2300:
  +       }
  +       else

Fixes: 31278997add6 ("ALSA: hda/realtek - Add headset quirk for Dell DT")
Signed-off-by: Lei Huang <huanglei@kylinos.cn>
Link: https://patch.msgid.link/20260331075405.78148-1-huanglei814@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 4eddc032b3d9a..31cf426f026c9 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5954,9 +5954,9 @@ static void alc_fixup_headset_mode_alc255_no_hp_mic(struct hda_codec *codec,
 		struct alc_spec *spec = codec->spec;
 		spec->parse_flags |= HDA_PINCFG_HEADSET_MIC;
 		alc255_set_default_jack_type(codec);
-	}
-	else
+	} else {
 		alc_fixup_headset_mode(codec, fix, action);
+	}
 }
 
 static void alc288_update_headset_jack_cb(struct hda_codec *codec,
-- 
2.53.0



