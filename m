Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215804;
	b=1/ePSJHvn6EZhj3JYgMPaDTvzMYor1OFsUcYX3ksEkdjP+IBkg2ORKRzs5xpJjns82fl
	 hIJaN9FV+APQ5tr9+KGiaRmscZ61q2Yxfai/7JoMlNro9k6xu+RFGLNgS6iBS69p8p7rj
	 4k7YktNGvzQlOTHJ2Eh6zpUivt+6Vb1Oh5hGw6jkO6Rp40ItevhOhl5abvCOjfrPIqhAD
	 4gYeFQCNsbBntvJqDJoqWKnt+KLi7ztiaQH2ImZFjh+lkIWpgnMpvihfH7pVCjXAb4ZVY
	 o0Qx4tepI9HYYzrM/80y3f/uG9oYnBD+DVsgAWLs+vlymWKeZfAgSs0oaFs8MLijS9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215804;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+56jrgDzX+aYQJtvpW64iwavfQ97EXUgIgS9Hr98T1E=;
	b=rXP4rf8QVYtnUUHnSc5wYK4hh+tLuWnWyD5hrO7y0uB3Nk5p0hb4pxvXYEX+Iqhm+SC7
	 KjOc1vMXlVBrP4qnYghsqCXxvN4kw+GVNmnILUUMDetsW74Kn32cWFqoh4kGtSMzDzkt7
	 k7DvdF5BIWMVo3/3EufR7HmAkL6T5ANxtTDLBOzUB9h+HiIqxV1mWV3JkSQva08fgVUl/
	 BR3HuKn44zbZm6FOHoriDs+o/lR0fZraFKts8/zitWAe1pdv/x1YbT3ZxmGveLebYJqzV
	 c2YYIgIYxn4+N9GwcVe7Q/4srB27l0E6GPrBb6Ymk8qSuDDHa7zGy045POnbgdsbjLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="OKH/EoGx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A1B606A321;
	Wed, 28 Oct 2026 19:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OKH/EoGx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398C81F01825;
	Wed, 28 Oct 2026 19:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215803;
	bh=+56jrgDzX+aYQJtvpW64iwavfQ97EXUgIgS9Hr98T1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OKH/EoGxJFb5kst2lBqCDxpt01Yl0W+MUlq5AvECbKDBF4ww1/NZPgqyXyn2Py6Jh
	 2gY6GqBTcxIJWjUa0MtaMHBIRGwr7SZ2A1KifEBLtjlV9GxU47lHqJgG0Mb9rlKZya
	 LzlAo9ZCrFJ14nJj6zo6npHAysWa5Cpi50cYZqoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1338/1887] s390/cpum_sf: move functions from header file to source file
Date: Wed, 28 Oct 2026 17:57:14 +0100
Message-ID: <20261028170529.884629950@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit a64e45c2ea62d9622bcebb586f359ea95f0a5152 ]

Some inline helper functions are defined in a header file but used
in only one source file. Move these functions to the source file.
No functional change.

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 7f40b346462f ("s390/dasd: Fix undersized format-check buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/cpu_mf.h  | 53 ---------------------------------
 arch/s390/kernel/perf_cpum_sf.c | 52 ++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 53 deletions(-)

diff --git a/arch/s390/include/asm/cpu_mf.h b/arch/s390/include/asm/cpu_mf.h
index efa103b52a1a1..7e417d7de5689 100644
--- a/arch/s390/include/asm/cpu_mf.h
+++ b/arch/s390/include/asm/cpu_mf.h
@@ -42,7 +42,6 @@ static inline int cpum_sf_avail(void)
 	return test_facility(40) && test_facility(68);
 }
 
-
 struct cpumf_ctr_info {
 	u16   cfvn;
 	u16   auth_ctl;
@@ -275,56 +274,4 @@ static inline int lsctl(struct hws_lsctl_request_block *req)
 
 	return cc ? -EINVAL : 0;
 }
