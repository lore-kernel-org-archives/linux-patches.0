Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061068;
	b=jZAYeDb6WFRVE/sFUr8UtJOtjF+OjI3PGIUGBCx27xo1VDV9joCcQK53Kbv+q/wa+9bZ
	 H7IJgfBHeN0TtoE7DyseDVzmTSMtErQBaS0QJ8RMD/BBh9RscW0tSPerOreGyR+k9dqOt
	 rH+SfXG1UcYNTKyeQ+RVYv5OIl+jdlEdLMT5BNQzfkrzpPgorJeI+zYwya5ddPoi+a+15
	 WVA8CfGBhNLaxPT7yjciCjkingmi9tv6KvhDpi8B150U9UqyHF4HEJYSxi2lbA09tpeH8
	 Xg6cZZddItz0ZDgsHeUy3lJtub3NnZun7LrStPq+w+bAuhVvdvG2xfGZMC9r6POp2MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=InwRp9TBHIwJuy0rgW2/rgexlSG47aUEfZ8X3XtZidY=;
	b=I6aBphjrGGpB5eB7Xj4s/6GU8ym8yBVmM/kKd9kOmjMhbFG1aGQODUlLcEajh9XIKeu1
	 91F/9n2YXq63gQA3vw2Id39JLmOYg6CqsjWE9Bgj3+1k43HFhDpvi72zLSz7jdX9ujgcT
	 sh6w2cdLOpkB5VJmUAyITbyh6n4Bh2cDrjFBhS/krwv+gQ1b1Xjs3mVwwDfdoLtX6fdmz
	 4N9AW19R5r8aBBd3+y+hA2tebPGdOmn4JuOKHIz35tjpBLt1RXMqZiOPpsSVqcNl+Rw6K
	 F818roQV/M/010rcFO+slKBbwe6SLFs3fBpyC+INeWHtoNjOyBqyyhItOGK6OrOEmuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aE5pl7ZB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E409E606A336;
	Sat,  7 Nov 2026 14:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aE5pl7ZB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C481F0089F;
	Sat,  7 Nov 2026 14:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061067;
	bh=InwRp9TBHIwJuy0rgW2/rgexlSG47aUEfZ8X3XtZidY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aE5pl7ZB/FKhBHKA2B6t8988xMVxcntdZKtx4jE6P7OXoOxb+tz4VEBEPX/qNglFj
	 0HokabUooUDAFbDzOTjQm5bzily7jkU4G4Zk1hLkazZ4diwnVJbN7kmdWW+lyTDDUK
	 fIpPgQE/ipV4nwfVT6PCG80oXG1WSO6G7XMvcK9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Federico=20Valent=C3=ADn=20Andrade?= <fandrade@frba.utn.edu.ar>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0395/1536] ALSA: usb-audio: Skip mixer creation on M-Audio Venom
Date: Sat,  7 Nov 2026 08:40:11 -0500
Message-ID: <20261107135008.690101692@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Federico Valentín Andrade <fandrade@frba.utn.edu.ar>

[ Upstream commit 4c0ec35e011309bd7091053ad5bbc01420967a66 ]

The M-Audio Venom (0763:2084) does not answer any GET_CUR request
of its feature units, hanging up the USB microcontroller and
"responding" with timeouts. So the mixer building lasts around 47
seconds, and the device does not stream at all.

The same GET_CUR requests issued through libusb (with no kernel
driver bound) complete correctly and blazingly fast. So it seems
to only happen during the initial probe.

I defined an explicit composite quirk to bypass the mixer creation,
as it is not needed (the synth already comes with volume controls).

With both this and the device flag applied, the synth works
flawlessly.

Signed-off-by: Federico Valentín Andrade <fandrade@frba.utn.edu.ar>
Link: https://patch.msgid.link/20260824140211.17003-3-fandrade@frba.utn.edu.ar
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks-table.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 8f47f29f38de7..5dcbd85a25112 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -1814,6 +1814,28 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		}
 	}
 },
+{
+	/*
+	 * M-Audio Venom
+	 *
+	 * The AudioControl interface times out on every GET_CUR request,
+	 * which adds around 47 seconds to the card registration and
+	 * freezes the device, blocking streaming.
+	 * Using an explicit composite quirk to skip the mixer entirely.
+	 */
+	USB_DEVICE_VENDOR_SPEC(0x0763, 0x2084),
+	QUIRK_DRIVER_INFO {
+		.vendor_name = "M-Audio",
+		.product_name = "Venom",
+		QUIRK_DATA_COMPOSITE {
+			{ QUIRK_DATA_IGNORE(0) },
+			{ QUIRK_DATA_STANDARD_AUDIO(1) },
+			{ QUIRK_DATA_STANDARD_AUDIO(2) },
+			{ QUIRK_DATA_STANDARD_MIDI(3) },
+			QUIRK_COMPOSITE_END
+		}
+	}
+},
 
 /* Casio devices */
 {
-- 
2.53.0



