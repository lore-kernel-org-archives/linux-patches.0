Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040279;
	b=qwFUL/rw9LH7To6iLQhQeBlkKIAVIzOyaknatDhBiiKEKBMjordWl3TVnI3BDRXHcM0l
	 ++IWzBTvGEDYotBS7NI5BLERAmSOfnNU3acPBTho6/51q17qlIMKqJjqyos4HcqD5K2+f
	 PNNMXx7yl4Eymh9s1O/2VnSi8XANIM12U1jdC6PlQZHxD7j6/NTmr0u6g6VpL4hgqXhPK
	 dlda4EY7I5M1U4lxRcdBDbjGsWUjtDYnnfoOsrhja2fM73V/hPovTIaVZJDOMVLDQ7UJs
	 ooddbc75N2nqskbjIt8yCy6AEsfD+5/A4qHuUZAER3g1iQ7y37ah3u2K6FP0RC/NYGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040279;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pkmJg+0cUhjURDrLlGsukQvafa8PpCuEX/6mm26umWM=;
	b=NST7RgEErRRtWx3dQthEIXaNebTlW7mwr4gZE68pM1pjV0+O7XSnMobxZ7LQ24jd2VXb
	 bVuoM0t68h2Oo0F0BoVhLWtVf/6KSjPHAzCLDKe1mf1Y7/uWxVr19nSRFsJBpNFKUhKiq
	 mVBiWDYf3+Jf8aEMsIxkrF3qfRTT+pA0NoLy+RJMIxh+nVzg0x6GA6+OjaTrkGZqKaP73
	 6yanaSZvyNfrBz68p5gxr246pRQOrCMGtM9nEOhpb7DucFHlof8sE4URM9Rvj4vEiXeqi
	 abKxDGKc6te7HhGbgK5wyty6jw705J4UUPDBjWAMUmoWvbblLqspuyo3Ji/0xfnH3Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a9eO951B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E662606A31C;
	Wed, 18 Nov 2026 22:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a9eO951B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BD11F000C4;
	Wed, 18 Nov 2026 22:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040279;
	bh=pkmJg+0cUhjURDrLlGsukQvafa8PpCuEX/6mm26umWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a9eO951B+MScp3+2ayqi22CfKt97FmCfxLgFTLL//aklcXBPaAjIijsxIy7mLL4PQ
	 /OqpkZOlJkoLVMN1Jz93zHk+BUByO5GQvZyGyOZzFD0sjj7sNZHnWhd9r6e7PkD7nR
	 zxHs7Q/h5SkAfVWVeWE7XUUi44Hekk5UMWQvEdu4=
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
Subject: [PATCH 6.6 2363/3318] powerpc/ftrace: Dont restore r13 during ftrace_regs_caller
Date: Wed, 18 Nov 2026 15:49:45 +0100
Message-ID: <20261118150432.470814676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 40677416d7b26..47ccb75deeaa3 100644
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



