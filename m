Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5685C1F7587;
	Tue,  3 Dec 2024 14:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237713; cv=none; b=vE6EqQTNDIFhuQGEQ6lCUIAq2lpkPovRAdS0oXuSZWKrfh1Hhp0X92cYc/n2lHp3HIQPRfF4wSflwBosbmEWY5ydjZNZkaqbp6xA79ne75gaVMYm0T83JI0WlLHuQEX+iiLiXcqMvnB35HNjAOMzfxmoEuih04vMw0ADn9R2RIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237713; c=relaxed/simple;
	bh=b5yswftItLNH0NlyqxKjxWLDdEIG8vYwITiDAydC80s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/mEOglIrKt/1k2xAcx+oCfwUm0znmyzuY/jH91OLJcrHScSRj6+a/SHX4ZDKDS6N2rcOmHWN4xHzkHyMJokrzi2/N4yCOIaqmtbTYw2ibS5wZk/o0IB+Efv1khm+2fLjB/aiz5mzcguURJ8zCIB69c9XMSPcKCrmOhqC9OpnYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDE7JM6r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDE7JM6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C103C4CECF;
	Tue,  3 Dec 2024 14:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237712;
	bh=b5yswftItLNH0NlyqxKjxWLDdEIG8vYwITiDAydC80s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yDE7JM6rtlrW7neN8aeWrfcatikEk8jVtD5I3AG2tcdOnldZvP8WSXs+hHqVAteqO
	 t0l3JHK/KwRrECM3RF1gXI8HUG9oXs+QpcWUrriTFUshnTJ/IIt18YVqVN+OGvWgpE
	 D8cUqeavGLukgbGGk4hUb1orBhUnr0rTHLg2fjZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 049/817] s390/facilities: Fix warning about shadow of global variable
Date: Tue,  3 Dec 2024 15:33:41 +0100
Message-ID: <20241203143957.584547311@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerd Bayer <gbayer@linux.ibm.com>

[ Upstream commit 61997c1e947dbf8bc625ef86ceee00fdf2a5dba1 ]

Compiling the kernel with clang W=2 produces a warning that the
parameter declarations in some routines would shadow the definition of
the global variable stfle_fac_list. Address this warning by renaming the
parameters to fac_list.

Fixes: 17e89e1340a3 ("s390/facilities: move stfl information from lowcore to global data")
Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/facility.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/s390/include/asm/facility.h b/arch/s390/include/asm/facility.h
index 65ebf86506cde..48791a02cab1e 100644
--- a/arch/s390/include/asm/facility.h
+++ b/arch/s390/include/asm/facility.h
@@ -67,7 +67,7 @@ static inline int test_facility(unsigned long nr)
 	return __test_facility(nr, &stfle_fac_list);
 }
 
-static inline unsigned long __stfle_asm(u64 *stfle_fac_list, int size)
+static inline unsigned long __stfle_asm(u64 *fac_list, int size)
 {
 	unsigned long reg0 = size - 1;
 
@@ -75,7 +75,7 @@ static inline unsigned long __stfle_asm(u64 *stfle_fac_list, int size)
 		"	lgr	0,%[reg0]\n"
 		"	.insn	s,0xb2b00000,%[list]\n" /* stfle */
 		"	lgr	%[reg0],0\n"
-		: [reg0] "+&d" (reg0), [list] "+Q" (*stfle_fac_list)
+		: [reg0] "+&d" (reg0), [list] "+Q" (*fac_list)
 		:
 		: "memory", "cc", "0");
 	return reg0;
@@ -83,10 +83,10 @@ static inline unsigned long __stfle_asm(u64 *stfle_fac_list, int size)
 
 /**
  * stfle - Store facility list extended
- * @stfle_fac_list: array where facility list can be stored
+ * @fac_list: array where facility list can be stored
  * @size: size of passed in array in double words
  */
-static inline void __stfle(u64 *stfle_fac_list, int size)
+static inline void __stfle(u64 *fac_list, int size)
 {
 	unsigned long nr;
 	u32 stfl_fac_list;
@@ -95,20 +95,20 @@ static inline void __stfle(u64 *stfle_fac_list, int size)
 		"	stfl	0(0)\n"
 		: "=m" (get_lowcore()->stfl_fac_list));
 	stfl_fac_list = get_lowcore()->stfl_fac_list;
-	memcpy(stfle_fac_list, &stfl_fac_list, 4);
+	memcpy(fac_list, &stfl_fac_list, 4);
 	nr = 4; /* bytes stored by stfl */
 	if (stfl_fac_list & 0x01000000) {
 		/* More facility bits available with stfle */
-		nr = __stfle_asm(stfle_fac_list, size);
+		nr = __stfle_asm(fac_list, size);
 		nr = min_t(unsigned long, (nr + 1) * 8, size * 8);
 	}
-	memset((char *) stfle_fac_list + nr, 0, size * 8 - nr);
+	memset((char *)fac_list + nr, 0, size * 8 - nr);
 }
 
-static inline void stfle(u64 *stfle_fac_list, int size)
+static inline void stfle(u64 *fac_list, int size)
 {
 	preempt_disable();
-	__stfle(stfle_fac_list, size);
+	__stfle(fac_list, size);
 	preempt_enable();
 }
 
-- 
2.43.0



