Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5967E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DFCC433C1;
	Wed,  2 Nov 2022 02:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357947;
	bh=hirwckMCgJj+uW0rDUlQ18kc0agJ0aW2bIOVc7+5l04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJzdiwt38hwDpT0s46fTXt2jkc1gUEmZ7nnt6m6wDQYNHEHPkzaTTIfWTukOfLN1y
	 BDv6GUKeaczoMj0OS9HXebBWwIMU7jtXv6MBqAVkt/6yMgJOerLXc+JFvuUgw6Ffuk
	 m47xf97KacChuIX5DbaBsO2kVeurLV7mdeFwwSK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 006/132] ALSA: usb-audio: Add quirks for M-Audio Fast Track C400/600
Date: Wed,  2 Nov 2022 03:31:52 +0100
Message-Id: <20221102022059.777003818@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
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


