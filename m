Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036334;
	b=KFgkQApf3q0WzJsJN7wbCvlWxfQftGE5ROdLwxotbYwSIns1woK2P8EMmtYJeOvUG/6v
	 sG5Da6QKGzUQXN45CtaAx6JP822nBMr6CESU+lXYbQuDw1iDE2l+OYccywkmZVal9YU98
	 w9HnVrQIyInPozpGYV4m2Cu/hmw05BTO4G3xEF1in2b4DnYoEsOjpWIiCzevpWw+ubUCk
	 RjG5TlNpUyY+LOFwO44hztGBznu9HnaIkdgUGLYarPMR3bZ8870jJPnj9SbBLpasW6Qgl
	 lWBe3dlhimIYQFhtGM6O4qGl3Fm5F3AMeRqKAWv3abUwheHup/ABJucWQ4g+W35P44Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036334;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vmo2DWqGGbaMAdzbz9Srg1daAYIITtd+hEdSK4fy430=;
	b=Q389b1M14eor/TnTfoN5j/FTTtJwlHk0VXrG5HH/2lI8UqvBdqheI/+PwXmJJYjK3KE7
	 dK+gJ4Fvt3E++EgyrlEl9eljAnW4u8oWtQYxbnzBGwot4lnwy1f8Ndl1VkQjnF5+vb71i
	 vYADwhJaxD3JmRXVXz3N4BaOmQhzwR4l7XPYjpYC+bv4eiEWmRzaac42bEFc8ywLrQNJr
	 PrfoKBQsu+1NKDgUK5Z+Ha8HlmsmS+v6cLG2Z6tyyCu+avCw3bYno4wFUPB5n77OUrAMf
	 WL1yiurrb672zGyocRLAtfjE6xf7/ZCWzdCVrj9j+K7+BisIGXSdONdG6hHUwoApBbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sjZDh5Yc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAFF606A31C;
	Wed, 18 Nov 2026 21:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sjZDh5Yc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795C41F000C6;
	Wed, 18 Nov 2026 21:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036334;
	bh=vmo2DWqGGbaMAdzbz9Srg1daAYIITtd+hEdSK4fy430=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sjZDh5YcdYWhtr/Dmdkvp0YRo6ViiOxcvVSRn2KmnIxkNDDXh2nfawU7r9md3TYb8
	 4LB8RymquqJZqWiudEPUT3Y2/DDBnpy46U1EeMf9uOET85Gyx2iJvFTbDYUEUe8/UE
	 VuzTW0IQykJ/NqVSAk2ywVv5eOhhJAIAAfFiTwYI=
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
Subject: [PATCH 6.6 1023/3318] USB: gadgetfs: do not WARN about excessively large memory allocations
Date: Wed, 18 Nov 2026 15:27:25 +0100
Message-ID: <20261118150350.573138024@linuxfoundation.org>
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
index 5bb767b0f3398..5d1f612f3dfa5 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -608,7 +608,7 @@ ep_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		return -EBADMSG;
 	}
 
-	buf = kmalloc(len, GFP_KERNEL);
+	buf = kmalloc(len, GFP_KERNEL | __GFP_NOWARN);
 	if (unlikely(!buf)) {
 		mutex_unlock(&epdata->lock);
 		return -ENOMEM;
@@ -670,7 +670,7 @@ ep_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		return -EBADMSG;
 	}
 
-	buf = kmalloc(len, GFP_KERNEL);
+	buf = kmalloc(len, GFP_KERNEL | __GFP_NOWARN);
 	if (unlikely(!buf)) {
 		mutex_unlock(&epdata->lock);
 		return -ENOMEM;
-- 
2.53.0



