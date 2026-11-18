Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045469;
	b=R3pz78bRpss9vy1bMXizQCHQ4pea5JO9R3xqGKRy67D6tTaJzdSAchv4PFu9L0kCaJTW
	 WcCZr77UErL8hdb2fVO4qyAUUYYSY/lAYaUyk4SG8L3PUPwsqemMHZ7pkjA1OSgA4TnNi
	 I9vcU4RSisutdTROTrAuEzF53c4Gz+ggvUjY84iPlXFzjOjgw/db+vkPt++ME//I0ozqM
	 AUo8aQEWmSgdjIzOmXxXBVJ1KOMJxqHXFRvmYpWtIMcwn09+53bQwIh8vTh92dy5lPPF6
	 x6Pz75Gg/4a2Apk7GvkmWgA0B7oFqToU3kuXQN3bmrq+WlDkhKD+ucSXaqNe1fxKuFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HOvtthcNA1SIN4rDTVHa+6huEtQUNhArSUpfMKFa2t8=;
	b=CnhsXwYnhvmzlUAEzfbxRndivETmhay5cHTbZRCmV6pzS9F1RikxNQ29PWWy0TWn9jJz
	 RQ6nhw7zIcfbPAP3f/vY+yYx5pI57U1Kdm1tIwvpked/HQrSjyI3cBl9o+zWuJPHGGPaT
	 PJmYSAnSEsaTwznZDc9qrcfpc2b457hPwwZxhp7MAQp/HGP5jMNzOl67X93yzrt2mP1Rv
	 yJGFN8cROpOtkQwdIAkpapzomtOAtYwb2vza6RujwDXo/9pazqLx5u1KXu2fZotgsSgCw
	 O1Cx2WGqOpAIEl4tSnwyEUVzjtx7CJCI+loJyKFjD/TCiRuiS6DBqD4w0nj52723ifg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1zfILCfi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C607606A320;
	Wed, 18 Nov 2026 23:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1zfILCfi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015371F000C4;
	Wed, 18 Nov 2026 23:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045469;
	bh=HOvtthcNA1SIN4rDTVHa+6huEtQUNhArSUpfMKFa2t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1zfILCfivgXsSsIKAZQW3T/RUyuIoCiS3CuEHOCWt7ru5OpaVpwXwlvxsb0gLytkt
	 gRBVykeRJwO9ZlfU7+1ld8Fyd4duVzRUhbhDIq+I6Ee3NAdYQxHaPbzQj1CKpZkTZW
	 qyxIGQLYT+6/HC+l8XRNZpbgjZX7lVauOpBAbI4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0932/2857] fbdev: xen-fbfront: check for fb_deferred_io_init() error
Date: Wed, 18 Nov 2026 15:32:46 +0100
Message-ID: <20261118150235.143652000@linuxfoundation.org>
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

[ Upstream commit 5b234b0dd29d79207c059c7b40851dd1e934fa3a ]

fb_deferred_io_init() allocates deferred I/O state, populating
info->fbdefio_state, or leaving it NULL if an error occurs.

Currently xenfb_probe() ignores its return value.

Therefore if an error arises in fb_deferred_io_init() (for instance, due
to an allocation failure) info->fbdefio_state is left NULL.

When the file is subsequently opened, fb_open() will dereference a NULL
pointer (calling fb_deferred_io_open()).

Fix this by checking for the error.

Fixes: 56c134f7f1b5 ("fbdev: Track deferred-I/O pages in pageref struct")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/xen-fbfront.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/xen-fbfront.c b/drivers/video/fbdev/xen-fbfront.c
index ae8a50ecdbd3a..4e17d8c25696e 100644
--- a/drivers/video/fbdev/xen-fbfront.c
+++ b/drivers/video/fbdev/xen-fbfront.c
@@ -463,7 +463,11 @@ static int xenfb_probe(struct xenbus_device *dev,
 	}
 
 	fb_info->fbdefio = &xenfb_defio;
-	fb_deferred_io_init(fb_info);
+	ret = fb_deferred_io_init(fb_info);
+	if (ret < 0) {
+		xenbus_dev_fatal(dev, ret, "fb_deferred_io_init");
+		goto error_cmap;
+	}
 
 	xenfb_init_shared_page(info, fb_info);
 
@@ -485,6 +489,7 @@ static int xenfb_probe(struct xenbus_device *dev,
 
 error_fb:
 	fb_deferred_io_cleanup(fb_info);
+error_cmap:
 	fb_dealloc_cmap(&fb_info->cmap);
 	framebuffer_release(fb_info);
 error_nomem:
-- 
2.53.0



