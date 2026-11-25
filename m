Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619313;
	b=Ewhylx/KEYfXNzCSyNYkfkVTBIt/RhGwPSKdU0Uf3koBtdXdIDLkKxIO4AxKVAp2T9uM
	 RXiwp5PUKIm7xgBY3gJGm0WwnW9hbJJkt4UkQNbe2syx0y+QKJfburSYZxdpRRPGX+M6x
	 yOtJwGo0I//vua9nmC/+2IE2jouHsSYrcFrw1XaA85ExbCIVWFARpjSgFTN3n0Xju+GnQ
	 2/WselAcCKwnNCPnWMrZLW+Z2xxJR4SUOeU1jdN1p4nDCa7lH9Qm0G83a/c9OYv97GV8H
	 qc1eIpLeWaptUVGY86FCCZS7zGAHsXWdojxqJ8pAcF1kBGPN7V93oN4TdOP/QBS0UqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619313;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gzGJ8U+AXKJ9kX9KOmpezh4a9dUaXQoBrAYPFVfoiMc=;
	b=ogwqKOaiSiMYKIL7eLdSJV274ONUo8XRjIKppQkJemvusRGYF2ltMuA9GURIM+Bwu/x2
	 yKeZA8p0HuLr1tzRLWrWMBh1pooSjkYGnJXxNO1ORELYkS/9b6aw1lTAwqihwNmAvQBAf
	 4L0VNLGA8UA88XaFXFp2HhlyfZiS1Ns9/FkbYkUkRBGWpffq0anF1XadjgsVw3HqYONTx
	 6ThddT1Yygw3tXXpyPj4EgJzhNWDqWhLoI1Qut41KDU2HvWnw69zeaZBoACWKa1iWhL2A
	 +8try4IVN4jCQxFpcXa8FIuRCafp6TocfqKPmjsIdOdnji/qx6/lkXZneyDhAdKcZGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dy2s07kT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E5B606A327;
	Wed, 25 Nov 2026 15:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dy2s07kT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CEC1F000C4;
	Wed, 25 Nov 2026 15:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619313;
	bh=gzGJ8U+AXKJ9kX9KOmpezh4a9dUaXQoBrAYPFVfoiMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dy2s07kTgHj1JWXzVlyQFyT0jNNzQa076MocsL3C37xixKUm4N5MAv8hUqyoHvYHy
	 jtM12wQ0NAQq2AT+XFJeMlz+p6DzxGcO/hx/KJxv1ZxgpyezTW3TrVbMUDRS5wwqak
	 BD5dGWtGRxpYX72z2VqM1LbXngqNi0XnJv8MIPkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0558/1005] Xen/gnttab: improve error handling in gnttab_dma_{alloc,free}_pages()
Date: Wed, 25 Nov 2026 15:31:36 +0100
Message-ID: <20261125143834.821464730@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Jan Beulich <jbeulich@suse.com>

[ Upstream commit 2b66f2cc753243a6adb3e9a5c038b0fc59ba7ec9 ]

Both decrease-reservation and populate-physmap can succeed partially. For
the former this may be pretty unlikely, but clearly the latter can hit
both out-of-memory conditions in the hypervisor or denial because of the
allocation exceeding the domain's allowance (there's no interaction with
the balloon driver here either).

In gnttab_dma_free_pages() we simply can't give back to the system what
hasn't been re-filled with backing memory. For gnttab_dma_alloc_pages()
both parts of the overall region need dealing with differently.

While no present caller of gnttab_dma_free_pages() checks its return
value, also don't use -EFAULT there: It really is an out-of-memory
condition. (In gnttab_dma_alloc_pages() -EFAULT doesn't look quite right
either, but I couldn't think of a clearly better error code there.)

Fixes: 9bdc7304f536 ("xen/grant-table: Allow allocating buffers suitable for DMA")
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20261110095605.369848-3-jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/grant-table.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 11c2ef1cc86eb..2a28884a84b78 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -1097,6 +1097,24 @@ int gnttab_dma_alloc_pages(struct gnttab_dma_alloc_args *args)
 	ret = xenmem_reservation_decrease(args->nr_pages, args->frames);
 	if (ret != args->nr_pages) {
 		pr_debug("Failed to decrease reservation for DMA buffer\n");
+		if (ret >= 0) {
+			/* Free the part where decrease didn't work. */
+			size_t done = ret << PAGE_SHIFT;
+
+			if (args->coherent)
+				dma_free_coherent(args->dev, size - done,
+						  args->vaddr + done,
+						  args->dev_bus_addr + done);
+			else
+				dma_free_wc(args->dev, size - done,
+					    args->vaddr + done,
+					    args->dev_bus_addr + done);
+
+			if (!ret) /* Nothing else to do? */
+				return -EFAULT;
+
+			args->nr_pages = ret;
+		}
 		ret = -EFAULT;
 		goto fail;
 	}
@@ -1130,7 +1148,12 @@ int gnttab_dma_free_pages(struct gnttab_dma_alloc_args *args)
 	ret = xenmem_reservation_increase(args->nr_pages, args->frames);
 	if (ret != args->nr_pages) {
 		pr_debug("Failed to increase reservation for DMA buffer\n");
-		ret = -EFAULT;
+		/* Can only free what has been re-filled. */
+		if (!ret)
+			return -ENOMEM;
+		if (ret > 0)
+			args->nr_pages = ret;
+		ret = -ENOMEM;
 	} else {
 		ret = 0;
 	}
-- 
2.53.0



