Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C250EA93C;
	Tue, 13 Feb 2024 17:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845995; cv=none; b=jsZC8WeoRA2kozLn8Bn4GsJi/8hU8Knk+ikz4rtxLLtKypklGR3e/d2gYSXm+rdLI9YGYNL58Mdegl0PpAAZFQqgf50uJiPdVAt9Y7VIYNH3n6CSoLYgxhe+Rg8sAMOfTloysJS6hGUHX8DSR54QxBxwR0ceayFqs92a55FS9/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845995; c=relaxed/simple;
	bh=E8QRCELMxBGLuk3SFYdPjAOFEnsHPBKo5NSoJLFE5fY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BH0m68TEedPDXCChmrupq7su6RT9/j15HAywk0ljTiv9kIonrGJ/8TjiDN7uAGYdTAUkBIO8ZOtJm++5frx1lntuKNEAdUlEtVasbNP5ZWE0RkG7XNwWY2YxWlQcLtqe4kU77NwbBnKcmtJRWeXO0zxi091BJT2GM6aatry3TI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sY8P6YRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sY8P6YRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237E9C433F1;
	Tue, 13 Feb 2024 17:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845995;
	bh=E8QRCELMxBGLuk3SFYdPjAOFEnsHPBKo5NSoJLFE5fY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sY8P6YRLKa+Py+xJfRFFIhQjdF+H4sKoFeEFCdZ3/DBStWYZnhBUQO5dzzPjmr9xi
	 kYWUSwcFm+UWviCRVEeeF67hWEeKgnZK3V602qJEeboK3elpMUluI7gFAOZ3zU2C+d
	 T5mXu1XdZtyWKMDGDymeTJct/KyHj4v8ovEyIUOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Tsoy <alexander@tsoy.me>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.7 087/124] ALSA: usb-audio: Add delay quirk for MOTU M Series 2nd revision
Date: Tue, 13 Feb 2024 18:21:49 +0100
Message-ID: <20240213171856.274340196@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Tsoy <alexander@tsoy.me>

commit d915a6850e27efb383cd4400caadfe47792623df upstream.

Audio control requests that sets sampling frequency sometimes fail on
this card. Adding delay between control messages eliminates that problem.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217601
Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Tsoy <alexander@tsoy.me>
Link: https://lore.kernel.org/r/20240124130239.358298-1-alexander@tsoy.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2073,6 +2073,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x0763, 0x2031, /* M-Audio Fast Track C600 */
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x07fd, 0x000b, /* MOTU M Series 2nd hardware revision */
+		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x08bb, 0x2702, /* LineX FM Transmitter */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x0951, 0x16ad, /* Kingston HyperX */


