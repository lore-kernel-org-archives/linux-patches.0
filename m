Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB93EEA8;
	Sat, 30 May 2026 17:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161101; cv=none; b=KX7yUgWRuaIiH7x+SoUCyqc/As8BYS+O5EHmuthJdmx7Tma21DheA+Hw97yP6NbximrHab0RN80mLfWciQHblyRN2lvA9jtoMJmYTkty1v1P3JSdqEeSh96lzsD3MzZpslfMqWeujgristrP4jntEjH0evQWzCbEYLErOpZAvIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161101; c=relaxed/simple;
	bh=5tQuf2rS3jKXSjbEuti2qPVEcD3PtlarbPnt57Mea2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMUFYQoE6nIZf3cX2pDSo1MBqzs2YM/E8W+WVBgwqRf4NuqFWXoTm5ZYmm7rsISrtcyZmU9mmIA2w+eVhAYyyav975HaroVXc2UFS25MAeO2aqUoOEPJ98CugHbx9k7CqFlILInY9FcvXdkcPBDZEZRrRyjp+QMLupHv1HQhBBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kxCTeu6I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kxCTeu6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7921F00893;
	Sat, 30 May 2026 17:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161100;
	bh=krvPUFtgG5tzNH/hu4EL/QF5eXgxNElja8GFetFb7rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kxCTeu6I49vgOAMzRpHfw+0PPQzIq+Kadq6BChma2zP4lQ5pqnIfg0F4lLgzTKY8N
	 3xxRYgmhV84NnUrTU7mNXQZTnzWFLwSvQfg/tTlIo0nHEZCK7U6hbRCVfGDzcqTBHy
	 ZhdMfCxhNaWlBGZiwMPWPQupBMqqsxGJDFMajR8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Huang <huanglei@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 525/969] ALSA: hda/realtek: fix code style (ERROR: else should follow close brace })
Date: Sat, 30 May 2026 18:00:49 +0200
Message-ID: <20260530160314.853753977@linuxfoundation.org>
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
index 9bda2f43394cb..7b4fd95c66f9b 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6040,9 +6040,9 @@ static void alc_fixup_headset_mode_alc255_no_hp_mic(struct hda_codec *codec,
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



