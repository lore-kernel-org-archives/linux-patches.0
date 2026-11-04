Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829180;
	b=rXybsNr3YhLIdifZ7iegb+/R1wJyPn680u2tbM5mIKPkJQq0JCb/hODD/wxuPa5Q4SRS
	 tkhGOPWwxsot4vy/ZJH/GWVeEjqdKCs40h9ZWQuL4eKTsFMEoaYziCF55pDML1mrXSfn3
	 wn+qc9UnmF2a9II3aYUOoX7R578y9FztHMUUCOydWgzX1b3Ym4tWxiZoI1Bz1lXgD4iky
	 wCtzoBvN9OfahrUsZisXVmRYL4bhBRsyn7K3GUuGEGR2cTxWWfSU1AU8W2pzJR3SfXV7x
	 X5CZ2d9cx21CZYMxJNiEulRjKz3Uk2mTW42pCmLSVKzQycHeF9kk7aLDguWKEBT7ECg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T4fr9PKoLwCuX6/DLyE+LDj/rq0HwWlnp7/RApqhCus=;
	b=wZmZMvrI8u3bNeEbz7IXLR2/2fVcmBn+0s4rBJeZPBY5RYCEmLNB91uAn/h6F7XejgKK
	 xKqpkB9ZhNjrJXyQfH3N82cazwv2QD9tQjbxkn5xoZPZ0JY4GBgC2KFjQxr7gp7WAa1Ky
	 Lwov6yaz0OXaf2mk+wILhBoodaf90Q3McBS2dP6AdRQ0drgrUI0LZaJxM4NJtu7BUecYj
	 XjLRRAG4OnYkZwy/BGlrxJ1H3uTabglwin9QSjnVbDrl+nblALKy67iN8v2Ve0uyj2+8J
	 s90KaCOBhVheGeGI0eI7oh8lJ7qBgAf7jXOGEtoW1bB4QINEUTyjdyZuapMqngLP4yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qXrow3m3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B296560709BF;
	Wed,  4 Nov 2026 21:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qXrow3m3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB6E1F000C1;
	Wed,  4 Nov 2026 21:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829179;
	bh=T4fr9PKoLwCuX6/DLyE+LDj/rq0HwWlnp7/RApqhCus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qXrow3m3JLsMUaDpZDsgxOOh+wQ4lOubtIk12vUg5Lfno3CFY98aAipRh9IoJuN1S
	 n6H0OqRa+VMk/He58U8Vig9giKYpNKYdrh72/2jOBdViWDtJvT3aW7Wm6arPLvK3E4
	 KFYYuiWz856UwfZFBg+B/Ux+xQaJbV5dIhMHkxy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.3 496/547] HID: picoLCD: check for fb_deferred_io_init() error
Date: Wed,  4 Nov 2026 16:11:20 -0500
Message-ID: <20261104211052.469117807@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -531,17 +531,23 @@ int picolcd_init_framebuffer(struct pico
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
 


