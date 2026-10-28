Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214110;
	b=0T3uAJVsG7C5WLBxPOo7rK+zgXSoIwY4dKbgFQsv930ZdXiAOCReWOV4PsoEdR1/FcQ6
	 7PZsDFa7KDqHil3uk3IUY/Csn4wlOTMqKZD7kn+qkC3H5UBKfYpupv4RrRIk7TqpZXHKl
	 jVGmQL22Jm3Jq3HvTuGRc/zY8fAk7EiIsx99pLI6HTikmWRj+9R760h1QlajEIsSOid8W
	 +SYbdIIZ1pfajvUEFuB+VF7NyfUmMpxVOgX2ywKbWi1gjhYl3d2sgUM+cTo4nwE02NLZi
	 enwMlAdEuU1LfxoDUectd7chBIfz6e/ok1lek9O6+gCU4M0E61WPWugs0IEQz73d7nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0qdqWyH0sxQADEvK5uiGcFIjWOIejQXchNqUtt6vg6c=;
	b=31faNjIGTs9Wi3GsT549gFAm223aXDnqI2U7TI5SS8nIZvB0q3tTqZgdNOIwR+Sxj7Xj
	 GD4GBkFblM8FKCIemF3ab7XFEJm2um2BWOqaDDJmgvkSnF/Ja0bmBAKE00/kbquLlMSoc
	 NGg1dzXOj8XrBkHeOpeY7QT3cSFqKXv4RS9K0QZAM66y+YmY+XxwYIg/tlEoAG47lWDNS
	 7HF9g7720HCy3kp7mP2vkeZqjNzIBqeIw1hFGcYS2kMtfiIWKQSkjPw51miYD0g1G+nYD
	 tOZZWaqR1TNzURlJvAB3yKkrEtniNqBwFt6N63IfxkLCRlAxcOsksByVUpRPh5DktwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cCH8bKR6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A596606A31C;
	Wed, 28 Oct 2026 19:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cCH8bKR6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C971F01825;
	Wed, 28 Oct 2026 19:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214110;
	bh=0qdqWyH0sxQADEvK5uiGcFIjWOIejQXchNqUtt6vg6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cCH8bKR6MmYE6WERnyJVWAN2AsOmk6voHWItg1CUqC/pPyJV17ZBLLuENpeqb+9ds
	 oTI5NMi5hveCrhC6LfaaR49PZPbu56VosylIRNTagaGXgFQiy3I8+67zgCPuLMJgIU
	 YBl3+3yZ0uN9fI44FbwM0ylhexNKV/RFlMDhDSkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0743/1887] RDMA/bnxt_re: Fix the page details for the srq created by kernel consumers
Date: Wed, 28 Oct 2026 17:47:19 +0100
Message-ID: <20261028170516.354818554@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Kashyap Desai <kashyap.desai@broadcom.com>

[ Upstream commit b66535356a4834a234f99e16a97eb51f2c6c5a7d ]

While using nvme target with use_srq on, below kernel panic is noticed.

[  549.698111] bnxt_en 0000:41:00.0 enp65s0np0: FEC autoneg off encoding: Clause 91 RS(544,514)
[  566.393619] Oops: divide error: 0000 [#1] PREEMPT SMP NOPTI
..
[  566.393799]  <TASK>
[  566.393807]  ? __die_body+0x1a/0x60
[  566.393823]  ? die+0x38/0x60
[  566.393835]  ? do_trap+0xe4/0x110
[  566.393847]  ? bnxt_qplib_alloc_init_hwq+0x1d4/0x580 [bnxt_re]
[  566.393867]  ? bnxt_qplib_alloc_init_hwq+0x1d4/0x580 [bnxt_re]
[  566.393881]  ? do_error_trap+0x7c/0x120
[  566.393890]  ? bnxt_qplib_alloc_init_hwq+0x1d4/0x580 [bnxt_re]
[  566.393911]  ? exc_divide_error+0x34/0x50
[  566.393923]  ? bnxt_qplib_alloc_init_hwq+0x1d4/0x580 [bnxt_re]
[  566.393939]  ? asm_exc_divide_error+0x16/0x20
[  566.393966]  ? bnxt_qplib_alloc_init_hwq+0x1d4/0x580 [bnxt_re]
[  566.393997]  bnxt_qplib_create_srq+0xc9/0x340 [bnxt_re]
[  566.394040]  bnxt_re_create_srq+0x335/0x3b0 [bnxt_re]
[  566.394057]  ? srso_return_thunk+0x5/0x5f
[  566.394068]  ? __init_swait_queue_head+0x4a/0x60
[  566.394090]  ib_create_srq_user+0xa7/0x150 [ib_core]
[  566.394147]  nvmet_rdma_queue_connect+0x7d0/0xbe0 [nvmet_rdma]
[  566.394174]  ? lock_release+0x22c/0x3f0
[  566.394187]  ? srso_return_thunk+0x5/0x5f

Page size and shift info is set only for the user space SRQs.
Set page size and page shift for kernel space SRQs also.

Fixes: 0c4dcd602817 ("RDMA/bnxt_re: Refactor hardware queue memory allocation")
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/1740237621-29291-1-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 63fae7263c89c..9db0d824d4627 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1659,6 +1659,8 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 	srq->qplib_srq.threshold = srq_init_attr->attr.srq_limit;
 	srq->srq_limit = srq_init_attr->attr.srq_limit;
 	srq->qplib_srq.eventq_hw_ring_id = rdev->nq[0].ring_id;
+	srq->qplib_srq.sg_info.pgsize = PAGE_SIZE;
+	srq->qplib_srq.sg_info.pgshft = PAGE_SHIFT;
 	nq = &rdev->nq[0];
 
 	if (udata) {
-- 
2.53.0



