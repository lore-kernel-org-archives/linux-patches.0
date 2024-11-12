Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7963D212D04;
	Tue, 12 Nov 2024 10:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407184; cv=none; b=poXmsaDLyJzn/9KGjTmDs99qcCfvin1qYwu1emf1YXL5uvgb3Dm+fhqi7YbQQ8Rlds6T/UJJLPziMX7TkVZHhZKRpfFkEI1rO0d7Ti9bOoj48/EeomNMZ/Z086gplpPXhQPshZNc43BnBDoc+jlr1LY/IlyX6oL7M0fX9Woqzfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407184; c=relaxed/simple;
	bh=q6OZzLIzSHdXrBMRULM6l+vv2kOUi9I+nqy0bp3b5kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dcTdvhhl1pqHkIgPFEbsq1Sa29XaOl8cmtLSrxFv12wxd3T8I6+mFLkJ3nCexpGpfn2rGFqO5X6WIF7jEZI+LC/juqP/p4s7v+pXL4UghRHV0HE3U4tjXk7MXSJ3+Tzdg8M7jhhv0hTE2jT9tNjo0fPbnSP+3h+h8sqSsJ9HcxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HIPVKKYA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HIPVKKYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4863C4CECD;
	Tue, 12 Nov 2024 10:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407184;
	bh=q6OZzLIzSHdXrBMRULM6l+vv2kOUi9I+nqy0bp3b5kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HIPVKKYAKQBrZ70g8snibDHQZnk9N/EqXFt+s2yVITX6tc5Y7oLozvWAiETuKAnyi
	 qR3Fb6dkZOUrcHE8XwCe9W2XqGtl8pHupKdyZuXfLxbpOH+xrF5VO2w7uWp/O+DDV7
	 xEDC7gpidSIrp5bvv8bMvy3WCC8YUYrBmy8Q4Vec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	=?UTF-8?q?Jan=20Sch=C3=A4r?= <jan@jschaer.ch>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 76/76] ALSA: usb-audio: Add endianness annotations
Date: Tue, 12 Nov 2024 11:21:41 +0100
Message-ID: <20241112101842.670094307@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
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
@@ -1965,7 +1965,7 @@ static int snd_soundblaster_e1_switch_cr
 static int realtek_hda_set(struct snd_usb_audio *chip, u32 cmd)
 {
 	struct usb_device *dev = chip->dev;
-	u32 buf = cpu_to_be32(cmd);
+	__be32 buf = cpu_to_be32(cmd);
 
 	return snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0), REALTEK_HDA_SET,
 			       USB_RECIP_DEVICE | USB_TYPE_VENDOR | USB_DIR_OUT,
@@ -1976,7 +1976,7 @@ static int realtek_hda_get(struct snd_us
 {
 	struct usb_device *dev = chip->dev;
 	int err;
-	u32 buf = cpu_to_be32(cmd);
+	__be32 buf = cpu_to_be32(cmd);
 
 	err = snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0), REALTEK_HDA_GET_OUT,
 			      USB_RECIP_DEVICE | USB_TYPE_VENDOR | USB_DIR_OUT,


