Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F0E4C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:50:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7FCC433C1;
	Mon, 14 Nov 2022 12:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430239;
	bh=GDEt/FSVAuPSoI9CeTo3xTQoRI8yEXRfbRul0s57cZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TtWAUTlup/FlfG9vTYfik7bpev8/fHqyr5OCr8R4s+X5mYyYX7f8VtMyoEz+qGRg9
	 +A2ijKSFR1RZMPeT1p8Sn0kAzu+vM6sC5RgRZsnmHzKMJ6DtGADh7Swdo49vPvwphM
	 3ELUPIuWZjm22DZc0z3bNxy2aaujNNIsh4S61Zg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jussi Laako <jussi@sonarnerd.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 66/95] ALSA: usb-audio: Add DSD support for Accuphase DAC-60
Date: Mon, 14 Nov 2022 13:46:00 +0100
Message-Id: <20221114124445.283862038@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jussi Laako <jussi@sonarnerd.net>

commit 8cbd4725ffff3eface1f5f3397af02acad5b2831 upstream.

Accuphase DAC-60 option card supports native DSD up to DSD256,
but doesn't have support for auto-detection. Explicitly enable
DSD support for the correct altsetting.

Signed-off-by: Jussi Laako <jussi@sonarnerd.net>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221108221241.1220878-1-jussi@sonarnerd.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1744,6 +1744,7 @@ u64 snd_usb_interface_dsd_format_quirks(
 	/* XMOS based USB DACs */
 	switch (chip->usb_id) {
 	case USB_ID(0x1511, 0x0037): /* AURALiC VEGA */
+	case USB_ID(0x21ed, 0xd75a): /* Accuphase DAC-60 option card */
 	case USB_ID(0x2522, 0x0012): /* LH Labs VI DAC Infinity */
 	case USB_ID(0x2772, 0x0230): /* Pro-Ject Pre Box S2 Digital */
 		if (fp->altsetting == 2)


