Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DBB3FF1DD;
	Fri, 15 May 2026 15:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860613; cv=none; b=p++50DHXuxjKm5Rze3QQSBacXPCgay2XmghstrcQrEZALxNKGwORdjZ0p3yFI2IGjb2clUUpCF9FEcQ2Q5BDNp4+lvED5xiqdlIgpXtqOGs/NIef6t8JQ0J6Roj3E8uL/oezQHtNUXUozJKzZWAfMTfWFJ4FnwGxE/Jki1FqHuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860613; c=relaxed/simple;
	bh=gPCQc2SNonOQShYkEzW/savmr8XbdmHIdJYYLC8JNgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hL7gbGRoit1dsu+U/t2aI/iGBBxyRH51ruoILjPH9pdadpFwfb7xW8U+c6uGqd4rRrUbEHTYwgZSM/hjNZIVhnZihEFMUJWS1zn4PPatZnrrD9zj0L4geAv9Ue4g4/QcuFi9RBmZMZNv7V8p3161j20r+9UxeWbNsJacbFL27Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ehw81Q+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ehw81Q+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58187C2BCB0;
	Fri, 15 May 2026 15:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860613;
	bh=gPCQc2SNonOQShYkEzW/savmr8XbdmHIdJYYLC8JNgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ehw81Q+ZbonpgXW5rYatkWHwqDBLhEN6VVkhBla0/5Fow1O6Ejylo3YwyToVP7fcB
	 aSOZh9SQnAzargcTC58XAIT8RYZtHiffW6+DbdPo4+Y9rxmQpWqKmbdZXlXy7PkMrN
	 vnxNIDKX9GXBuI1sSBsPFoWIzEmkOayAV4bS0Vsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Julius Werner <jwerner@chromium.org>,
	Samuel Holland <samuel@sholland.org>,
	Brian Norris <briannorris@chromium.org>,
	chrome-platform@lists.linux.dev
Subject: [PATCH 6.6 013/474] firmware: google: framebuffer: Do not mark framebuffer as busy
Date: Fri, 15 May 2026 17:42:02 +0200
Message-ID: <20260515154715.340909431@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

commit f3850d399de3b6142b02315227ef9e772ed0c302 upstream.

Remove the flag IORESOURCE_BUSY flag from coreboot's framebuffer
resource. It prevents simpledrm from successfully requesting the
range for its own use; resulting in errors such as

[    2.775430] simple-framebuffer simple-framebuffer.0: [drm] could not acquire memory region [mem 0x80000000-0x80407fff flags 0x80000200]

As with other uses of simple-framebuffer, the simple-framebuffer
device should only declare it's I/O resources, but not actively use
them.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 851b4c14532d ("firmware: coreboot: Add coreboot framebuffer driver")
Acked-by: Tzung-Bi Shih <tzungbi@kernel.org>
Acked-by: Julius Werner <jwerner@chromium.org>
Cc: Samuel Holland <samuel@sholland.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: Brian Norris <briannorris@chromium.org>
Cc: Julius Werner <jwerner@chromium.org>
Cc: chrome-platform@lists.linux.dev
Cc: <stable@vger.kernel.org> # v4.18+
Link: https://patch.msgid.link/20260217155836.96267-3-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/google/framebuffer-coreboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/google/framebuffer-coreboot.c
+++ b/drivers/firmware/google/framebuffer-coreboot.c
@@ -50,7 +50,7 @@ static int framebuffer_probe(struct core
 		return -ENODEV;
 
 	memset(&res, 0, sizeof(res));
-	res.flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+	res.flags = IORESOURCE_MEM;
 	res.name = "Coreboot Framebuffer";
 	res.start = fb->physical_address;
 	length = PAGE_ALIGN(fb->y_resolution * fb->bytes_per_line);


