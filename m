Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994897866C;
	Wed, 21 Feb 2024 13:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521622; cv=none; b=GAA2ENaiOxCApU8Mdnv+Ci89dNLg5VTiMLLg4QBxKVPO4bmgIfQx512YsIWuUEpehf6f1Z5hf0LmmNwDNxdQwN81ijzvUfJNwakqLk/8AEbi3xTYzgKda4w0DlQqjfNaP3vY0yoFHM3wNIZtq6BvEBHod0ux3vd1cb10lmpQO9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521622; c=relaxed/simple;
	bh=xsELHlVa09fWL9TRxy6uJebFglqGyyy/Nx99s65wGc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQZNwBX1zHvB2D+G7aBi9/nsIbJu901plLIHL+5S3yMmdWIIge9aavzM0QjXAFR5+HlU5HFSqYiErLWd0W7NRVgE2W58ZqHnj1UlLcESaFwnryonCyNBgPIA2lwby/moZLpWO6yXPJ6GaJZlgAWGuuPlRf8FwC2Fh4NK0e3HvCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eot4k+9S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eot4k+9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C705C433C7;
	Wed, 21 Feb 2024 13:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521622;
	bh=xsELHlVa09fWL9TRxy6uJebFglqGyyy/Nx99s65wGc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eot4k+9SNiyUTbfmhju5BSO8zzA3vpstjFzfRpQ6Vs0mCEiO9uy4Mf+M0st3KSBBX
	 Wm+g6jDwLuB8esuaDJqBpenQ0RL7XpSXgpqGE35y/RlTdbSAE7vgQSn1KvnYCbZ90K
	 kKDLV5U16saUPmoJl4E7k8mjWv1h49J9QTwn5gG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonard Dallmayr <leonard.dallmayr@mailbox.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 161/202] USB: serial: cp210x: add ID for IMST iM871A-USB
Date: Wed, 21 Feb 2024 14:07:42 +0100
Message-ID: <20240221125936.918865506@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leonard Dallmayr <leonard.dallmayr@mailbox.org>

commit 12b17b4eb82a41977eb848048137b5908d52845c upstream.

The device IMST USB-Stick for Smart Meter is a rebranded IMST iM871A-USB
Wireless M-Bus USB-adapter. It is used to read wireless water, gas and
electricity meters.

Signed-off-by: Leonard Dallmayr <leonard.dallmayr@mailbox.org>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -147,6 +147,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x85F8) }, /* Virtenio Preon32 */
 	{ USB_DEVICE(0x10C4, 0x8664) }, /* AC-Services CAN-IF */
 	{ USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
+	{ USB_DEVICE(0x10C4, 0x87ED) }, /* IMST USB-Stick for Smart Meter */
 	{ USB_DEVICE(0x10C4, 0x8856) },	/* CEL EM357 ZigBee USB Stick - LR */
 	{ USB_DEVICE(0x10C4, 0x8857) },	/* CEL EM357 ZigBee USB Stick */
 	{ USB_DEVICE(0x10C4, 0x88A4) }, /* MMB Networks ZigBee USB Device */


