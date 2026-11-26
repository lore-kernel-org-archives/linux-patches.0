Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705494;
	b=fncSj+oReziNt38NfqKw7FODyIlYvRBH4K8PEbyyupd1V7t0g/du6NotzTbAfDuA/zYu
	 ceGEaaERj6e397t89kbXiPwTUtOrEuO60KIynyrNvmnaADYTxZeipRX9pbXlZCudgrgOT
	 yMmCl0Q1LNkZxecOj12Kuj+mOyH9i+AItIQO0o6+V0V7oJPe/J2Ed6V4RIRIiAVAQcWM5
	 UVYrbMtuPo7uSTIchcYXUm3DwPbi5yzeyT+8gb+/st9JbvqhoxbFhWYc5xjtrNK4GfRaa
	 nRO8KZuyC/2yvNyEqJuE57HPvfvmaWZlSoeyB5fc0l77/3p/kV3EBdna/D6+vqWzJAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CNDm1fZjsTU//Iewfq2/EmdO0bRtbLYJpzs8L4QYo+I=;
	b=nchZ+X1oG5+uBDUW0o4hcQIl2mVf0XhBLc2kdOgBWRd1V63qX0XEkJ2lVSccdolXXQ8v
	 y+IVJvhiGQ6o3D/s9FnAzRBLGtHrJQY7/1sYwpfONYRE5mJCzylN0KULK4hLOEgyjQgzG
	 gZxVvdrGxv6/BYYFZMa+tMXxrgWuqSHJEJFu8NIxqrA8BaoUuSz7lsnMHfF+ZRB/bZFq9
	 O6iGT/3BSi8eiwrIjqIKQO227H6MbSPDyZPt1QU1lch7uBrXyazu32BgaT7myBgCRKgT1
	 hoJOZ6+a5bqJCh5dsH+57xE9YvTPAyC6rQi7OBw2jIJSbMbHhBk9n4jpUOWfhkrdfRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yxmP7Zds;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD8E606A329;
	Thu, 26 Nov 2026 15:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yxmP7Zds
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74DBB1F000E0;
	Thu, 26 Nov 2026 15:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705493;
	bh=CNDm1fZjsTU//Iewfq2/EmdO0bRtbLYJpzs8L4QYo+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yxmP7ZdsFB6OCSPVRaOKu9KNQjmECNRk1O43jVPlQMC6FcXQ68dQbvb0ju1jLymeO
	 bgMem0QFpnRJrPe2UprgT9Zr0yTyuUAPnwXCDGU66P7pblRooIwYzuKWpI1/kfRMjE
	 BEn9DOMSyioRiFYiBnVJGTNqq/SOX1oMdPOjlFFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.15 215/319] x86/mm: Ensure write visibility during LDT installation
Date: Thu, 26 Nov 2026 15:39:43 +0100
Message-ID: <20261126144011.599198962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -420,8 +420,14 @@ static void install_ldt(struct mm_struct
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


