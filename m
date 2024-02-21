Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4747B3F2;
	Wed, 21 Feb 2024 13:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523172; cv=none; b=WeOl7Hbqm1ES/QExEOgj6JdfAxHjwiDZiDOh42Li9Gwu6ng/iysW5J/YA9iSOoyM2mCjNtaaihYQkmvfc6dIuOhxZkxssMCEOLLFlo/BXwuOFOvU1z+t1+fBy4TN7B2PrehSVIQBFg9nGKmY5T8FB89MhE7B0yRCK8WO/WQWb18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523172; c=relaxed/simple;
	bh=aBC8A86UhPWSMeeSvMUbcu9XaVJFpfPEOA7xL/EZzgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ulj6KhnU2kaECz/LXMCJH1/h40V0cfaSA+tNoTAj9WLLDL7MY4ZsMSELXTC1Rzz/fw1/KmxyNr3fCPMFKzmEOQncTj9sZz0AK5i657tsrCDTti1uuRKxDx6MartS+mTjyE6KG4dVXioFuKEUoX/Ai8CnF2MqBD8GyVstcoLC2wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7b/eL+X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7b/eL+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58117C433C7;
	Wed, 21 Feb 2024 13:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523172;
	bh=aBC8A86UhPWSMeeSvMUbcu9XaVJFpfPEOA7xL/EZzgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7b/eL+XsYyK8J3+Ioaprxc1tKtEpe7L7Eq3WExTyo/lbyn2yITwdBTWlyOAsTWwn
	 JYEx+L65gG2Z6hIgj+jAhzplVDNK4kXr5pl5PhxpVivXeuGLHbLNHI4hp1PzFHDIww
	 2gSOWzcdJcx+7OPgh18wa7IIERmnUO5wTY0ugbHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sikorski <belegdol+github@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 330/476] ALSA: usb-audio: Add a quirk for Yamaha YIT-W12TX transmitter
Date: Wed, 21 Feb 2024 14:06:21 +0100
Message-ID: <20240221130020.219023292@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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
@@ -1759,6 +1759,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x0499, 0x1509, /* Steinberg UR22 */
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
+	DEVICE_FLG(0x0499, 0x3108, /* Yamaha YIT-W12TX */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x04d8, 0xfeea, /* Benchmark DAC1 Pre */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x04e8, 0xa051, /* Samsung USBC Headset (AKG) */


