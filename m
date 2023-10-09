Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA306199A1
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VbdbFlre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37356C433CA;
	Mon,  9 Oct 2023 13:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857278;
	bh=wNB94y0Hb8JLF+G2+c2mKhKTD3kbPxQwe++Qd1KY8oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VbdbFlre9vLi3uVgB6vd4YKj2cEY01NtcAoKs8jrmYSeZC688tUMaS6jLbQaz6Rli
	 qtHJAn9/iHb25GlPKBbkSPXgc1Nv15md0GGvwtpk8GtDXynKpvM9tY5+zV6+bakjOA
	 Hjp5SXll5/Fd1xuyr1eroWhlpvRMzh6m7NChhH90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.5 157/163] ALSA: hda/realtek - Fixed two speaker platform
Date: Mon,  9 Oct 2023 15:02:01 +0200
Message-ID: <20231009130128.347202998@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit fb6254df09bba303db2a1002085f6c0b90a456ed upstream.

If system has two speakers and one connect to 0x14 pin, use this
function will disable it.

Fixes: e43252db7e20 ("ALSA: hda/realtek - ALC287 I2S speaker platform support")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/r/e3f2aac3fe6a47079d728a6443358cc2@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7065,8 +7065,10 @@ static void alc287_fixup_bind_dacs(struc
 	snd_hda_override_conn_list(codec, 0x17, ARRAY_SIZE(conn), conn);
 	spec->gen.preferred_dacs = preferred_pairs;
 	spec->gen.auto_mute_via_amp = 1;
-	snd_hda_codec_write_cache(codec, 0x14, 0, AC_VERB_SET_PIN_WIDGET_CONTROL,
-			    0x0); /* Make sure 0x14 was disable */
+	if (spec->gen.autocfg.speaker_pins[0] != 0x14) {
+		snd_hda_codec_write_cache(codec, 0x14, 0, AC_VERB_SET_PIN_WIDGET_CONTROL,
+					0x0); /* Make sure 0x14 was disable */
+	}
 }
 
 


