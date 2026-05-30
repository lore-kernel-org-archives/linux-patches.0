Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E8E23392B;
	Sat, 30 May 2026 18:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164114; cv=none; b=ONyCafSneiVYSozPPbhuK19B1Ho0OLa6bOpVytqJGTiWMm64upvRGuFyjMpdI1mKgBKquTLmJ3QqVm0SJv3PfJIiao2AqcVEFibbVtZdjwIun/5/+YO/TE5GIIkOhKk/hGK5AaDIG8vIq0uTn2BtCbVqIk0m7px25CE7+Tr6FSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164114; c=relaxed/simple;
	bh=6JeRpeRkiNCevFYqT2/HRb8krOZXHVIP12gtMH5X9PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fk7SqSSCCKaUd8YKxiJ0Hn05KXZ5XWCkb/OnYgwlP+ogPp1JSVz2RWvTvtzJSOIgwhOsne2RGoy4+voXVgbj0L5FoQzTqRhWTV5ddYG77iAVcEvyVZqXFQPHPcCBfbEToQgkbLioHV1/XIyKsj5q8GDw/W/86B0GCjZ7hGzwhMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUa3hw5c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUa3hw5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6AD01F00893;
	Sat, 30 May 2026 18:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164113;
	bh=SxNG+flpkDGJRtp9R9ZBlCXZkB6x/z48htZv46cNpq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUa3hw5c0mtldbMz60rvkoBnth7O+V1oA06N1zhGsgsPn226pMFXj/s7OWz55TIqb
	 bbUtjIzr4PhXILZiRKBD/qV0AaCiwPGC/VTn0sPG3jxwjwQbveqeTfxqv+Ve6A+7U4
	 Q7OGMcbmJBB59dB466EvZ01HI0gzu2slCY6UA7FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Huang <huanglei@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 457/776] ALSA: hda/realtek: fix code style (ERROR: else should follow close brace })
Date: Sat, 30 May 2026 18:02:51 +0200
Message-ID: <20260530160252.182878040@linuxfoundation.org>
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
index c847e9ab36b31..bd8878f4896c8 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6011,9 +6011,9 @@ static void alc_fixup_headset_mode_alc255_no_hp_mic(struct hda_codec *codec,
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



