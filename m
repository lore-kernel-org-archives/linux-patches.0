Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619891;
	b=SqmBBGFYfyDvHr4D40YB7799kWg4znkd+LH4mLNeCJGKpcRLkOfvdgp+9NI7kaZrl/WS
	 y6buzS0HiDa9zIln8IqsP3914FCU+XdsxEwn+PzFj+puLw483tbFwAj96/hnh7lwJ0k/n
	 axP7MG0N4iW/4uq/eujHGEFd4CRLmjGQIfBrTfrFZaKGz9D5dT+Zk9OT02X0UHYOlz0kp
	 y4gE1l9NzOQG0iJWXo+jkClEKMiX3fzaOhu9jD4dpGIqttUAnidXvO7GdQ6K9MVeedT80
	 dZGvrGusZ7LU7QGUiRkIgT0xq9D8g7t/ZtxdLS+xjTdUCOLV9KpEL2aL2Bhe7X6Exvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ae1OqPp+C8UCu1aq2zH2S21FDbosifBBQV3wlab+OzI=;
	b=yMp946tFQATWipv8iCLhjGSe8RnApV9Gk74efvj1RuLIQcc6LbQxxIxllNZND68O3l86
	 tJa5+QQHZ5m93V54IdYQuAmHcilgbLWwnS+4Un+ZrI7L5rtTe9HBM+EVKYGhFQuPq4mLy
	 zoqs3yxA+eRFb/ra2NH8Uml4Z5nabpJjSLZTTQEi1m7NMqFpxM+ByLkHRbut9DGj6pIp5
	 QKUNdsxZ88L5mGvrJFS5Qv+8PpqaJ7lCzvXl+i/P8rB3Pi64tTTRebYyhV1g3SOoSqKPw
	 T5d6+Pu3ijqr/qKpDQh6NHGVbSuVSGn61/q+kduFXqAyqv1jZcZNcluvkwV389NgKVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UcJzepoz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E547606A31E;
	Wed, 25 Nov 2026 15:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UcJzepoz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53C91F000CF;
	Wed, 25 Nov 2026 15:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619890;
	bh=ae1OqPp+C8UCu1aq2zH2S21FDbosifBBQV3wlab+OzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UcJzepozwH2q7KOSVycWxvvn1GupR0I3/ys/7dhTTgjQH9O2UNlAb/Y2uGaOL8gvb
	 Q3dt/2Z+d4lblNgQrZjOmeiHU7i0nZn0PLGsAsX2gkuw1opbjxemKL72y0OuyY8bwk
	 J3pCGK3O583R9qPlUQIZ4bLj1F5moLCdEtX+u7f4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 7.3 0738/1005] x86/mm: Ensure write visibility during LDT installation
Date: Wed, 25 Nov 2026 15:34:36 +0100
Message-ID: <20261125143839.045022980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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


