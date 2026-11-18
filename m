Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030096;
	b=1981qt1wuvmme6y/WztCz5+xIF0cdmG8ChwkWGorGSzQcdQt81BVnGRms/UMm4mfitPU
	 GVDj6gdsvWmb/6TKkBYynoRnqp/GjarH13XvUQeSjZDB0TOAQowTs4+Jy6sbXzvN/KoIY
	 UtvjoOhLnR6n3TqPig5kfXEnmHR/7s96JKHhgfuRriBQwvPJDp3N2sClRq+K07fURTi7q
	 0E3Nro3aMhPtTkamAuPP0wSZe7l8E0SIEmFdfiHXf/BgihEr3GtWty686RQsE2ZJHCPvu
	 eA4BIWcQ1DBGJuzF9y7tY9ZFs30GAFtHpx/0DLkcht6G5OmtDOfCWZT0u8PX1IvVguw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030096;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0gyE4yDcviyeO0F8nMZx0VGOmXeuh8+FFsGwUvceWOk=;
	b=qBpsL34oX6pm9VwlEJWS2Mb4P40RIdDZasFvJiv54/1dxAQVhLmNtcAcA3Vafc0yC51r
	 wzuPMHJz3dDtq+QKCIZIGirQDGLciBv+snyewQFKhvc74g+xwzFHiAoYSwXnalGvyEfJK
	 fNDD3MxBRcb6kFJErBXvNY8UD1qw6j0j3MCXjIx+96XH3P5Dyqn/U4LR5C3K2ULgQoHkA
	 41PJxcg/VwwjbhMHgAEzp2QvNLhiwcqOCieglHRkhDQjQeyOHk64aZdoTN+Lx28iEeEh9
	 pmtIOLQlXHO87X1/gRpbdlPAMSwWR1h6p4ygPja9//6dX14d8LCDhRcg+kr/Q3t9o0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W7iC0x9t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F237B60A6F47;
	Wed, 18 Nov 2026 19:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W7iC0x9t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0911F000CC;
	Wed, 18 Nov 2026 19:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030095;
	bh=0gyE4yDcviyeO0F8nMZx0VGOmXeuh8+FFsGwUvceWOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W7iC0x9tNKkxQMFdMXCWkz7conwKTWHZtsWvATc+rLglSK0zTK7M9gQhl0wVjuhwu
	 vvZPWfNGRZ8azz4IgUrLEq2R1zqOR2MqgvDzuP5swzAsSsPZrSNZETH7jxdlWXP/Fv
	 SUzkrMF0Tz8Hrrs6C/+Ll5sjHGRd19+v5oFDoee0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Such=C3=A1nek?= <msuchanek@suse.de>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Samir Mulani <samir@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0583/1756] powerpc/ftrace: Dont restore r13 during ftrace_regs_caller
Date: Wed, 18 Nov 2026 15:45:10 +0100
Message-ID: <20261118150032.241936593@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shrikanth Hegde <sshegde@linux.ibm.com>

[ Upstream commit af5f0870883ae4aea7f668d06cbb7ad0e12824c8 ]

Michal reported a stack-protector failure and subsequent panic when
running kernel builds. This was observed with full/lazy preemption.
Initially it was suspected as KVM, but later turned out to be due
to a bcc tool running in parallel.

Issue was recreated using a bcc tool.
For example, running below in parallel leads to crash.
./funccount sched* -d 100 and make -j 64

The same crash was observed when running kprobe for schedule() function,
while simpler function tracer for schedule() didn't cause the crash.
This helped to narrow it down to ftrace backed kprobes area.

The crash occurs as follows:

ftrace_regs_caller entry on CPU A
    |
    +-> save r13 = CPU A PACA into pt_regs
    |
    +-> call kprobe_ftrace_handler()
            |
            +-> ftrace_test_recursion_unlock()
                    |
                    +-> preempt_enable
                    +-> task can schedule and migrate to CPU B
                    +-> task resumes with live r13 = CPU B PACA
    |
    +-> REST_GPRS(2, 31)
            |
            +-> restore saved r13 = CPU A PACA
    |
    |-> The task then continues running on CPU B with r13 pointing
    |   to CPU A's PACA.

The stack-protector canary is accessed through the PACA. After the task
migrates, CPU A may run a different task and update its PACA with that
task's canary. Restoring the saved r13 then causes the migrated task's
saved stack canary to be compared against the canary in CPU A's PACA,
resulting in a stack-protector failure.

Similarly, current is resolved through the PACA. With a stale r13,
preempt_count() can access the state of the task referenced by CPU A's
PACA instead of the task running on CPU B. This results in corrupted
preempt-count warnings and scheduling-while-atomic failures.

This path for example is called when using kprobes and parallel kernel
builds can cause preemptions during ftrace_test_recursion_unlock.

Do not restore r13 from the saved register frame. If the task did not
migrate, the live r13 already has the saved value. If it migrated, the
live r13 contains the correct PACA pointer for the CPU on which the task
resumed.

On PPC32, r13 is regular register. So do this fix only for PPC64

Fixes: 153086644fd1 ("powerpc/ftrace: Add support for -mprofile-kernel ftrace ABI")
Reported-by: Michal Suchánek <msuchanek@suse.de>
Closes: https://lore.kernel.org/all/aqKfsVArHHaIK6M9@kunlun.suse.cz/
Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Reviewed-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Tested-by: Samir Mulani <samir@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260921072151.35531-1-sshegde@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/trace/ftrace_entry.S | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/kernel/trace/ftrace_entry.S b/arch/powerpc/kernel/trace/ftrace_entry.S
index 76dbe9fd2c0f2..e662b2c9ed257 100644
--- a/arch/powerpc/kernel/trace/ftrace_entry.S
+++ b/arch/powerpc/kernel/trace/ftrace_entry.S
@@ -129,7 +129,13 @@
 
 	/* Restore gprs */
 	.if \allregs == 1
+#ifdef CONFIG_PPC64
+	REST_GPRS(2, 12, r1)
+	/* Do not restore a stale PACA pointer if the task migrated */
+	REST_GPRS(14, 31, r1)
+#else
 	REST_GPRS(2, 31, r1)
+#endif
 	.else
 	REST_GPRS(3, 10, r1)
 #ifdef CONFIG_LIVEPATCH_64
-- 
2.53.0



