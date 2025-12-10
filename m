Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015C526A0A7;
	Wed, 10 Dec 2025 07:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351984; cv=none; b=RClsxIOY/kklOY/z36tiwUUDSZhkitUtJM1u2EZcjogiFC/j7+LEpGd6004jw9BGq8OQ7fcQiowujNuewldt1n1l506jLHBqYkZ+0FQInejF73K8bqBGVDGwZd1F+6EuPDEBKPQmQ89QeDlJqDWMqD4zOBKK2gSrjegPoJQHDRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351984; c=relaxed/simple;
	bh=chPDOxs6m60lcmzv6aL+pF+XdUeX/Ecvp/B4bujh2QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQOro33AHC5v8YZZEE3TRKLghnAe9Cji2N/4BJzYuLm9r0xN+zkSv+dhTmOqdgVFVEL9pFTrGstLYdqaJIbk8Qfe02Hx1Df5CEMHll1G1H75e7ToTHSfIwu4apSRPchQE16J7UXi9ynBL0fIXoMOYc9KpuK3ttWTJoIdJ+N+7bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j2/1dOe9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j2/1dOe9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0704CC4CEF1;
	Wed, 10 Dec 2025 07:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351983;
	bh=chPDOxs6m60lcmzv6aL+pF+XdUeX/Ecvp/B4bujh2QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j2/1dOe9b/y/xVcFIusP5k+baJB4Nchg0ZyUzBHSBSc5QHGAYnN7eiUqWPdhs8Cou
	 lSjSX5JYYhr3faCl/+cSnclp4+Lfd36vlxX7hVEmeiQI/0d/jwjyMqWIruzLfZByhC
	 Qpdm5DthlYFUhCwq43QicwiPESZAQ1KL3nexPJnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Porcedda <fabio.porcedda@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 15/49] USB: serial: option: move Telit 0x10c7 composition in the right place
Date: Wed, 10 Dec 2025 16:29:45 +0900
Message-ID: <20251210072948.505634733@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Porcedda <fabio.porcedda@gmail.com>

commit 072f2c49572547f4b0776fe2da6b8f61e4b34699 upstream.

Move Telit 0x10c7 composition right after 0x10c6 composition and
before 0x10c8 composition.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1445,6 +1445,9 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(4) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x10c6, 0xff),	/* Telit FE910C04 (MBIM) */
 	  .driver_info = NCTRL(4) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10c7, 0xff, 0xff, 0x30),	/* Telit FE910C04 (ECM) */
+	  .driver_info = NCTRL(4) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10c7, 0xff, 0xff, 0x40) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x10c8, 0xff),	/* Telit FE910C04 (rmnet) */
 	  .driver_info = RSVD(0) | NCTRL(2) | RSVD(3) | RSVD(4) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x10c9, 0xff),	/* Telit FE910C04 (MBIM) */
@@ -1455,9 +1458,6 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(5) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10d0, 0xff, 0xff, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10d0, 0xff, 0xff, 0x60) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10c7, 0xff, 0xff, 0x30),	/* Telit FE910C04 (ECM) */
-	  .driver_info = NCTRL(4) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10c7, 0xff, 0xff, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10d1, 0xff, 0xff, 0x30),	/* Telit FN990B (MBIM) */
 	  .driver_info = NCTRL(6) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10d1, 0xff, 0xff, 0x40) },


