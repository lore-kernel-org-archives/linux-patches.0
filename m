Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049445;
	b=1DPlTZNLpHeCGDfpFg2yHn/BjQOr68bagXB1L60dym6i87PvCA7rfo4FxICN2chHKJog
	 r+nE5tS9L3UWEr0HDA/s5FXu1NH2acFknWbtQQXd8MhX7ikeDL/U5RmP6KrDw9PL4KoW/
	 rg2MWOHUNY4tzQsfIeb2hT4/TA+bjxFE0th3ry87jvulKmZZnO0CVmqNE2ER4cbZ6CPM6
	 x1UCLFrxwysWbM+tqXKFXuc1hlkGVHGLaSb/tT16KOhFFwju+gE6NNE7met4FNgTrBgoJ
	 INi/apdlzhfSoj0UEkDg1KApTxCErADLWksPGbDvTNbqVHPU2Mudfu8SFsNaBqB3/UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yCOCbYox5oov77KNxqc6AS3erXtvGrzfN3qtp/Tv5Ms=;
	b=C6pl5jXaxeLWUCyJhR/V5TO2+NSmafY/qnZDQkKLBe08eYTXVagJ3OTvg5I4hvaUvOEy
	 voQ5Rf9NaF4ActDDquYo/tAMKS29BJaFd2C58+8HKuzK0ydSdic5qR9/iFi9I1cGdgllw
	 Y0sYFs+BOk7ygypCXz74NrmR1d8qNKNMk/RzQBlHLo+V5HjH4Q607mZ/veophm+XIxOlv
	 DBbxGxzEZMe2zzkI5ZbuqeBT5X+wOaQGpRYODtoQ8ih3fm6rZuvx3JEoC4lfSl6T9JGnW
	 gV/MmdXe4j1kZPxlgpW8A4TbF6ix+0NCD+eO0bt517QZWEU4UdGnd56wK+PPd2fvUnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="eDg/VbOl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B7B606A320;
	Thu, 19 Nov 2026 00:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eDg/VbOl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B16C1F000C4;
	Thu, 19 Nov 2026 00:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049445;
	bh=yCOCbYox5oov77KNxqc6AS3erXtvGrzfN3qtp/Tv5Ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eDg/VbOlKY9q1UiWJrxY5wEMYq3crTNCVSQB3HZlPsagp54BKy2pmAA3pQsIn584u
	 AlyY5gIeTwlpUzwaCXjwvSJX/bVv1LsuiuC61N6JQrvJUnjlsU/dr+h4o9lKSSmzke
	 oRDUbmIhdpyahw4LlOoiEc/iGdAZjrgWDjOAs4MM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2353/2857] ALSA: hda: Add NULL check for the driver pointer at unsol event work
Date: Wed, 18 Nov 2026 15:56:27 +0100
Message-ID: <20261118150326.245412570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 8cbf75d115e97b7f5ba7859d30d0ce74d1af6c19 ]

snd_hdac_bus_process_unsol_events() assumes that the codec driver is
always set when it's accessible from the codec table.  It's true in
general, but in a sheer timing, it might have been already NULLified
at the driver unbinding.

Although the codec removal should have been done properly by the
previous fixes, just for more safety, let's add a NULL check before
dereferencing and calling the driver's unsol_event callback.

Fixes: e7255c00b10e ("ALSA: hda: Skip event processing for unregistered codecs")
Link: https://patch.msgid.link/20261009133341.440917-6-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/hdac_bus.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/hda/hdac_bus.c b/sound/hda/hdac_bus.c
index d497414a5538f..a75b68de9e420 100644
--- a/sound/hda/hdac_bus.c
+++ b/sound/hda/hdac_bus.c
@@ -185,10 +185,13 @@ static void snd_hdac_bus_process_unsol_events(struct work_struct *work)
 		codec = bus->caddr_tbl[caddr & 0x0f];
 		if (!codec || !codec->registered)
 			continue;
-		spin_unlock_irq(&bus->reg_lock);
+		if (!codec->dev.driver)
+			continue;
 		drv = drv_to_hdac_driver(codec->dev.driver);
-		if (drv->unsol_event)
-			drv->unsol_event(codec, res);
+		if (!drv->unsol_event)
+			continue;
+		spin_unlock_irq(&bus->reg_lock);
+		drv->unsol_event(codec, res);
 		spin_lock_irq(&bus->reg_lock);
 	}
 	spin_unlock_irq(&bus->reg_lock);
-- 
2.53.0



