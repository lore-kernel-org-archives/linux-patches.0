Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7327256E07C;
	Wed,  9 Sep 2026 14:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963245; cv=none; b=rhG/5JUg2kbkPIReeqJP41oUGbmbyJSxAmOem/v7T94gpro3UPIDoARRSZsYVrZDyJA7fe9lu9wf1e1a5mLgje2j6zs0/cVcQSwOfizINWBBFKfF5v/DkmiZu7qXlEZna2U35aEVEvGXf6HSw0WcrAD7F45LDPs7HnvrYRGnMao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963245; c=relaxed/simple;
	bh=Kx5BN2dMlj783q+Fur28v7x0c+RmNWQyvHpEvJP2HsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRxaTZWtUI3VLplaouu2MCU1aA78LVNMq4/oofXDbrqa3YbOKKDqyIvJ/4oAOJvtiXDMdU2LMOChcNO2sgz9aPqHBqChsoD6C1OKuOFpuYfpiSgxJZn1pnbJ7242CUiqCAq19IhtsQV8v2+J2u2ykIaoCzeJSFIlQIa6d8eW6W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AFtS3E/Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AFtS3E/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7EC1F00A3A;
	Wed,  9 Sep 2026 14:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963244;
	bh=Hd1tGTofGsR5jfgHYcCMLeRWxDfARJFxwNqLwxXvnuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AFtS3E/Qiy3W1aYteqZN+DLBrz63Gvc8pKOjqRiu/Quo2xycTFn+99W1sZZI6Q6Uk
	 JATshGBoD9A0tAsNpxXXW/i0ZLqQlIGlJC8n9LsR4KT2eg5WyFdoEzJTTgpn75EzL7
	 yD8fG5NoG9l6ClZXVATpPHwTEQKCH3TguTcIFuTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 6.18 013/583] usb: image: mdc800: change kmalloc() to kzalloc()
Date: Wed,  9 Sep 2026 15:34:58 +0200
Message-ID: <20260909134238.261308685@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Griffin Kroah-Hartman <griffin@kroah.com>

commit 2430eb81e44111b30eeb5273bbcf8b24ca517ef9 upstream.

Change the kmalloc() calls in usb_mdc800_init() for irq_urb_buffer and
download_urb_buffer to kzalloc(), avoiding potential stack leaks if a
shorter message is received in mdc800_usb_irq() and
mdc800_usb_download_notify()

Assisted-by: gkh_clanker_t1000
Cc: stable <stable@kernel.org>
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Link: https://patch.msgid.link/20260819-usb_misc_random-v1-1-43a0dcee3a32@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/image/mdc800.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/image/mdc800.c
+++ b/drivers/usb/image/mdc800.c
@@ -1000,13 +1000,13 @@ static int __init usb_mdc800_init (void)
 	mdc800->downloaded = 0;
 	mdc800->written = 0;
 
-	mdc800->irq_urb_buffer=kmalloc (8, GFP_KERNEL);
+	mdc800->irq_urb_buffer=kzalloc (8, GFP_KERNEL);
 	if (!mdc800->irq_urb_buffer)
 		goto cleanup_on_fail;
 	mdc800->write_urb_buffer=kmalloc (8, GFP_KERNEL);
 	if (!mdc800->write_urb_buffer)
 		goto cleanup_on_fail;
-	mdc800->download_urb_buffer=kmalloc (64, GFP_KERNEL);
+	mdc800->download_urb_buffer=kzalloc (64, GFP_KERNEL);
 	if (!mdc800->download_urb_buffer)
 		goto cleanup_on_fail;
 


