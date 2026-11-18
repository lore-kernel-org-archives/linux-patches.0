Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040803;
	b=SVsi/64IpsHnGHiIvIOg9QFAxQoMxgsRQajrlcj2fnU2axbM4OhUriUXrw4JJy1dADPr
	 ud+phZC9eaILgB0hGBjAagHYaXzJ7g1LPJZrGgTMXorBL73n4RJ4n9QviFBoDiIMZYPEH
	 h9H6RVWSfibMBk5ihV4lK+2N47x6Bcc982kJOSCwwGazE+Kqp5mUhRKhdcmDgBEGdkSrm
	 nVyerAKooPmYW3s1mjkPT+wUyyleJeSDXatOk9DrFId+FWMaaO4CpF7fcYVZi+msw6J8S
	 YM4aD/LLHnJ/ILZgtMwITFPBg6LSde+SeraDuNKd0xVPhw7RehiuNWtx4m1HMJky96A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SEy6ELj0qPyNNZYNguITL5oTE0upujBg7Pag3BSuzq4=;
	b=eUBDTe79RUzfSXqyKohmcxy6FktGBN79In81ujBrE/wNfkTMwTE9eHDeT5N62/CLPf/1
	 pPpSTqRnyEnjNzNBU86slFuhJwQxL83+WyKTvV3gkyvZ6J8/M2GeOxFYsQMvnm8rZANJi
	 x78UqoLzUAEwm9O/72NEr8/nJfj+Oxk9Fwnu79JoLzN0Y0e28ve3yZ1Bx541HvHj/PDH5
	 h8ThGy2u5D+khJRwzOXkif0VhGoYQz8ONj5kNO7mrxudgUSt7saPd6SQ4+C3sZ6dxPYjh
	 IGO4WafJhS1FBOAku2MbuARAa30PLfmph1a5UuOPGDTPLz4ctXzAReEP1M6t1SmZ/pA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nLZ6yPzj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44418606A320;
	Wed, 18 Nov 2026 22:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nLZ6yPzj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD561F000C4;
	Wed, 18 Nov 2026 22:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040802;
	bh=SEy6ELj0qPyNNZYNguITL5oTE0upujBg7Pag3BSuzq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nLZ6yPzjN0aYja9Oy+tANmFk4Wv6uFthSFIO4VEDJ1gFktmRed0YBEYhPc+bgpT92
	 LCyU3r1bTjbbTuXhkmuBNdOPARFf5AjW6euvMjFIpqvORH8/2IcPy5RiJ5mQucVAJz
	 K/VncjZKYOJEGbfpT5LmDKeHKbdMNdNRm18MuVLE=
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
Subject: [PATCH 6.6 2546/3318] perf/cxl: Dont share the overflow interrupt, and keep it pinned
Date: Wed, 18 Nov 2026 15:52:48 +0100
Message-ID: <20261118150437.677822010@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bd4ac39d3d50a..79b1d824d0b12 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -790,7 +790,7 @@ static irqreturn_t cxl_pmu_irq(int irq, void *data)
 
 	overflowed = readq(base + CXL_PMU_OVERFLOW_REG);
 
-	/* Interrupt may be shared, so maybe it isn't ours */
+	/* Nothing overflowed, so the device did not raise this */
 	if (!overflowed)
 		return IRQ_NONE;
 
@@ -893,7 +893,14 @@ static int cxl_pmu_probe(struct device *dev)
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



