Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3A72BB1B;
	Fri, 15 Nov 2024 06:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653966; cv=none; b=mRDDdMPcfblyNDB6qWums4ISqBwe0OBYY/rn3r5Fn4RR/3YrtYuXfGJmutcRvaAn+tE19dBJFVxZYyXsQn+S3rInJ1GScyA/ExPYH8o6Za9HTtAD8Ilw9tIDSWQqxdPR8C+0AitYx3HI5cSro57VVVNZaNxwx2+fnsYiaqstuF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653966; c=relaxed/simple;
	bh=A8i33bJut3e8ndFDhzJ1JCGz1btMafUIq3P8Uuc5mc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gvRQcA9yY9xuZuIG4UDx9JBYNUPuAm47rOwmwV3fo7sLel9YraOAO6FhKk6Vw3Wb58mw9+fyuEyl3XCCPMJiK9T32yIKfSPVhICR4XyQSe4mAZGfKvXqhCV4gdH0ZFiFLv9OO513Z14qee8y2Iq2pY6PZAUfaDIB+zO6C1SKK1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMfzzyEF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMfzzyEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2255AC4CEDA;
	Fri, 15 Nov 2024 06:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653966;
	bh=A8i33bJut3e8ndFDhzJ1JCGz1btMafUIq3P8Uuc5mc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pMfzzyEFCV8reUPVR/4QqhoVf8QtMnRxk8rfuPkqQk6hWiZXyxFkczugfkWTPjRQb
	 rdnvqtYZbXaAOooQ2z6xlCSzOpZvHCVPD0xTm2GgI/zpClkICAuUmbH1/h8hEE1qFA
	 29d3fu7Df7OivchaFR386oYcnQZWOSOwsZ6hlYIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	=?UTF-8?q?Jan=20Sch=C3=A4r?= <jan@jschaer.ch>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 68/82] ALSA: usb-audio: Add endianness annotations
Date: Fri, 15 Nov 2024 07:38:45 +0100
Message-ID: <20241115063728.001386454@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Schär <jan@jschaer.ch>

commit 61c606a43b6c74556e35acc645c7a1b6a67c2af9 upstream.

Fixes: 4b8ea38fabab ("ALSA: usb-audio: Support jack detection on Dell dock")
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/202207051932.qUilU0am-lkp@intel.com
Signed-off-by: Jan Schär <jan@jschaer.ch>
Link: https://lore.kernel.org/r/20220705135746.13713-1-jan@jschaer.ch
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -1824,7 +1824,7 @@ static int snd_soundblaster_e1_switch_cr
 static int realtek_hda_set(struct snd_usb_audio *chip, u32 cmd)
 {
 	struct usb_device *dev = chip->dev;
-	u32 buf = cpu_to_be32(cmd);
+	__be32 buf = cpu_to_be32(cmd);
 
 	return snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0), REALTEK_HDA_SET,
 			       USB_RECIP_DEVICE | USB_TYPE_VENDOR | USB_DIR_OUT,
@@ -1835,7 +1835,7 @@ static int realtek_hda_get(struct snd_us
 {
 	struct usb_device *dev = chip->dev;
 	int err;
-	u32 buf = cpu_to_be32(cmd);
+	__be32 buf = cpu_to_be32(cmd);
 
 	err = snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0), REALTEK_HDA_GET_OUT,
 			      USB_RECIP_DEVICE | USB_TYPE_VENDOR | USB_DIR_OUT,


