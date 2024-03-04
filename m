Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B689A7BB1F;
	Mon,  4 Mar 2024 21:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587787; cv=none; b=ZKoELe3El2MW7enLnENIu2j+YjRuA+SUP6HMS3q1kzGPnBVz9Ail+n5d/0mB+voU8/yV4nk8cCEn1f/z2TpTulYPjrCSqXoPfTS0ovuqrNj0ivuFvgzGbFZnlN2rcIO3CLTrOA0BDCPJNIuo+6yDWFcTblleBR1l3gHbFOBdzi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587787; c=relaxed/simple;
	bh=eqfBtNGa7QUrmAbzodf1hXdxqlaC+4PYcxrR8wBiE5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puCM0+PUEveP3crMSqbHvX0IR9OuZzS+7EyYl9I6ZK6sKNo7itQHDwr9cpyd7F2YGxg9ahvvWvKLzVyNJ2LisnO2QoX/jVR/6cyRwFhUqfJR3D6CAs8j/5P3OqoLwNNYFXeCWW/3NiJ1vPq6n9/fR5Dh7WY8wSv8bKhoPeUpUcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0U+Bg93S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0U+Bg93S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8F8C433C7;
	Mon,  4 Mar 2024 21:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587787;
	bh=eqfBtNGa7QUrmAbzodf1hXdxqlaC+4PYcxrR8wBiE5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0U+Bg93SXQywm2PLrv978y2ZoWkRq643cpJE0Dk9B1oWe3TohcSxUHiG42R9LxXcQ
	 V/IXwvkYBZHlj1zqDMbd5ubqkNMRXWngWU7XwxsY8vqyX4hcEtcu9KEYE8B1D1V/u0
	 mlE7qKWAtk2NPsH+w2TTIMRWWQ2Vp8wKaW9f3MwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Shakirov <vadim.shakirov@syntacore.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Atish Patra <atishp@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 066/162] drivers: perf: ctr_get_width function for legacy is not defined
Date: Mon,  4 Mar 2024 21:22:11 +0000
Message-ID: <20240304211553.964289519@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vadim Shakirov <vadim.shakirov@syntacore.com>

[ Upstream commit 682dc133f83e0194796e6ea72eb642df1c03dfbe ]

With parameters CONFIG_RISCV_PMU_LEGACY=y and CONFIG_RISCV_PMU_SBI=n
linux kernel crashes when you try perf record:

