Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831852;
	b=3Wkd0kEskhlhrJXfE5XzEhgsR06j+np1BBiRwOAkt7s1JhJplyV3XaNB4iSQ0Cg4aMI9
	 H5+Eeyx7KBjqTR+hBfCQEBj6GHtTR4GOZ5kdde+D5m24ZUMsa3/yHv6ozTk3bChZ+2vJF
	 hZSG12fobwrAmMLTPJ6ChXst8PPNDJFyZ/3ivJFjsydvaQKjM8h9vwL9/AI4NpTexn70j
	 Ru/Zn3lWCM/2tN1KwPNnFq8bJCh4B0nMhHDGucrEKsgpR6Mi9cJvaL7fojDN2Cc7eb0r3
	 zvONpPsh5uwXIeHi/mTuDq5bAfNreJ/GMqniKa5xCYGgO6+xk6zI61xL1480SoVhU1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rGqwuE7dkX7sju8sIH69IvFUHGPH3wbkxw8ZWOIlmn0=;
	b=HCoKYcPaWpg0dJcsLWcJ+EgfPTjM6CB8Wzl3hxIY9QKus6JgnRIOuE45Oumjd8wdvp4K
	 d7nV5eTo0qWPgB59iJ9Ph1TvOnEJSN7pIhAd3rgCRNrbfnvKD9ZYKcTOOP8N80Hzjq0po
	 wr7FXHJdlG1tavIhN8J4H8Qy9jyDD2UbZMivdwE3cLdmVAvc8PgyUtCcAn3GeaH+fCT42
	 tat7ijlvkvscoM4biJ6Q8K4o9dk+GSfW3CaSSg4qERh4JQft5l1LgYXVtmY51xwIYG0yu
	 oNmzYa+INkKfO7mKozaHPErpxBopGxcmwYy02jFIRrTO5HPNP9yZgrh3+KI5HFHJc2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oWLrkLeb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73278606A328;
	Wed,  4 Nov 2026 22:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oWLrkLeb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD091F000C1;
	Wed,  4 Nov 2026 22:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831852;
	bh=rGqwuE7dkX7sju8sIH69IvFUHGPH3wbkxw8ZWOIlmn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oWLrkLebG1BS1MFjSj1zx8G4OjP/J/ZDQ82cuPorXE21dzKP3jybxHMGlG3KRrnDh
	 V8korA4QfWojYscPz4fJ5RyDpD4vpVIP0m2TspsGy46qD3jS0dvBzEawdHcRXJCcta
	 G7x6Cknj0WGlOJIUi3vC3B93K5n1r2zpFKf6mIpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 0955/1005] HID: picoLCD: check for fb_deferred_io_init() error
Date: Wed,  4 Nov 2026 16:11:28 -0500
Message-ID: <20261104211109.844058881@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


