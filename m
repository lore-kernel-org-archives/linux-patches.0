Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831104;
	b=WKVcRDZaES7iAHGH5FdIG3vJhrWa5lVwhX8+5yZ2wy0p+dqJEH/+huqRSKhlhH1WdQeG
	 cr2MMIGrfFIHRrNMs3SD2FA+FrsxmZOS1yuyxHjHzrrMlxXicSdefscWaMMNIC+VeDF3M
	 VktEfD2GXNygqZWj9kM8BsSUCVUnOx8ZXMFBNAmUFD0F2teMuAfCitJxihIUqAS9xH/xN
	 pmqwfZFhbF0o+lsUqF5hv6ye42qaWg9kcsSSbg4houCzoGA8Ev1+6B7W1TvciU106aUbO
	 CGmLALKrckVJoPC8anuYPe1DtnGWB5O1IhU9dgF6CazLE2zy+U1KJ3c2/Iw3nUO3+GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=bXS6vqrCVExfHshDVxGwzSRWQ3MBMEprJukSY9lDh1I=;
	b=1D+KSfvrFj57ZV+7zWOQvQNkM0mWEKl9btxp/2Y5upQeuBs5bizUL9D0sny+wmKsBw8/
	 9D6EIVVoMi/50HuHkR5rvHmRgrsM7fqlZK+ydsot/S3+URL3BA1MRBZ2i4a1FhpIGiN30
	 Tx7KMmI2CXvZe1MIrdpNz6ZjHFecHwgixf8XxnPtlafMsKd0tGvL5tbCgE1iL6r9TpvlH
	 WjEn8kdDxsvuQtOo6DTxxhfVKE/mfNynmf0lS9/gr3o21PeMvUk4B4ovTRQrL6QX4mSt/
	 ImGYuFJF78rycVaNvdOFvmMt9WyqAHgi1aVhEaJ/5zBvJVKUuUiByhQf3vuZ4A/sCRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JySew4S5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DDA606B2DC;
	Wed,  4 Nov 2026 22:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JySew4S5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92161F000C1;
	Wed,  4 Nov 2026 22:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831104;
	bh=bXS6vqrCVExfHshDVxGwzSRWQ3MBMEprJukSY9lDh1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JySew4S5PXzpvhTKc9DRp/NkWcSoMSVstUWElAIZ9dFwC14yA4W7bQNmJ88P9IGPO
	 usqXEHwoePiIpmNVeEjhw+IDMaD0oc27sfVpoyKld+X0CgON8DeSbeDnw18SHTti1W
	 ewnnk9XsSGmHYO7GoQQ/Ik9nPdcH8161ay1zGsps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Federico=20Valent=C3=ADn=20Andrade?= <fandrade@frba.utn.edu.ar>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0467/1005] ALSA: usb-audio: Skip mixer creation on M-Audio Venom
Date: Wed,  4 Nov 2026 16:03:20 -0500
Message-ID: <20261104211057.096763928@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d783dae1850a0..061d21da91fbe 100644
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



