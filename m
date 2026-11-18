Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024417;
	b=BqzOGArxN3xRukHtANeWl0T2FK4wy6xzSaszH5csI1cbzTlUi0GadSgRtv9n7X/oCy3e
	 gY1IFjo61/Dxl2SiRtpPSjNFmqaLET3BG9c1pJPUDgCakzlc/+LQOc2VpbdPX0koNvGuA
	 SfVuqrNF08uWdT7psNJ/eBLeB8UJGNTQyD/m6tjls7kPLoPFGOvPEGCK5JNPWkFQHSov2
	 m6rblHA5zjOjOQsqRnoQIExZITCWbaCGywtZGl7QUfkrSXe4b/cbO3v7X3p+5E5lQWu99
	 ihh5aOqUPxODGZm9jsG04WIJMQ3Ca25QX8o7RSsYCnFE2dcw3UgNLmS1LiNr9/z9U7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=bWR0Hw/xRI4UppikuupQrVZ/xswp7witT9QOIF+RUO4=;
	b=S5CxXI8CPoXH6XHU+fMApCLq8KfqvR0jIDPi4vHwHhRHo0JwhIf2k6OVfiw7zB+ZsiP4
	 xrOIBQ7pHp59ZUGOixCJHDmvP5Srs9OXiVVVBO9QReNy+w2J82kNMKiJXopo6/3tZms8X
	 42WAmwpO3JybPWVUVWak8XqGDf7zEN53atfQs2k18hT5RSpAWE91l5GfoT0B7t9O6sGeq
	 1gVjHSisxPdeYuun4njLv3AcK/AFI0aZsGucR1bgMheLWh32chBWjggftorNfHMPeCQ+O
	 PR11Lent8Ey39Yo4qWZSEcVWMgjWZ0QTQxCE4Y7CqQtplS/t5vFoZtXOy9ET9FILyAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RNKz7ebe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC58606A325;
	Wed, 18 Nov 2026 17:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RNKz7ebe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84EA61F000C4;
	Wed, 18 Nov 2026 17:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024417;
	bh=bWR0Hw/xRI4UppikuupQrVZ/xswp7witT9QOIF+RUO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RNKz7ebeFmlCjRYa67IU9XWgUBtkph3y11n/4Sr3ubN6FwcTA1zPEmkesWwwN1tw/
	 GD3hHvz8NoZHrKgN6nwtwTrFSIX2wxP4ANn/ls4hYZDQCjoecfhU6gGIR8n2GuSPTh
	 u+Z+z67z/tZ+uZRQ7pZVjRt7+ifTumKfiGHRwNHQ=
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
Subject: [PATCH 6.18 0718/2151] powerpc/ftrace: Dont restore r13 during ftrace_regs_caller
Date: Wed, 18 Nov 2026 15:40:53 +0100
Message-ID: <20261118150148.053076747@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6599fe3c62347..5eb8eee32549d 100644
--- a/arch/powerpc/kernel/trace/ftrace_entry.S
+++ b/arch/powerpc/kernel/trace/ftrace_entry.S
@@ -220,7 +220,13 @@
 
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
 #if defined(CONFIG_LIVEPATCH_64) || defined(CONFIG_PPC_FTRACE_OUT_OF_LINE)
-- 
2.53.0