-
-/* Sampling control helper functions */
-
-#include <linux/time.h>
-
-static inline unsigned long freq_to_sample_rate(struct hws_qsi_info_block *qsi,
-						unsigned long freq)
-{
-	return (USEC_PER_SEC / freq) * qsi->cpu_speed;
-}
-
-static inline unsigned long sample_rate_to_freq(struct hws_qsi_info_block *qsi,
-						unsigned long rate)
-{
-	return USEC_PER_SEC * qsi->cpu_speed / rate;
-}
-
-/* Return TOD timestamp contained in an trailer entry */
-static inline unsigned long long trailer_timestamp(struct hws_trailer_entry *te)
-{
-	/* TOD in STCKE format */
-	if (te->header.t)
-		return *((unsigned long long *) &te->timestamp[1]);
-
-	/* TOD in STCK format */
-	return *((unsigned long long *) &te->timestamp[0]);
-}
-
-/* Return pointer to trailer entry of an sample data block */
-static inline unsigned long *trailer_entry_ptr(unsigned long v)
-{
-	void *ret;
-
-	ret = (void *) v;
-	ret += PAGE_SIZE;
-	ret -= sizeof(struct hws_trailer_entry);
-
-	return (unsigned long *) ret;
-}
-
-/* Return true if the entry in the sample data block table (sdbt)
- * is a link to the next sdbt */
-static inline int is_link_entry(unsigned long *s)
-{
-	return *s & 0x1ul ? 1 : 0;
-}
-
-/* Return pointer to the linked sdbt */
-static inline unsigned long *get_next_sdbt(unsigned long *s)
-{
-	return (unsigned long *) (*s & ~0x1ul);
-}
 #endif /* _ASM_S390_CPU_MF_H */
diff --git a/arch/s390/kernel/perf_cpum_sf.c b/arch/s390/kernel/perf_cpum_sf.c
index 96fd3654abda4..33550d9cecf50 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -22,6 +22,7 @@
 #include <asm/irq.h>
 #include <asm/debug.h>
 #include <asm/timex.h>
+#include <asm-generic/io.h>
 
 /* Minimum number of sample-data-block-tables:
  * At least one table is required for the sampling buffer structure.
@@ -99,6 +100,57 @@ static DEFINE_PER_CPU(struct cpu_hw_sf, cpu_hw_sf);
 /* Debug feature */
 static debug_info_t *sfdbg;
 
+/* Sampling control helper functions */
+static inline unsigned long freq_to_sample_rate(struct hws_qsi_info_block *qsi,
+						unsigned long freq)
+{
+	return (USEC_PER_SEC / freq) * qsi->cpu_speed;
+}
+
+static inline unsigned long sample_rate_to_freq(struct hws_qsi_info_block *qsi,
+						unsigned long rate)
+{
+	return USEC_PER_SEC * qsi->cpu_speed / rate;
+}
+
+/* Return TOD timestamp contained in an trailer entry */
+static inline unsigned long long trailer_timestamp(struct hws_trailer_entry *te)
+{
+	/* TOD in STCKE format */
+	if (te->header.t)
+		return *((unsigned long long *)&te->timestamp[1]);
+
+	/* TOD in STCK format */
+	return *((unsigned long long *)&te->timestamp[0]);
+}
+
+/* Return pointer to trailer entry of an sample data block */
+static inline unsigned long *trailer_entry_ptr(unsigned long v)
+{
+	void *ret;
+
+	ret = (void *)v;
+	ret += PAGE_SIZE;
+	ret -= sizeof(struct hws_trailer_entry);
+
+	return (unsigned long *)ret;
+}
+
+/*
+ * Return true if the entry in the sample data block table (sdbt)
+ * is a link to the next sdbt
+ */
+static inline int is_link_entry(unsigned long *s)
+{
+	return *s & 0x1UL ? 1 : 0;
+}
+
+/* Return pointer to the linked sdbt */
+static inline unsigned long *get_next_sdbt(unsigned long *s)
+{
+	return (unsigned long *)(*s & ~0x1UL);
+}
+
 /*
  * sf_disable() - Switch off sampling facility
  */
-- 
2.53.0



