Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BCA566C6B;
	Wed,  9 Sep 2026 13:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961662; cv=none; b=qEugCw60Rj7YU9Fonpafn96P6ZCE58J0VwsOWzCD4wLNC3Lr3CgvHttg6GX1klC60mHkk56/9ZnL7PaCHTL7Sh1173aUkuTUZ6JNZe0mLcRKuQc4FomqgH29GYCoaR+3gKo1PiAgO5vcucUqOrLNIh7Ds4eKwba6vA3yWpcEJhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961662; c=relaxed/simple;
	bh=Kr6RuhoHtgko4eMRc5NyIlOP7gcjXdK2Peup8llVESs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phkUAKaIbEwO9mYjwM2vimZcNsKMPequoCjXrUz2Vxq7kCUKTeH5pHlhUJQ6j2rcTGWBjZ97MUqYik8jbdxU3TV9guLFgPqshL4FrcTGZOxnfwYRPcKKq9/EGKptfsMh410uYIyKC1HNvas9vnPW9mI6/BUPYF+4dPycYwMGa5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxPsoYJ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxPsoYJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5DF1F00A3A;
	Wed,  9 Sep 2026 13:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961661;
	bh=WTwjldlQjUELBF7mscZlpT4C/OVV3rS8Cse24AkIU9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DxPsoYJ47ugClRrnQWlv5xJTFFYuYfrjZoyrKijo8cmksU7jrI0xrOi06ywJHulPj
	 shCzM/XNWCaqDviiTrKJzkTO2Xizxw0WBize/T1kO0GTV77+iHbGFF2Jf+cYMrVG3T
	 LNRYcUUeQ8PpSFfo0ieEMtEUrgMM+Ic9wn4XGjc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 7.2 025/556] usb: image: mdc800: change kmalloc() to kzalloc()
Date: Wed,  9 Sep 2026 15:35:05 +0200
Message-ID: <20260909134231.388188021@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 


