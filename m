Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07460476CFA;
	Thu, 20 Aug 2026 17:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248060; cv=none; b=htgfALf01k98agSmrnvUs2pW2WfApA5NpzXiMAehEL0IZ2MmhnFZNmAdW0qxXMWP/gVegmc/FJDdgr6jn2Nb/r7f6OiInWT9UUJeOo8GfzLLE9ck9rB4u1FQtdccOXYLjz+66EcoFk3kEBpsVKb2PJcf7jhdDQ65Krts5bajBjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248060; c=relaxed/simple;
	bh=bkLt6B7uudWVPuehtw4Urs8ttL6qcSOyWTAS93rSeNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RnmI+6laCXJsu6ZQ16KYT+S3n5MXCdSzcUsZBLLAIh3nAgl8/Vgro+v5Z+VUUt7KiqomyIYYsrqqf7U9XUVin4f9RDMd3VHpjYjn7SOHeGvNRWO6vFCQJsmNoXX5GeAi66WGxUTzT1N7Mvf/OkwAhNCC9sD34jhynXRAcgH6+Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4mTiQkd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4mTiQkd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BE81F000E9;
	Thu, 20 Aug 2026 17:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248058;
	bh=Y3gDEciRqdGx/Q8SQjYhHVQJ1EA2DSOAvIBA/kus/kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C4mTiQkdFGM3IL21/+dnO4TdTzSoZwrIEB5yon1xicZWKHqe/+EueVHoOP4jzPEYY
	 D+rchHVVDVu9cvsL73Ky+L+x+sGWfuE0Q0/m+VPyyW3DGZr76kAiLgXaC5j6C2s4S+
	 s8gtFkCJL7tdRh0fc5gtVkWPL76vaILkiXTskNnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Hendrik Brueckner <brueckner@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/303] s390/cpum_cf: move stccm_avail()
Date: Thu, 20 Aug 2026 16:53:51 +0200
Message-ID: <20260820145256.149258109@linuxfoundation.org>
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

[ Upstream commit 7a8f09ac1850b17ca0cc9e1e4d6621a64661347e ]

Function stccm_avail() is defined in a header file and the
only user is one single source file. Move this function to the source
file where it is also used and remove it from the header file.
No functional change.

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Hendrik Brueckner <brueckner@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 49145bce5391 ("s390/perf_cpum_cf: Add missing array_index_nospec() to __hw_perf_event_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/cpu_mcf.h |    6 ------
 arch/s390/kernel/perf_cpum_cf.c |    6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/s390/include/asm/cpu_mcf.h
+++ b/arch/s390/include/asm/cpu_mcf.h
@@ -99,12 +99,6 @@ static inline void kernel_cpumcf_end(voi
 	preempt_enable();
 }
 
-/* Return true if store counter set multiple instruction is available */
-static inline int stccm_avail(void)
-{
-	return test_facility(142);
-}
-
 int cfset_online_cpu(unsigned int cpu);
 int cfset_offline_cpu(unsigned int cpu);
 #endif /* _ASM_S390_CPU_MCF_H */
--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -821,6 +821,12 @@ static struct pmu cpumf_pmu = {
 	.read	      = cpumf_pmu_read,
 };
 
+/* Return true if store counter set multiple instruction is available */
+static inline int stccm_avail(void)
+{
+	return test_facility(142);
+}
+
 static int cfset_init(void);
 static int __init cpumf_pmu_init(void)
 {


