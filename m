Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393A65FF04;
	Tue, 13 Feb 2024 17:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845512; cv=none; b=ISqIhKkTuqmVRN30jO+iBtS8EeX6bTXUPlJYTXy6hdcIA4srUrxi29a43Vt0TGVN3IhlR9aF8vrB9V3jMX2BPK3LI1sW8tJFoShpQCBjPF3j+zcm9PmUTqTuntTuUNX6XUesNMNwIiG9TVcNxMlIaKcy5dfQpfyUtI1kkg0odgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845512; c=relaxed/simple;
	bh=NwDOQWDxBz74iyOVe9VEfDQZA3n7v/QOi+0SvyrtvGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXUVkowV56qRC760pboWUmjR4jVS/4OUS3s4tMPWUpuK2/hlKpPykQSRD9lE9v8VMyHv6nuy7RvNhLYDMro+y0ReSVWyJh16FrLz55OUjHMEWhV5EgNTNjv7S3hkGtlARTwmq++BYRoT51wXui+Wh90BYeW+HTZbRzBg2y+5Wjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tvx9i4hN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tvx9i4hN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A974CC433C7;
	Tue, 13 Feb 2024 17:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845512;
	bh=NwDOQWDxBz74iyOVe9VEfDQZA3n7v/QOi+0SvyrtvGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tvx9i4hNIDqKXRpF+tIi/NIdLXvsrv+nuMfTVjMakrFqLXFYCO2idAkFfKS7sa2MG
	 jGfCytS68fhWuHaIfi+4Pocc0Mi6Kh7Oj+EQtbDYRe22OPzlZB3XAiunpetqTh5yro
	 OrRBYTDvEUChJHvT646LYv5Rc8b2GO1Ekk8g7Xow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Tsoy <alexander@tsoy.me>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 099/121] ALSA: usb-audio: Add delay quirk for MOTU M Series 2nd revision
Date: Tue, 13 Feb 2024 18:21:48 +0100
Message-ID: <20240213171855.883850347@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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


