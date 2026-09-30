Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EC451DE10;
	Wed, 30 Sep 2026 16:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784776; cv=none; b=VqbCaSs3Hve5LldD9y6ut3TIM5Dw8zxJ+hAAbeCi1XeMXGcnZIlykW+Tcrks7BYaLzpUPPZqXQtTm2vOruYy69ymy/bhlZ4f/7Vg4cPlDy0Z4IYefLNptBHxL+yc4BS7ZAfIPXaWxiqy0qHJDAtTBlXZwYaQ9u5xX22dkxD0h3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784776; c=relaxed/simple;
	bh=ew69Rdz7wN//NrpVpXBiAjqw4qPwjLbrICa25Srs0mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9e6vjBL+HdVg1MdkVnHpJ+79eBS0ol/3O06wnHcHVt1vvf5F0a4d7IfJ2jp28qWgDlqam/k0RWHrGXnarNw0poC7W3P6Dv5CdiZLyCvEliM7Yy9TTdNFNdKqOhhQ6fxKN8WCvxo2dSENSxvcpG/H29PCHXKslHzAIG3rM8alRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJx01gKz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJx01gKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936A61F000FF;
	Wed, 30 Sep 2026 16:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784771;
	bh=iECCjTUagBOZFfp7uamyrvj6qKpwXsGzJl8SvxLwJNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJx01gKzo2q/RWX1hmf0dAsOgj+L3SNg9hvVqlQy/CaN1kHZiL/04rZj6z1WUiLF5
	 OlLZymx7mvK4kHWOVuHPPNiU5FL3yeeJKkB0VtsC9HZPAY8Re7T8xe9hT8Or7VP62B
	 u3jbcOHaBgWlk+HGNi/WSBZ6z6MtXPngllHR1HEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Daniel C. Ribeiro" <dcoutinho.96@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 273/982] ALSA: usb-audio: Add FIXED_RATE quirk for JBL Quantum650 Wireless
Date: Wed, 30 Sep 2026 17:16:49 +0200
Message-ID: <20260930152422.664857948@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Daniel C. Ribeiro <dcoutinho.96@gmail.com>

[ Upstream commit f6d6a4147ace0c417035f65b021027c209c75190 ]

JBL Quantum650 Wireless (0ecb:2125) requires the same workaround that
was used for JBL Quantum610 and Quantum810 for limiting the sample rate.
Without it, the capture (microphone) stream fails to work.  Setting the
QUIRK_FLAG_FIXED_RATE flag, as done for the sibling models, makes both
playback and capture work correctly.

Signed-off-by: Daniel C. Ribeiro <dcoutinho.96@gmail.com>
Link: https://patch.msgid.link/20260719090037.40149-1-dcoutinho.96@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index b575b50337cbd..22e69a6528dff 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2157,6 +2157,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_MIXER_MIN_MUTE),
 	DEVICE_FLG(0x0ecb, 0x205c, /* JBL Quantum610 Wireless */
 		   QUIRK_FLAG_FIXED_RATE),
+	DEVICE_FLG(0x0ecb, 0x2125, /* JBL Quantum650 Wireless */
+		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0ecb, 0x2069, /* JBL Quantum810 Wireless */
 		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0fd9, 0x0008, /* Hauppauge HVR-950Q */
-- 
2.53.0



