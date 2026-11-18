Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043941;
	b=b3d6bwBnIpEnvDtq7vk12UVissCTB4+Mou7/nBN1Qgy8LN9u4FehuG53NnJwiZRnQTY8
	 i1OnHYpBFAOd6vQAsV32RE7wDNptBdYwYQ0kWPHJgEagR3vDEQgGC8US0UduHvHK/B3oq
	 x89+GpA4/6ZNGMeyjhVck2/5dFVPwWZdtrVpSrFd8+QK9FybFmkEODENvWYskz+di+zTZ
	 XRkBId/kBqfpu62HMgFj4JL8yS6WG3zhlJAtBr+yrE4NWn1tHmPVnz6ab3sSxWcfuxH7r
	 v1WdQ7Hi4s0EY6GhR8DT1+jNHcbwaVtrOokk2yR09c67h0oV3c9Rue0Anh874MwbRuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ucDB60i7r65KmoffLidfV0+Z4LHqKDWQRUegZOdGjJc=;
	b=41DQ1L7JRWM2ocAbhasvb3JZr0qLs3+0BGODx7nkMCvkOfrafXpNLmLBc+B4obhGjd8d
	 7w4UVy3GnRR45wXp7rIvZCBDPhirLzpicU13A2ILQNQnIj02XjN2eCLqNMbCfvIJswCZ8
	 biheo2cuNgcY/JGL0IwUj35IRqxwox9V+TZHOs0Mz2gM8+as++qljeHKpTAzyt1DeUJhn
	 nFkMuGuY8O8AYvF1HX6eDxRwKN3sw7ESPo1UQH7ifpk9tCotG7jogB8YyI1OXqn0XpHpJ
	 0Y+xUOIZuQBn0E3lhSciP2M+d+G8IUSP5JIi7nu2NN5NNX87LEI2soJyvEv5B4KlGOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cEKhge0Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3468606A32C;
	Wed, 18 Nov 2026 23:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cEKhge0Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291A91F000C4;
	Wed, 18 Nov 2026 23:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043941;
	bh=ucDB60i7r65KmoffLidfV0+Z4LHqKDWQRUegZOdGjJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cEKhge0Qwx8wWZu2tWYu/WqP6pHaMQ1oOEqimeL5rTMm2zDUFcL6kX3kRTsAZy0sj
	 eXNzsoxKGn91HOLLpCxBrzr7P46Kly8fIVj4QBU3Tj4+G1UUqZchuxraEQcSU8T3nH
	 gkGEfM5jmA5cMoMMZucINA0SDlUA5/empl63+2Cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhei Takeshita <jyohuku.alterego@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0390/2857] IB/hfi1: Resolve the credit-return buffer through the send contexts node
Date: Wed, 18 Nov 2026 15:23:44 +0100
Message-ID: <20261118150215.442767342@linuxfoundation.org>
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

From: Shuhei Takeshita <jyohuku.alterego@gmail.com>

[ Upstream commit 975396b9e5a4028e649f4b9a6a5ca5dfb76a824b ]

hfi1_file_mmap()'s PIO_CRED case derives this context's credit-return
page offset, and the DMA handle for it, from dd->cr_base[uctxt->numa_id].
uctxt->numa_id is the node of whichever CPU the process happened to be
running on, but the entry itself lives in the credit-return allocation of
the send context's own node:

	sc->hw_free = &sc->dd->cr_base[sc->node].va[gc].cr[index];

and user send contexts are allocated with sc_alloc(dd, SC_USER, ...,
dd->node), the HFI-local node.  On a multi-socket host with the process
running off that node the two allocations differ, so the subtraction
produces an offset into an unrelated buffer and the DMA handle belongs to
the wrong allocation.

Use the send context's own node for all three references.  The
continuation lines are reindented at the same time; they mixed spaces and
tabs.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Cc: stable@vger.kernel.org
Signed-off-by: Shuhei Takeshita <jyohuku.alterego@gmail.com>
Link: https://patch.msgid.link/20260809032743.2671579-2-jyohuku.alterego@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index e03b0207856e7..1bc59d71c1d0b 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -384,10 +384,10 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		 * of enabled contexts > 64 and 128 respectively).
 		 */
 		cr_page_offset = ((u64)uctxt->sc->hw_free -
-			  	     (u64)dd->cr_base[uctxt->numa_id].va) &
-				   PAGE_MASK;
-		memvirt = dd->cr_base[uctxt->numa_id].va + cr_page_offset;
-		memdma = dd->cr_base[uctxt->numa_id].dma + cr_page_offset;
+				  (u64)dd->cr_base[uctxt->sc->node].va) &
+				 PAGE_MASK;
+		memvirt = dd->cr_base[uctxt->sc->node].va + cr_page_offset;
+		memdma = dd->cr_base[uctxt->sc->node].dma + cr_page_offset;
 		memlen = PAGE_SIZE;
 		flags &= ~VM_MAYWRITE;
 		flags |= VM_DONTCOPY | VM_DONTEXPAND;
-- 
2.53.0



