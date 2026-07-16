Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161FA3BCD11;
	Thu, 16 Jul 2026 14:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210575; cv=none; b=WmQsJP3858bTx3pHaGfrD6OXZkBRv3dsLEgUquT63D32U5WGfaS8Ux2nm/grzw4r8xYocMePm3iib3zc5jBc2h3gpyZCuDFmFuWFJAxtMave//Ytiius1lfb8ACp182Xgjn1tk0G8C8mwBt846t9naWMaqtvQbY92LgpbF0sORA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210575; c=relaxed/simple;
	bh=3W2jpjf95TdlC3JKPmG0SDah5Vs/FmpRhH4p0cWQMnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+aQJwxFlqrs9FoIKy/qvi5th/1mzxA0phRZdBcOBobchzREdHIZoSRXxQS/bQwntenTcCBRJCYW6ujcTx+KwTXRNjhK64ccTFOyuTk14Ibqc4yV5oCPn/whSTX2gbkpfphaeMN0hWSHhTSNzSIDUcqXG1JWW6vXF7l3T2M0oTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZ8465Nd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZ8465Nd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8331F000E9;
	Thu, 16 Jul 2026 14:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210574;
	bh=KxatwpTwDHxbjyhyT5CXiqrWVsKVk/kPMUlBQ/5Qtu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BZ8465NdquJHhSAKgwv6TWEYvwlH8i29HhUJRbnZcyZ8HZ/qnY7G20s65wUhXHd8h
	 NG0GN0MjC5aGSM0pLqDEHqnIZsza3WPAlyJkJee7jGUP/ph1aysDrTRDgIMj7dpm9e
	 AqHAszCGP/rkiECTX2/Y8dRVqA6DmYFXsBUYeo/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 100/480] ALSA: FCP: Add Focusrite ISA C8X support
Date: Thu, 16 Jul 2026 15:27:27 +0200
Message-ID: <20260716133046.874907902@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoffrey D. Bennett <g@b4.vu>

commit e0ecb324246be9cf3a0689346a658e48a38546b2 upstream.

Add USB PID 0x821e to the list of devices handled by the Focusrite
Control Protocol (FCP) driver.

Cc: stable@vger.kernel.org
Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Link: https://patch.msgid.link/ajlw4HK+2RSW3nUl@m.b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -4346,6 +4346,7 @@ int snd_usb_mixer_apply_create_quirk(str
 	case USB_ID(0x1235, 0x821b): /* Focusrite Scarlett 16i16 4th Gen */
 	case USB_ID(0x1235, 0x821c): /* Focusrite Scarlett 18i16 4th Gen */
 	case USB_ID(0x1235, 0x821d): /* Focusrite Scarlett 18i20 4th Gen */
+	case USB_ID(0x1235, 0x821e): /* Focusrite ISA C8X */
 		err = snd_fcp_init(mixer);
 		break;
 


