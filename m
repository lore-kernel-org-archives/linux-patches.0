Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024977;
	b=rg5KcjghU/eeaD3SYkeTGaFSCU9UKBw2klj5OlFFmIHI8vZ7mk6t/BTiftcFCBj2nMYC
	 RNeZba8tMx35WO3hjmWKUyvLzZyWwbfdkUAgZSgeci69PyNH0QHjdd2W2Oa8KZaitdF7q
	 fTRJeVv1HUKSWhKuKGzx5j76R6iXnSSDJn+O0WIbYojLrQ2l85f0uOj+ACaCAElXSUFfq
	 YtZfDPY+0EC0FIPY6GuV71ji4EkP655/ldgnyHAmm9EMQZL9XHm1PIAYnOjZcTgnRLPbP
	 fC+e4nibbmEMzXqBHvTKxIea21qPGgfa2AhT0FH79COO1tygzK4HX1Ev+uJfSF1Do6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X51uaylUDV9TYUOjCmB/+MQysRjm7Y2OG7tmi7AgmuU=;
	b=wnHMumNI/PJ8/SBmdTLcyea/E9/rUBVh+j827rzW+pF3rkmsV1D130hGe0auoEh8By0K
	 7JrGO+LFRA/UyH/TENkG/2JBBH1JxP6H0bUXgByE5+6YrvSXVcgNPmjnpyErmC6bZ+pZN
	 HHOMV9zH/9wtMaX5stmiuZpZ0hTWdsL0TXvdNdRBF7fWw+o0hLqi5xfSZHEbe5CIjIxQb
	 PaRO4LaOA0dyqjtZy3CHTU1B7JAa+tB2ofobJSbdj+A9RoPp30AMYB/i9/LVV48p0rAbv
	 y5Zv4EyH0fii43QAmcEIpk7AILmBIrlRxjrhW4KFWa3YE7sq2lizwEEWVdL1CBBPVpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vnlKvxKD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873E8606A31C;
	Wed, 18 Nov 2026 18:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vnlKvxKD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D805E1F000C4;
	Wed, 18 Nov 2026 18:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024977;
	bh=X51uaylUDV9TYUOjCmB/+MQysRjm7Y2OG7tmi7AgmuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vnlKvxKDaH1n30BIS1KbUS+CXuOcCsHeuKKed8YlcN1/08WiGDr8uaXlwGjzRQfiI
	 /yhCVCMwsIE7B6yBDxDLFLROl7AD443iScy6AbK5K/aPqCJF0ju/8eQzEksUNNZBV7
	 zK94LtL5dtI2EiWOPH9UGFPSzDLrvJGupgR3IMfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yili Zhang <zhangyili01@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0875/2151] RDMA/nldev: Fix NULL deref in dumps of objects abandoned by DRIVER_FAILURE
Date: Wed, 18 Nov 2026 15:43:30 +0100
Message-ID: <20261118150154.068721476@linuxfoundation.org>
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

From: Yili Zhang <zhangyili01@baidu.com>

[ Upstream commit 9f4c322be27bf617cad2f4a15f6c6024a69e220c ]

fill_res_cq_entry() dereferences cq->uobject->uevent.uobject.context->res.id
unconditionally for user resources.

This is normally safe by ordering: destroy_hw() removes the resource
from the restrack before uverbs_destroy_uobject() clears ->context,
and the XA_ZERO_ENTRY marker set by rdma_restrack_begin_del() hides
the entry from concurrent netlink dumps.

The ordering breaks when a driver keeps failing to destroy an object
during ucontext teardown. uverbs_destroy_ufile_hw() then falls back to
__uverbs_cleanup_ufile(RDMA_REMOVE_DRIVER_FAILURE), which
abandons the object in place: the HW object and its restrack entry
are intentionally leaked, while the uobject bookkeeping is torn down
and ->context is explicitly set to NULL by uverbs_destroy_uobject().
rdma_restrack_del() is never reached, so the orphaned entry stays in
the device restrack with a valid kref, reachable by any subsequent
netlink dump.

Observed on 6.1.52 with MLNX_OFED 24.10, after an mlx5 FW failure
left a process unable to tear down its CQ (destroy_cq FW command
failing during FD close):

  WARNING: ... uverbs_destroy_ufile_hw+0xe3/0x100
  BUG: kernel NULL pointer dereference, address: 0000000000000058
  RIP: 0010:fill_res_cq_entry+0x15e/0x180 [ib_core]
   res_get_common_dumpit+0x304/0x530 [ib_core]
   nldev_res_get_cq_dumpit+0x1a/0x20 [ib_core]

The faulting chain maps to the source (CR2 = 0x58):
  cq->uobject            (struct ib_cq +0x08, res at +0x98)
  uobject->context       (struct ib_uobject +0x10, NULL after abandon)
  context->res.id        (struct ib_ucontext +0x58)

The recent restrack rework (8d186210677c and its series) moved the
restrack deletion to the start of the destroy flow and thus fences
concurrent dumps from an object being destroyed, but it does not
cover this case: when destroy fails, rdma_restrack_abort_del()
restores the entry, and the RDMA_REMOVE_DRIVER_FAILURE sweep still
never removes it from the restrack.

>From the fallback until the device is unregistered, any "rdma res
show cq" deterministically takes the NULL pointer dereference; this
is a long-lived state, NOT A RACE. The dump path holds neither the
restrack lock (dropped before the fill callback runs) nor
ufile->hw_destroy_rwsem, and rdma_restrack_get() only guarantees
that the res memory stays alive, not that ->context is still valid.

Fix the dump side: check the uobject context directly instead of the
rdma_is_kernel_res() marker. A non-NULL uobject already implies a
user resource, so kernel resources keep being skipped, and the
additional ->context check skips the RES_CTXN attribute for
orphaned entries instead of crashing the dump. The orphaned resource
itself remains visible in "rdma res show" (cqn/cqe/usecnt/pid),
which is what an operator needs after the accompanying uverbs WARN
to diagnose the driver destroy failure.

fill_res_pd_entry() has the same pattern (pd->uobject->context->res.id)
and is fixed the same way; a PD can even reach the fallback without
its own driver callback failing, e.g. uverbs_free_pd() returns -EBUSY
while another object that failed to destroy still holds the PD usecnt.

Fixes: c3d02788b45a ("RDMA/nldev: Provide parent IDs for PD, MR and QP objects")
Signed-off-by: Yili Zhang <zhangyili01@baidu.com>
Link: https://patch.msgid.link/20260923131239.6521-1-zhangyili01@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/nldev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index c92c24e681f11..b3b1d5c9f6f60 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -652,7 +652,8 @@ static int fill_res_cq_entry(struct sk_buff *msg, bool has_cap_net_admin,
 
 	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_CQN, res->id))
 		return -EMSGSIZE;
-	if (!rdma_is_kernel_res(res) &&
+
+	if (cq->uobject && cq->uobject->uevent.uobject.context &&
 	    nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_CTXN,
 			cq->uobject->uevent.uobject.context->res.id))
 		return -EMSGSIZE;
@@ -742,7 +743,7 @@ static int fill_res_pd_entry(struct sk_buff *msg, bool has_cap_net_admin,
 	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_PDN, res->id))
 		goto err;
 
-	if (!rdma_is_kernel_res(res) &&
+	if (pd->uobject && pd->uobject->context &&
 	    nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_CTXN,
 			pd->uobject->context->res.id))
 		goto err;
-- 
2.53.0



