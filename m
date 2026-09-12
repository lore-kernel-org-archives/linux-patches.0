Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188B0386559;
	Sat, 12 Sep 2026 19:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241814; cv=none; b=WeW91jRWkpGxDJAeAAPvesvAJD+N/BHZNK2RJ5kB1iux1HcrhkYNYhbd3T0WL/As+GVR/LT/4umq7pD6ul4scdhMEEVMVGJIv31WZEaYsBqQhv/YqIttBAkig6SpjLdRjGf7G/dZPva3YPooQILo0qHEIj81teXbtDKhAi21C7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241814; c=relaxed/simple;
	bh=zZXlAaVQMNjvglVz+bTRzI8L/bbzx9K2cTgPfxDarjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiSAvv0Qe4lNjnfRbfUoqgJdzjNO3NYmZ6AljjHrSMErZTDTRh4FprD6A95RhOYAqoIxsj5I+ybGjmx9Gk85j09En7H5LG4QNMHU+CImEYHhlZRUDNqUZ2iCAiNJSnjSPl7C5nhey1TDOjW0j63bOanPvY+fVq3fylIOK8PAdqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJKOTs6e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJKOTs6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79001F00893;
	Sat, 12 Sep 2026 19:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241813;
	bh=1RbYhZcEdjr5KXy+SU7DG/kVM4OWoGUWqbE0NzuMj+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tJKOTs6eOtaZVJhIFoSWLZxYB5rcUFN8CzTLzwWJ8tOZw59boHX21NZe5xBsf9UzQ
	 Vb3uWuEkc7fJssj1NB1tAXTDJpvnEWDsFhSHM78Exh2CdT93xQSIMf5Sy7xNLod8AO
	 Ro7mRFPKKCfnunl7fyyGNZtQNow4GAYnXz4uh6CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 5.10 213/798] usb: image: mdc800: change kmalloc() to kzalloc()
Date: Sat, 12 Sep 2026 08:57:21 +0200
Message-ID: <20260912065521.991426754@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


