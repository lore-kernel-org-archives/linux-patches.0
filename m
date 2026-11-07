Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064487;
	b=ly2u9oUXDAELyWJRmMiqq70t68fDsWPrPnis/R5Iwh4GkqVnWCF64ihwvLn2gEgRUD9c
	 vWQjmaQeRGE+PFE8txSp9Mctnwdf0E+hRBSR0JRACHajzc1gmvCdD2yr/2Pfsc7jZ9qkv
	 DG57N18IAYJofSHSgTYvTY+mkSVDnjPSC6ZJMH1aSvzcc6VMu/UnoygJ7UNDcK7cfoyga
	 dlZPSlkm7QI0w4Z7cex60mMCTpDUxKm1sSnDoHuJTZdpwFDZKJCCI7QJjy952FEgDVCc4
	 LdxKNZ8dv1xNsLSxOmiYHva/yvSdd6j/zh+v26bocl7UN0f8UxkBuv/uVaftwRsnFHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064487;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BwQpG2Hcb8EfCi9QDtafX/IeisbFnQAmr26k8o9cy+s=;
	b=iqaxkeIb8csJbDN9lxQRy/RMljZ+bq1Ku3Pa4OoHjcmesVRifv9/nHayem42vVdOyrQL
	 Ux3L95G/y91E8VNgubxfiPAAd0VX6zDs57p1Uay7P6M10QEdriCxgL3Gk0yewDZNMlwbD
	 7TxQuszxA2BO9sECxioYsGGkuuRJfUqFtQWqhWoFNlMKZ0RUPkcvAkf9RzOUIFwdKgoXG
	 N9KFQKwaDBOUwJ22/8KjvB6EH+pTOKYP+rVKlIB+/2Ml/+56W3pcPMkN+sD7vE2jf2saq
	 mbM3aViI2AFGqZrXHO9jWOJCyaZnJrEQzAnTElr4kUxoZfgtGwoMJE1q+X5Se0DTIfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eHojYmN9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CCB606A9EE;
	Sat,  7 Nov 2026 15:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eHojYmN9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1F91F0089F;
	Sat,  7 Nov 2026 15:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064486;
	bh=BwQpG2Hcb8EfCi9QDtafX/IeisbFnQAmr26k8o9cy+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eHojYmN9sKErBvx1Ky/AiIvjNqeJBc17lkT4OIDcMjrdlzLHkpUx4TJzmQKb/3esC
	 ITLAOaPn3A46bjjICh4DG8rhmTHUMUiSKb4r+A/aFtSVmWAoRm4AFwE9ZfLnm58Dve
	 GMdwGeYb5qW8zMx7yPPF2luU7t7ssS1WqRyeoAaI=
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
Subject: [PATCH 7.3 0523/1257] USB: gadgetfs: do not WARN about excessively large memory allocations
Date: Sat,  7 Nov 2026 08:46:59 -0500
Message-ID: <20261107134953.868347937@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ce61348d9f2b7..d15a48bdd7596 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -613,7 +613,7 @@ ep_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		return -EBADMSG;
 	}
 
-	buf = kmalloc(len, GFP_KERNEL);
+	buf = kmalloc(len, GFP_KERNEL | __GFP_NOWARN);
 	if (unlikely(!buf)) {
 		mutex_unlock(&epdata->lock);
 		return -ENOMEM;
@@ -675,7 +675,7 @@ ep_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		return -EBADMSG;
 	}
 
-	buf = kmalloc(len, GFP_KERNEL);
+	buf = kmalloc(len, GFP_KERNEL | __GFP_NOWARN);
 	if (unlikely(!buf)) {
 		mutex_unlock(&epdata->lock);
 		return -ENOMEM;
-- 
2.53.0



