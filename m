Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00E31CB518;
	Wed, 19 Feb 2025 09:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955651; cv=none; b=ExO+S97FrHoy6lMvrnMdvHOUY6AhHx62UCADoMU/ctAOGui5J/s7FFyCvJaoZDWHAuFP6E6KoyB9zrbgsKtjdwnLuQW8tavFmdZVpE+5QLICjCEpahYTeISn6PCOJBPkRjuMpC3UrL+DJgnGsVJPjkuCoVhkkCCKLJ33VeQqkKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955651; c=relaxed/simple;
	bh=kIQsdRq8KqY3D1KwqpFyq5bMOuHEiIIrBHUFfI+izz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WH6xBeP07Dyk+qe1fXhzYsEXexQQKtG+SdPodSZcr5kLgpMvdgsRKBYMbqtC9r/CdzoGvhPjfh59wR4dbJlt9566uAkiuiFBUyyHncv4i2+oMdDky1Zk4U4fWfsSk9gvKm/0Lhpttsv2AGDSR2ZkLktWqvmgUXeC5ydoUCdfiCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y8jwI0iT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8jwI0iT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF8EC4CEE6;
	Wed, 19 Feb 2025 09:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955651;
	bh=kIQsdRq8KqY3D1KwqpFyq5bMOuHEiIIrBHUFfI+izz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y8jwI0iTEmp13YrnBUBmtVea1sGsZo5+Fx46JelMd0tA9hN08xRbjcxVkO4J/zSIm
	 c0yUPTvBIBijXz7kMkehi/YBheF8AzOm79WzPnD1mtIlvGF8Jb3yMq6fFYUxhBZM9b
	 HbmFCju+IdiVS/cdDmZAlXZ/UYas0rdGBUIRG9Sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Porcedda <fabio.porcedda@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 072/152] USB: serial: option: fix Telit Cinterion FN990A name
Date: Wed, 19 Feb 2025 09:28:05 +0100
Message-ID: <20250219082552.897273309@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

From: Fabio Porcedda <fabio.porcedda@gmail.com>

commit 12606fe73f33647c5e79bf666833bf0b225e649d upstream.

The correct name for FN990 is FN990A so use it in order to avoid
confusion with FN990B.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1370,15 +1370,15 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(2) | RSVD(3) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1063, 0xff),	/* Telit LN920 (ECM) */
 	  .driver_info = NCTRL(0) | RSVD(1) },
-	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1070, 0xff),	/* Telit FN990 (rmnet) */
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1070, 0xff),	/* Telit FN990A (rmnet) */
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
-	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1071, 0xff),	/* Telit FN990 (MBIM) */
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1071, 0xff),	/* Telit FN990A (MBIM) */
 	  .driver_info = NCTRL(0) | RSVD(1) },
-	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1072, 0xff),	/* Telit FN990 (RNDIS) */
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1072, 0xff),	/* Telit FN990A (RNDIS) */
 	  .driver_info = NCTRL(2) | RSVD(3) },
-	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1073, 0xff),	/* Telit FN990 (ECM) */
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1073, 0xff),	/* Telit FN990A (ECM) */
 	  .driver_info = NCTRL(0) | RSVD(1) },
-	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1075, 0xff),	/* Telit FN990 (PCIe) */
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1075, 0xff),	/* Telit FN990A (PCIe) */
 	  .driver_info = RSVD(0) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1080, 0xff),	/* Telit FE990 (rmnet) */
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },


