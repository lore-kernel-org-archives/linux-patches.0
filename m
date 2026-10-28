Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212144;
	b=tS/uJMz7lFfb+g9NTNG3Nh3SgPBJfYdjjrZ+rehbn/cawgKIIKKbs1aQ8doXZkV4fDgr
	 7b85my0bfyznBP3cxmMt6D9rJtd6vVGhREWkIseusgKOBGb7BSyPuLZXXZpNPBxzXBA59
	 FQvxuZODDj7ar6dkGG5XV5T86dNdLiWFgE+LH2MXmQTg2Asc0OKjgVj+dfnScP/HQB4Da
	 PwkbuVJBnUtYy/4xcvvJIYupjBP+knt9DZD4ZO0V3p5UxvXaFmuPAqXjWM5LcAdlAcpWW
	 u5BKsgTwQhnN7WHkDL3Tl9B+/DspsCsrRK+lpYdeLOAEDjR+NDCVl46UR6569nT1X0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=rvioDNIuytI123GbGu/IbvAzZPyGlgPM4ejcPjsZegY=;
	b=pCmHH/VK7lYeklX8iGdQr4fQbWy6a+1ELECFHcuvIEUFlIpoVCkMMc2L4Hsyq2XYmZ/R
	 X3HmFhYfEOeKS1Zqxvzd7iaR6rEolPCr9g2Nc115PPjr34cIKahS4+bthGWFjBRLFe/Dd
	 AO6spUrsggfzEoarD2UveTlwcirzcFaSdevffVJ2t/WN0QTwutKuBLLTffkF4FpZn5mae
	 0olNmYv22DWTAke5zxAVCJHWiPo1qmkMx/8NYTbThFclpLQORNSRQnXnCHXdeNk1BakYf
	 WhCqDb/s/O8Zxk4Az9qRKewYv092r53fR5s0LKaOczmu8irVJqkCtkkH7BmDg9aXuAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fN24odb6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293D0606A320;
	Wed, 28 Oct 2026 18:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fN24odb6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460BE1F01825;
	Wed, 28 Oct 2026 18:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212143;
	bh=rvioDNIuytI123GbGu/IbvAzZPyGlgPM4ejcPjsZegY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fN24odb6FAL2kKVUHkiPgbJ3Brp5JD2eauIjiRw7GCECOPz+Tz6+1hPvWxLqegH3r
	 pWEemxa/ngFzB1Ycz7I4bdE/qC2dr8MLLnZI/A1de+ZslzOrnACcjGsV1aVYCI+EDq
	 KrjHjqegkkqxRPhomI7uUcTpG4EfGZD87hWIkNPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Kijo Park <red993688@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0052/1887] exec: Cleanup POSIX timers right after de_thread()
Date: Wed, 28 Oct 2026 17:35:48 +0100
Message-ID: <20261028170500.411389431@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit acb03d3881818581052924a9bbbe92b8741ed448 ]

A per-thread CPU timer holds a reference to the PID of the thread it is
attached to and, while it is armed, its node is queued in that thread's
posix_cputimers. The task is looked up by that PID.

When a non-leader thread exec()s, de_thread() changes which task owns
that PID. pid_task(timer->it.cpu.pid, PIDTYPE_PID) then returns NULL,
but the node is still queued on tsk, which is alive. timer_lock_sighand()
takes a failed lookup to mean that the node is already dequeued, so it
has nothing to undo.

begin_new_exec() calls posix_cpu_timers_exit(me) right after
exec_task_namespaces() and that removes the leftover node, so the state
normally stays invisible. But bprm->point_of_no_return is set before
de_thread(), so if unshare_files(), set_mm_exe_file(), exec_mmap() or
exec_task_namespaces() fails, the task dies before it gets there.
exit_itimers() then frees the k_itimer while its node is still queued,
and reaping tsk later erases that freed node from the rbtree.

In short:

      the non-leader thread B           the parent

  timer_create(CLOCK_THREAD_CPUTIME_ID)
  timer_settime()
    arm_timer()            // the node is queued on B
  execve()
    de_thread(B)
      exchange_tids(B, leader)  // B's PID now belongs to the leader
      release_task(leader)
        __exit_signal(leader)
          posix_cpu_timers_exit(leader)  // cleans leader's queue, not B's
          __unhash_process(leader)  // that PID has no task anymore
    exec_mmap()
      mmap_read_lock_killable(old_mm)
                                kill(B, SIGKILL)
      // -EINTR
  get_signal()
    do_exit()
      exit_itimers()
        posix_timer_delete()
          posix_cpu_timer_del()
        posix_timer_unhash_and_free()  // freed while still queued
                                wait4()
                                  release_task(B)
                                    posix_cpu_timers_exit(B)
                                      cleanup_timerqueue()
                                        timerqueue_del()  // use-after-free

Move the POSIX timer cleanup right after de_thread() before any of the
later failure conditions brings the task into do_exit().

[ tglx: Move the cleanup right after de_thread() ]

Fixes: 55e8c8eb2c7b ("posix-cpu-timers: Store a reference to a pid not a task")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: Kijo Park <red993688@gmail.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/ao7Q8miiuLAPVnWv@v4bel
Link: https://patch.msgid.link/20260911090541.627712075@kernel.org
[ kept timer cleanup inline instead of introducing upstream’s posixtimer_exec() helper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exec.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 6ff6367793b9e..7391ec00a1cc1 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1268,6 +1268,21 @@ int begin_new_exec(struct linux_binprm * bprm)
 	if (retval)
 		goto out;
 
+	/*
+	 * This must be done here to ensure that POSIX CPU timers which were
+	 * armed on the current task are dequeued from me::posix_cputimers.
+	 * Otherwise in case of a TID switch the deletion of the related POSIX
+	 * timer would not remove an enqueued timer because the TID lookup
+	 * of the old TID fails.
+	 */
+#ifdef CONFIG_POSIX_TIMERS
+	spin_lock_irq(&me->sighand->siglock);
+	posix_cpu_timers_exit(me);
+	spin_unlock_irq(&me->sighand->siglock);
+	exit_itimers(me);
+	flush_itimer_signals();
+#endif
+
 	/*
 	 * Cancel any io_uring activity across execve
 	 */
@@ -1316,14 +1331,6 @@ int begin_new_exec(struct linux_binprm * bprm)
 
 	bprm->mm = NULL;
 
-#ifdef CONFIG_POSIX_TIMERS
-	spin_lock_irq(&me->sighand->siglock);
-	posix_cpu_timers_exit(me);
-	spin_unlock_irq(&me->sighand->siglock);
-	exit_itimers(me);
-	flush_itimer_signals();
-#endif
-
 	/*
 	 * Make the signal table private.
 	 */
-- 
2.53.0



