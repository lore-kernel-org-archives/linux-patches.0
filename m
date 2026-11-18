Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053465;
	b=gA0cah3Tet1gWprPifHRbNlxfpN8f4OJLVYHCXbabXoH092/l8go3NyGpCOOdWDTkKB6
	 UFJoyBM4VmRJVeRx52LOXkme95mYHw7Dyv4IY+mqvmqae34VBl5P8bRncWp2TK9rM7/UV
	 XzpYXIvdJVb/Kv287FSLJZNwwNJNwKwMYH+pWiorffr+uXpiKTQ6doAVdPxVrSSwsl5qr
	 Ic9ulToBBCTAhHla6qiGjHbtQ7F7PQwtUGWGUEAnpC1uxt3KhFGE321IBPWJdmiLA0HQt
	 j0zuAdsJeEJ7/NHFL3OFXoFk/ZhPqBiqFKNgY3q1odrFYwn59TSN/eHosfrNVrOeikw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053465;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2g33p4N75ekJoyalUOTumb2ksM0/19JPcMS2mk+HUb8=;
	b=p5VFMaxotqWJFiNrb57q9GtUWG7ICOBVDIbQ69JRH9iuicDsh3XRFoxiKtgxy2haGkoD
	 caHNK32O4Sbb1mKw2znvzawuiGvgNNZ8y+rkKoLsTvc0H6roztNAiQMxqbhs8fRB4wDLL
	 5t0BuLxJPu/Rgv9I6o90XCU26d9Cx7cqowO6U8u4b2eBJXo7IGngrZDsZ1BKK+BoXyaY2
	 lMWSTw1NxonlPj2YVcY7PiUd04yO2bLZ9Tg/DPsFox4qDB7+7CmIYvNhAfNEeqVDDX/cx
	 6WnrpYct52qRd2KC2kRhA9vwNkX2GmMPm8rIwcevBtjkcUnOuXbE9ouwuntYAYnzNzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W9mecRAn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9DF606A31C;
	Thu, 19 Nov 2026 01:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W9mecRAn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F321F000C4;
	Thu, 19 Nov 2026 01:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053465;
	bh=2g33p4N75ekJoyalUOTumb2ksM0/19JPcMS2mk+HUb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W9mecRAnf2Qs5VbUn9R7kJVJB5OwxsmMYMnj0WAocJOQt5HiLW7i4xULwSeh6KQ6k
	 qMQrWdGCNvecQIRDXBtEQyNdLZJUu7Ed6ruK4E+xos7k6JNDnkhdnXAKMizvSPx93e
	 Y0uKVe5EFH/QNw910h+gOHfpDUkwyiRTEwiotuqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0928/2214] x86/nmi: Ignore negative NMI handler durations
Date: Wed, 18 Nov 2026 15:43:24 +0100
Message-ID: <20261118150049.479818210@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit ade63af6cfb7b3ca19ced28730fd6461e8d1d410 ]

I am seeing NMI handlers in the Meta fleet reported as running for
about 584 years. Over 30 days, 11 AMD and Intel machines logged 637
such lines, for example:

  AMD EPYC 9D25 (family 0x1a, model 0x11, stepping 0x0):
  [ 1650.616627] INFO: NMI handler (nmi_cpu_backtrace_handler.llvm.9643156322683129580) took too long to run: 18446744073709.551 msecs

  Intel Xeon Platinum 8321HC (family 0x6, model 0x55, stepping 0xb):
  [360448.230129] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 18446744071018.936 msecs

  Intel Xeon D-2191A (family 0x6, model 0x55, stepping 0x4):
  [81787.188959] INFO: NMI handler (ghes_notify_nmi) took too long to run: 18446744073709.545 msecs

nmi_handle() times each handler with two sched_clock() reads. When the
second read is lower than the first, the u64 subtraction wraps, and
nmi_check_duration() treats the result as a duration. In the three
examples, the clock went back by less than 1 us, by 2.7 s and by about
6 us.

The wrapped value is also stored in action->max_duration. Every later
real duration is smaller, so the handler is never reported again until
the next boot.

Whatever makes the clock read lower, a negative difference is not a
duration, so return before it is stored or reported. A clock that steps
forward is not covered, since that cannot be told from a real stall.

A backwards clock is still worth knowing about, so print the size of
the step once per boot. This uses pr_warn_once() rather than WARN, as a
stack trace says nothing about the clock and panic_on_warn machines
should not go down for it.

Fixes: 2ab00456ea8a ("x86: Warn when NMI handlers take large amounts of time")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261027-nmi_negative-v1-1-b436a005eb8a@debian.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/nmi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index a858d8e5d6104..57656085fede8 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -109,6 +109,14 @@ static void nmi_check_duration(struct nmiaction *action, u64 duration)
 {
 	int remainder_ns, decimal_msecs;
 
+	/* sched_clock() went backwards? */
+	if ((s64)duration < 0) {
+		pr_warn_once("NMI handler (%ps): sched_clock() went backwards by %lld ns on CPU%d\n",
+			     action->handler, -(s64)duration,
+			     smp_processor_id());
+		return;
+	}
+
 	if (duration < nmi_longest_ns || duration < action->max_duration)
 		return;
 
-- 
2.53.0



