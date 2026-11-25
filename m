Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623163;
	b=Ol2s8kMt77d+AKrlq1SAA9RJh/nWCVCwsWSTjYHOuMGCV2Zr32hBDcTM+Mz/Eb1op+MT
	 YFSNi9L3/wHFLvHcKRHBOFDs3wbPmpWzQjXR52D3j8BiFe7s8bldk+0Js4Q4OlB6Ze0Vk
	 nX5R4A8qOIeiRpH1cedg/msTUnptZpYt6heqtuV7Is/dvohJIWOfEawA7+7Sjfj16hCw0
	 VMEBhCrpSvgvThwAPCYvM5NZ5gl1XkxLt18iltJ7Kh+mNM26Sc1SIch5xgeoGg6srk9Ud
	 wLRzVGICdv9go+BF3Q6l2dDgXSnhea+KFgqlP4OWxe2p0ItamDkXJUMklHGN+8CBFzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lwdDNxj/5T9A+PiqzrCJXPfUdWCiXBG3uRjzB6FLHi4=;
	b=t5hld8ZGDSU8k9uNJqwni39QGERLREJ6Tbij299NnqK7IMj+mJrT7u2nj04o7KWjUOOo
	 Up+4RcEaembUauzd4peD99Or+bsLVZLlZsSB0XM1eKY6BnaJSELEXlO9SyEo0CI6d0ssU
	 JhUygA/s5BRsDWLkHogEF9+uke4/NtDEzKpUtEKyrruX6H6Z2cZnynKWCc/hat50VMS8B
	 bnqJCW/1o6WGTdIzGAa9WYBgm17BOmiGq7vWO4rmag4/H3/WA9iDPKATgTIkgICtX1wHY
	 34XFUZJIAVp5c/k9eXdB/qMyyHulyG9LjmSFfFfx2UBt1b3Zm9uzz8b6H7Qx3wSsx1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PRcay82d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2EA606A326;
	Wed, 25 Nov 2026 16:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PRcay82d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8CB1F000C0;
	Wed, 25 Nov 2026 16:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623162;
	bh=lwdDNxj/5T9A+PiqzrCJXPfUdWCiXBG3uRjzB6FLHi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PRcay82dq8Y3r61vzx8fhB7aJM3BvXhdEz2kPXrZrPQqNk/zW8ft55S0NzY/aeGNV
	 7AJkZCdZQloGh+dPCb8rv6ES3m5A4qqt/zLczbDj/Sj+6F3ROa4FJVp2LFqrkYOXA1
	 NuvKYaoijgyt6ahzo/mkgoXhP3q11NcvBR2x6AQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.18 770/990] x86/mm: Ensure write visibility during LDT installation
Date: Wed, 25 Nov 2026 15:35:37 +0100
Message-ID: <20261125143840.091805797@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Dave Hansen <dave.hansen@linux.intel.com>

commit 0dc2a4dac3d04e9e4479aeb0b46172feab1cca0a upstream.

During LDT installation, the intent is to overwrite the old per-mm
LDT value, then send an IPI to the mm user CPUs to have each load
the new value.

But there is an ordering problem: a new mm user CPU sets itself in
mm_cpumask() and then reads mm->context.ldt. The LDT-installing CPU
writes mm->context.ldt and then reads mm_cpumask(). But, there is
nothing which orders the LDT installation side actions. The CPU
can read mm_cpumask() before its write becomes visible.

Ensure that new mm user CPUs see the new mm->context.ldt. Make
mm->context.ldt visible before reading mm_cpumask().

Also convert the smp_store_release() over to a WRITE_ONCE().
smp_store_release() has an internal barrier which is weaker than
the new smp_mb(). Avoid an extra barrier by converting it to
WRITE_ONCE().

Also refresh/correct misleading comments. READ/WRITE_ONCE() do not
"synchronize" anything themselves.

Reported-by: Jaeyoung Chung <jjy600901@snu.ac.kr>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Jaeyoung Chung <jjy600901@snu.ac.kr>
Acked-by: Linus Torvalds <torvalds@linuxfoundation.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/ldt.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -43,7 +43,7 @@ void load_mm_ldt(struct mm_struct *mm)
 {
 	struct ldt_struct *ldt;
 
-	/* READ_ONCE synchronizes with smp_store_release */
+	/* Pairs with WRITE_ONCE() in install_ldt() */
 	ldt = READ_ONCE(mm->context.ldt);
 
 	/*
@@ -422,8 +422,14 @@ static void install_ldt(struct mm_struct
 {
 	mutex_lock(&mm->context.lock);
 
-	/* Synchronizes with READ_ONCE in load_mm_ldt. */
-	smp_store_release(&mm->context.ldt, ldt);
+	/*
+	 * Ensure that new mm user CPUs either see the new LDT value
+	 * or get an IPI. Make the store visible before reading
+	 * mm_cpumask(). New mm users make their mm_cpumask() writes
+	 * visible before reading mm->context.ldt.
+	 */
+	WRITE_ONCE(mm->context.ldt, ldt);
+	smp_mb();
 
 	/* Activate the LDT for all CPUs using currents mm. */
 	on_each_cpu_mask(mm_cpumask(mm), flush_ldt, mm, true);


