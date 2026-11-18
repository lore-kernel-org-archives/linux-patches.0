Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037947;
	b=JdikLa9ZwmHFqawqirgBBXAbShomr97/+QwpUhdxcoQdf0EF9/IqeffWAyfjuNenX5yU
	 diaaxfkeIcOLKFRTC5CFFJiByMf2NjiueVIESeVro5VB0MyDWgD8n4iD4lbLbmZgWNdif
	 jrWOFFLwBz/F6IxnZv5hmZ8ttMAjc0XamxZ+lK4uYgWRhfsZVDy55YRQbfGpSy2K6XzdS
	 EUbHCmc+VdEOrtNE5TCkOxY/shU+Mvu8yTeyf2V0iToUwjw5P5T4BdxG5qjdY//kqGF79
	 KvT3+NTXaJEUbEJ9xC2onmz8oSNPp+f9XDZcun57khEU/PZAS7utyMvt10gFeY6kovQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037947;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VzC8aC2dX0tigZ7eEAoBCAo3hUWPAO6IezHtiJS/1aE=;
	b=ioTv5jUinddCk4vQwJ4MeaSblnxqVnsp0309GqkVV6zZyZB4ojvVVbTGB9u+BfAO2xw2
	 HlnVkD0nuKFWhN1EGHwlNPqEtsjnYsYZLQbzweFpcCuy66jpdYKTt6aIYIN+kLn0Av0IN
	 9fB3MM1CylLP9Ms+pnxlokpkGpQBovMJPL/eOdIG06PH+88Ef7Yx4QzalhNUerasvGJef
	 Qq6/e2t/K+/Mxu0qOPlknFEvogmYxHIROcIzhfrHyoeKpKUMJEjDHZ26aZWuk/enftDcc
	 LVW9GDNB5hZq312rJFhAyhu+FNEPdLBap6ELAX251CrGdq0YrTJfhur4EFEp1sGrBRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UgPYTZUw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3641606A325;
	Wed, 18 Nov 2026 21:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UgPYTZUw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4851B1F000C4;
	Wed, 18 Nov 2026 21:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037946;
	bh=VzC8aC2dX0tigZ7eEAoBCAo3hUWPAO6IezHtiJS/1aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UgPYTZUw5cGJVP3fA1mgB+MjjqukqDvHw5N72/55iHouIf9oUeXU2MfXxTcYmUCLs
	 E8L7JgQfb/kknd/SyNIphOplqqZZC9P+wFAnbEr9a1rkXWNDDqrFS8wZAeq/nCJzmx
	 VYY9LWedQ4ggcdeYytrazXbhZpr+ro40+TqBWb1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Brennan <stephen.s.brennan@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1574/3318] powerpc/pseries/iommu: Restore CONFIG_IOMMU_API dependency
Date: Wed, 18 Nov 2026 15:36:36 +0100
Message-ID: <20261118150408.337933497@linuxfoundation.org>
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

From: Stephen Brennan <stephen.s.brennan@oracle.com>

In stable v6.6.161 there is a build error with ppc64 when
CONFIG_IOMMU_API is not enabled:

    arch/powerpc/platforms/pseries/iommu.c: In function 'iommu_take_ownership':
    arch/powerpc/platforms/pseries/iommu.c:69:25: error: 'struct iommu_table_ops' has no member named 'xchg_no_kill'
       69 |         if (!tbl->it_ops->xchg_no_kill)
    	  |                         ^~
      AS      arch/powerpc/lib/copy_mc_64.o
    arch/powerpc/platforms/pseries/iommu.c: At top level:
    arch/powerpc/platforms/pseries/iommu.c:1787:37: error: 'spapr_tce_table_group_ops' defined but not used [-Werror=unused-variable]
     1787 | static struct iommu_table_group_ops spapr_tce_table_group_ops = {
    	  |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~
    cc1: all warnings being treated as errors

This is due to stable v6.6.161 commit 1e9dfe15404d ("powerpc/iommu: Move
pSeries specific functions to pseries/iommu.c"). It was included as a
stable-dep-of commit 8f70caad82e9 ("powerpc/pseries/iommu: IOMMU
incorrectly marks MMIO range in DDW").

It was backported without its associated fix: commit af199e6ca29c
("powerpc/pseries/iommu: Define spapr_tce_table_group_ops only with
CONFIG_IOMMU_API").

The code was supposed to only build under CONFIG_IOMMU_API, but the new
location doesn't have this condition. Unfortunately, the fixing commit
comes after a fairly large refactor, and doesn't apply on v6.16.161.
Instead, apply the ifdefs where they would belong prior to the refactor.

Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/iommu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 6a45e3e86f79b..a79927e870a87 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -54,6 +54,7 @@ enum {
 	DDW_EXT_QUERY_OUT_SIZE = 2
 };
 
+#ifdef CONFIG_IOMMU_API
 static int iommu_take_ownership(struct iommu_table *tbl)
 {
 	unsigned long flags, i, sz = (tbl->it_size + 7) >> 3;
@@ -104,6 +105,7 @@ static void iommu_release_ownership(struct iommu_table *tbl)
 		spin_unlock(&tbl->pools[i].lock);
 	spin_unlock_irqrestore(&tbl->large_pool.lock, flags);
 }
+#endif
 
 static struct iommu_table *iommu_pseries_alloc_table(int node)
 {
@@ -118,7 +120,9 @@ static struct iommu_table *iommu_pseries_alloc_table(int node)
 	return tbl;
 }
 
+#ifdef CONFIG_IOMMU_API
 static struct iommu_table_group_ops spapr_tce_table_group_ops;
+#endif
 
 static struct iommu_table_group *iommu_pseries_alloc_group(int node)
 {
@@ -1702,6 +1706,7 @@ static bool iommu_bypass_supported_pSeriesLP(struct pci_dev *pdev, u64 dma_mask)
 	return false;
 }
 
+#ifdef CONFIG_IOMMU_API
 /*
  * A simple iommu_table_group_ops which only allows reusing the existing
  * iommu_table. This handles VFIO for POWER7 or the nested KVM.
@@ -1792,6 +1797,7 @@ static struct iommu_table_group_ops spapr_tce_table_group_ops = {
 	.take_ownership = spapr_tce_take_ownership,
 	.release_ownership = spapr_tce_release_ownership,
 };
+#endif
 
 static int iommu_mem_notifier(struct notifier_block *nb, unsigned long action,
 		void *data)
-- 
2.53.0



