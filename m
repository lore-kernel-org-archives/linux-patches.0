Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060548;
	b=yruosY9e3GdqSjaowMul5NSzP/gRq1JUcXgWDQ8HWTdwh+yTvz7TtCHASe8z0w1Kbghn
	 HVTkhOsc98/cfMze5d2mM8mSGY9Zx0qEKfaGgRX6yH9AV+ZyigDsJJc8Z11kWVYTvpszv
	 +2jOJG4kGiJI90nQjT4TADzTf33Eiqz8Ds7OK63RDF5xClyBAjllS5MzwdUKXI6e1lD/1
	 BLAsLGwM/oWrDypKveshGrim4VWi2cjiyA7mjSr7BOloIwFcaBf+3GK5TvjkbHjY/wMe/
	 fobJBuaOUadUTYmBYOahLU+KSYebkrOJYWt2KGqsR52W7KmfJ/fDmKIyxeta7EFBdkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060548;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=066WXecPweIdYzvMzbLpBkDQ/Xmc5nTqaVtaxevJnQw=;
	b=OAnv8Hd6ESP38kZk1tY/MfYkCuL5i1An6pzd9fb2gaunEgMDQPi+OuyaQDG03aFIxmQ9
	 hZamLAX52cbn41D65fwuFaJVCzoVEVa2wFwIUIoLHgc5JECqKY/5mzFgcdLdfb7UorWFi
	 nvEicx6IGYJFM3X9+Cj9sUPNsMUDCpQE95/b2jl7vZowlmanM/Fd9iHtqryGs9xZ0+75V
	 tcykOKRGksgFXp3LYmmXeG/02qX0/1MCP0M/AQ8CDhvAQqD7GL1F7tXOb+YxY0jTDrWby
	 FtvPeCoXoelzS1GQArQxSimhO4XTDtKn+7QBVPeFh+pqzegf7bG0ZLv1CkkFU6KFYQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dfUZznPw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6663F606A326;
	Sat,  7 Nov 2026 14:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dfUZznPw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8191F008A1;
	Sat,  7 Nov 2026 14:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060548;
	bh=066WXecPweIdYzvMzbLpBkDQ/Xmc5nTqaVtaxevJnQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dfUZznPw4ABCd2P1lQRJE/Z0g4FlgRsA5qKcgYr/5gtDs/IwX+xrYZIBfZx5tRTi/
	 ZS9LtVE/aHdngtc51fdmsAVtdEMcWysOrHz3j+U4aYpws3Kq84x0l14lRpMerE+zEr
	 WAiosoyrELiu2SjQlY+3WsKHn3SBhoifZcaez0ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0007/1536] Revert "KVM: s390: move gmap_shadow_pgt_lookup() into kvm"
Date: Sat,  7 Nov 2026 08:33:43 -0500
Message-ID: <20261107134957.880299618@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

This reverts commit 4f2fe83204ec878499b33b260d9b1b8c8c20f512.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/gmap.h |  3 ++-
 arch/s390/kvm/gaccess.c      | 42 +---------------------------------
 arch/s390/kvm/gmap.h         |  2 --
 arch/s390/mm/gmap.c          | 44 ++++++++++++++++++++++++++++++++++--
 4 files changed, 45 insertions(+), 46 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 69eb2ef64034b..22775b1ce7101 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -134,6 +134,8 @@ int gmap_shadow_sgt(struct gmap *sg, unsigned long saddr, unsigned long sgt,
 		    int fake);
 int gmap_shadow_pgt(struct gmap *sg, unsigned long saddr, unsigned long pgt,
 		    int fake);
+int gmap_shadow_pgt_lookup(struct gmap *sg, unsigned long saddr,
+			   unsigned long *pgt, int *dat_protection, int *fake);
 int gmap_shadow_page(struct gmap *sg, unsigned long saddr, pte_t pte);
 
 void gmap_register_pte_notifier(struct gmap_notifier *);
@@ -151,7 +153,6 @@ void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns);
 int __s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,
 			    unsigned long end, bool interruptible);
 int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool split);
