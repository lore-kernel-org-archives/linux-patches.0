Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9A21FCF72;
	Tue,  3 Dec 2024 15:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240131; cv=none; b=BVoibvuM1ZZ/nPtRjqt4/p9isamDIvoZ/FOVoZzn/y+L4ps3WJdVTWWRSLoOaW/MItgcvZmk3rdU/+eULbazDUuYkf9P7QA4GSsAWtA6RMdDHHztekTnMrvy68s4Z2bSHmYjUXugFhK/g+f6pMS9sKLz9qqKzlH9SXAK3xeBrSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240131; c=relaxed/simple;
	bh=YKEcBRPbL08zVB+eghihwRrT1utGxznmLQyRlwQOqQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bn1IjqRdrCT7HL+3zB4nfm2FYXYHF9VrWYSC+BDJhl+cFKc9d6PkE6Pmvjxj+7kITT2jq3XiV/oxj+iZn6TpUAy9Qjv7BsU3AzeaasKK2hYrHNhMkba2enO3Nl58xU95aleVbeIGnn0SaieUUygNu+wvRHLQO7prmhwj/bHKGqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c08tLfuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c08tLfuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C96C4CECF;
	Tue,  3 Dec 2024 15:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240131;
	bh=YKEcBRPbL08zVB+eghihwRrT1utGxznmLQyRlwQOqQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c08tLfuCV+g0rfiL592mMU9Lrhn/oQpcH8sz3EEHUcaMeo/g+3GFE6lTvTSqIm1ai
	 taGCwwhfSWO/5Ku9+LhBh03CeMsBhpcqJkvvqrmbxRa2EbDBUNtg2TSMKAycvghb6C
	 22GbU6rhf1V2oQaR2xjCA2+s7iaYehl7gHJznHk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/826] s390/facilities: Fix warning about shadow of global variable
Date: Tue,  3 Dec 2024 15:35:31 +0100
Message-ID: <20241203144743.615942614@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 715bcf8fb69a5..5f5b1aa6c2331 100644
--- a/arch/s390/include/asm/facility.h
+++ b/arch/s390/include/asm/facility.h
@@ -88,7 +88,7 @@ static __always_inline bool test_facility(unsigned long nr)
 	return __test_facility(nr, &stfle_fac_list);
 }
 
-static inline unsigned long __stfle_asm(u64 *stfle_fac_list, int size)
+static inline unsigned long __stfle_asm(u64 *fac_list, int size)
 {
 	unsigned long reg0 = size - 1;
 
@@ -96,7 +96,7 @@ static inline unsigned long __stfle_asm(u64 *stfle_fac_list, int size)
 		"	lgr	0,%[reg0]\n"
 		"	.insn	s,0xb2b00000,%[list]\n" /* stfle */
 		"	lgr	%[reg0],0\n"
-		: [reg0] "+&d" (reg0), [list] "+Q" (*stfle_fac_list)
+		: [reg0] "+&d" (reg0), [list] "+Q" (*fac_list)
 		:
 		: "memory", "cc", "0");
 	return reg0;
@@ -104,10 +104,10 @@ static inline unsigned long __stfle_asm(u64 *stfle_fac_list, int size)
 
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
@@ -116,20 +116,20 @@ static inline void __stfle(u64 *stfle_fac_list, int size)
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



