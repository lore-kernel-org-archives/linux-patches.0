Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020430;
	b=NldglqSo1QpmGcGsj+Wm5w42oV7agPZdJpXNL299YNUPC9dkH6Qe/FNq7Y1yq2wSNMa0
	 pEUtG5p7KhIQ0Vp6mEi94SjzIEXlGEvXj5agxXxFF7BCCan8/enpJKzcGY4Xp6juA5lJE
	 YcUp+G3hQdkYliUpt/TTdoUonWnlzhT8PMhCEDgiB6LcfsQiy7oyaq0lC0h/2bzB/ReVq
	 AKditQpvdHH+7UpVDVZjcmf2NpsL/XvUygWXNtexNkBVwBBjXdV2ERNqOXDioL1naJDgq
	 p/2mt5EXxdonNiQF7MiZrh+KDWAf7sZYx0ChH4sqZ7tF8KGVCen7R4YbYsiNvSYvgZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020430;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Kypml57nqVuOWyUsIu4zqzxwYEm7gr/ILHSoy8d3H4g=;
	b=yoMOMEOdhZs84BE6nbFO+wVAqCPl5mP0VyWuO6ujxDjtzSMm1HZxIlIp2WJ+SDdV3kkF
	 NnaA4lvRVVCoaZaqQXa5mEHB3a/wvLXOVElRORRe8xy56suvueqRJxTwN3xoCqcsv0Eh7
	 bIbQDbsE4d23fz+2LuwRF3xZuYojrnnNneVhr3L/sXHg/RsvuyUhLpmZ+mKbnm6tQBeSL
	 IuqCIJMMLQZBQZ/3u4EWhWP2W3PRmUqmrGvS/lQnPol2x4VYirI+42k1TM+tidC6Zw1PV
	 nEkXcqhnYiK4SIB6U2VbJ5MQ4GnZAasBuSF7BcAbI3fwLo7OmV9KNVi4IYtBDY5fTPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xe7cEXwj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85875606A31C;
	Wed, 18 Nov 2026 16:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xe7cEXwj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85911F000C4;
	Wed, 18 Nov 2026 16:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020430;
	bh=Kypml57nqVuOWyUsIu4zqzxwYEm7gr/ILHSoy8d3H4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xe7cEXwjpUEMZ/K3tWsGB2gfFw1D8RFvMkOZ2cFTld9VRNu+LUmiczvgUZyLvk4kW
	 alSK9WFBy6FMbXr6AbB1VptQpdiuy82chrIp8SbYs9NxJYjG0h4GrkSzZ+4ZehsZHc
	 yy4m/71OW0AEc/JshuM2BHIkbgVlA0pPMb4zRCE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Monin?= <benoit.monin@bootlin.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1949/2651] irqchip/mips-gic: Fix unbalanced cm_core_lock in for_each_online_cpu_gic()
Date: Wed, 18 Nov 2026 15:53:09 +0100
Message-ID: <20261118150356.750507433@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benoît Monin <benoit.monin@bootlin.com>

[ Upstream commit 03c4d26933d54556a89379db5923ae9e474569e8 ]

Commit d9e2ed610a60 ("irqchip/mips-gic: Support multi-cluster in
for_each_online_cpu_gic()") added a gic_unlock_cluster() call to the
macro's loop increment, which unconditionally invokes
mips_cm_unlock_other() on multi-cluster systems. However nothing in the
loop ever acquires the corresponding mips_cm_lock_other(), so on
multi-cluster hardware every invocation of for_each_online_cpu_gic()
releases an unheld per-CPU cm_core_lock.

With CONFIG_PROVE_LOCKING this triggers a "bad unlock balance detected"
warning at boot, e.g. from gic_irq_domain_map() while mapping local
interrupts. Only the first occurrence is reported, since the first
warning permanently disables lockdep (debug_locks = 0); the unbalanced
release itself silently persists.

Fix this by moving both the acquire and release into
__gic_with_next_online_cpu() so they stay balanced. When advancing to a
CPU in a remote cluster, lock the CM redirect block for that cluster via
mips_cm_lock_other(); when leaving a remote cluster (or finishing the
iteration) release it with mips_cm_unlock_other(). Local-cluster CPUs
require no locking, so single-cluster systems are unaffected. This also
makes the redirect region behave correctly when accessing local register
blocks of CPUs in other clusters.

Drop the now-unused gic_unlock_cluster() helper and its call from the
for_each_online_cpu_gic() increment.

Fixes: d9e2ed610a60 ("irqchip/mips-gic: Support multi-cluster in for_each_online_cpu_gic()")
Signed-off-by: Benoît Monin <benoit.monin@bootlin.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Link: https://patch.msgid.link/20260929-sync-gic-counters-v4-1-ec70c4b60434@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mips-gic.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index 19a57c5e2b2ea..3b31cbcbed6f3 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -70,6 +70,10 @@ static int __gic_with_next_online_cpu(int prev)
 {
 	unsigned int cpu;
 
+	/* Release the redirect/other region lock to the previous CPU, if any. */
+	if (prev >= 0)
+		mips_cm_unlock_other();
+
 	/* Discover the next online CPU */
 	cpu = cpumask_next(prev, cpu_online_mask);
 
@@ -77,23 +81,12 @@ static int __gic_with_next_online_cpu(int prev)
 	if (cpu >= nr_cpu_ids)
 		return cpu;
 
-	/*
-	 * Move the access lock to the next CPU's GIC local register block.
-	 *
-	 * Set GIC_VL_OTHER. Since the caller holds gic_lock nothing can
-	 * clobber the written value.
-	 */
-	write_gic_vl_other(mips_cm_vp_id(cpu));
+	/* Lock access to redirect/other region to the next CPU */
+	mips_cm_lock_other_cpu(cpu, CM_GCR_Cx_OTHER_BLOCK_LOCAL);
 
 	return cpu;
 }
 
-static inline void gic_unlock_cluster(void)
-{
-	if (mips_cps_multicluster_cpus())
-		mips_cm_unlock_other();
-}
-
 /**
  * for_each_online_cpu_gic() - Iterate over online CPUs, access local registers
  * @cpu: An integer variable to hold the current CPU number
@@ -108,7 +101,6 @@ static inline void gic_unlock_cluster(void)
 	guard(raw_spinlock_irqsave)(gic_lock);		\
 	for ((cpu) = __gic_with_next_online_cpu(-1);	\
 	     (cpu) < nr_cpu_ids;			\
-	     gic_unlock_cluster(),			\
 	     (cpu) = __gic_with_next_online_cpu(cpu))
 
 /**
-- 
2.53.0



