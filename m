Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6135F1C68C;
	Sun,  1 Sep 2024 16:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209386; cv=none; b=n+GhdmE8mVXqHy9wd+KBrq9B1lDEVoOswruct1fhuUAfh9ePyXkBR75s0H6swXd10z0QDNrtpDv1SFxwbqf2VdGpFiuPkPc9qY4Hex35Uk9fTNeY6OWVAN4Sisr+riZHA1q0RYy3j7b9N7cpHmvN8APVZSLR1O3SORlGUjiDtUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209386; c=relaxed/simple;
	bh=bEfm5ea6uLZxg0LIbxKttBmqpPDf+auPH7zls/jSowI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PTvUooedTn1aM/dP3P5R0/Wsq34rztEHdqw914bP+WdD6RuP5mtmcK1vYLrh4ILlvlTmoMObAL1Rai673zb9U8t8X8DK7EOoZapKyTlF1DHmJiCsVhIhahWI42qltJm3Y4I5ympiLz9yYye+Iamwq7Hd6+W8gN2/A5h33dRTBvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qCy2rXV9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qCy2rXV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6A1C4CEC3;
	Sun,  1 Sep 2024 16:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209386;
	bh=bEfm5ea6uLZxg0LIbxKttBmqpPDf+auPH7zls/jSowI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qCy2rXV9bq1ZgSA3Q0SjGmuEL35l4YYq5zb9mHxz0UHC03ZAsxw9iQzvx7hqQcFH1
	 b6vmHYoFJIX280WRWNv9bbyZMb9t8X0dX3vCQhqJNnakTI0UtSzF7k/uRDUtd8vVrg
	 PeSmKke3LCLozFHn22ok3tUIBETZbAYRdSK8e/jY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Juan=20Jos=C3=A9=20Arboleda?= <soyjuanarbol@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 002/151] ALSA: usb-audio: Support Yamaha P-125 quirk entry
Date: Sun,  1 Sep 2024 18:16:02 +0200
Message-ID: <20240901160814.186662418@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juan José Arboleda <soyjuanarbol@gmail.com>

commit c286f204ce6ba7b48e3dcba53eda7df8eaa64dd9 upstream.

This patch adds a USB quirk for the Yamaha P-125 digital piano.

Signed-off-by: Juan José Arboleda <soyjuanarbol@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240813161053.70256-1-soyjuanarbol@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks-table.h |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -273,6 +273,7 @@ YAMAHA_DEVICE(0x105a, NULL),
 YAMAHA_DEVICE(0x105b, NULL),
 YAMAHA_DEVICE(0x105c, NULL),
 YAMAHA_DEVICE(0x105d, NULL),
+YAMAHA_DEVICE(0x1718, "P-125"),
 {
 	USB_DEVICE(0x0499, 0x1503),
 	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {


