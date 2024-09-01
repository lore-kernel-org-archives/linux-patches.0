Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0C944C97;
	Sun,  1 Sep 2024 16:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207596; cv=none; b=ZUuJ9hg3pD/n4+KB937npXSWgHJhRid8ZkGNvy0cwJpmuskgz/8bGwSEcV0ISuPjpshkvjZuK9IXj6/Y9nIlNUfcViE/xAN0q9xYYFEYfsN2/5A8lIQj8YU3YFvZ5mHuOku9uCKoysCr8hLDc2k/Ca7+V9ekko6h6t3Znyuyo+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207596; c=relaxed/simple;
	bh=0SWc5UMn7HsSe7QvwU3EmYrG+Z9T8y9HDCBI13P2Qhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lOx7BLccqJwtLseOasUZycfT+ttxiVYfF1cRlwYeoiPgOlp/TLm3Fx3Z0oYQL1ICnw3dSDjo7xfdT+i5Slzxoc7Ahmx/X8F1uq3+bGCM+f6Yf3aJi+aGR0qxxfOfWkijAbAcIu2ceeIz94xva7hVmzvLeT3hzhr4gVAASEDlfig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHCIQSnp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHCIQSnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A111CC4CEC3;
	Sun,  1 Sep 2024 16:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207596;
	bh=0SWc5UMn7HsSe7QvwU3EmYrG+Z9T8y9HDCBI13P2Qhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tHCIQSnpAFUHEt8XV7DTyKrJY8rYmCOsXB99mSUmODJvXdbaFBK/Iit0hSdNehZZ0
	 Yp5waaIL4jsx3FrppqeStKe+JaLMCTyYcVAAeAD7zCMEYA3UJpPaMMn1fMswZ/KZUV
	 QzZuxo4TLeqluFnz1cTQP2O1W6o1NEywG3am85nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Juan=20Jos=C3=A9=20Arboleda?= <soyjuanarbol@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 02/98] ALSA: usb-audio: Support Yamaha P-125 quirk entry
Date: Sun,  1 Sep 2024 18:15:32 +0200
Message-ID: <20240901160803.769132465@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -352,6 +352,7 @@ YAMAHA_DEVICE(0x105a, NULL),
 YAMAHA_DEVICE(0x105b, NULL),
 YAMAHA_DEVICE(0x105c, NULL),
 YAMAHA_DEVICE(0x105d, NULL),
+YAMAHA_DEVICE(0x1718, "P-125"),
 {
 	USB_DEVICE(0x0499, 0x1503),
 	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {


