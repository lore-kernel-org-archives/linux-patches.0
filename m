Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052491;
	b=kx6lR0FjtX171luKMs+2wnpLJ8CjnCq/L4hw7VLQSvKjv+a/lf38zO7NPmlMUhkbH+0+
	 PmF2XU+1R2AvKYqp15Uq/8j1VkuJ+DyP48xFrFGmmjgqWh/aJnsGTkQjMJEk6oYorpQkh
	 FxVsuQ7WsP9F2lrurP0/uzWfF4MmqRvMHGKqImYlGrD2u8zoO+1DUmn5DsKDmJL9+lFw4
	 z1hIJmaTt2KgKwU7ri6842Ff8I7FPIF04kKh21aowVJuNxIUdjgiuGtXv/G+Znjr/DqI0
	 Re2VTydXrMdbU1C5jP6IM3XBsf5G/p4SQVaihzbTUxjGClNPNK4gV51ghjc0l8ujUIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052491;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZjthpqyS4349KrnQ1o0iT2KaS2KlOxLeiAkZWtUvKXI=;
	b=ABohizx2cxzsop4K3neJDMRGdPtJyRzEURPg0gs/UDCrbnoB1O1YEafN7L4kAr6R2xW3
	 DbOtMRjSlGnlHL0ozokOrtDoRoiTbPv4X2yT2Vba6JuFRqL5tJ4m4aeXuwg3E4K2c2aUw
	 CP1CgrRP6r2/6amPdKRFGqao6KAHrKIcqHOblgAz6UcQR7BSGPNojJMEgY0b6MqUU6qzM
	 SF+fEEguNGt+MevjbRPaHfWlaLUD8xMrJDtlwyXRFoZFDNqr2I1kz6jgjGa6MNOFWvdei
	 mvX3kZt5+2kfsr/oXDEL4w4UMeQTUM4hx6fpn/wt06MsYKmspthkZRC04TZaRu8NcZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jHQQlOAQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F97606A325;
	Thu, 19 Nov 2026 01:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jHQQlOAQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27ADE1F000C4;
	Thu, 19 Nov 2026 01:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052491;
	bh=ZjthpqyS4349KrnQ1o0iT2KaS2KlOxLeiAkZWtUvKXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jHQQlOAQC2iqyCi0n188XL0VlQLAbkDYn/C4GbYYiq71O8NBz4LK95Ee24lhdOY42
	 0pqCzFKjQpihmrmWr3Bdw+LYXZV3poDlAMdwiUEnR66x72VEbnFBJIyaOrOKx6e0Zm
	 tSC/B8FjHvBbXzKkgXF7JPxOBL+3Ba8xsKo0B4LM=
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
Subject: [PATCH 5.15 0584/2214] USB: gadgetfs: do not WARN about excessively large memory allocations
Date: Wed, 18 Nov 2026 15:37:40 +0100
Message-ID: <20261118150034.282174289@linuxfoundation.org>
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
index 896a3a075b674..437718a4a0f29 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -611,7 +611,7 @@ ep_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		return -EBADMSG;
 	}
 
-	buf = kmalloc(len, GFP_KERNEL);
+	buf = kmalloc(len, GFP_KERNEL | __GFP_NOWARN);
 	if (unlikely(!buf)) {
 		mutex_unlock(&epdata->lock);
 		return -ENOMEM;
@@ -673,7 +673,7 @@ ep_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		return -EBADMSG;
 	}
 
-	buf = kmalloc(len, GFP_KERNEL);
+	buf = kmalloc(len, GFP_KERNEL | __GFP_NOWARN);
 	if (unlikely(!buf)) {
 		mutex_unlock(&epdata->lock);
 		return -ENOMEM;
-- 
2.53.0



