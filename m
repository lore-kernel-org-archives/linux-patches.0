Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8636BA93C;
	Tue, 13 Feb 2024 17:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707846002; cv=none; b=PCUD1VtmGZLWvhVkjuTsKrM/Y/reHu0l60xAbl6uam34Ynek6sR+2RvF6lZzkOtFjH9Uc2xo6vKwGB2+tZVI1rGGIpSTMfo0CNgrFTEc1x8TcwjCF/+/Udr5MMW+03QU9lms7S2+Hdg9TzLuO7Pg4yli5SAmr4LSq8tNg249fzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707846002; c=relaxed/simple;
	bh=nsYipW2AEAK05xVrORWvb6qtf0MsdWV1Y4H3SH4uRm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVmAshUhSRV03BSnhy8I8JLfZ5vwXQbu6R2kAeLK/csQFqsAXeZ/A71zyUcXc7fuTKpgvT+M/tc+liLafp1L9k4S0RJ4WhvnN/OFtmI5hbKYe7qYHkbM0tB2q9QgehXNQa2G4RqwxqUElnshiW6aMRBs0EdSArZlhfofMfGKnKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C0XJfKOA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C0XJfKOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7C3C433C7;
	Tue, 13 Feb 2024 17:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707846002;
	bh=nsYipW2AEAK05xVrORWvb6qtf0MsdWV1Y4H3SH4uRm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C0XJfKOA9C/tqN4axjHgqkWbmU0KQo8/ln9f+VXw9tuP0PurDwL5U44sTf/SapYaP
	 sJy9awWLckmHW8Bf1dSNW6UsxA7fbBmSNb4lUxRkR8cxCdM8d96x+1RrFl22t4StCO
	 xKAkVR9U5T+/d+LP/AdJLAVMTBgSWczc0UVHG9Yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sikorski <belegdol+github@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.7 088/124] ALSA: usb-audio: Add a quirk for Yamaha YIT-W12TX transmitter
Date: Tue, 13 Feb 2024 18:21:50 +0100
Message-ID: <20240213171856.302997717@linuxfoundation.org>
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


