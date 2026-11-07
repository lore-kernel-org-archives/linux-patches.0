Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063314;
	b=S/UnVPIz8IdQ+n6Zj7mJpluvFuaiDbmtldp1NoMDVnuhbk9Gwi/fiA4TbOS3Oggt7OYA
	 l+03ufe7MRmcOJ5yACyGFQpvnqM8te3f2FN2SERCb60HX/YDYzLgX/TPL9wpg7+/jk+5N
	 8/wTbt4tLeBE+xFN09cp8mOpI7G3dxuJkcKyYpP9qX6qdIBtmDZjePXbAgochzFRRWe2r
	 97XZbDDXC1wBH7CdBJQNPRSkoeVSwpwjt9NrzBm90N5GDF32mQsqeJFEqR7jbrgH3D70A
	 n64S6gA1CGSyrzZLEiEJfoMjOIiic1pobPiZslhrndk/REp5wgLZHQNHNhLwa5gUFcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=whd81ZCz5u2bpeeUifRXgcdPI7z679dvmF09JSNZa8U=;
	b=XOJdxuLzgxhinxhkgMpBwfOWVpjJvFfjq12Cza9km17PY2Im/IwmdnCaCvy7PYGm0Tr1
	 690VdJl6ZCkl1E6Y3dHMvgHyFQK3DoVOpNyX5+DNSvTJo02wPqtbH0MIHODMnB4qNk0dB
	 WUX20g/yA55+n7+f89Zs/GEQ9mApcYHEXZVWRt/zaMlcDBDFchxPWNuBK0g6AjZbJbFn6
	 i1qOjbZr2a34p35REEJg+hP2HkiOqxZzOpG2DGq/mbJeqIkKVKVku9q1YLn7mwpne1W43
	 VhC5BIgnKF4/fd/jTFGLJYwqVffSZrlj8hG8Y4ZehyRPe483qFXK3HNL4thiE5k5jpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ro6JpRfs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B27606A32C;
	Sat,  7 Nov 2026 14:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ro6JpRfs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659D81F008A2;
	Sat,  7 Nov 2026 14:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063313;
	bh=whd81ZCz5u2bpeeUifRXgcdPI7z679dvmF09JSNZa8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ro6JpRfsQ10lFJgXbk/EsTiMZEcADAobdNZWI6sOZxHyWQBE3QgKfWFIei8itMnso
	 SNmDjIx3f0CPzQh9pJEKK4dEf9JVlla550EPUxImhPZ0uvmqo9aZC/Qb1ul9nUHh56
	 3k0bqgroWvj7fS0JbQWVOZeaoAFZK2ru0SHfvdKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 501/869] fbdev: xen-fbfront: check for fb_deferred_io_init() error
Date: Sat,  7 Nov 2026 08:53:03 -0500
Message-ID: <20261107134910.613388046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index d8f3bfb2dd6c9..22aaafd2c11f5 100644
--- a/drivers/video/fbdev/xen-fbfront.c
+++ b/drivers/video/fbdev/xen-fbfront.c
@@ -443,7 +443,11 @@ static int xenfb_probe(struct xenbus_device *dev,
 	}
 
 	fb_info->fbdefio = &xenfb_defio;
-	fb_deferred_io_init(fb_info);
+	ret = fb_deferred_io_init(fb_info);
+	if (ret < 0) {
+		xenbus_dev_fatal(dev, ret, "fb_deferred_io_init");
+		goto error_cmap;
+	}
 
 	xenfb_init_shared_page(info, fb_info);
 
@@ -465,6 +469,7 @@ static int xenfb_probe(struct xenbus_device *dev,
 
 error_fb:
 	fb_deferred_io_cleanup(fb_info);
+error_cmap:
 	fb_dealloc_cmap(&fb_info->cmap);
 	framebuffer_release(fb_info);
 error_nomem:
-- 
2.53.0



