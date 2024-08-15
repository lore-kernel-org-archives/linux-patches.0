Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C7D1AC8BB;
	Thu, 15 Aug 2024 14:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730471; cv=none; b=a74DAyzmncFs9AxeOAbT4NJY2dT+wHJXB/QLl0s5LSuZzVnXHt9ZPa/nVdk20Btuqigv5+DCTQNOOmzriGs3pwJwTw8ojIWLAWPNNYmJA0hbqZ5I8Mfmlvsz9U7U30nPJ0L9Zmk9Rp5c3H0qjhtlZa13fdI1S5crCijdMULu4G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730471; c=relaxed/simple;
	bh=+9dwOwozR+9E6XWZgC/6pmKdKjASfSVPR7MSdGtBGMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ly7ueh7JWvxnJSXF3r1BfoM3Myb6mkphnC89nYCgWAz/b8NG+IkPYgrt9h7YLMoQHuOSAC4UDXok/fs/tOu/Ufe+P0OWzbzUQnWI1+t0m1rbX7GmVVgK10wze2OP4Wm7f5x63rej0St4tqflNNbByT1Ahd7Kk9nFMepxFTZiMxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MpiQYYcb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MpiQYYcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA269C4AF0A;
	Thu, 15 Aug 2024 14:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730471;
	bh=+9dwOwozR+9E6XWZgC/6pmKdKjASfSVPR7MSdGtBGMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MpiQYYcbYqNrc2cG2cOt0KwSYmBK8spWTHFFDEkDkkqScHOMZ3Ij1ugrbdAgiHvt/
	 DI1766Rkk5ISUFdrYdZV+nmh73Vu1DMF0qHDWCZ7AMwsmlFhnRTQlzCvhNKTS0HyJu
	 XMCXcrbs0SLeK3YxhWYfoq/cOSvMik3jMikwg6vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Steve Kendall <skend@chromium.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 418/484] ALSA: hda: Add HP MP9 G4 Retail System AMS to force connect list
Date: Thu, 15 Aug 2024 15:24:36 +0200
Message-ID: <20240815131957.601310641@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven 'Steve' Kendall <skend@chromium.org>

commit 7e1e206b99f4b3345aeb49d94584a420b7887f1d upstream.

In recent HP UEFI firmware (likely v2.15 and above, tested on 2.27),
these pins are incorrectly set for HDMI/DP audio. Tested on
HP MP9 G4 Retail System AMS. Tested audio with two monitors connected
via DisplayPort.

Link: https://forum.manjaro.org/t/intel-cannon-lake-pch-cavs-conexant-cx20632-no-sound-at-hdmi-or-displayport/133494
Link: https://bbs.archlinux.org/viewtopic.php?id=270523
Signed-off-by: Steven 'Steve' Kendall <skend@chromium.org>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240806-hdmi-audio-hp-wrongpins-v2-1-d9eb4ad41043@chromium.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1960,6 +1960,7 @@ static int hdmi_add_cvt(struct hda_codec
 }
 
 static const struct snd_pci_quirk force_connect_list[] = {
+	SND_PCI_QUIRK(0x103c, 0x83ef, "HP MP9 G4 Retail System AMS", 1),
 	SND_PCI_QUIRK(0x103c, 0x870f, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x871a, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x8711, "HP", 1),


