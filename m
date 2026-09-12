Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C883264F9;
	Sat, 12 Sep 2026 13:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221140; cv=none; b=BIQa2CahJvXSNg7XPf1BC5uz708bfhAj94igP7ZiDa/GdHp1ct967wf2WMtWdHKA7XmJppXr9v3qli6b+0ht5jRrDjHM38KtMOOOIFNYXTb9nwAPadSCTHlNgr4z7uZH0e8ynV9kheRf2gjqVx5KMaHrup4EzAzGsxRVCMoZJNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221140; c=relaxed/simple;
	bh=ek3NzZPsFEBbjB3QuzRseofmL7ZxZCw6EX7i4KZQhtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXgFVkoetaWrO6GXrWv418smcZUTjUIxGn8y0mdWDWjSM8s82pXBxggF0olVGdSvdSkRjEDdhG6mjYPLS7xomFutBhlz6r+CoCb58N8R+b52ADaIKBVpmwjOjnDZ0otlZBCb0Es31LJJL3GzV+JHGLzyCZIpBum9Dj9XxpheI+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9Z0FYz+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9Z0FYz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A031F000FF;
	Sat, 12 Sep 2026 13:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221138;
	bh=vJF+mHqK0oGOM8GMCPi5s4G0AHCp4aNqUyhlTlf/iAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I9Z0FYz+DdEF/R6ycETkUHDYEIP+QtJt8oSP/DheXqvr8u8V3w8gouGVGzfHJ9+Mt
	 f4+tZG01Ai0JWsaZglXMSSTeNchwGsHsX4TDa4Mfv0uVZnG8rPGtY/ryB43N7lwSeV
	 ds7ZeBAsPUXte15O6cU3wFzfoshSih5fwEt5kySk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 6.6 0322/1424] usb: image: mdc800: change kmalloc() to kzalloc()
Date: Sat, 12 Sep 2026 08:45:54 +0200
Message-ID: <20260912065614.496510644@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
@@ -1001,13 +1001,13 @@ static int __init usb_mdc800_init (void)
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
 