$ perf record ls
[ 46.749286] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[ 46.750199] Oops [#1]
[ 46.750342] Modules linked in:
[ 46.750608] CPU: 0 PID: 107 Comm: perf-exec Not tainted 6.6.0 #2
[ 46.750906] Hardware name: riscv-virtio,qemu (DT)
[ 46.751184] epc : 0x0
[ 46.751430] ra : arch_perf_update_userpage+0x54/0x13e
[ 46.751680] epc : 0000000000000000 ra : ffffffff8072ee52 sp : ff2000000022b8f0
[ 46.751958] gp : ffffffff81505988 tp : ff6000000290d400 t0 : ff2000000022b9c0
[ 46.752229] t1 : 0000000000000001 t2 : 0000000000000003 s0 : ff2000000022b930
[ 46.752451] s1 : ff600000028fb000 a0 : 0000000000000000 a1 : ff600000028fb000
[ 46.752673] a2 : 0000000ae2751268 a3 : 00000000004fb708 a4 : 0000000000000004
[ 46.752895] a5 : 0000000000000000 a6 : 000000000017ffe3 a7 : 00000000000000d2
[ 46.753117] s2 : ff600000028fb000 s3 : 0000000ae2751268 s4 : 0000000000000000
[ 46.753338] s5 : ffffffff8153e290 s6 : ff600000863b9000 s7 : ff60000002961078
[ 46.753562] s8 : ff60000002961048 s9 : ff60000002961058 s10: 0000000000000001
[ 46.753783] s11: 0000000000000018 t3 : ffffffffffffffff t4 : ffffffffffffffff
[ 46.754005] t5 : ff6000000292270c t6 : ff2000000022bb30
[ 46.754179] status: 0000000200000100 badaddr: 0000000000000000 cause: 000000000000000c
[ 46.754653] Code: Unable to access instruction at 0xffffffffffffffec.
[ 46.754939] ---[ end trace 0000000000000000 ]---
[ 46.755131] note: perf-exec[107] exited with irqs disabled
[ 46.755546] note: perf-exec[107] exited with preempt_count 4

This happens because in the legacy case the ctr_get_width function was not
defined, but it is used in arch_perf_update_userpage.

Also remove extra check in riscv_pmu_ctr_get_width_mask

Signed-off-by: Vadim Shakirov <vadim.shakirov@syntacore.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Fixes: cc4c07c89aad ("drivers: perf: Implement perf event mmap support  in the SBI backend")
Link: https://lore.kernel.org/r/20240227170002.188671-3-vadim.shakirov@syntacore.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/riscv_pmu.c        | 18 +++++-------------
 drivers/perf/riscv_pmu_legacy.c |  8 +++++++-
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/perf/riscv_pmu.c b/drivers/perf/riscv_pmu.c
index 0dda70e1ef90a..c78a6fd6c57f6 100644
--- a/drivers/perf/riscv_pmu.c
+++ b/drivers/perf/riscv_pmu.c
@@ -150,19 +150,11 @@ u64 riscv_pmu_ctr_get_width_mask(struct perf_event *event)
 	struct riscv_pmu *rvpmu = to_riscv_pmu(event->pmu);
 	struct hw_perf_event *hwc = &event->hw;
 
-	if (!rvpmu->ctr_get_width)
-	/**
-	 * If the pmu driver doesn't support counter width, set it to default
-	 * maximum allowed by the specification.
-	 */
-		cwidth = 63;
-	else {
-		if (hwc->idx == -1)
-			/* Handle init case where idx is not initialized yet */
-			cwidth = rvpmu->ctr_get_width(0);
-		else
-			cwidth = rvpmu->ctr_get_width(hwc->idx);
-	}
+	if (hwc->idx == -1)
+		/* Handle init case where idx is not initialized yet */
+		cwidth = rvpmu->ctr_get_width(0);
+	else
+		cwidth = rvpmu->ctr_get_width(hwc->idx);
 
 	return GENMASK_ULL(cwidth, 0);
 }
diff --git a/drivers/perf/riscv_pmu_legacy.c b/drivers/perf/riscv_pmu_legacy.c
index a85fc9a15f039..fa0bccf4edf2e 100644
--- a/drivers/perf/riscv_pmu_legacy.c
+++ b/drivers/perf/riscv_pmu_legacy.c
@@ -37,6 +37,12 @@ static int pmu_legacy_event_map(struct perf_event *event, u64 *config)
 	return pmu_legacy_ctr_get_idx(event);
 }
 
+/* cycle & instret are always 64 bit, one bit less according to SBI spec */
+static int pmu_legacy_ctr_get_width(int idx)
+{
+	return 63;
+}
+
 static u64 pmu_legacy_read_ctr(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -111,7 +117,7 @@ static void pmu_legacy_init(struct riscv_pmu *pmu)
 	pmu->ctr_stop = NULL;
 	pmu->event_map = pmu_legacy_event_map;
 	pmu->ctr_get_idx = pmu_legacy_ctr_get_idx;
-	pmu->ctr_get_width = NULL;
+	pmu->ctr_get_width = pmu_legacy_ctr_get_width;
 	pmu->ctr_clear_idx = NULL;
 	pmu->ctr_read = pmu_legacy_read_ctr;
 	pmu->event_mapped = pmu_legacy_event_mapped;
-- 
2.43.0



