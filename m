Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACD4EAD0;
	Fri, 15 Nov 2024 06:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653141; cv=none; b=OC46fR6KGPQB1qMBTR3oGjuxtBuucASzVoblWbpICRWUbHytLfnjJRiVZ3j3/5YvsWSRufHcGulcUwJKWoV5O8ETmtTTeK6jJ+tq6pNBzlM21ejYhDjRKcOHQ7GDEtE/p2lAu43CU737FwvQ5ONwMSPmoeYk6M01b2aWRXBkrdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653141; c=relaxed/simple;
	bh=I8KFIsLkJH5FK03HInRAfOMcMNjXNpW9AbnbqufOfcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gGxoOsLu2zAp8Z1ZbbVMX/f/T2bkxUKiAqkSzoyi46GTkHMaMo14D0L7U/xAw0SRrreWg4WuH5yFxwDwWbbvn0da6GHFltZPiYAYmuWDJTpE+hGBZFPD7XOO0GejHj52Eab9v4Hp6ztxv8EImCYtb2Nzhi0a2k75pNGynGZc6eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vyQUF2M1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vyQUF2M1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5482C4CECF;
	Fri, 15 Nov 2024 06:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653141;
	bh=I8KFIsLkJH5FK03HInRAfOMcMNjXNpW9AbnbqufOfcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vyQUF2M1XVjU2KQfEa4G8t2X0GJWrqSnxDGEqWknApldYftPocZCvxQxH+GKgOwIi
	 QrawJRywg2BevXeiRqE09sUyBkwdHySSXu31tfypk4Q94SGVuYfbFuDG4dNXUDQ9Wt
	 vtSTV45RNXuFQa0glOqggbHHLhFIlY1RjMdxsYdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20Sch=C3=A4r?= <jan@jschaer.ch>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 48/66] ALSA: usb-audio: Add quirks for Dell WD19 dock
Date: Fri, 15 Nov 2024 07:37:57 +0100
Message-ID: <20241115063724.576492616@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Schär <jan@jschaer.ch>

[ Upstream commit 4413665dd6c528b31284119e3571c25f371e1c36 ]

The WD19 family of docks has the same audio chipset as the WD15. This
change enables jack detection on the WD19.

We don't need the dell_dock_mixer_init quirk for the WD19. It is only
needed because of the dell_alc4020_map quirk for the WD15 in
mixer_maps.c, which disables the volume controls. Even for the WD15,
this quirk was apparently only needed when the dock firmware was not
updated.

Signed-off-by: Jan Schär <jan@jschaer.ch>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241029221249.15661-1-jan@jschaer.ch
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 08cbcd69b3251..403b83cfac4c1 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -2444,6 +2444,9 @@ int snd_usb_mixer_apply_create_quirk(struct usb_mixer_interface *mixer)
 			break;
 		err = dell_dock_mixer_init(mixer);
 		break;
+	case USB_ID(0x0bda, 0x402e): /* Dell WD19 dock */
+		err = dell_dock_mixer_create(mixer);
+		break;
 
 	case USB_ID(0x2a39, 0x3fd2): /* RME ADI-2 Pro */
 	case USB_ID(0x2a39, 0x3fd3): /* RME ADI-2 DAC */
-- 
2.43.0



