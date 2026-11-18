Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045345;
	b=Kdv8SrNIscbsP5kSv3nknT5s9B3y8evQqfMt1skL/mtaoycJjAqO9r66KpfSCnkpsnmv
	 GIxxIiuogM4ge0wRc52kIgitAPtsgI8Tw2dv1te9PK6FQsIBhtzCw3n+jjHx9iyTrPmxY
	 Mjkoss5ax7G/UE9vwiOR4pV7VErDN3UGMgZCDQ93GWgRbCln2ThRINXkuiM1/pA1UVTAs
	 KEHMwSLhi/sUPATQXMpAsaduPKYpKnbbGkz7OMmy5kx2wRsPp6GaqTansBJxOuDrwS+ss
	 wgXzsye54gg/yJlxiBx9dL//xZfgXLCDxeJzLkEQD8gAwfxEgRkqYpbH3b9QZf2arHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jbbgO0YQg30jJYUDdfg05nBLC15QE/OyaR8TOVMPtDM=;
	b=XIk13GGmq77DiZRtSGzWXgTC9/lwZBty0Mc1H63mLHAPosot9KWFw5Undjlp3Zsz/9v5
	 hx/NNrT58zVcUZ16wy8vXecytFIb1y+eWS4rrlLVmn80XBFdCUWrQr/IXR6xnwybFoRXE
	 ow3OirGMED/TPe1kdLYBaYTXBsAiPe72OQ6cMS3i+h62rEQgAI23zx1Dry3kOdHkFxcVZ
	 C1f6X+zJ8RjBuNr6R3TA419hfBQilvcB27f2erb9cIQzcVwz9K/2iNSsXRZOOnh0RVSJt
	 8PQLEHTxrU4W1JwIPdUJSgYxpe9a1ia6fsCNy7xS9fs9ljeeKP94GW2oq9l2xIC9BSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1dZDA1FY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AB6606A31C;
	Wed, 18 Nov 2026 23:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1dZDA1FY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D201F000C6;
	Wed, 18 Nov 2026 23:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045344;
	bh=jbbgO0YQg30jJYUDdfg05nBLC15QE/OyaR8TOVMPtDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1dZDA1FYnthkW5R4VeNBRBSmyYbPiGIKOQUXrkqxZDIUd+gN9uZWgsvrWXntEjH6D
	 mEpVs+iB0Qwft7fYJY+uUGYAEsTN/XFo4WUkOKXy/z4lUCRk+umsfQZrz8Dtqj7uwW
	 MznYXJGwM3JAlWcIlsMlrsfyoz9xuWhZ9HMezKTw=
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
Subject: [PATCH 6.1 0887/2857] USB: gadgetfs: do not WARN about excessively large memory allocations
Date: Wed, 18 Nov 2026 15:32:01 +0100
Message-ID: <20261118150233.493843922@linuxfoundation.org>
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
index e3101131dddaa..b20a0ce91dd0e 100644
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