-unsigned long *gmap_table_walk(struct gmap *gmap, unsigned long gaddr, int level);
 
 /**
  * s390_uv_destroy_range - Destroy a range of pages in the given mm.
diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 448304e662fbb..7bc97ebd60d5d 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -16,7 +16,6 @@
 #include <asm/gmap.h>
 #include <asm/dat-bits.h>
 #include "kvm-s390.h"
-#include "gmap.h"
 #include "gaccess.h"
 
 /*
@@ -1393,42 +1392,6 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 	return 0;
 }
 
-/**
- * shadow_pgt_lookup() - find a shadow page table
- * @sg: pointer to the shadow guest address space structure
- * @saddr: the address in the shadow aguest address space
- * @pgt: parent gmap address of the page table to get shadowed
- * @dat_protection: if the pgtable is marked as protected by dat
- * @fake: pgt references contiguous guest memory block, not a pgtable
- *
- * Returns 0 if the shadow page table was found and -EAGAIN if the page
- * table was not found.
- *
- * Called with sg->mm->mmap_lock in read.
- */
-static int shadow_pgt_lookup(struct gmap *sg, unsigned long saddr, unsigned long *pgt,
-			     int *dat_protection, int *fake)
-{
-	unsigned long *table;
-	struct page *page;
-	int rc;
-
-	spin_lock(&sg->guest_table_lock);
-	table = gmap_table_walk(sg, saddr, 1); /* get segment pointer */
-	if (table && !(*table & _SEGMENT_ENTRY_INVALID)) {
-		/* Shadow page tables are full pages (pte+pgste) */
-		page = pfn_to_page(*table >> PAGE_SHIFT);
-		*pgt = page->index & ~GMAP_SHADOW_FAKE_TABLE;
-		*dat_protection = !!(*table & _SEGMENT_ENTRY_PROTECT);
-		*fake = !!(page->index & GMAP_SHADOW_FAKE_TABLE);
-		rc = 0;
-	} else  {
-		rc = -EAGAIN;
-	}
-	spin_unlock(&sg->guest_table_lock);
-	return rc;
-}
-
 /**
  * kvm_s390_shadow_fault - handle fault on a shadow page table
  * @vcpu: virtual cpu
@@ -1452,9 +1415,6 @@ int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
 	int dat_protection, fake;
 	int rc;
 
-	if (KVM_BUG_ON(!gmap_is_shadow(sg), vcpu->kvm))
-		return -EFAULT;
-
 	mmap_read_lock(sg->mm);
 	/*
 	 * We don't want any guest-2 tables to change - so the parent
@@ -1463,7 +1423,7 @@ int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
 	 */
 	ipte_lock(vcpu->kvm);
 
-	rc = shadow_pgt_lookup(sg, saddr, &pgt, &dat_protection, &fake);
+	rc = gmap_shadow_pgt_lookup(sg, saddr, &pgt, &dat_protection, &fake);
 	if (rc)
 		rc = kvm_s390_shadow_tables(sg, saddr, &pgt, &dat_protection,
 					    &fake);
diff --git a/arch/s390/kvm/gmap.h b/arch/s390/kvm/gmap.h
index 14431ce978da2..f2b52ce29be3d 100644
--- a/arch/s390/kvm/gmap.h
+++ b/arch/s390/kvm/gmap.h
@@ -10,8 +10,6 @@
 #ifndef ARCH_KVM_S390_GMAP_H
 #define ARCH_KVM_S390_GMAP_H
 
-#define GMAP_SHADOW_FAKE_TABLE 1ULL
-
 int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
 int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr);
 int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr);
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 072e3fd01dd3c..fb975e72a81ae 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -804,7 +804,8 @@ static void gmap_call_notifier(struct gmap *gmap, unsigned long start,
  *
  * Note: Can also be called for shadow gmaps.
  */
-unsigned long *gmap_table_walk(struct gmap *gmap, unsigned long gaddr, int level)
+static inline unsigned long *gmap_table_walk(struct gmap *gmap,
+					     unsigned long gaddr, int level)
 {
 	const int asce_type = gmap->asce & _ASCE_TYPE_MASK;
 	unsigned long *table = gmap->table;
@@ -855,7 +856,6 @@ unsigned long *gmap_table_walk(struct gmap *gmap, unsigned long gaddr, int level
 	}
 	return table;
 }
-EXPORT_SYMBOL(gmap_table_walk);
 
 /**
  * gmap_pte_op_walk - walk the gmap page table, get the page table lock
@@ -2003,6 +2003,46 @@ int gmap_shadow_sgt(struct gmap *sg, unsigned long saddr, unsigned long sgt,
 }
 EXPORT_SYMBOL_GPL(gmap_shadow_sgt);
 
+/**
+ * gmap_shadow_pgt_lookup - find a shadow page table
+ * @sg: pointer to the shadow guest address space structure
+ * @saddr: the address in the shadow aguest address space
+ * @pgt: parent gmap address of the page table to get shadowed
+ * @dat_protection: if the pgtable is marked as protected by dat
+ * @fake: pgt references contiguous guest memory block, not a pgtable
+ *
+ * Returns 0 if the shadow page table was found and -EAGAIN if the page
+ * table was not found.
+ *
+ * Called with sg->mm->mmap_lock in read.
+ */
+int gmap_shadow_pgt_lookup(struct gmap *sg, unsigned long saddr,
+			   unsigned long *pgt, int *dat_protection,
+			   int *fake)
+{
+	unsigned long *table;
+	struct page *page;
+	int rc;
+
+	BUG_ON(!gmap_is_shadow(sg));
+	spin_lock(&sg->guest_table_lock);
+	table = gmap_table_walk(sg, saddr, 1); /* get segment pointer */
+	if (table && !(*table & _SEGMENT_ENTRY_INVALID)) {
+		/* Shadow page tables are full pages (pte+pgste) */
+		page = pfn_to_page(*table >> PAGE_SHIFT);
+		*pgt = page->index & ~GMAP_SHADOW_FAKE_TABLE;
+		*dat_protection = !!(*table & _SEGMENT_ENTRY_PROTECT);
+		*fake = !!(page->index & GMAP_SHADOW_FAKE_TABLE);
+		rc = 0;
+	} else  {
+		rc = -EAGAIN;
+	}
+	spin_unlock(&sg->guest_table_lock);
+	return rc;
+
+}
+EXPORT_SYMBOL_GPL(gmap_shadow_pgt_lookup);
+
 /**
  * gmap_shadow_pgt - instantiate a shadow page table
  * @sg: pointer to the shadow guest address space structure
-- 
2.53.0



