Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0414ABBA9;
	Wed, 30 Sep 2026 18:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793973; cv=none; b=b4OrhW3IO35okYqxWaDdovoZx6BePpAaRglbqrddKuZmyJL5tIrhaAg7jQzRUf8ROXSLS/RNGNCmvZR8biJb9CB8hQtPqglURn0kT/JE1ADL8aac28d36SPzbfEyj6W93rfPB25Aw9f9nhRSuiptqNkv1E2gxt8O79xvFLuS+Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793973; c=relaxed/simple;
	bh=VeyobfWrcsdE7OdPuKEtjPsVhtk0yowVtNS1phRDjd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTmOVvRjhmGyAzvNTtLkW46t2cc6dR68DklOYmBLpALr7oGvJFugud3WgZbMiYx0HjXZd1ZkiD66zqf4FZbwYLPXaVONUsjjLz8WHss1hXUoMGvhJ5zPlLUWg1c1Srf7uWK1rVj/BFp4CP59veGZ1sVOXnTpH4OFq8tIPgTH77g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hX4QhELR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hX4QhELR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48331F000FF;
	Wed, 30 Sep 2026 18:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793972;
	bh=2Cj71tFyVb9AXJ4uDl4jETpvDacE87qr4G2w328wyLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hX4QhELRY0Q2KBJJpno1xc4j1GVFLZOU3TEqecqCKBJ2u/O7cYVLZBR18MZpGuXwp
	 1eHhV5zw0lzeIrXNo+uJhgzXFED7pzdWPjNU/VjyGqUxJaVGGGbey4mKN8NCzp7lm/
	 JJkjNZEbPTKWesmI7yBYkeFuVYr566gWS6AHSGO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sophie D <patches@scd31.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0045/1193] drm/gud: Add RCade Display Adapter VID/PID pair
Date: Wed, 30 Sep 2026 17:12:09 +0200
Message-ID: <20260930152435.285106248@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Sophie D <patches@scd31.com>

[ Upstream commit ac5ac0acf11df04295eb1811066097b7022d6c7f ]

The RCade Display Adapter is a hardware device that allows driving an
Arcade CRT display via the GUD protocol. Currently it spoofs an
existing GUD VID/PID pair. However, now that it has its own pair
assigned, it makes sense to add this to the list of pairs that GUD
supports natively.

More information can be found in the project repositories:
https://gitlab.scd31.com/stephen/stm32-usb-vga-adapter-hardware
https://gitlab.scd31.com/stephen/stm32-usb-vga-rcade-adapter

Link: https://pid.codes/1209/4FB3/
Signed-off-by: Sophie D <patches@scd31.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260509025405.4143956-1-patches@scd31.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/gud/gud_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/gud/gud_drv.c b/drivers/gpu/drm/gud/gud_drv.c
index 9d7bf8ee45f13..ab7662a31c16d 100644
--- a/drivers/gpu/drm/gud/gud_drv.c
+++ b/drivers/gpu/drm/gud/gud_drv.c
@@ -660,6 +660,7 @@ static int gud_resume(struct usb_interface *intf)
 static const struct usb_device_id gud_id_table[] = {
 	{ USB_DEVICE_INTERFACE_CLASS(0x1d50, 0x614d, USB_CLASS_VENDOR_SPEC) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x16d0, 0x10a9, USB_CLASS_VENDOR_SPEC) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x1209, 0x4fb3, USB_CLASS_VENDOR_SPEC) },
 	{ }
 };
 
-- 
2.53.0



