Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024626;
	b=YLzroYLwKQ5wzh1Zik0/hlpNQsukXbL7aTkdnSwYZ6mfWZir5yTCvp/4N/ysUsn4kXfp
	 vIHIrdeCW17v/HY28jKbkT9CJ7OHKksDD4Hz2UmvSOZuQgXg44CsMaXIgRllpUw9rzkQx
	 AxlpJg8PpHnuqbkCu9XL90vjjTPIz6R6E5nx7ibDcfRbPis4wnLheKV+iKY6HmDyK0hYQ
	 rCWxx9U9/7/lMgQrpoaKhHs+Yo08oE87/brfc/I0P17VE+i9JwS9+HPSx10ujk+jb/GgM
	 VMZDVZ2cO58bByuSeeF1hPh/kkojs0EO+xa5iLf5jkO+3NrIjOTzEf7ronESnrZniFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=rXZia+jsgsr8ib/7YQuQ0xAwY2D3410jFPi94hceE6Y=;
	b=2HjDN97VP/Ps/zfGwo8bYWSNoU6Y4eJUwHjabBi/p5uPX6D3ukT+jn/5mk+M7DnEaLnX
	 /uC7IwU9GWS1vpnLBM1+WQawibef+a/GeQmj5P1z+EAySizj336r31WOqfDjKC7ranKoT
	 YCp0KIAgg7Hu+BwDZXAJNU4Dp2sl28HeSYHyZbWY0TCcVpsvwFjMecormdeqPG6XOyVm5
	 kylOtMmEvaz/COnzveywki4CzK4TCnbFNGfYHQKtO6Jn9/aULTgp8gEtOz/gygY1YesNu
	 UsLtv8J5OFIEd14NKzx8P2KNBUpshTA9QckcH2ZdCk01RrMfsoPjv7J3TVtnFmS2j6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OgBhKWq+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B7E606A31C;
	Wed, 18 Nov 2026 17:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OgBhKWq+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8654C1F000C5;
	Wed, 18 Nov 2026 17:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024626;
	bh=rXZia+jsgsr8ib/7YQuQ0xAwY2D3410jFPi94hceE6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OgBhKWq+vJN8JyEDXgLnypeqD/h9bEQ0tcaHhNY+57bWZ75ZxNRTxGAUaGiP2uIRO
	 AE2qsrWT2AMuDUXKC07LkA/mI9nLgEd1U3o9ANpS4/Ul5bB45RVkDQUpBU4v8xBBPM
	 GANF6PY2OxnVbsGl7ujt0QEkAlrSIeTXDSLI/VYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanghui Feng <guanghuifeng@linux.alibaba.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0793/2151] iommu/vt-d: Fix IQE handling to cover all descriptors in submission range
Date: Wed, 18 Nov 2026 15:42:08 +0100
Message-ID: <20261118150150.983183593@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanghui Feng <guanghuifeng@linux.alibaba.com>

[ Upstream commit 754d07b940c4ce025fab022b548fb5c3d11bf766 ]

When an Invalidation Queue Error (IQE) occurs, hardware halts fetching
and IQH points at the faulting descriptor. The previous code only
checked whether IQH matched the first descriptor index of the current
submission, missing faults on any other descriptor within the batch.

Expand the check to cover the entire submission range [index, wait_index],
accounting for circular wrap-around.

Furthermore, after detecting IQE, the old recovery only replaced the
single faulting slot with a copy of the wait descriptor and immediately
returned -EINVAL. This left two problems:

  a) Hardware resumed fetching and could hit another invalid descriptor
     in the same abandoned batch, raising a second IQE that no submitter
     would claim — permanently deadlocking the queue.

  b) The caller reclaimed all batch slots (QI_FREE) while hardware might
     still be asynchronously processing descriptors from that batch,
     allowing concurrent overwrite and descriptor corruption.

Fix both by introducing qi_drain_remaining_descs(): upon IQE detection,
overwrite the stranded slots in [IQH, wait_index) with fenced no-op wait
descriptors, resubmit the wait descriptor at wait_index, clear IQE, and
spin until hardware signals QI_DONE (with DMAR_OPERATION_TIMEOUT). This
guarantees hardware has fully drained the batch before the caller
reclaims slots.

