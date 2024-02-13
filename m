Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA9E5FDDF;
	Tue, 13 Feb 2024 17:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845515; cv=none; b=PfPvZCH06OBXO0TbCdWMb1AoBK9rl/el+qQXstkPtc7Pot9viMVyYyeuguPS2zvB/HQDDI4ejfleX6r1wPklM92hqTdSEZIj7wjLpzZ4JirVvSnpqnxwRUMMHgiKjET3t8fkUXhpef3m8aBHdn8/cfF7sUedjGNoS6A2G4l8zHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845515; c=relaxed/simple;
	bh=MknbxNhz/or3pYTIRf3Z6O2d8RiVymHYJICz6rtrNG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfilu/+bpJfG3uDrjCvcRN7AuoWF+eouiu+KAnwJRlITIU0U2Dcpzg2g1onyciz0O6s7jEo9N7UW8qGy1TcyzMOgYiaCBOm4sClW/ElNcM6sBszl/bUfc4WrI63C5R5RdW+mU4xW+8p7TvpTg85zUCJMAV0ChzTEPDm6aHqLfDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GYwph7ML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GYwph7ML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D21C433F1;
	Tue, 13 Feb 2024 17:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845515;
	bh=MknbxNhz/or3pYTIRf3Z6O2d8RiVymHYJICz6rtrNG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GYwph7MLresNZP5QmfFFgkNEJs/I8+4fPMI6zZpdRRmdoXDvtRADB5RLcIYiJxf0p
	 p/YT62lK8l1NHPgZ9ELsarr7RBR0Dj1jM9A4cSPowdhvow7UWRQEaw1Vs7e0QhsSCc
	 52WJI+MpLm3ZKK8GbgaUH/8kyfBzQdstYodkRZiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sikorski <belegdol+github@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 100/121] ALSA: usb-audio: Add a quirk for Yamaha YIT-W12TX transmitter
Date: Tue, 13 Feb 2024 18:21:49 +0100
Message-ID: <20240213171855.912459558@linuxfoundation.org>
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

From: Julian Sikorski <belegdol+github@gmail.com>

commit a969210066054ea109d8b7aff29a9b1c98776841 upstream.

The device fails to initialize otherwise, giving the following error:
[ 3676.671641] usb 2-1.1: 1:1: cannot get freq at ep 0x1

Signed-off-by: Julian Sikorski <belegdol+github@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240123084935.2745-1-belegdol+github@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2031,6 +2031,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x0499, 0x1509, /* Steinberg UR22 */
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x0499, 0x3108, /* Yamaha YIT-W12TX */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x04d8, 0xfeea, /* Benchmark DAC1 Pre */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x04e8, 0xa051, /* Samsung USBC Headset (AKG) */


