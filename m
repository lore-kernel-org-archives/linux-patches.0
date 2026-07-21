Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E6344AB71;
	Tue, 21 Jul 2026 21:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668440; cv=none; b=h8G3GsNVEJr3KLJMpAaN+4zu5Xp3EH9diw+uRTAHBPxW3tcPTpcHRnhZCmp6Irfg71KiHccEqKPC6Zn1OKrcbdwdWTEQUhi7X7U5MNXSXJbqF09f0K6yQLab3ZBXrPQ5Qbi+cbcjsJJ3cnlo02fXTfPu1OAjU5vngjaZfnXxBgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668440; c=relaxed/simple;
	bh=Iqyzhw19YFxnDtVexpZM2fHYv+fptmirEbEBejGx+a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPmZjp4gYfM8NvrKPQbBvD2Onyeo75nB8WVZBzLlTWLZtyN6+f+M6toaQFOqTbXtyzZmyGvv8OnOeAgxJ6ozlYyCASXJDN9suZEYfWLIcYsc4U079kpxrtsMZQC6eSDmtJOYhsC0vAHv+ImpHCA7xTiqz2EpvqjR5WMWOikWZ8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JyujVugE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JyujVugE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6AD1F000E9;
	Tue, 21 Jul 2026 21:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668438;
	bh=gUPViJpg9+GSbGjSu/3wI1FdwomA2Pl+w10YMGZr1m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JyujVugE10aFzbeZkRbl8skOzVsM5k3IBauC6pOcChoJuiaCoxrvn+/RL5nqagYzm
	 XJzvuYn8Ueq0wZ/fibzjrwRYUVZ/ikonldRSwBKgtasPp6zFzilvXkgE06SiFD4yzF
	 uJuEvFuLsBrh+JOSdWsTKGJ2AHSZhQZXJ85MsQgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Erich E. Hoover" <erich.e.hoover@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 0175/1067] USB: quirks: add NO_LPM for the Samsung T5 EVO Portable SSD
Date: Tue, 21 Jul 2026 17:12:56 +0200
Message-ID: <20260721152428.507017409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erich E. Hoover <erich.e.hoover@gmail.com>

commit fc591787785b9709a0bb65a7df3ba2537d611c47 upstream.

The Samsung T5 EVO Portable SSD (04e8:6200) exhibit two forms of
link instability when USB Link Power Management is enabled:

  1. The units fail to initialize properly on first detection,
  resulting in a lockup in the drive where it must be power cycled
  or the kernel will not recognize the presence of the device.

  2. If used for sustained operations (small amounts of continuous
  data are transferred to the unit) then the unit will "hiccup"
  after roughly 8 hours of use and will disconnect and reconnect.
  This has a certain probability of triggering the first issue,
  but also causes mount points to become invalid since the device
  gets issued a new letter.

Signed-off-by: Erich E. Hoover <erich.e.hoover@gmail.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260602204508.48856-1-erich.e.hoover@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -297,6 +297,9 @@ static const struct usb_device_id usb_qu
 	/* CarrolTouch 4500U */
 	{ USB_DEVICE(0x04e7, 0x0030), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Samsung T5 EVO Portable SSD */
+	{ USB_DEVICE(0x04e8, 0x6200), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Samsung Android phone modem - ID conflict with SPH-I500 */
 	{ USB_DEVICE(0x04e8, 0x6601), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },


