Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37AF4F85CB;
	Wed, 30 Sep 2026 16:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785069; cv=none; b=LXHCZSCs345z7+QGUM3CB0NiPok9sGMxZ2vAa+NVgfy4+6sLMY3tbH6ADfVn/IPAqYmy0/H4CUUGl0P0zYY4uuzQfXTkVrH5vdJLqeaboZ1/1CRLx26gW6fV2veSR3RuYzuYBR2iswBWvmoeMMUsWzI0xCBbl4FIe3Be3084jzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785069; c=relaxed/simple;
	bh=chfhGX2+NtIGIb0y90s76KF6MEQxg5A4Y78CSCZ7R7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QaMpW9iwqazWtO0wXRwhQBk+DQ5JTdKtYYZ/j0neOr3eu809dR6QSpWxa2VKEzaIqRnMI4DYC7mgjlM/PZLIJn+4TS4+ZhDF2+IKgxdnuxcCIVqt6bIoaHxgDYCMaxQb26mml6qorLy7pmJIqHk16esA3uFyMOH4hZ0DLTc42aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XCIOw/4d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XCIOw/4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D071F000FF;
	Wed, 30 Sep 2026 16:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785065;
	bh=JgJt7mJsrqMW8IvVEybxmtT/4YeF2O38sCFvsdVkTqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XCIOw/4dqykSQQ6zzbPvtH4lHgRbcW7o9LX7mY2OzMllLgqQoTi5X6UjOQ9Z23iCA
	 Sc0RTiUDmc9Q1QuNT9t5Yj25hn6utcrJajn5X4cFaOPaGV0+iTL//WAmqgH7EiliU1
	 Hckgl9NQKee3hx1MNvhdmT3tUDc1uIC+elv3c5x8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YueHaibing <yuehaibing@huawei.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 377/982] mfd: db8500-prcmu: Remove unused inline functions
Date: Wed, 30 Sep 2026 17:18:33 +0200
Message-ID: <20260930152424.909221146@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 2dfe293bcde2d302c045d0cd536ccb15f86385d2 ]

Since commit b0e846248de5 ("mfd: db8500-prcmu: Remove dead code for a non-existing config")
these inline helpers also no need any more.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Link: https://lore.kernel.org/r/20230720143738.13996-1-yuehaibing@huawei.com
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 66ec63e7a90b ("ASoC: ux500: Deassert the MSP reset during probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mfd/dbx500-prcmu.h | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/include/linux/mfd/dbx500-prcmu.h b/include/linux/mfd/dbx500-prcmu.h
index e7a7e70fdb385..dd0fc891b2289 100644
--- a/include/linux/mfd/dbx500-prcmu.h
+++ b/include/linux/mfd/dbx500-prcmu.h
@@ -556,16 +556,6 @@ static inline void prcmu_clear(unsigned int reg, u32 bits)
 #define PRCMU_QOS_ARM_OPP 3
 #define PRCMU_QOS_DEFAULT_VALUE -1
 
-static inline unsigned long prcmu_qos_get_cpufreq_opp_delay(void)
-{
-	return 0;
-}
-
-static inline int prcmu_qos_requirement(int prcmu_qos_class)
-{
-	return 0;
-}
-
 static inline int prcmu_qos_add_requirement(int prcmu_qos_class,
 					    char *name, s32 value)
 {
@@ -582,15 +572,4 @@ static inline void prcmu_qos_remove_requirement(int prcmu_qos_class, char *name)
 {
 }
 
-static inline int prcmu_qos_add_notifier(int prcmu_qos_class,
-					 struct notifier_block *notifier)
-{
-	return 0;
-}
-static inline int prcmu_qos_remove_notifier(int prcmu_qos_class,
-					    struct notifier_block *notifier)
-{
-	return 0;
-}
-
 #endif /* __MACH_PRCMU_H */
-- 
2.53.0



