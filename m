Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D81438F945;
	Wed, 20 May 2026 16:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295294; cv=none; b=PKHL/eQ4/fSZamLVYrjMLKZVjCa0AVx9oZiWntLmMncUx4/DjdtIoqQGNvQa6TVzw1iRaAONeF9gkTdtPR5EulKJERxoJDEqKKYILuAMUTniI5MQ7NY3qhmFG+ODGYH9SYo4PF26v1GduXad5BkteP8rn0vzDVhyyxNbV7SWjPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295294; c=relaxed/simple;
	bh=sj7RGN20YV4iZ2an+xqT7B8FhDwfUjeujFEOvcIHjtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vs8UOS8X/gguXRnG2ZRAcLa+ynuQvzuvEntHMajVwQOArctyySZiFVCbQDTdFEo40AaTdpXrFJPIdqCDUH4mRTKRF9UPTT1lLi7NupNHjQ2PJlyqCTkqBcbZq4ehZvIl0YzSqpEowCblYCWaJyVjpWLPCv1q0D9DlglFIrrTH50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F80RcYWM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F80RcYWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0881F000E9;
	Wed, 20 May 2026 16:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295293;
	bh=wondaJSp0vEHNhL9YKvv+VQpj4Uq+Hc3UFOdGEK1ccc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F80RcYWMLHlWuD0BA+6OLJ7wM5+8CKtXm49IXbXqGiIPID0pw9bC1aTzaHV4nYRC7
	 Pwko3PFqGaWH5kngt6KEngqp+DvG0SSKcQeVErWhRom5i9rOUV3J6GdFlTDZNo4GmH
	 bm0os3RpAgsUYUjRZ36PkmW8iNG/W9m9YZ//YOh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0364/1146] ALSA: hda/cmedia: Remove duplicate pin configuration parsing
Date: Wed, 20 May 2026 18:10:14 +0200
Message-ID: <20260520162156.438041529@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wangdicheng <wangdicheng@kylinos.cn>

[ Upstream commit 579e7b820de5dd5124585413bb5e9c278d255436 ]

The cmedia_probe() function calls snd_hda_parse_pin_defcfg() and
snd_hda_gen_parse_auto_config() twice unnecessarily. Remove The
duplicate code.

Fixes: 0f1e8306dcbe ("ALSA: hda/cmedia: Rewrite to new probe method")
Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Link: https://patch.msgid.link/20260401082625.157868-1-wangdich9700@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/cmedia.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/sound/hda/codecs/cmedia.c b/sound/hda/codecs/cmedia.c
index e6e12c01339f6..88dd80d987d41 100644
--- a/sound/hda/codecs/cmedia.c
+++ b/sound/hda/codecs/cmedia.c
@@ -39,13 +39,6 @@ static int cmedia_probe(struct hda_codec *codec, const struct hda_device_id *id)
 		spec->out_vol_mask = (1ULL << 0x10);
 	}
 
-	err = snd_hda_parse_pin_defcfg(codec, cfg, NULL, 0);
-	if (err < 0)
-		goto error;
-	err = snd_hda_gen_parse_auto_config(codec, cfg);
-	if (err < 0)
-		goto error;
-
 	err = snd_hda_parse_pin_defcfg(codec, cfg, NULL, 0);
 	if (err < 0)
 		goto error;
-- 
2.53.0



