Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3C647D463;
	Thu, 20 Aug 2026 17:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248057; cv=none; b=QzMOGfoE63At4ak1gWNRERCijjuNMbTUoqhNqdnoQ1ykxULoGla6NlN/sOmB1YKzDvey8EWSLJZlxNeu9qcXWTXVRn929GyBT4T6Fop5I66gG+aC8hzMte0FUmiFaGXhznnMPIbt/Q2MRAtWBr+n0HCzSyjYBANPHvac1/ksrjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248057; c=relaxed/simple;
	bh=em1hMVT6PSiSL2nRF95zTr7i27zQHewX8T8JVy+VW38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBtjcZHzf6bjWOv4+D8GuHN8ajpCyVt3abXeYn4azxHZ2gqZF9awYGIWiZUM0DpBFAPlrmLU9G2Es8DoY72McsRtIHG9l9WbiQIhzA3P+vgs0hB9ldZftLeRPqyIwfkjW4NxoHQUoZUGP5iFFc56YNWdjU4X7I99YbQoC0pr4Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqum5UO3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqum5UO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597551F000E9;
	Thu, 20 Aug 2026 17:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248055;
	bh=muWIGnKq7LNfLDioPXIMLN/L1NblN9Jpq+5Wlksekfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lqum5UO341M15lGtjxEP9rgmNK9M7G5oQ+3GS7pH5PpyFfvhZPLGygSP7MXGmJPtG
	 S5sWolE5qb2YlTLipgRBooZItG8xOVauTb55nfhuiVNY6+Gwdxw103biEpDPKzS53O
	 w8vBKnOzLhQRPyuVCXBodf2DQuH8UxI0J4HWZI1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Hendrik Brueckner <brueckner@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/303] s390/cpum_cf: move cpum_cf_ctrset_size()
Date: Thu, 20 Aug 2026 16:53:50 +0200
Message-ID: <20260820145256.120139347@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 345d2a4dcdb7d0f33ebd990a19aeb3f3f458817d ]

Function cpum_cf_ctrset_size() is defined in one source file and the
only user is in another source file. Move this function to the source
file where it is used and remove its prototype from the header file.
No functional change.

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Hendrik Brueckner <brueckner@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 49145bce5391 ("s390/perf_cpum_cf: Add missing array_index_nospec() to __hw_perf_event_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/cpu_mcf.h        |    2 -
 arch/s390/kernel/perf_cpum_cf.c        |   47 +++++++++++++++++++++++++++++++++
 arch/s390/kernel/perf_cpum_cf_common.c |   46 --------------------------------
 3 files changed, 47 insertions(+), 48 deletions(-)

--- a/arch/s390/include/asm/cpu_mcf.h
+++ b/arch/s390/include/asm/cpu_mcf.h
@@ -105,8 +105,6 @@ static inline int stccm_avail(void)
 	return test_facility(142);
 }
 
-size_t cpum_cf_ctrset_size(enum cpumf_ctr_set ctrset,
-			   struct cpumf_ctr_info *info);
 int cfset_online_cpu(unsigned int cpu);
 int cfset_offline_cpu(unsigned int cpu);
 #endif /* _ASM_S390_CPU_MCF_H */
--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -112,6 +112,53 @@ static void cfdiag_trailer(struct cf_tra
 	te->timestamp = get_tod_clock_fast();
 }
 
+/*
+ * Return the maximum possible counter set size (in number of 8 byte counters)
+ * depending on type and model number.
+ */
+static size_t cpum_cf_ctrset_size(enum cpumf_ctr_set ctrset,
+				  struct cpumf_ctr_info *info)
+{
+	size_t ctrset_size = 0;
+
+	switch (ctrset) {
+	case CPUMF_CTR_SET_BASIC:
+		if (info->cfvn >= 1)
+			ctrset_size = 6;
+		break;
+	case CPUMF_CTR_SET_USER:
+		if (info->cfvn == 1)
+			ctrset_size = 6;
+		else if (info->cfvn >= 3)
+			ctrset_size = 2;
+		break;
+	case CPUMF_CTR_SET_CRYPTO:
+		if (info->csvn >= 1 && info->csvn <= 5)
+			ctrset_size = 16;
+		else if (info->csvn == 6 || info->csvn == 7)
+			ctrset_size = 20;
+		break;
+	case CPUMF_CTR_SET_EXT:
+		if (info->csvn == 1)
+			ctrset_size = 32;
+		else if (info->csvn == 2)
+			ctrset_size = 48;
+		else if (info->csvn >= 3 && info->csvn <= 5)
+			ctrset_size = 128;
+		else if (info->csvn == 6 || info->csvn == 7)
+			ctrset_size = 160;
+		break;
+	case CPUMF_CTR_SET_MT_DIAG:
+		if (info->csvn > 3)
+			ctrset_size = 48;
+		break;
+	case CPUMF_CTR_SET_MAX:
+		break;
+	}
+
+	return ctrset_size;
+}
+
 /* Read a counter set. The counter set number determines the counter set and
  * the CPUM-CF first and second version number determine the number of
  * available counters in each counter set.
--- a/arch/s390/kernel/perf_cpum_cf_common.c
+++ b/arch/s390/kernel/perf_cpum_cf_common.c
@@ -156,52 +156,6 @@ static int cpum_cf_offline_cpu(unsigned
 	return cpum_cf_setup(cpu, PMC_RELEASE);
 }
 
-/* Return the maximum possible counter set size (in number of 8 byte counters)
- * depending on type and model number.
- */
-size_t cpum_cf_ctrset_size(enum cpumf_ctr_set ctrset,
-			   struct cpumf_ctr_info *info)
-{
-	size_t ctrset_size = 0;
-
-	switch (ctrset) {
-	case CPUMF_CTR_SET_BASIC:
-		if (info->cfvn >= 1)
-			ctrset_size = 6;
-		break;
-	case CPUMF_CTR_SET_USER:
-		if (info->cfvn == 1)
-			ctrset_size = 6;
-		else if (info->cfvn >= 3)
-			ctrset_size = 2;
-		break;
-	case CPUMF_CTR_SET_CRYPTO:
-		if (info->csvn >= 1 && info->csvn <= 5)
-			ctrset_size = 16;
-		else if (info->csvn == 6 || info->csvn == 7)
-			ctrset_size = 20;
-		break;
-	case CPUMF_CTR_SET_EXT:
-		if (info->csvn == 1)
-			ctrset_size = 32;
-		else if (info->csvn == 2)
-			ctrset_size = 48;
-		else if (info->csvn >= 3 && info->csvn <= 5)
-			ctrset_size = 128;
-		else if (info->csvn == 6 || info->csvn == 7)
-			ctrset_size = 160;
-		break;
-	case CPUMF_CTR_SET_MT_DIAG:
-		if (info->csvn > 3)
-			ctrset_size = 48;
-		break;
-	case CPUMF_CTR_SET_MAX:
-		break;
-	}
-
-	return ctrset_size;
-}
-
 static int __init cpum_cf_init(void)
 {
 	int rc;


