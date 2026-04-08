Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A30B37F01B;
	Wed,  8 Apr 2026 18:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672242; cv=none; b=YJdpg27ftGQc0YfGYH9TRpoh5e9ZIucZ7sE3RXxDdjaT7y1enr5UrCKGpg9bTxhsr5/N3PsybgxdghIFHm1GsYOu1uVomYSQX8TKGRr+zpeK+d65pQF6JGhoG7/cyaoP3rc8aH2n+kTkqV1RKhqqUuIPcWTyTJH+VoHFqZ9HWJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672242; c=relaxed/simple;
	bh=BIr27KDaWQZYNgSfk5pxzo5sGYVvJzWYUWftVij5X8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyJg3RQdgiKraZRFB5xpWkyL1m7L7vcpPlIHi2zp+RKh8J3I/elEhc2njxQhPGGvOA01rEpuXrMrSwu/Oq3Vy0tWusUHOqVCrsN+ICpS+Z2JBuWphWZm3NwT9PpAl2G5sc9fJSV6Kyrtew8ljMy8CPNrm1WFQTdR7zleb5vF2mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXaBzRWO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXaBzRWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD77C19421;
	Wed,  8 Apr 2026 18:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672242;
	bh=BIr27KDaWQZYNgSfk5pxzo5sGYVvJzWYUWftVij5X8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OXaBzRWODxBPRUKcmfDoQRyGCtstLYFrxsjFS+dBXKmRHAs7rQkV/h+eDFt0OUgIb
	 PwFE86xztLI2Nkdjk2Kmx/Uc/tqVQyjKvj3jCM5iXXPRoZd/q7cddatdqiFsO/GKgO
	 f5Zu27G2yNMUtSLvwJpgUS2p8rPAupb8W8kU3CuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Li <limiao@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 227/312] usb: quirks: add DELAY_INIT quirk for another Silicon Motion flash drive
Date: Wed,  8 Apr 2026 20:02:24 +0200
Message-ID: <20260408175942.234243574@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

From: Miao Li <limiao@kylinos.cn>

commit dd36014ec6042f424ef51b923e607772f7502ee7 upstream.

Another Silicon Motion flash drive also randomly work incorrectly
(lsusb does not list the device) on Huawei hisi platforms during
500 reboot cycles, and the DELAY_INIT quirk fixes this issue.

Signed-off-by: Miao Li <limiao@kylinos.cn>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260319053927.264840-1-limiao870622@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -402,6 +402,7 @@ static const struct usb_device_id usb_qu
 
 	/* Silicon Motion Flash Drive */
 	{ USB_DEVICE(0x090c, 0x1000), .driver_info = USB_QUIRK_DELAY_INIT },
+	{ USB_DEVICE(0x090c, 0x2000), .driver_info = USB_QUIRK_DELAY_INIT },
 
 	/* Sound Devices USBPre2 */
 	{ USB_DEVICE(0x0926, 0x0202), .driver_info =


