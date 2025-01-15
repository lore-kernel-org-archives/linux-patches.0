Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5B8248BB0;
	Wed, 15 Jan 2025 10:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938782; cv=none; b=kMxn0SHZltQ1aJyEEI542dNTuimBwTYFUf2s8ZGQ6ZCpkHnpiQ89uKOGq+oiZbjW4+WNpHzi3FYoLpu/a88AMQ3bPNxYtN5PLAIobM0hzxhluUDtMS0qmspAhX0TEvyFCmX1xkdFL7waMck8GLabVMvqdQZdEENmdhwPrCHAnO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938782; c=relaxed/simple;
	bh=y/USKRa0y9BAQOH3ASDfDYPT80rrzPPa6R0uREOylrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJqyKqpmy2wMmGM8u/n902CrxG+FdTG83oR1vKd/O8I65q7eoJNgsT3+ImbHVhRXjaeqFKpmkVaMAuhxqb/ARrlqlK1Nz4LOhFRVz8mrGz8d9K16xMtlZGha38IszEteu/LFJiHwJjcENFrNE8q10ZXMrOmn/ycAFT0Gll8Etk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJ8fwpJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJ8fwpJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281B8C4CEDF;
	Wed, 15 Jan 2025 10:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938781;
	bh=y/USKRa0y9BAQOH3ASDfDYPT80rrzPPa6R0uREOylrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJ8fwpJRJCfXWymHTkVfJVKZCUStkeYZnNMlLpuXRGDd0XeokbDcGLxtSNSbFnyP4
	 drLmRXty2fnaZLVPZ8htGjOOO26Dr5Gq7Z0oMeE+wHUKHPSprT142SLqza2SiGWrKx
	 eyhuAEmsVMiLMax5akBWE7YUrUTjrocUm+VoEeTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 096/129] usb: gadget: midi2: Reverse-select at the right place
Date: Wed, 15 Jan 2025 11:37:51 +0100
Message-ID: <20250115103558.195799817@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 6f660ffce7c938f2a5d8473c0e0b45e4fb25ef7f upstream.

We should do reverse selection of other components from
CONFIG_USB_F_MIDI2 which is tristate, instead of
CONFIG_USB_CONFIGFS_F_MIDI2 which is bool, for satisfying subtle
module dependencies.

Fixes: 8b645922b223 ("usb: gadget: Add support for USB MIDI 2.0 function driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20250101131124.27599-1-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -210,6 +210,8 @@ config USB_F_MIDI
 
 config USB_F_MIDI2
 	tristate
+	select SND_UMP
+	select SND_UMP_LEGACY_RAWMIDI
 
 config USB_F_HID
 	tristate
@@ -444,8 +446,6 @@ config USB_CONFIGFS_F_MIDI2
 	depends on USB_CONFIGFS
 	depends on SND
 	select USB_LIBCOMPOSITE
-	select SND_UMP
-	select SND_UMP_LEGACY_RAWMIDI
 	select USB_F_MIDI2
 	help
 	  The MIDI 2.0 function driver provides the generic emulated


