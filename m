Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1967F17A2E8;
	Mon, 10 Mar 2025 18:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629670; cv=none; b=dosQKfJ82TE1qqfOVMdgsO5IjgrVHrMd9bJecza3Ach0fB6JTaNcQF4E1HWds+pmbPS+xMF/CJ6oVfsIex4J8T/x4pXD+xtpJjc4rtMKFIRlSH840iTCxm5v+i+BI3P7UZ0pJ5wFWqebb6n/SGeJkV/pIKEmT4F5ZvefDL2QvaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629670; c=relaxed/simple;
	bh=bTHFE2p9Xoto2WmfINgPDvYFqv6wQ8B3NuNrqEF/BVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5ISHuKR++G/PYiopaL7grklEi+Eg1FOBGrzYRPqOQAD14Sn8s0nqSbjVTINzXr6xbWDf+XPeMjS02AcwzRG13+ohua5IEsRKltMUZZzCwC7hJBpbRX94qqR1eanHHV41OnjsYEkJcpH+VTxoSE0UlrtXgWUDuRT1vZ30jcYIZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WrlRMHuZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WrlRMHuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A281C4CEE5;
	Mon, 10 Mar 2025 18:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629669;
	bh=bTHFE2p9Xoto2WmfINgPDvYFqv6wQ8B3NuNrqEF/BVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WrlRMHuZjuUuKCIuGwVzcJdbqyuzZ54IJjprPsaDV8BUDWGPq/gySrI03onp9mRYg
	 OjFpzmESLl3tS0LvKbNiSWTqDz5wILW1vuZmgX6qfYMLjxwHel/D6tsMd8+gI1e7W/
	 PxVekRRUlRZa8L74sRYndWiACFk5jb3ehKkySzhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Porcedda <fabio.porcedda@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 374/620] USB: serial: option: fix Telit Cinterion FN990A name
Date: Mon, 10 Mar 2025 18:03:40 +0100
Message-ID: <20250310170600.363092091@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


