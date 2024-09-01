Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC92F1C68C;
	Sun,  1 Sep 2024 16:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209930; cv=none; b=NxNlysXWwPuC/DzUkB3YLuDW7WGG0A816RbX5+tkM2A8TsL5BJpzUKUdT1ef7palL8FMOfese10PcmTL80B1fIA2Pum2XqAIThHm3XwhsF5AbLjCasj8qNIt8Rvrt9tkWq6hTB1sN6bxNVk7EwHM3sdIIK/vgZhtNbnJgVp3eQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209930; c=relaxed/simple;
	bh=l24+CEhIPe/K1dpUNEbc8oXllQBqxqPRkggdIglTRqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c25AxU2lIhOAuJzWI4qVYKl/ac0Li1C8nqbcQzR5uJSI/X9oXUh2mstgkhsyfZwtNca7TClvhNQCKrUaMN6UtTSgHAJTWmvTRG7bGUCAqtJnrJLzcDyQUzFCEKoRoZPE7bSu7s+HXM3oE604utjkjElwnmX1k8gc8LVolrvF3aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ff8JbSAZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ff8JbSAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E018C4CEC3;
	Sun,  1 Sep 2024 16:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209930;
	bh=l24+CEhIPe/K1dpUNEbc8oXllQBqxqPRkggdIglTRqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ff8JbSAZzTg66ppJS3UJGEgeuO6efjuK8v6OiX4b0V9lVMP/SoAL82/b37RIFo/7M
	 ZY1Ir7vxxKgx6+FrwnA/9TqctKIIyld1QMJbgCttHADTbdHmJ39lPgJt4+Wv6DQEjH
	 R7m+FvVfbqgC0lw9wLhaTtziCyVFJPXcv+22uzTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Juan=20Jos=C3=A9=20Arboleda?= <soyjuanarbol@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 006/215] ALSA: usb-audio: Support Yamaha P-125 quirk entry
Date: Sun,  1 Sep 2024 18:15:18 +0200
Message-ID: <20240901160823.480850566@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juan José Arboleda <soyjuanarbol@gmail.com>

commit c286f204ce6ba7b48e3dcba53eda7df8eaa64dd9 upstream.

This patch adds a USB quirk for the Yamaha P-125 digital piano.

Signed-off-by: Juan José Arboleda <soyjuanarbol@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240813161053.70256-1-soyjuanarbol@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks-table.h |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -273,6 +273,7 @@ YAMAHA_DEVICE(0x105a, NULL),
 YAMAHA_DEVICE(0x105b, NULL),
 YAMAHA_DEVICE(0x105c, NULL),
 YAMAHA_DEVICE(0x105d, NULL),
+YAMAHA_DEVICE(0x1718, "P-125"),
 {
 	USB_DEVICE(0x0499, 0x1503),
 	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {


