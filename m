Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025332;
	b=OTWuyGXO3O1jk51M4fqCOTRQeIeOaKGy1Zlqbv0aJTj0+IyXRZJzL8WRh02tsv/C7QQ/
	 PBu0uStmUt/m2EJVy7YQbNMujy9Q7sqQQ+kKd2ezHRWEQdGR7WG9/lTeGW6mvdMB+wsch
	 8yE8OecA8008VqLEvi71zUaTVu6HcXKKJbe99so7vHG16oWB4RZt2NI3H4S3JGH+fMJ/S
	 nnhhGBJl7bj2gH16v4fnQh209WwF08Dz4cJGgOMYVpKjTJEaDtGeMUbTltJlPwmueIXTU
	 s3huRSrTqruYq/qY6Wxcz2SZmM1DaIRgetK94eUJbTUTX929v2LeYmAy4LEewuAZLlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ei8qrGTz8iFnNIRPiJ+C0yyl9SkskA+wedTuqEtmIA8=;
	b=SMKqfy5X3IAtqJvtpCaubrhD423vsFwJ5BoReL69mu4L+tIKP6Pn2MkUKpmf3KDP7azp
	 fjSyanMUKmgoHJLcY50OghHvi14MfEXUPatWlr6z9dJ/9iDyY2zg+CoZX83fulImc/JkA
	 kazPypryk44TgMfG6TyMo70SQHOhxQY5FaoOf4GVWaD4BsVvIqeklZfKSAY3WNWL+wqtO
	 IeR31/G1yhUQPGxH9j8+nDX/9kMgIMlG13SOwi1MCy7HQJi9Lpww79c5tBmVSgupoLV+y
	 fZPcHH72EVKSHlrqlcbY8pN8vjAFvnz44U4WDzgXTWbdJ+vCCYt2MLx61EwfHoufhaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q039TwiL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990A8606A336;
	Wed, 18 Nov 2026 18:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q039TwiL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E091F000C4;
	Wed, 18 Nov 2026 18:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025332;
	bh=Ei8qrGTz8iFnNIRPiJ+C0yyl9SkskA+wedTuqEtmIA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q039TwiLSHbnLoYIyQGIiIXoMGFuZaw5qJlae496cBPVqfQiQ6GG/QzJIoIE0V1+o
	 3OOP7rAG6mL2vPm+/d8m8FGhnnIIHJ8cxT47PtEkzCDLbpXJkhOU2ldACM/1dIRv0t
	 kkxNZ0c3tBC5iXPaSsV6sGRXCXLN8Y4lqSjgjTYk=
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
Subject: [PATCH 6.18 1042/2151] perf/cxl: Dont share the overflow interrupt, and keep it pinned
Date: Wed, 18 Nov 2026 15:46:17 +0100
Message-ID: <20261118150200.290726984@linuxfoundation.org>
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
index 24ff8082cc7cf..912cc125b41aa 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -782,7 +782,7 @@ static irqreturn_t cxl_pmu_irq(int irq, void *data)
 
 	overflowed = readq(base + CXL_PMU_OVERFLOW_REG);
 
-	/* Interrupt may be shared, so maybe it isn't ours */
+	/* Nothing overflowed, so the device did not raise this */
 	if (!overflowed)
 		return IRQ_NONE;
 
@@ -885,7 +885,14 @@ static int cxl_pmu_probe(struct device *dev)
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



