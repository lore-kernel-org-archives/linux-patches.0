Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062323;
	b=jsas0FfJ509AVmvZQlgwtrAYOd9XcsKdIDY5uOWw0yXFExE1S2PoDQ1wsZeIFoatPq/8
	 WCyGwzJgb8K9VxQ/43VrZLFe6o/NBsj4LiVXNxMUrJcIQnpQq1ocBR4jp9vhfc/SGoE6l
	 aAPmAEhWpfGb3BU2vfJd+a0uC+uNegpRVJLytVkZgAiRSRVQA1gAt8pVC8kMEBtu/fY5K
	 dof0wkx0O1QuHmQGUJ4Z6df+vsEmXdze8nrdV7aKlgebi1QvbjCLIyWlRngmDXUbSaWAb
	 Dg7abIz5+UhZACukZpt8bH+pDyq+iJaaJMr5+iSoE29s6agGxYG1PZECRUZEcBZn28A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062323;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wBP2lNPaxUb3tKdbkrRvahjudeMtRdq01Nx/IHOMnMA=;
	b=2N7BNGTJ4xtqdfkSPYsX36QamW5GjWmAwN0vgvEpr29SyJUORsTME9gL9jGrxLXCILbC
	 2iPKvl4TSUFMHf9dmHKh2BPrQ3fF5zBoP99Sf7/6L5pDBy9QovRM2ST2irpKsbNM/RQjL
	 Zq/anw8OWWHxRfQkMsmo7/9PH0AF4OhasJCz1YJNmUjtRIrO8DX391dd6bMq7ntVhPkNl
	 JeTd1H5njwDGmNZ+JtLJY0YHWDA3DCtWrcH9DxOK/mUBRGBkdoQQ1b4cpnnoFh5edawLh
	 Yx2X42QLO3+yHbbYkbheMM75tu8Seag8Z1uZ31HUWILOsJNdaslb3Hmvh4QKmMn8pAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kzt6Nrkx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF997606A666;
	Sat,  7 Nov 2026 14:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kzt6Nrkx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0A01F0089F;
	Sat,  7 Nov 2026 14:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062322;
	bh=wBP2lNPaxUb3tKdbkrRvahjudeMtRdq01Nx/IHOMnMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kzt6NrkxLF8WLXNXoMwcniJ/iQP3gZULHqnJevsQgtlVLIwtIs3cAdxsXokrCF/l/
	 IHN2+sKncQPRx9KapeBd0vXINnJ9Lf0Lt0frv+w5JT1EOaxlGNt58YoHTKERjc/TLx
	 WlAhwcde8he9K87pKueA30YZY9MuM0EVb6nAdk0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1255/1536] fbdev: xen-fbfront: check for fb_deferred_io_init() error
Date: Sat,  7 Nov 2026 08:54:31 -0500
Message-ID: <20261107135033.022523966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c90f48ebb15e3..3b1ff45cac783 100644
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



