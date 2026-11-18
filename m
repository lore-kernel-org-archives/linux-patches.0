Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030764;
	b=JFZ/SiYk8c+Re/dg7k7TPpE/p3bQG7MEquPfj5wyxahKvzaz9YmbdGKh5FrqB0NekgLr
	 HHLgcgHbSqyJzHiCftfiMDhCEU4/Z7bk1+ZBjPonj/sH2nSC3UhzcHt1mdVeqkxCB3bna
	 PmKEnUTYWXFcDosjLOy9K/cg41gK011y7GCfN9x6U5trXwRZ1zROqRhqsKjPM3jWLvLxv
	 5dm1rN7KL3lJ8XkVB7a6X+Fog8fbpNYMT+UN5XOLSWj4xm0snU2AwdNB281d0GutA+huY
	 AkGZD/FM7H33zSRkz26lNnSlUT8FtLfH+rHCRTGyAEQZ0m06hsjqmogvcN7g3seHkmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030764;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7p5AppQyBiSBzQqnO7T4/6mXP0YcjggkULtBOE2Bsz0=;
	b=0ZxdMgXoQJxcZKTFrACgLWywAqMA/gSKKK1xZUvJ15roFTyRi8noa3rJzKLrmNgnWMwr
	 J/XtvwrIP1wNvU1S7Umye3YgehBfZugph9tfOSnkOQ1h4OE8viH7AGZeBzt8Szqa7/yJ7
	 YiDGcTncxCDRsxbWYpCZN0XXlExZnEkpxhJHaa56I5QY3xWI8E+QRU0AFKUWmjRH6Bibw
	 QzECqO6p7Lm/H8SZ+O/r0NNrcxnhZezQG33N+y9HOgyER/MG6jSxHXebGAymIiC7eC7Ky
	 LsHXQku6q55STAUDNhdvSrU22uetC2mKr6wez7Jqrjsj83NDCsCpj3SGU8/dkJuZGsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qZMsOFvb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB27606A92F;
	Wed, 18 Nov 2026 19:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qZMsOFvb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FFC1F000C5;
	Wed, 18 Nov 2026 19:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030764;
	bh=7p5AppQyBiSBzQqnO7T4/6mXP0YcjggkULtBOE2Bsz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qZMsOFvbb0y8pUgFxnLmaO7fW8X1DKVGaau5f/HWzNxAiKZV/AxdozteJDbPAYUA/
	 LbBZ0ulSmilXCy88dROupYLpGTedkBAnjsRXpTL2sdiErPeJHrAIOoaAGHpT60RN/r
	 VStEO5pMOZ28br5SEZlV2gEPQOp0Trqch7lphYMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0819/1756] perf/cxl: Dont share the overflow interrupt, and keep it pinned
Date: Wed, 18 Nov 2026 15:49:06 +0100
Message-ID: <20261118150042.180974967@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit b899fd3487b0d4066d60ebcf5b73e77c9617de54 ]

The PMU pins its overflow interrupt to info->on_cpu in the hotplug
callbacks, but requests it with only IRQF_SHARED | IRQF_NO_THREAD. Without
IRQF_NOBALANCING, irqbalance or a userspace smp_affinity write can move it
elsewhere, and cxl_pmu_irq() then runs local64_cmpxchg() and local64_add()
on hwc->prev_count and event->count at the same time as the managing CPU.
local64_t is only atomic against same-CPU access, so the counts corrupt.

The flag alone does not fix that while the line is shared. __setup_irq()
only acts on it for the first action on a line, and a co-owner has no
reason to want our affinity - it would keep taking the interrupt wherever
its own points, running our handler on the wrong CPU.

Drop IRQF_SHARED and add IRQF_NOBALANCING. The spec only recommends a
distinct Interrupt Message Number per CPMU instance (CXL r4.0 8.2.7.1.1),
so a device may put several on one vector, or share with the mailbox or
event log. Such a device now loses a PMU rather than silently miscounting -
and only the PMU, since the preceding patch adds the CPMUs after the event
configuration.

Fixes: 5d7107c72796 ("perf: CXL Performance Monitoring Unit driver")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260715191454.459673-1-dave@stgolabs.net?part=1
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://sashiko.dev/#/patchset/20260715191454.459673-1-dave@stgolabs.net?part=1
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/cxl_pmu.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/cxl_pmu.c b/drivers/perf/cxl_pmu.c
index 09b9eca802525..f8195774213c4 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -779,7 +779,7 @@ static irqreturn_t cxl_pmu_irq(int irq, void *data)
 
 	overflowed = readq(base + CXL_PMU_OVERFLOW_REG);
 
-	/* Interrupt may be shared, so maybe it isn't ours */
+	/* Nothing overflowed, so the device did not raise this */
 	if (!overflowed)
 		return IRQ_NONE;
 
@@ -882,7 +882,14 @@ static int cxl_pmu_probe(struct device *dev)
 	if (!irq_name)
 		return -ENOMEM;
 
-	rc = devm_request_irq(dev, irq, cxl_pmu_irq, IRQF_SHARED | IRQF_NO_THREAD,
+	/*
+	 * The handler must run on info->on_cpu, so the interrupt cannot be
+	 * shared - IRQF_NOBALANCING is only honoured for the first action on a
+	 * line, and a co-owner would keep taking the interrupt wherever its own
+	 * affinity points.
+	 */
+	rc = devm_request_irq(dev, irq, cxl_pmu_irq,
+			      IRQF_NO_THREAD | IRQF_NOBALANCING,
 			      irq_name, info);
 	if (rc)
 		return rc;
-- 
2.53.0



