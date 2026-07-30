Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22B4435A94;
	Thu, 30 Jul 2026 16:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427242; cv=none; b=XyeBOG7UaI0+MjEiG1oR3np3MDWnwaLbK1sAmu36aFZyDW3WIpfYpwU6VAo8HffpyHpdgL77T2mU0BfqVEzmzCwJrkTAp0aDrMXjO/Npg27sqKn/TB2j28mAGEtjHxn3jo+IbmB1fQo3EA7O7WvuU686RVLy+v+sI6IghL7s9mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427242; c=relaxed/simple;
	bh=8Tp27WQQHRVPejzKAApbIygz5cJDI70cKdIQATLMJQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jo9urQ7VUHYxe7n+IBAWR6FB3JDDlJUtOvYiHCZwb3MxXlV7Lhz3FCTqB10CsHdxJUOoohpPtyxTA4hfdFngzb7yqrl3KYsZ5tr7q8Ed0atEGwsZNqXtKF/uptzPyOehlh9xI+RgBMt1ZGL0nOeI/T8LwjaaWyqaxv31tQZaGyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PGRjp87Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PGRjp87Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068C91F01559;
	Thu, 30 Jul 2026 16:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427240;
	bh=HI6kZhXMXn3pk6aA+gcRNVts3YkaN2RGuAwIxPNyhcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PGRjp87QZhHwPj3quEBJyIWPm1EvGDYTL7YHhlHl09sRo0sYSfXMUvisRAHPx6zzV
	 kGUd+IJdPf6VbhJe6fU7g38IX3Lz0a6ZY5x28+QijJnPX/rMSqZXJ94mLPYpHiBMQq
	 mHSS0YDQxaAyW68DlxeukjJg0STyNC27w3ve0A2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 102/484] USB: gadget: snps-udc: fix device name leak on probe failure
Date: Thu, 30 Jul 2026 16:09:59 +0200
Message-ID: <20260730141425.674213704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 29a142d3e8b35ebc9e0bcc78f4bc26c9b6a9ac0b upstream.

The gadget device name is set by UDC core when registering the gadget
and must not be set before to avoid leaking the name in intermediate
error paths (e.g. when detecting an older chip revision).

Fixes: 12ad0fcaf2fb ("usb: gadget: amd5536udc: let udc-core manage gadget->dev")
Cc: stable <stable@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260702141536.90887-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/snps_udc_core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/gadget/udc/snps_udc_core.c
+++ b/drivers/usb/gadget/udc/snps_udc_core.c
@@ -3133,7 +3133,6 @@ int udc_probe(struct udc *dev)
 	/* device struct setup */
 	dev->gadget.ops = &udc_ops;
 
-	dev_set_name(&dev->gadget.dev, "gadget");
 	dev->gadget.name = name;
 	dev->gadget.max_speed = USB_SPEED_HIGH;
 


