Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8581C423775;
	Thu, 16 Jul 2026 13:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209180; cv=none; b=birip77cb5gpGLias1OQS6j8qVXSHzLL6wvzNa7V64yvXOoTzNueamlS3AYCZ5RliQK6aacXy5yUtjyMUm6nTX+jOC2HdCMXtgOcz5y0K+zH9MOvnovEVSTEDvSsj4T7jpigH4yLSaHheNrhvMTDmoIOIBOnN7kIPr/sZzKrz1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209180; c=relaxed/simple;
	bh=iMWa8TsrczRv+lQTCfoiPXtOTCFW82aA4DEfs6exnCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwLstvNpyvws03Dam8aB8U1t9I6j/kLPPE3bz9xiNW2w7jiXJ/ado6x9WPL6GCWO/9kFnWYd0KTxkVHe1UVlsBikLAZzBQ5S5fX2IKOyx4wDxdqyxFnZdHlQsS1ksLWakTjnCDiO8KRV3A6PEQ5hp8vYfOFsHyT4S+3MaqdF1wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2MiyMEsw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2MiyMEsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33081F000E9;
	Thu, 16 Jul 2026 13:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209179;
	bh=ALhC3amZHfFsFZcgu+AAPcjUJQOq5+kcisR/A0ZfZmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2MiyMEsw9b+X4/5+St4HXvOlSDV4aiYYjbeixbnWt+0tM/53gt/MhWl2kN7xasuij
	 /0o7EjzHaulMIS3o2htxXGSKB5qCQ2r85NkD7vooGwA5nk1et4IL/f3o+ZyTh/kEOT
	 MDE7C0V2bEWacIMfD92LE1jpB3nmNaf7WTKCNYGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 088/518] ALSA: FCP: Add Focusrite ISA C8X support
Date: Thu, 16 Jul 2026 15:25:56 +0200
Message-ID: <20260716133049.792108288@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4451,6 +4451,7 @@ int snd_usb_mixer_apply_create_quirk(str
 	case USB_ID(0x1235, 0x821b): /* Focusrite Scarlett 16i16 4th Gen */
 	case USB_ID(0x1235, 0x821c): /* Focusrite Scarlett 18i16 4th Gen */
 	case USB_ID(0x1235, 0x821d): /* Focusrite Scarlett 18i20 4th Gen */
+	case USB_ID(0x1235, 0x821e): /* Focusrite ISA C8X */
 		err = snd_fcp_init(mixer);
 		break;
 


