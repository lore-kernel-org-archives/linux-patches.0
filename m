Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AFE32D7F8;
	Sat, 12 Sep 2026 18:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237318; cv=none; b=QhMc8k2zIjqAHhFsBz/TSyLGvOQLjgNUixyCJaJyjrtK/rXbIg6dmJS/AVraC1g3jL7bhuOPmr7qFOzc9G1R+BZU8p5r3mZ1F3UAfNGxzEsW04SDcaN6+hT0r6s5hMKDPTRuiDbtqy11el3C+miAsGc9cB/rQjbn5JXedZvckas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237318; c=relaxed/simple;
	bh=ldjt+Oz/lyPnEY5oLH6OR4Imjo97YjN9D0xbVIAZLR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GbDsuJ6dpL4Wd4z/bAWXkC6kBTeQWlMHkjEVP2cUbuVbex/52rTS/3Rzmyt33Y7yyM5jZZkglagt9PGyrIA4URiU4F2X8Db6/HfToa/UwvZ+syVzVp9RkXNzZUSA++S8jC2XtwZ8sbXfdRQ9Xj3h3bzPZzi2jnFeEqaBF/q+Jbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQI1yqGe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQI1yqGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAA51F000FF;
	Sat, 12 Sep 2026 18:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237317;
	bh=ElUrghWfM14NnEEkYUes4UqLx/gER7EvMLbMncL1QzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZQI1yqGeGHvIAKsqJfeD89cFQfLLzrjFZHdKNAn1c3aPFOdTKEUNsPvsNinH1IxN4
	 J1yA1AkQf+pP7TKFzM7CIgfOAjOB70pJjHcYmc1OQ4Ab7Ysn5TzuaKtTH3omwsY/LF
	 0BWm72ihGgpyd6V1DPvUxUGtP4A0AmFk3ZB0fA+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 5.15 234/935] usb: image: mdc800: change kmalloc() to kzalloc()
Date: Sat, 12 Sep 2026 08:54:24 +0200
Message-ID: <20260912065532.195823791@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


