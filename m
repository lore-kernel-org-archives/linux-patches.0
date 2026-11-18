Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051913;
	b=IiWFnY7jJ1YVI9lPrESLAUgiusxuuhb9Mjq3cftqQMiKWrztnWx5m6lPa8RITbRU77EF
	 +CH+/Ff0OhvP6bEuRl6/vMXQlmtHt+9fxoJPR5mcgVe7to2Fu2dP953lYzZqfcliRIOOW
	 q3dlFFGJoullSNTlt/ut7PDLlJo5acYWOck8FAo9un+L516Sw6YD5+NlhRfSxfMZaZ5Oe
	 I3p+oH4Rkqz0r1DvaZyYyuXUHVvd7U626USB8Pu4J8c5K+IVlyP2BlNZHiBDaVPgDOXUW
	 SEBIZFKBLoRDSK0DNrTvW+8ekgy5/lykU3ggkc8jRpoNDGYGO+TYYRWx806tFTI707g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051913;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fj6IehzQTU1Wz4jJpPgsGeN/f/aqTn9eb4LTigRphxI=;
	b=IOB6+F/DEENih6eBLrFbkvCIPiyxqSVw5HcNF9YtMzIHuxfMzA9u3kCktRr4Z5UYY85R
	 9IN+o6dtV+8wtmyHC58mWE2a3OaPRJ5J9VaxYVWECI5R+QRMD2jDR2xGAfqTcc5jinwZ5
	 gORBddFioSvcQL4BTPLamFkWYnH7iDrERcfnkHLA5v1ZUyKo9BYurlh2XvrpHwhyuquKb
	 JCYjpErQbJY110zELl8Ac/YYt4cAhZtRDTTP6U+giJwXOFGfU2jVYXJcO0rSuoi5EI8Jp
	 12Z/to/Dh1Cud11DH1vPof+bmfJVKziVYpqCYGGsY33maJUgsRmFvqikiyrv5bsl2HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EP2fxM4M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A4060A3817;
	Thu, 19 Nov 2026 01:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EP2fxM4M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F4C1F000CF;
	Thu, 19 Nov 2026 01:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051913;
	bh=fj6IehzQTU1Wz4jJpPgsGeN/f/aqTn9eb4LTigRphxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EP2fxM4Mbzms4WWYPvxjgYb8Mm+uxhPzaRk2AByvj3yky3GmjtOliW01fLLdBzthx
	 WQdZZIVMdLhdr8zbLZA4w0QWiAuNUd/RRrieZHQldrmkI6uFv2YbdNU9FWQX1TAY6U
	 19UTFhcpyTt+O7euVICryTya3bZztOXsc/6KZ8Nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 0378/2214] HID: picoLCD: check for fb_deferred_io_init() error
Date: Wed, 18 Nov 2026 15:34:14 +0100
Message-ID: <20261118150025.831108704@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


