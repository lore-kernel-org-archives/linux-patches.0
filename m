Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052610;
	b=q2yWNZKboexuEwJXKU6v0NbVW8WI2tXon2uu/YJmgjBhCMiK4v37Scs1ctOEMjQhRLpc
	 J3hW1AXCBGfBFihrROlK45slBZ+xq5GO6AWPmRLQbUayRpyzyt5mkyDG+gLFaBXSNVtJC
	 G161f2+X6WPmXSqTfxwVTK4vyi25CcoHe9ekXWK2OXLcwAv9/aeVLUrYXE+dn/KTzNht0
	 Rk4l2qWZ4YGSIwaIXwswASkQg5dOBGU1v6Q5s9DFZYg4oNp8A9FrA+6nDixqgL2fVIlqI
	 rG5hz5Uc3GQ/YLFRNP7KNuJnqd/HmVwAvzkNHsBjJhNteio4hNVYESPvoOU4lm68BPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7jTame540xXhmUXLGjpLJ2U2WJVEC+Be6FCzU8+leps=;
	b=wnZNQN96Pbe4KNlPFwHLc9cp/p7BbKTW3uECLWiKXJi04Yqb2f27sAdBpzZTV2zwNU6Y
	 meAGwviNuX5D+qg9Fi4XZ8D0A324/ZW+MJ+LnbimVwDsS0uB37u7RI6iwz9oUymyz3x5G
	 vE1TSYLin1iCC1vq+wMjPnuCXS2ewkZ/6AEg1ISlR0hhM7sQfvMyHE1DLt7qlk36NiEzL
	 z1OfkE5nJkCMXc/D6PgtT9QhpWq0DXO/JmtxLtG5ysofTkkiSY96swS4iB+xfDeuOG0EG
	 /K8vQTmMlnK+LSwUZxO/ugB68w1pLwVG4oKOnOdZRWkdyH+9POUcs/i8Vhwp2p51xRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Unlj0FoC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00E3606A31C;
	Thu, 19 Nov 2026 01:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Unlj0FoC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A871F000C5;
	Thu, 19 Nov 2026 01:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052610;
	bh=7jTame540xXhmUXLGjpLJ2U2WJVEC+Be6FCzU8+leps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Unlj0FoCLVMD14KyGql+3o01tAD26+Wx1TzLvuKokBHszE3huHrvvbP2cFJ78BiH3
	 uZ8rVH2pf9zoo/jhX0jnX6VPEa3vDJ0UUbM3JE19GUTkFOnLjByOpJUFNAT2C5uRkC
	 oFFEDvg0ju6tGTY1NmHrX5kxh4DI9E1/DLXaynkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0623/2214] fbdev: xen-fbfront: check for fb_deferred_io_init() error
Date: Wed, 18 Nov 2026 15:38:19 +0100
Message-ID: <20261118150036.304948973@linuxfoundation.org>
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
index 37e3f226f78ce..83505ff49c361 100644
--- a/drivers/video/fbdev/xen-fbfront.c
+++ b/drivers/video/fbdev/xen-fbfront.c
@@ -464,7 +464,11 @@ static int xenfb_probe(struct xenbus_device *dev,
 	}
 
 	fb_info->fbdefio = &xenfb_defio;
-	fb_deferred_io_init(fb_info);
+	ret = fb_deferred_io_init(fb_info);
+	if (ret < 0) {
+		xenbus_dev_fatal(dev, ret, "fb_deferred_io_init");
+		goto error_cmap;
+	}
 
 	xenfb_init_shared_page(info, fb_info);
 
@@ -486,6 +490,7 @@ static int xenfb_probe(struct xenbus_device *dev,
 
 error_fb:
 	fb_deferred_io_cleanup(fb_info);
+error_cmap:
 	fb_dealloc_cmap(&fb_info->cmap);
 	framebuffer_release(fb_info);
 error_nomem:
-- 
2.53.0



