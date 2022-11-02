Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E21D7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CA4C433D6;
	Wed,  2 Nov 2022 02:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667356636;
	bh=hirwckMCgJj+uW0rDUlQ18kc0agJ0aW2bIOVc7+5l04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D1EoCIlwS9D+aBKDXba4y5fLgvzk1tMtiLo288w8iBmszWAZbDsOQ5eFoPliH3iL4
	 PB0BuyJ5WqXY+6c4i5pF9sPJn9Ds+HbZTsbEuALA3O/MMZn87z598ewXAdUnrnHtca
	 5clApMzwTjl8P+rGHhuJuRzcBMBRZ6RM9WLSqwis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.0 008/240] ALSA: usb-audio: Add quirks for M-Audio Fast Track C400/600
Date: Wed,  2 Nov 2022 03:29:43 +0100
Message-Id: <20221102022111.596913025@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

commit 794814529384721ce8f4d34228dc599cc010353d upstream.

M-Audio Fast Track C400 and C600 devices (0763:2030 and 0763:2031,
respectively) seem requiring the explicit setup for the implicit
feedback mode.  This patch adds the quirk entries for those.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=214817
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221021122722.24784-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/implicit.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/implicit.c
+++ b/sound/usb/implicit.c
@@ -47,6 +47,8 @@ struct snd_usb_implicit_fb_match {
 static const struct snd_usb_implicit_fb_match playback_implicit_fb_quirks[] = {
 	/* Fixed EP */
 	/* FIXME: check the availability of generic matching */
+	IMPLICIT_FB_FIXED_DEV(0x0763, 0x2030, 0x81, 3), /* M-Audio Fast Track C400 */
+	IMPLICIT_FB_FIXED_DEV(0x0763, 0x2031, 0x81, 3), /* M-Audio Fast Track C600 */
 	IMPLICIT_FB_FIXED_DEV(0x0763, 0x2080, 0x81, 2), /* M-Audio FastTrack Ultra */
 	IMPLICIT_FB_FIXED_DEV(0x0763, 0x2081, 0x81, 2), /* M-Audio FastTrack Ultra */
 	IMPLICIT_FB_FIXED_DEV(0x2466, 0x8010, 0x81, 2), /* Fractal Audio Axe-Fx III */


