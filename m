Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044636;
	b=1/8Gx4eYkfmZ64Xg5vDb8TKUC0AzNfC9m3OQvjbeng5GP4BJ9RWuhZ7XCOltFUOjY+P+
	 Ocj/YG3Stq1R88n3DqEqHIBXzBr73uGQ0wBZ2w39eJYa5eCJwVxUFa1MAmyJK1xBUwKcj
	 plfVCEIsqVVnk1NAC4MG2SbowRycmQXIQMquuecBR8SD3J84CIsTLvG1Jes3SgGowXcfu
	 9slJHngRdNa3aOF8xMh75LFq0/tkSKlg3+KlzJsRKSWiawomlfBfCoiaibtQSz0ngmNFR
	 YhTIwcSWKVRyMs7A1xaTw2KzkwAli+hXOKZ9dg5eN38GkHXazFUMQaa9cBwLR0+0Mpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044636;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=spDhx9B7mEH+beKu95oEbaUDs567EiiwungSVpH8v60=;
	b=jw2SOhqDmfuoY6rdvnb03wwxJQ2b9rpHpBFImcsxYELKg9fUwQc+jgvvM44yoOKVLE/l
	 Mj8AF38LhJpzCuVUpF45JVj8XavR/YcPshBqFchl4Z5BbexEKwgB6B9htykCdd4xjhXqx
	 5bS/Bc1PAqjqoOmvCIAcUR2GW9C0OJ07cuLHrC9yjKL9UasVbEHCJaFPG0L/qgofhkysX
	 HBgPlCs0812Y/w/AMMp5B/vEmtoA2QW6Gzkq9K8XG7PQMXgUnIyW8Qg36AXnLPSofVZ9n
	 2AbH/RCjkgCTpax/0XT+C9zb790hGJvP+RuVjCaPqCkFZgtH5xwv0cDtbPex4U6jwbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sqXizG2b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A181760A2602;
	Wed, 18 Nov 2026 23:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sqXizG2b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00071F000C9;
	Wed, 18 Nov 2026 23:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044636;
	bh=spDhx9B7mEH+beKu95oEbaUDs567EiiwungSVpH8v60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sqXizG2b6QejFLqEHKhUSxJghLE5cLcjwvfN++AagRRl8ActqFH9357W9m/X9ySor
	 /s69qITKYSgbuZlPAMgdtFDbAXEjARubtnXVNbhHj8YbaXA0MZCMNcsEYlZmIWKM1v
	 bsEY/aWqatzzRfhqC9rZv4r/fw6AINRIZ1i4mUKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 0639/2857] HID: picoLCD: check for fb_deferred_io_init() error
Date: Wed, 18 Nov 2026 15:27:53 +0100
Message-ID: <20261118150224.525542309@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -558,17 +558,23 @@ int picolcd_init_framebuffer(struct pico
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
 


