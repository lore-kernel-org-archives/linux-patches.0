Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064596;
	b=evGngeYp2gO51xSwhzjfjmmzh9icdC+dMO2VTkyJmYIFxlUvK1sGPX5CX6LyFhvtk8gZ
	 hZ0E6RewEStI98PAK0yDV+57wa/OZrDHblT/3dgpK1y3xFPW+b9NOFKkZAPcbfssHXxt0
	 pShd+kIPD34qC0idRcdNMhtfqQIG9wS0qIS9+cQ7mnB7N7IvT6unDO1YliHhAG35SuC+d
	 kWwb0blQDuW+rblONXBSv2E1mbbWgvnQuU9XNr/HNC9H4e5zlMYr7ov5XchGz1S6EWoP3
	 uO/AZgtejq9Y4GK9Idr2ifai7lh/ozne3QBiX4HYyJY0iPGO8AGzWHVUVV2iV1g1R2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064596;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rasA7DsuYGl0+YlBwSliFkHxBckW17wJnIR0hKSUb7Y=;
	b=pYzkhsi0URZdtTiw3zsnMi1ArEUZFkBiNcGN+3WBlJ50G5CtXv9MTyD3oex0gYiixGJH
	 t8VxhAM7UyHtfRNC00vTSXZiSKucjkGg8zwB0vvyqHyqa40HP1MN5TyKzsOdIlReGgdH9
	 O7RyP4IIQQ1tR/GsywyQnwbl/g6W7RNemqgT3voC3HcVQ52jnfRDl0KBTfz5hjNhs+Ki0
	 STd8VuqVSxlFboDhfYnHQr19T8m0d1ql0yCTNzicN6j/CRDnxlxKha4PG/ryNit6eISVL
	 ZQSsGiMe0nLPZUD+1YKPjYHeQd08p+l20SLcpFMbSmGLzsNw163ETCV8uapOiYPQfxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="v//T/t0Y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10F4606A9CD;
	Sat,  7 Nov 2026 15:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v//T/t0Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224031F0089F;
	Sat,  7 Nov 2026 15:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064595;
	bh=rasA7DsuYGl0+YlBwSliFkHxBckW17wJnIR0hKSUb7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v//T/t0Y9sWUvLn5+99p54d2jYNuHDltWFc4ui5vDA6aB9e1JevEnJUwQnhDlqvSs
	 b985qdYQ/at5s28i/PxERrfj0wUvgYyI9lv0x3pQPinK472W8mDvoLu/upkdNdD82a
	 TudMhgQG/QUOrEC2xfDHKKBIO9d07JRNPn/v3LCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	Xiaofeng Yuan <yuanxiaofeng@eswincomputing.com>,
	Nutty Liu <nutty.liu@hotmail.com>,
	Troy Mitchell <troy.mitchell@linux.spacemit.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0610/1257] RISC-V: KVM: Fix IPI delivery for out-of-order vcpu_id
Date: Sat,  7 Nov 2026 08:48:26 -0500
Message-ID: <20261107134956.155337700@linuxfoundation.org>
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

From: Xiaofeng Yuan <yuanxiaofeng@eswincomputing.com>

[ Upstream commit c367d3bf721f2bc391d6cfb47f6884e99d563df0 ]

The SBI IPI handler walks vCPUs with kvm_for_each_vcpu(), which
iterates by vcpu_idx (creation order) rather than vcpu_id order.
Since vcpu_id can be assigned out of order by userspace, a vCPU whose
hart_bit falls outside the XLEN-bit hart_mask range may be reached
before vCPUs the mask actually targets. In that case the handler jumps
to "done" and stops sending IPIs, leaving valid target vCPUs without
an interrupt.

Replace the early "goto done" with "continue" so vCPUs outside the
hart_mask range are skipped without aborting the loop.

Reproduced with a minimal userspace VMM driving KVM inside a QEMU
(RISC-V virt) guest: three vCPUs are created with ids 100, 0, 1 (in
creation order) and sbi_send_ipi(hart_mask=bit0, hbase=0) is called
from vcpu_id 1. Before this change the IPI is dropped and the ecall
returns SBI_ERR_INVALID_PARAM; with this change the IPI is delivered
and the ecall returns SBI_SUCCESS.

Fixes: 0611f78f83c9 ("riscv: KVM: Fix SBI IPI error generation")
Cc: stable@vger.kernel.org
Suggested-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Xiaofeng Yuan <yuanxiaofeng@eswincomputing.com>
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>
Reviewed-by: Troy Mitchell <troy.mitchell@linux.spacemit.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20260917122012.2577-1-yuanxiaofeng@eswincomputing.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_sbi_replace.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index 506a510b6bff3..c2f1f7f264423 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -64,8 +64,17 @@ static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			if (tmp->vcpu_id < hbase)
 				continue;
 			hart_bit = tmp->vcpu_id - hbase;
+			/*
+			 * kvm_for_each_vcpu() walks kvm->vcpus[] by
+			 * vcpu_idx, i.e. the creation order, which has
+			 * nothing to do with the vcpu_id (hart id) space
+			 * that the SBI IPI operates on. vcpu_ids need not
+			 * increase along the iteration, so harts outside
+			 * the hart_mask window must be skipped instead of
+			 * aborting the loop.
+			 */
 			if (hart_bit >= __riscv_xlen)
-				goto done;
+				continue;
 			if (!(hmask & (1UL << hart_bit)))
 				continue;
 		}
@@ -76,7 +85,6 @@ static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		kvm_riscv_vcpu_pmu_incr_fw(tmp, SBI_PMU_FW_IPI_RCVD);
 	}
 
-done:
 	if (hbase != -1UL && (hmask ^ sentmask))
 		retdata->err_val = SBI_ERR_INVALID_PARAM;
 
-- 
2.53.0



