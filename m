Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036503;
	b=uNXLmsEw7hrrKt0zMDPwpRsgvmmAeo90HCMipw2r3al6NUmicFPDULNvigRD82LcdPmq
	 /WOyWRADI0YeSyRdftT2qq5xdUWsWrTPZEvQCG2YIxLSgcINVLi98EBUyCRCkmYknQz8c
	 6nAoZUaj3dudXAcw1lMp7nBXc+a6xpo0ZNd1x5srWT9krcq0viIxGK6wQjgRXEM3Mn6Pt
	 BMdh62Y4xgwJI9adhWioYVOPZqLETjI+o+t8UtPyEXOPhdxhYivCGaTBWbddLY07d5jIJ
	 MkcG4UVrptnkqBx7bxyjSDt8IdUnIT2zGFX5IrC9jlZoN1TTui1LVMF6PCQ04NtbPsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036503;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A4btaeorIRjGVkst2puiEuCrCN2tNZgTzcp0OU59Mxg=;
	b=S2tkXw08ufCr1d7r+Tja7q22EjpmHWNuJgJHn3LkL9i0hBI2A2nax0VyX0FwzqSo1qT+
	 i35PWKXnREYHKJWAoE6PradB8CB/tLOtuS0vECdpTjTjknnjB5mXANcZIySVmC/ywSJH3
	 0YGecLqmMsD5MIkxaN6B8vezAL/yuXSubwLoiMAd7ylT9eJUhoOc7NMgs/VADGKxIC7Z0
	 leNKeyI958Tki7VtfnfiFDddTZxKGE+syRykeBr8b4hQ1K8EPjVWGgQfRXCfUI9BKAosU
	 4lPkwBp9AlaFnZpuKZ4jtQ5sDFe/9EJj4qxm+uIKKMeJMXhxX9zYCY2CG0GTT8aHxsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JVGyX/iB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288BC606A32F;
	Wed, 18 Nov 2026 21:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JVGyX/iB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765051F000C4;
	Wed, 18 Nov 2026 21:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036503;
	bh=A4btaeorIRjGVkst2puiEuCrCN2tNZgTzcp0OU59Mxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JVGyX/iBSmScO6Uz3qxJnTuD6pHp+dA8KsYwMtXK0GseQXHK8jH08mHZ8GiT/OIJ6
	 SYneN1KTwlaigmYYoClXFdDpWnAR7b1myk5hB2JazzKG7dvkVsCW0P0WC/fGVcaKcw
	 K7vwqy33MkTjWhlUVBXn7tSfhZpIxgj278hdtLhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1083/3318] fbdev: xen-fbfront: check for fb_deferred_io_init() error
Date: Wed, 18 Nov 2026 15:28:25 +0100
Message-ID: <20261118150352.461505785@linuxfoundation.org>
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
index 66d4628a96ae0..0e6bb07e7cd90 100644
--- a/drivers/video/fbdev/xen-fbfront.c
+++ b/drivers/video/fbdev/xen-fbfront.c
@@ -442,7 +442,11 @@ static int xenfb_probe(struct xenbus_device *dev,
 	}
 
 	fb_info->fbdefio = &xenfb_defio;
-	fb_deferred_io_init(fb_info);
+	ret = fb_deferred_io_init(fb_info);
+	if (ret < 0) {
+		xenbus_dev_fatal(dev, ret, "fb_deferred_io_init");
+		goto error_cmap;
+	}
 
 	xenfb_init_shared_page(info, fb_info);
 
@@ -464,6 +468,7 @@ static int xenfb_probe(struct xenbus_device *dev,
 
 error_fb:
 	fb_deferred_io_cleanup(fb_info);
+error_cmap:
 	fb_dealloc_cmap(&fb_info->cmap);
 	framebuffer_release(fb_info);
 error_nomem:
-- 
2.53.0



