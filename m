Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2856317145;
	Sat, 12 Sep 2026 15:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227872; cv=none; b=tMo+v1YCgLwOlT+n6fgSl2DTbwAXP7gvvVr9uddgthUegt5liZSHBbfvVmAbnHpDGYndFKrr3xMTHhaWISqiGrnZ8eycRMCwcZg0ojZ+7McWwnqwCzyUPnLohyGvr0PhZ322WdTI0KwLcMu62n1sMHJCYRrEnxw/mo7TCIcfW90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227872; c=relaxed/simple;
	bh=AUtpMAkG8Ps36gyBHuC8c7coMRfXUFh3HV5Qycg1Ckk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFRVbs4YSvlkr55/QdXd0kgRhyXj8H4Nlli68vUadT6ZK74uhYvoMruHnd0XKD3/t8LY5ShqtHtukXZA7Jub5Dq65ylU+KWpfIJw95rEWjeNzkrJY4MyKFeaGNOpmHhPzNdm+AIAO2bFuRi3lOyXXnS64Y6zRi8wRn9TXy8ihK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lRjuRJJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lRjuRJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239101F000FF;
	Sat, 12 Sep 2026 15:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227871;
	bh=Soh9D6ePbCgx7D8G5LdTkcNgQeINRtRRk9HlyktABoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2lRjuRJJDOtkyljMXtXHfvravooDClSrdrOFIHV0ncIE8FG3B4d+lLQpNUD6Su/tE
	 8fkddYfuWMX/G97UXTloGBf4P9yhon8L0w7ZG4LzjI1nQdwCw4YB2p7AhEEZ9pRRp2
	 q6B7TKYMBrhyj9/RoVZwPwkw52qKczD/BmN003gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 6.1 0269/1191] usb: image: mdc800: change kmalloc() to kzalloc()
Date: Sat, 12 Sep 2026 08:49:57 +0200
Message-ID: <20260912065554.264942486@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
 


