Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12141DB151;
	Wed, 15 Jan 2025 10:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938323; cv=none; b=Z6GAci1LkKtmSiXgJiyS/iressrN1f5+wE7iIBGtfl2GSSrAzzyE7obPfNghSE6SvZzuSYyOljbYIHgvS5ShMR0P0eQT0UEgibHzhjcV4jA8IfA/Ab080pDrklcetEejdMy5+QbfPJWs3Xw9HBd5Q/16obRST/YCW2wzarxIXTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938323; c=relaxed/simple;
	bh=9XeOEvWB0kgzwPfGwBW7+CwxKYp7pBO6XdjMEoVdhsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtaJXir8onsEVQctmee870mLGrns115+8CeK/xNUGgcoNWqb3bfZvhV1hZZDRTFdjqQzNxk/RZtJVzppq/0b8A7EFLFiEvVsF6lfrVPDppEQ02hwn44N+2l1PKaXQaXxKGG3wPGE/Sv2uSw0ddPz/tCKF/zy3VwIS4nmJRZ7FbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eGC23kfR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eGC23kfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBD4C4CEDF;
	Wed, 15 Jan 2025 10:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938322;
	bh=9XeOEvWB0kgzwPfGwBW7+CwxKYp7pBO6XdjMEoVdhsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGC23kfRvpOtZQw9pADCWlrNHJ8N8KoehvEs4fXky6p4SHfIt/E8ekI4QKqnDUOg8
	 MXG/rWJFInCA1We3qXzG3K19H5x2MLrAa4Aj541RNn0pMwpVY5VrQAep6dJ+yi1auS
	 ywrCrfESGEDMRCgB/zDT6p2m5DU4BWew8WH3k990=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 148/189] usb: gadget: midi2: Reverse-select at the right place
Date: Wed, 15 Jan 2025 11:37:24 +0100
Message-ID: <20250115103612.324047753@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -211,6 +211,8 @@ config USB_F_MIDI
 
 config USB_F_MIDI2
 	tristate
+	select SND_UMP
+	select SND_UMP_LEGACY_RAWMIDI
 
 config USB_F_HID
 	tristate
@@ -445,8 +447,6 @@ config USB_CONFIGFS_F_MIDI2
 	depends on USB_CONFIGFS
 	depends on SND
 	select USB_LIBCOMPOSITE
-	select SND_UMP
-	select SND_UMP_LEGACY_RAWMIDI
 	select USB_F_MIDI2
 	help
 	  The MIDI 2.0 function driver provides the generic emulated


