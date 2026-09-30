Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D910251AEF3;
	Wed, 30 Sep 2026 18:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792762; cv=none; b=J186KWnRjrEZl/W2gF6ght9A27tJMNUrUVzZ5gnqBKpODXDElapcY58HaF5E/nKUK0k7X9M666ny7fes+VwWVR2lam1pS9yN+w/XYh0ppjZkwNkHbDKBdVuxXLByx0OF5/w0lkHhJe5UrT8vRSnMpU6T5Je0DoAyrLtlmcCLQQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792762; c=relaxed/simple;
	bh=kErrUKSlSj/EfCQ57WFQZ7xVrCdLnILhV7Ps62L3jgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIZkNGTLma1j9noHOYDDLOkQRZqycODMIxHVxsppOyti3Vg9mu2j5Y1kUHKJmoDUDBcGvJs2CjH+dxYsehCWeWo8sjKePmrxHtz2cVHTQF1BRxsiBL8V+oJWn+ORTZtECE76JwCsLX/S6wWfgtaRdya8P/hzh/Ya/XDVG9i0gj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kXWU3M0N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kXWU3M0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 419F81F000FF;
	Wed, 30 Sep 2026 18:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792760;
	bh=w+T591DVaRtsiqeoR3ZLfjl99ICgGdcw23ZqjM6DAq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kXWU3M0Naqxx2QgWLhrj93kHvjSBCwp7HJN/I6ikSBrOaORaLuIy8aLl3pT5AUhj/
	 sg0NV6s99DZXbSiIYGZKY5YLEMYhxGEdgg9S2EECDBNKV3SxdsS0DWPjWH/ho1r5WJ
	 O3w1gIRPaRPKWDFvA95pCqqb6g3MFuSgEExh9GR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oscar Priego Verdugo <oscar.priegov@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 017/395] HID: elecom: fix bus type for M-XGL20DLBK
Date: Wed, 30 Sep 2026 17:24:39 +0200
Message-ID: <20260930152340.989264226@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oscar Priego Verdugo <oscar.priegov@gmail.com>

[ Upstream commit 8e2a4b458ad25e13422bb059758c30a6562aa9cf ]

The M-XGL20DLBK is matched as a USB device by hid-elecom, but
its entry in hid_have_special_driver[] uses HID_BLUETOOTH_DEVICE.

This prevents the special-driver quirk entry from matching the USB
device handled by hid-elecom. Use HID_USB_DEVICE there as well.

Fixes: 55633e681afb ("HID: elecom: add support for EX-G M-XGL20DLBK wireless mouse")
Signed-off-by: Oscar Priego Verdugo <oscar.priegov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index ebf865c2dbb38..92aea01e1d644 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -421,7 +421,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 #endif
 #if IS_ENABLED(CONFIG_HID_ELECOM)
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_BM084) },
-	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XGL20DLBK) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XGL20DLBK) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1MRBK_01AC) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_00FB) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_018F) },
-- 
2.53.0



