Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043735;
	b=fwa3yPLH1Oq1wZyPqrMt8qYAhdsjDWj3V1rSSvAzVDDeHzDmnJtF6/0IU0890FCaqBGj
	 XS2nm837vLPZiaAmbpaquRQQOCBdNQg/LWITNU3dxUWHO/hi/jSLT63AX5XEWLOoyUdcd
	 qVKoP0QGL48dzcAINjG3+bz6nBQJRxK1o6USwQo/6UZgkqQBTuvQ9UnldtYCMRTs46YJB
	 cVBK3jiDHpCxl0ri76DH2jVDn1DkVlgUuFNjzYXsRN3BuihTAnMF0N+T8VdowS+Elmt4X
	 8Vb8zaYsU89IAHLhUjnbS5fnoFhAFx3DeHXgyMCpnJdBV/yoU5n4cYnmbofLKhr3wCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043735;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=DEqDsuwjQsItG3W2fQw5LHRKxUOghczGvCdowwmFFTM=;
	b=5VpeMkbbJQNUeLK5EAtssmtm3FaGPlYE3ZbS0K3lELPdh3610cbhvPGxK8XpVS5KH9UQ
	 W+M0tK+4Z94Tor+zMWAEtK2C+0o6tmxIyJa6+umTaebJ+5P+lkksXZa8SG5cxzXuqnSEP
	 dJGMzwnBvROuFbILiZpts+WRSBpVS2bjWeQCq2tIBi/TkoXGhMk66N2fEeuM/KGOdRFTJ
	 0KGtV1p49tzD31ETfdABRI0xgFQLehpbfY6eItyxZarlGyAZLJ6gDzz2VCPhXS6HHxBzp
	 6nVAlg0Qe1htB+XdVpJKCbGRTGXDvixxOeSNwsIhob1IsdJvmbWzuo+p4dywZ9njnnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jDmvRg8e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C903606A32A;
	Wed, 18 Nov 2026 23:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jDmvRg8e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A211F000C4;
	Wed, 18 Nov 2026 23:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043735;
	bh=DEqDsuwjQsItG3W2fQw5LHRKxUOghczGvCdowwmFFTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jDmvRg8eBLAIy6mIiCEig47ZWesri9glQ/s4eGWCFHIqwB5y0UXaV2H2IdUwLZSOn
	 mvdfj/7rmChbBJRLYBU7XhhNXAksWnEkdP5yF12Syhlsyhy9Hj59KQmCmUED3AvSp4
	 fXea9hIwCXicFKPy6jOnngZ76Dh2fS6rzGXGynwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Federico=20Valent=C3=ADn=20Andrade?= <fandrade@frba.utn.edu.ar>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0279/2857] ALSA: usb-audio: Skip mixer creation on M-Audio Venom
Date: Wed, 18 Nov 2026 15:21:53 +0100
Message-ID: <20261118150211.472346271@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f4995560050ab..b505ec63f199d 100644
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



