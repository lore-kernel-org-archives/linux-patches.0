Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058417;
	b=CgyKXWTboYofQJesX1fmgkmj3yMlJ1mLkTiMKYBi9Ihb0l5ANHrmVILem/B2xznGs8YG
	 LKal6h357rbJwu8MZbjTzWIBZlep1wy1d2GD+T05z4rh9bgZVA+Ya5fWteTUgmSh1ploW
	 73Q+KRQk27u6hHROHdplbEBdZFbn8i1xMUnCJsI5OfUzCU5xBnPw8KtZyaWD4AHnM+mnA
	 U/JMSfDgehtzFf4gUI7c61AyBwuUyamULni9+TwZuw5Vu9eAF340lIXJM04WqcZOwCrkz
	 CyrBMGCPwjzNyIfmDMNmHVRslsHXsSSbgnuYTvIuQ9+3D+GrM9pLrYh+OpYGZNBvS4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VzB8Yeraj2ZZMh2PEUizdiZJwRGmXsZ1k7JdWxvrbP0=;
	b=Ti9zpcLAwxAcI+caVvMatLvN5P2fKAk3pedOVXvhBlOdGjAk7E9TVQ9oUflSoRiJVIGj
	 b65yxDP/JphNNEqRbK5KY9BVL6qtQtGLsAEwcQJqE3Q3W7mjTK0Bj+BsKf6hapAtylj15
	 kJL7llv1zyOn9jtYk0T+XkNf0y/JepwGKqbNIPxi+Yrv2uLWqhy/eiAZA2+KVe2WHWUpC
	 r3FbgzFPmnM8VWRZkvg1z4XEkK3tsSncWWIO047WDRTRHB65DdK5QcpiHoLdB4Q+ezzLP
	 v6pAiM8wKqVorRSCbDwVMoWxdDz0AT/CKae0dscpa2/W+Jcsa4n3Pyl7BuoSRERODeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sh3hy1PI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7450606A32C;
	Thu, 19 Nov 2026 03:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sh3hy1PI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1759A1F000C4;
	Thu, 19 Nov 2026 03:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058417;
	bh=VzB8Yeraj2ZZMh2PEUizdiZJwRGmXsZ1k7JdWxvrbP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sh3hy1PIjBaCjwunjgNUpMzK0Un9H/P8NqYu253UDsLjnCkGUX2b4tIUMVQNDLjTb
	 6tulbgH/XtlizqqB0nnZIq0ejkdDHXUvnWgm+057bYuFK0766UZ18K3NsBs/xPBo0j
	 fvZ23V+oCOcJ4cLC4rBEVYOcnWGIUITK19ujdRno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	syzbot+805630f1453e490427fa@syzkaller.appspotmail.com,
	Alan Stern <stern@rowland.harvard.edu>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0477/1848] USB: gadgetfs: do not WARN about excessively large memory allocations
Date: Wed, 18 Nov 2026 15:41:55 +0100
Message-ID: <20261118145934.230527546@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zi Yan <ziy@nvidia.com>

[ Upstream commit a156148976eac47bee7210097afbb609cafe88b6 ]

GadgetFS passes an excessively large user input len to kmalloc and kmalloc
gives a WARN (see below for details).  Suppress it by passing __GFP_NOWARN
to kmalloc used by both ep_write_iter() and ep_read_iter().  Follow the
same method as commit 4f2629ea67e72 ("USB: usbfs: Don't WARN about
excessively large memory allocations").

kmalloc is used to allocate physically contiguous memory for kernel
allocations.  For requests larger than KMALLOC_MAX_CACHE_SIZE, kmalloc
uses the page allocator and can only support up to KMALLOC_MAX_SIZE.  For
request sizes bigger than KMALLOC_MAX_SIZE, the page allocator can emit a
WARN because kmalloc allocates an order greater than MAX_PAGE_ORDER.

Link: https://lore.kernel.org/DKTTMAS94IMH.2C6ERY0ZIVWVZ@nvidia.com
Fixes: b3c466ce5129 ("page allocator: do not sanity check order in the fast path")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com/
Tested-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/legacy/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index f1dfb3c129858..0fa1549bb5f65 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -610,7 +610,7 @@ ep_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		return -EBADMSG;
 	}
 
-	buf = kmalloc(len, GFP_KERNEL);
+	buf = kmalloc(len, GFP_KERNEL | __GFP_NOWARN);
 	if (unlikely(!buf)) {
 		mutex_unlock(&epdata->lock);
 		return -ENOMEM;
@@ -672,7 +672,7 @@ ep_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		return -EBADMSG;
 	}
 
-	buf = kmalloc(len, GFP_KERNEL);
+	buf = kmalloc(len, GFP_KERNEL | __GFP_NOWARN);
 	if (unlikely(!buf)) {
 		mutex_unlock(&epdata->lock);
 		return -ENOMEM;
-- 
2.53.0



