Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035519;
	b=iUFpBBp7chU5DrMM9aVu4uSsj1fMD5YnOWj2WGiu/bcrg6kwFrZiA6aUhxLGfW9ut8jE
	 5qvyTOZW8Jkaf/N300lE1qe5Z2f9LZS31qNPV0Gew2zddd6MJaGrKBrdRENucLsSH9BAG
	 GwBvt7N03nkVmCclYPVRRvSEqgdygJoZmQrSstJmGKFkxm+D9Bz9NtNbsjEgxYcWIvB5G
	 nrq5q3NJ77rg4JiSdrUmZB1phJ2i5KHaRvuJKBp8AB1hko/FgSwd9ME4ML2onKAQxYFC4
	 yRW+mcyXimUxDLHEveWw+xAF9MV5MUmhYI8TFo9ITDUj3+A3N9XBaPF3vYXL9fSdIoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yl7weRM0SJaClfvFHXQmhZFnkv2y4Q77NdxSrJGtSXg=;
	b=hiwPLoi5nU1LEFb9OxfpxNZfSVQBoxmoTuahlw9P9aea+t5f1oKTM9LcHSB6/rw3fXx8
	 rpzd140iKxv7P8FVMVJr6t9esIPig/my5+ufun+ViecR/CY9SU8XwuCpMldGkb7Z0foT/
	 UnxRtxvpn3Gsaf8/D6A4rjvW7a5nGhLzx+w1NNRWV0MRX347ENl9FFlvUNOexXNZhnFo8
	 JvWYC483sUWuFMCDlip8CUa6KibEzI92D734HgMo1JF8wnB44N2ksiBuUcHxQfpQflpmS
	 xiYBag20vXQ6UD7sXYSSzh4lEmXp3q+m8I/lVBi4IlBIzYxtug8Lbwaubdk1cSw7z0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wO6h3Rhr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F7F606A31C;
	Wed, 18 Nov 2026 20:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wO6h3Rhr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CDA71F000C4;
	Wed, 18 Nov 2026 20:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035518;
	bh=Yl7weRM0SJaClfvFHXQmhZFnkv2y4Q77NdxSrJGtSXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wO6h3Rhr1dL3B5iOXxK6PPCK9//RZ8lDxP3U1jaZoJmnzGc7Yy57kzHJAceyOhJYm
	 RkiOQQ/p1qi5atouOE6nYm4YqCqWrxyIvTJMwQGt8sloMco58kXZGOB31D94r3Adk9
	 f2JTKcyY2ykwc5bvaAxU28O5dFfW2W5LU+AnD3Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 0732/3318] HID: picoLCD: check for fb_deferred_io_init() error
Date: Wed, 18 Nov 2026 15:22:34 +0100
Message-ID: <20261118150340.502021843@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

commit feade898fc958ff355101adf12d5632272e64220 upstream.

fb_deferred_io_init() allocates deferred I/O state, populating
info->fbdefio_state, or leaving it NULL if an error occurs.

Currently picolcd_init_framebuffer() ignores its return value.

Therefore if an error arises in fb_deferred_io_init() (for instance, due
to an allocation failure) info->fbdefio_state is left NULL.

When the file is subsequently opened, fb_open() will dereference a NULL
pointer (calling fb_deferred_io_open()).

Fix this by checking for the error.

Also correct cleanup ordering - defio is initialised after the sysfs file,
so cleanup defio first.

Fixes: 56c134f7f1b5 ("fbdev: Track deferred-I/O pages in pageref struct")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-picolcd_fb.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/hid/hid-picolcd_fb.c
+++ b/drivers/hid/hid-picolcd_fb.c
@@ -557,17 +557,23 @@ int picolcd_init_framebuffer(struct pico
 		goto err_cleanup;
 	}
 
-	fb_deferred_io_init(info);
+	error = fb_deferred_io_init(info);
+	if (error) {
+		dev_err(dev, "failed to initialize deferred I/O\n");
+		goto err_sysfs;
+	}
+
 	error = register_framebuffer(info);
 	if (error) {
 		dev_err(dev, "failed to register framebuffer\n");
-		goto err_sysfs;
+		goto err_defio;
 	}
 	return 0;
 
+err_defio:
+	fb_deferred_io_cleanup(info);
 err_sysfs:
 	device_remove_file(dev, &dev_attr_fb_update_rate);
-	fb_deferred_io_cleanup(info);
 err_cleanup:
 	data->fb_info    = NULL;
 


