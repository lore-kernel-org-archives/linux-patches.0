Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625783;
	b=FryR6eTJaSAgacXXBuQkV4qKqI0JNHgFWZkDRYFv/2ER5gDNVmFUvWIJOaeeXzRTecn8
	 lJu/aZNCZnIbVFeInobFd6Y6xChx/faEbwb7lPHxU6puub58fg9z/NROcHOVpE1HvM/WK
	 LQ6Mq+uWemtwm2Q20ni3Xfz39qLnTXpLB0BqTU1S9Hx3Q3aeQMg9dWf2OyTPTS/bCHpYO
	 fwI7FBoRY47rHpcgvtzDf+2O6dI0iNA+/emx0x7wyzbPU66Y+wOwKb0qtKVxFIPL9yg97
	 lwIZsE00x0O898WU4G5hL7vjzT9+f1xJ9+PmbcHDSYP7D+pRbQ6Lequ7LKMvnzbCKkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KfpOqPLaEmNXoAqb+0ut9UfC56FWFhLsl5JZ/hxYVDg=;
	b=XWlD6jUZzkhXVHOGvC+9LxsgmcehttmZ80WS+zQdkF74B1GG1qWS3vpmlKwwkd1hmcOg
	 nmstW3o9rlpkY/hHO/D3a2uBt8v61i6xzKg6EQSmnYqsYCcGbtAVFqFk6K4XR5ZJtowfq
	 7E8DLOlcB6oTuufnXefqHdVn9yPLlsbzxRlfDSwsNpBVUFNTGLlKsg0CXjlvS6As737lI
	 Gdy9AQVRMfQMkDD0uh7z4NhCXSnx2u1R+htfmsSe1tBTotfAuym/wSOnPIMSl7qozgVi2
	 AVVzoxRorSxFsHSXM4VSfBgRmn1fGVdPpj9hE6CLZ5hIxhEWGpWtW18541dBAsNqaCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="l/hg6sfr";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004EA606A321;
	Wed, 25 Nov 2026 16:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l/hg6sfr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B401F000CA;
	Wed, 25 Nov 2026 16:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625782;
	bh=KfpOqPLaEmNXoAqb+0ut9UfC56FWFhLsl5JZ/hxYVDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l/hg6sfr9PHqyAEgCJlMlOrImt+TxqSRMLYptA/qJSF7GE/2qw5LEtPt6E/Mi87pV
	 8f0x2GhnpleaRKOt6zc+h5w+tVURq7Zj3GwGhGiddnrJWS6JfyPjBowjRL1t6MzAqy
	 7Dv46+6qE5rcS4LlXvr1SRk2+a80hoDaoWVAYfi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.12 630/816] x86/mm: Ensure write visibility during LDT installation
Date: Wed, 25 Nov 2026 15:36:18 +0100
Message-ID: <20261125143903.767868828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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


