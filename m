Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020464;
	b=Hr/zDaKQR4PqyH/dRh5ZJA1cymYOlQvwfAJKPiRpPLocN/+UB1EQTB7Gj2QLLP2nXNFX
	 7mt+FIyZY31nOg6sql+xpA9oEjs9r944YQ+Ge1dNE7hH6qlaqEk2dR6WTj895g9LUhYXY
	 ZUslOW/FQFMUD5HKem+NJCE7q7mKE6APnG8/CctUncTl1JXCu4Lj0+EHVw37jXgp0e2rc
	 IN1qd3MtoKYYYZeCSNmzUq/0IJ4FxudmhcIB4NxXmnq6iJUq99fVF0VSFVV4s4pN3Kddu
	 cipKF+0moFycgY3J1YHDmdzzA0fuvDA75RsetgsdK6kgYdwQgLHw6sYcxbdSOTyVVCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sWxlpdLBqC0qUtYdvDlpaKn6x0lG/gPyucEtcm75IvA=;
	b=1wzSPaKyJpOa7ficFPS9EmrTgWJ5fVBKqm2H5ovQ2yrx5PpZLtLr+zVwN2ua0No7kU8/
	 3dRXjsqH7JX1ukE+DCkTWKAYvzACYRm4uQB18ZtH6UmJebevk7M33tezoUO7f7LkHWu8s
	 ClrYxOUlSjt8zdhS5nNANuprIMMHZuv8znj/70NoNe3QJYbF3zkeP7xt9kPixsEByUzIj
	 Hg8feTe+dawd6iJ9TdNWYFfR/Lfwm4NdSzxYHbEKl81jQsB19j9xrqtfnU+2HnOKf0fXC
	 IuT9dOo/rVJ6kfU+Ns941hOJJJxZnLbosZNWPrFl9iIPKGk6cAJhgtiU0Plw31+b8hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vLV+SCFw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE80606A338;
	Wed, 18 Nov 2026 16:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vLV+SCFw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949331F000C4;
	Wed, 18 Nov 2026 16:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020464;
	bh=sWxlpdLBqC0qUtYdvDlpaKn6x0lG/gPyucEtcm75IvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vLV+SCFwSGJhMFHv43Ly+fyLtdkMOMboG9CpY0AGLJUd5X6U0qYY3EyK/yJgaKrEO
	 M09fpI1U4r4P/5wGV2zuY7bMGMZjHJKQ9eBXURdC/DkmymUMIYddrh2CFL+ZZphK+q
	 HOC/uieGWAErmk+Mb+pOcNJCHYnL985bc0O4SQ4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngsung Ahn <ays511.kr@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1960/2651] RDMA/rxe: bound the ODP page index against the umem in rxe_check_pagefault()
Date: Wed, 18 Nov 2026 15:53:20 +0100
Message-ID: <20261118150357.092437207@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Youngsung Ahn <ays511.kr@gmail.com>

[ Upstream commit 7797bbb0e86f0062fe58480a0116c86e4ec0d0d1 ]

An ODP MR has a page array, map.pfn_list[]. Its size is computed from
the umem start address. But rxe_check_pagefault() builds the index into
that array from an iova that is relative to the same start, while the
access itself was range-checked against the MR's iova (ibmr.iova).

Those two bases do not have to match. reg_mr only requires that start
and hca_va have the same page offset, so a user can register an MR with
hca_va = start + N*PAGE. The difference then becomes an index skew of
(hca_va - start) >> PAGE_SHIFT. Nothing compares the result with the
size of pfn_list[], so the read goes past the end of the array.

An unprivileged local user can reach this with a single RDMA operation
on a self-connected rxe QP. KASAN reports a slab-out-of-bounds read. If
the out-of-bounds qword happens to look like a writable HMM pfn, rxe
then copies the payload into a page the user never registered.

Reject an index that falls outside the umem and take the fault path
instead. That path rejects the out-of-range access in
ib_umem_odp_map_dma_and_lock(), which does check the umem range. The
other users of pfn_list[], __rxe_odp_mr_copy() and the atomic helpers,
run only after a successful map, so this single check covers them too.

Fixes: 2fae67ab63db ("RDMA/rxe: Add support for Send/Recv/Write/Read with ODP")
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
Link: https://patch.msgid.link/20261004153246.2951263-1-ays511.kr@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_odp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
index c375d3efd9992..9d27244f89bca 100644
--- a/drivers/infiniband/sw/rxe/rxe_odp.c
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -136,6 +136,11 @@ static inline bool rxe_check_pagefault(struct ib_umem_odp *umem_odp, u64 iova,
 	while (addr < iova + length) {
 		idx = (addr - ib_umem_start(umem_odp)) >> umem_odp->page_shift;
 
+		if (idx >= ib_umem_odp_num_pages(umem_odp)) {
+			need_fault = true;
+			break;
+		}
+
 		if ((umem_odp->map.pfn_list[idx] & access) != access) {
 			need_fault = true;
 			break;
-- 
2.53.0



