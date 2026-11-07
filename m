Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063171;
	b=M8U16lSZKDmMjD6qIO7inep+OYHY4MhIf2CEbj4N5qDHU0A8VXfMNLeSqGv7pF4z6BhH
	 34ZABNgp3AtWVTE1k1PK2lLdV2m+uFSiA31uJG1dYThxLwu6103rL/48Vd53hPNz8/CKH
	 EJzmVCI1SLY3yT1wojZBq/Ay8CF11iSvtPfwGsq1SnUisMqgDRA9rrymZfOjBhVXH4NAu
	 m6ohUGbPfARnKIX4ozmK2a2pNqjWtuh78/mAJoD6SV+ZpF3OLiUxG7ErhI+hPC3fyWbG8
	 KKVKvLHMxOInsOAdhiJ9y5CtuKMk+j5WWBKDah/rTZRbsY1fXt25cEQOpkGBejj//sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oCA3SdLuBBKZCvF0y/BOTPyZHPgkHM7oDXOTP4WfITg=;
	b=1n/wwB9qwx/wj4xLBMk5nsX5y6ddQdXZ2eyzyAfbaG5dzwAsSJbBzOmEVvNgjPP21qX1
	 kID0G2TV8WGqHOK8OAxAr2NMf93IKj6sjLeeYnHQovdwYALby+TKvtVr3gTfwxQPKicUH
	 VtvA81vv/zJwJMq6HcAPL3LFVLECgS1pFvJGWgP0EZfZFYDQ5/MeHwXaKkmCVWgzIrjSP
	 NJzwbfSLwTDSLB2huoHW/q+ZcPYQKKi4UijDLDWyGFwpbCivWz8EHlm3Q1BXNR+e3BF6B
	 vDs2tmMQHijGD9IRam/DHJ4OOJInxPeYyJP/M86a53wsQ+G0eDZ7RdQhVe3pq59DG9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MhQ7dcXf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D56C606D802;
	Sat,  7 Nov 2026 14:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MhQ7dcXf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68F61F0089F;
	Sat,  7 Nov 2026 14:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063171;
	bh=oCA3SdLuBBKZCvF0y/BOTPyZHPgkHM7oDXOTP4WfITg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MhQ7dcXf9qRjkeWDShYreAXTD7lt4FPA/kVm1mBvWmy5iRFmWmCOrQCYROkXd4doj
	 ZcSQqi76gJjiowWEsyW36rPzxcgzkI4nvXVmKNIH3TUvIXXqoVPkRjsJRphg2N6OoK
	 eSh+Bgw4olJG2Oo47ZJrjF2Vn98scZG2VJXtDeiQ=
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
Subject: [PATCH 6.18 389/869] USB: gadgetfs: do not WARN about excessively large memory allocations
Date: Sat,  7 Nov 2026 08:51:11 -0500
Message-ID: <20261107134906.630134561@linuxfoundation.org>
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
index 677cd236f079c..c14e8e250037d 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -615,7 +615,7 @@ ep_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		return -EBADMSG;
 	}
 
-	buf = kmalloc(len, GFP_KERNEL);
+	buf = kmalloc(len, GFP_KERNEL | __GFP_NOWARN);
 	if (unlikely(!buf)) {
 		mutex_unlock(&epdata->lock);
 		return -ENOMEM;
@@ -677,7 +677,7 @@ ep_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		return -EBADMSG;
 	}
 
-	buf = kmalloc(len, GFP_KERNEL);
+	buf = kmalloc(len, GFP_KERNEL | __GFP_NOWARN);
 	if (unlikely(!buf)) {
 		mutex_unlock(&epdata->lock);
 		return -ENOMEM;
-- 
2.53.0



