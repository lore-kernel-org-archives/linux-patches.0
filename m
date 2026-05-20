Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA1030BF68;
	Wed, 20 May 2026 17:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298066; cv=none; b=KOCrbBpTgLqtBGmaPNgqCWWrRk5QSLSqQqM4b9lj2a5bZSqJ+e7rl90GbEnISuF4dckGyL3vAe4i2tLK2ea6YZYpoukf54Ku3PxZs3EHqx404HZ6KcZe2Bkb9hvGdWpx5ZvGhEqfdyP3vO313NKhwec+lcktVfe4cyej0fiODRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298066; c=relaxed/simple;
	bh=K2PRpfPkchbHBnTbp1tSWGpWPqxhdBkaHoTvKn5A/sY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgMnWTC30Lyt/GNru1P4TFGK8WA0H0GZG5LUf7q0pQrfnLJeKRQu4NDNjiEE/vUkDd6Iu4s8RkS377R5bOs2g/M+XLunBuyeUD1NplFC3S22h2k7lhO9mnxfCFIAjghHqw7Y4eNr/JkPQkvaOYoB39uPX1HY/XzIKYYdrBzdg0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3CMKPVx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3CMKPVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F151F000E9;
	Wed, 20 May 2026 17:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298065;
	bh=La4cttabI4k74o+xZgezc4stZjJ/BgSG2ceOty5gbdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W3CMKPVxobnL2kBjdMeVfRDfHQDblKkfQaxGBz3lcCUw9Rwf0WEZ1x/buBNdaPBIz
	 QVKkmTZ5dkR8KrpTJQ/xPYW+Q9YTk4xorCOcy4LibuAdD7EeEpVKC1f3A11coEENgt
	 +UAy9bmcHn2OWaYd0ybgVnMMwJzHvF+DoZ2nJZmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Huang <huanglei@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 270/957] ALSA: hda/realtek: fix code style (ERROR: else should follow close brace })
Date: Wed, 20 May 2026 18:12:33 +0200
Message-ID: <20260520162140.399222989@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 sound/hda/codecs/realtek/alc269.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 844c4650230cd..a2ecbe1412632 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -2237,9 +2237,9 @@ static void alc_fixup_headset_mode_alc255_no_hp_mic(struct hda_codec *codec,
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