Fixes: 8a1d82462540 ("iommu/vt-d: Multiple descriptors per qi_submit_sync()")
Signed-off-by: Guanghui Feng <guanghuifeng@linux.alibaba.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/dmar.c | 72 ++++++++++++++++++++++++++++++++------
 1 file changed, 61 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index 2a99df386560e..7376cf6502afe 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1280,6 +1280,49 @@ static void qi_dump_fault(struct intel_iommu *iommu, u32 fault)
 	       (unsigned long long)desc->qw1);
 }
 
+static int qi_drain_remaining_descs(struct intel_iommu *iommu, int head,
+				    int wait_index)
+{
+	struct q_inval *qi = iommu->qi;
+	int shift = qi_shift(iommu);
+	struct qi_desc wait_desc = {};
+	struct qi_desc nop_desc = {};
+	cycles_t start;
+
+	nop_desc.qw0 = QI_IWD_FENCE | QI_IWD_TYPE;
+
+	wait_desc.qw0 = QI_IWD_STATUS_DATA(QI_DONE) | QI_IWD_PRQ_DRAIN |
+			QI_IWD_STATUS_WRITE | QI_IWD_FENCE | QI_IWD_TYPE;
+	wait_desc.qw1 = virt_to_phys(&qi->desc_status[wait_index]);
+
+	while (head != wait_index) {
+		memcpy(qi->desc + (head << shift), &nop_desc, 1 << shift);
+		head = (head + 1) % QI_LENGTH;
+	}
+
+	WRITE_ONCE(qi->desc_status[wait_index], QI_IN_USE);
+	memcpy(qi->desc + (wait_index << shift), &wait_desc, 1 << shift);
+
+	/*
+	 * Order the descriptor rewrites before the writel() that restarts
+	 * the fetch engine.
+	 */
+	wmb();
+
+	writel(DMA_FSTS_IQE, iommu->reg + DMAR_FSTS_REG);
+
+	start = get_cycles();
+	while (READ_ONCE(qi->desc_status[wait_index]) != QI_DONE) {
+		if (DMAR_OPERATION_TIMEOUT < (get_cycles() - start)) {
+			pr_err("Timeout draining invalidation queue after IQE\n");
+			return -ETIMEDOUT;
+		}
+		cpu_relax();
+	}
+
+	return 0;
+}
+
 static int qi_check_fault(struct intel_iommu *iommu, int index, int wait_index)
 {
 	u32 fault;
@@ -1302,18 +1345,25 @@ static int qi_check_fault(struct intel_iommu *iommu, int index, int wait_index)
 	 * is cleared.
 	 */
 	if (fault & DMA_FSTS_IQE) {
+		int head_idx, ret;
+
 		head = readl(iommu->reg + DMAR_IQH_REG);
-		if ((head >> shift) == index) {
-			struct qi_desc *desc = qi->desc + head;
-
-			/*
-			 * desc->qw2 and desc->qw3 are either reserved or
-			 * used by software as private data. We won't print
-			 * out these two qw's for security consideration.
-			 */
-			memcpy(desc, qi->desc + (wait_index << shift),
-			       1 << shift);
-			writel(DMA_FSTS_IQE, iommu->reg + DMAR_FSTS_REG);
+		head_idx = (head >> shift) % QI_LENGTH;
+
+		/*
+		 * The faulting descriptor can be anywhere within the current
+		 * submission's range [index, wait_index]. Since the queue is
+		 * circular, this submission may wrap around QI_LENGTH
+		 * (index > wait_index in that case), so check both the
+		 * non-wrapped and wrapped cases of the range.
+		 */
+		if (index <= wait_index ?
+		    (head_idx >= index && head_idx <= wait_index) :
+		    (head_idx >= index || head_idx <= wait_index)) {
+			ret = qi_drain_remaining_descs(iommu, head_idx, wait_index);
+			if (ret)
+				return ret;
+
 			pr_info("Invalidation Queue Error (IQE) cleared\n");
 			return -EINVAL;
 		}
-- 
2.53.0



