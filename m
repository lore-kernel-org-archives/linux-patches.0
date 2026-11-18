Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057610;
	b=mI9G9xeqs70uFXdai+eAPps1hQ9uFBseOIMwoFXOp8e6GVKamJN0OGii2/Zyi22neTWP
	 mIOBqdZ/3gV4PIBGFD3SzhTT6fHew7OXsdGSZlWrpT6ijZOAu4NBrYKUszJ1Sn+JeNVGX
	 FbKjRzoohYSGAHsDh3Y6Zqn/oj3tk4AU+kaBst9OzcporUV6OHV+IiLKZYh+1H72jlcPd
	 O0eUKAjTrLuNUSqXE+HLGOiFzabCo5iScPJDJ9qSpTmf6BxPnyInpkolbzpUh4kyXi/KL
	 64Va4nEZYVJliD0KMpDf1tE9aCj4Z/whVx5ZiUWoKFT8do8pQhVUkS0PIXzyiwDJB7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=DtRZ3kFn385gecfdD7boiZWMRGVuEhZhf4GZ247NStE=;
	b=z7yzMFPUHIG3dBxwadgz/FFAzMjoFJTzCzCYCOnK29B7dfsKAymJ7Vvv9v1UuOijlnJK
	 TF8RflEZyKYlX2MNWd/Se02sZsjGo9LNS2Y12HFsXvQX3sQcbhw1Gh6tJ0pUUegEc4XM9
	 SZcyBhigNO0f5Sedvr4OXpifaLMp/xbytggcWZP2ixPuhqsA0/RPaTKfesYg4NqUUaEXB
	 F3bkSWY5L2Mq5Bzj+TyzotnTbDzRUnQOZNSdrL/KMP8UBfIkhZfQF55yBXoLzXihq1rcd
	 qC1nANFVpwcI76WSzl06He5+xJPfzg3KG/njNH0yex+KrS2MtqjXsquF7SnNmHstC8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cJKuAaDC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F93606A33F;
	Thu, 19 Nov 2026 03:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cJKuAaDC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8EAB1F000C4;
	Thu, 19 Nov 2026 03:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057610;
	bh=DtRZ3kFn385gecfdD7boiZWMRGVuEhZhf4GZ247NStE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cJKuAaDC19PlGyPcPAhySYUM1TKhM7CRN2baAzw+G61uI6VQdzW5cbZrujP+AhOU5
	 0nYkIzZ3PeFpP1K7IezbUVpDl65GU1n33srZNor4q6/1KpxunFxf5lzbhnnKwKoB3o
	 CLIT5fHMAYTcRtx1jvVBcUoNOA8BaCyWYY8HcyWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Federico=20Valent=C3=ADn=20Andrade?= <fandrade@frba.utn.edu.ar>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0192/1848] ALSA: usb-audio: Skip mixer creation on M-Audio Venom
Date: Wed, 18 Nov 2026 15:37:10 +0100
Message-ID: <20261118145919.780625407@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3891952e17476..3ae8f8cd22d94 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2414,6 +2414,28 @@ YAMAHA_DEVICE(0x7010, "UB99"),
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



