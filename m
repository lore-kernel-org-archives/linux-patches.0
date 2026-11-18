Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024005;
	b=nAEpPDhRXGzuK2z3rQaX1dNW/iSup838J7ygF0tPc2KXa3aO3UcxzdmDqfh4BpO/qkF9
	 MBIDrkSlIA9E+iP0rp+JoE6hJei3Z2WqrJbFtGbX7yz44U/cz3rnonQ54HsDZqjBR92Cg
	 yuALQFofCvafSDhaIySqouBSS0edKjhVBZk5V0+qxRNYufWifqrQiA1oOgfxXmBBWruGT
	 udGVd0xMacKm/xNnxgYkzTsooMVjultO67xVEf9zLSi6PjDZlo2fc1dT/2ERw0Dqftogj
	 wC/R7aIbNmHAqLeVnvMv78XAJ/ajzKi6oqCsoDYsZMsVX8kIbRmFpVSzsCtfqGwoUyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024005;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wy5ay0edasK9zO4xIF1ZDO4MgCOri41aXe6/eVmXeHU=;
	b=Hymp1EHx+zGbOIihx/o8Z97Q41JCGSGKG9DDqxRQx+LFPnU1uzcRC/2bsbOkYXx7CZ/B
	 3cvCIw3/+B+DvukoA2wMtMllyOXf93Ia8pPZlxesQ7L31xxV4geikbejiJAfAhHZpEiOb
	 7lBS3hovr134fSBq5/0a9nROoCw/0JtDycoKmnzNn+u/UHIXuDLQi0/7Cxot3zihArGQD
	 4JsIL/55urkMMO787c5eH9sIuCvOjmng89TkYhst0aUstTJQrYs9ZOewedYN2WbtR/yL/
	 dSq9aqgDcQdNei22BM73IagKtmCx5/DcTMFoaV4QlQ8xnNfIm4zp7874gBs96dgvuHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sX6BUb5D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71479606A32F;
	Wed, 18 Nov 2026 17:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sX6BUb5D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DE91F000C5;
	Wed, 18 Nov 2026 17:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024005;
	bh=Wy5ay0edasK9zO4xIF1ZDO4MgCOri41aXe6/eVmXeHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sX6BUb5Dlsb1v7cxIgpVDV9WnY2iPDIeHmk8Pn2r1zJ1/gQ2xdngHW9fYKgtYp0Di
	 4D74h9cN6DqPBGA1xhVjTNUX7fNO5qgRfjIWkgCahL+9NMKlqsgmoeqxEsO4lAdjyh
	 zrJBPS7rmRchDCozPhTIUuZ2/MU8Pif1pQCPT2kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Lance Yang <lance.yang@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0572/2151] mm/gup: honour FOLL_PIN in NOMMU __get_user_pages_locked()
Date: Wed, 18 Nov 2026 15:38:27 +0100
Message-ID: <20261118150142.788237811@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit da01399b90a73cd00b502f7903fa5acbfac4a103 ]

The !CONFIG_MMU implementation of __get_user_pages_locked() takes a bare
get_page() reference for each page regardless of foll_flags:
	if (pages[i])
		get_page(pages[i]);

This is reached from pin_user_pages*() with FOLL_PIN set.
unpin_user_page() is shared between MMU and NOMMU configurations and
unconditionally calls gup_put_folio(..., FOLL_PIN), which subtracts
GUP_PIN_COUNTING_BIAS (1024) from the folio refcount.

This means that pin adds 1, and then unpin will subtract 1024.

If a user maps a page (refcount 1), registers it 1023 times as an
io_uring fixed buffer (1023 pin_user_pages calls -> refcount 1024), then
unregisters: the first unpin_user_page subtracts 1024, refcount hits 0,
the page is freed and returned to the buddy allocator.  The remaining
1022 unpins write into whatever was reallocated, and the user's VMA
still maps the freed page (NOMMU has no MMU to invalidate it).
Reallocating the page for an io_uring pbuf_ring then lets userspace
corrupt the new owner's data through the stale mapping.

Use try_grab_folio() which adds GUP_PIN_COUNTING_BIAS for FOLL_PIN and 1
for FOLL_GET, mirroring the CONFIG_MMU path so pin and unpin are
symmetric. Keep supporting the traditional behavior where users specify
a pages array but don't set FOLL_GET.

While at it, don't return NULL pointers in the page array,
as this is really not expected for GUP users; instead, just fail and return
-EFAULT.

[ david: support traditional behavior with no FOLL_GET, extend
  description ]

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>
Reported-by: Anthropic
Fixes: 3faa52c03f44 ("mm/gup: track FOLL_PIN pages")
Assisted-by: gkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Link: https://patch.msgid.link/20260921-nommu_gup_pin-v4-1-c410041cc479@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index c345bca01e3af..f74fe4b17d017 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1987,6 +1987,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 	struct vm_area_struct *vma;
 	bool must_unlock = false;
 	vm_flags_t vm_flags;
+	int ret, err = -EFAULT;
 	long i;
 
 	if (!nr_pages)
@@ -2003,6 +2004,10 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 		*locked = 1;
 	}
 
+	/* See the MMU variant: support the traditional behavior. */
+	if (pages && !(foll_flags & FOLL_PIN))
+		foll_flags |= FOLL_GET;
+
 	/* calculate required read or write permissions.
 	 * If FOLL_FORCE is set, we only require the "MAY" flags.
 	 */
@@ -2023,8 +2028,14 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 
 		if (pages) {
 			pages[i] = virt_to_page((void *)start);
-			if (pages[i])
-				get_page(pages[i]);
+			if (!pages[i])
+				break;
+			ret = try_grab_folio(page_folio(pages[i]), 1, foll_flags);
+			if (unlikely(ret)) {
+				pages[i] = NULL;
+				err = ret;
+				break;
+			}
 		}
 
 		start = (start + PAGE_SIZE) & PAGE_MASK;
@@ -2035,7 +2046,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 		*locked = 0;
 	}
 
-	return i ? : -EFAULT;
+	return i ? : err;
 }
 #endif /* !CONFIG_MMU */
 
-- 
2.53.0



