Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964592F5491;
	Tue, 31 Mar 2026 17:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976559; cv=none; b=TQWn4w9HkcpabC/8tsx8kpNSxHSWrYiBWxlq4LlzY8p2G77G59xKcbiL8Ik8JteLTVUTVkpJcMGDhub1NVVqQsdryqfDuFGWdVzLRu3WJXqI5gdFSUjbF7kHlF87VsVq20VKA7K0IvfBbTI+sn3PWgOT3aCNjVU9WO215PibB/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976559; c=relaxed/simple;
	bh=kZTNqkl7fFTTc3OEB3TVVYO9vAGU8iLtFhy7lGoVu94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYypAyCN3LzdL7+GNki+DxTuBza8mufPYMsGJyOBCmuV5BqarkxG5YTJRF1ZMcCxuPemc7cw+n2HkWtz+B4/r/iL5zvVUVIwZmMK+8rKz4wO7wrO7CNB+7RHPbJncoWe7jkM5kpawPI1tI8BzrD/StM9Mt+U87KnaPxOXsp6/3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iu3J2hn8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iu3J2hn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297E9C19423;
	Tue, 31 Mar 2026 17:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976559;
	bh=kZTNqkl7fFTTc3OEB3TVVYO9vAGU8iLtFhy7lGoVu94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iu3J2hn8sHN9+5+AX7QYEsLkZxD5I0PcX7MfEW+VSkmbu7vJzGexUnS7TXu3t4Acz
	 u2H1Ec6SFfT2im9GhgcmPyIvMtepe8h5UF1NnhaRaK6OAqUCFaxPYPTEY7KEklSjRp
	 NoVntaWBaCXfbqnP0H7ivXACaDt8juesK57kTBWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 140/309] ALSA: usb-audio: Exclude Scarlett 2i2 1st Gen from SKIP_IFACE_SETUP
Date: Tue, 31 Mar 2026 18:20:43 +0200
Message-ID: <20260331161758.628261221@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

[ Upstream commit 8780f561f6717dec52351251881bff79e960eb46 ]

The Focusrite Scarlett 2i2 1st Gen (1235:8006) produces
distorted/silent audio when QUIRK_FLAG_SKIP_IFACE_SETUP is active, as
that flag causes the feedback format to be detected as 17.15 instead
of 16.16.

Add a DEVICE_FLG entry for this device before the Focusrite VENDOR_FLG
entry so that it gets no quirk flags, overriding the vendor-wide
SKIP_IFACE_SETUP. This device doesn't have the internal mixer, Air, or
Safe modes that the quirk was designed to protect.

Fixes: 38c322068a26 ("ALSA: usb-audio: Add QUIRK_FLAG_SKIP_IFACE_SETUP")
Reported-by: pairomaniac [https://github.com/geoffreybennett/linux-fcp/issues/54]
Tested-by: pairomaniac [https://github.com/geoffreybennett/linux-fcp/issues/54]
Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Link: https://patch.msgid.link/abmsTjKmQMKbhYtK@m.b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index fd50bf7c381d6..11823549900f1 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2422,6 +2422,7 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_CTL_MSG_DELAY | QUIRK_FLAG_IFACE_DELAY),
 	VENDOR_FLG(0x07fd, /* MOTU */
 		   QUIRK_FLAG_VALIDATE_RATES),
+	DEVICE_FLG(0x1235, 0x8006, 0), /* Focusrite Scarlett 2i2 1st Gen */
 	VENDOR_FLG(0x1235, /* Focusrite Novation */
 		   QUIRK_FLAG_SKIP_IFACE_SETUP),
 	VENDOR_FLG(0x1511, /* AURALiC */
-- 
2.53.0



