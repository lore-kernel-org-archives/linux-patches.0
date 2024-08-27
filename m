Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB291494AC;
	Tue, 27 Aug 2024 14:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769701; cv=none; b=A89W9qvpDdM/ZentkLTJ8yO458AY2bof79/kOMDHtwBMvq3WkPWGd2NFdj5dGRjqbey3OiTaqsGYzAtLA5WBOf4uYfiH09mP8MPeoTEdWGlZOPubsO2MoXItiwOwsRuC0cRTuiGgqdfizwkvRmSD7rB0WAyfZK5oeQVskx3WyWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769701; c=relaxed/simple;
	bh=ojYONU4LCjwFabzikN13dNvudONNRz9QxeEmhfomXFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0vf1DqOsnYcMv07I0fB9jHojxDGoQEPpqnjeyvOpl+pxp2QLCixFWqdpu7jwRXC5fTsyQKAhJxVSnifl7ujbVqSCHNz6teWF4YnDPf8p+uSQuIo5FZxQxL/5g1NWUnEhHysO5T1qeXrfZA6xiyaT6GWX46EWM6btQkoLaX8KAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8okE+dC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8okE+dC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8FA0C6107F;
	Tue, 27 Aug 2024 14:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769701;
	bh=ojYONU4LCjwFabzikN13dNvudONNRz9QxeEmhfomXFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8okE+dCct3Rp38Ck6RugLgOzQWPTjHAtlT3qgLTpg4/YIYVnp7g2kbAQR4+Ir2BZ
	 a+uMcSvBvA5NRUo7pjbGTJaOkzYxSIlr9cAQOPuzFXmVtGFQx2PUmW/1fhlfiGMFg9
	 mAoWLN9yDyhUm35yGHDVRhrb3/imFv7uhWEW7SgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianqin Hu <hulianqin@vivo.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 011/341] ALSA: usb-audio: Add delay quirk for VIVO USB-C-XE710 HEADSET
Date: Tue, 27 Aug 2024 16:34:02 +0200
Message-ID: <20240827143843.834919584@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lianqin Hu <hulianqin@vivo.com>

commit 004eb8ba776ccd3e296ea6f78f7ae7985b12824e upstream.

Audio control requests that sets sampling frequency sometimes fail on
this card. Adding delay between control messages eliminates that problem.

Signed-off-by: Lianqin Hu <hulianqin@vivo.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/TYUPR06MB6217FF67076AF3E49E12C877D2842@TYUPR06MB6217.apcprd06.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2181,6 +2181,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x2b53, 0x0031, /* Fiero SC-01 (firmware v1.1.0) */
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x2d95, 0x8021, /* VIVO USB-C-XE710 HEADSET */
+		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x30be, 0x0101, /* Schiit Hel */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x413c, 0xa506, /* Dell AE515 sound bar */


