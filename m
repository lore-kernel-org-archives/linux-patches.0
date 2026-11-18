Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050960;
	b=NAswgAwoKzLyo7E0d0jCZvM8ShceON6/rqzeALel13b1eQNLRYAiqOgskg7dOquxjgW5
	 MWw20V5Fd2iajAOAmbJMLcFK98IHY3MNxa9nbXM5048FQDCfBj2Ak+bKFucrK7PmZnbGH
	 f9nKbKOSxB7RR/59WRQyXrQZalvOtRjUrWJ2rSbfj47k35no8XOQhu9F5dYBZcVgIheSL
	 3kUUn9b1JHDkG1dE9q5MjTQgm2IMWpe9MnieoHic1zJv4Pq8n2Ek3FXLTVSGypQvU9EX5
	 8Jc26v5xcaF94KVebchksgi6fFsItbB0h4st0Lbj9xSZLB6e7fQe5Q7pO4x6uhUtPUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050960;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aTZpfgRFZS3VV6II3qaQ3oJSWU2sA0Sb1jGmezDRBCw=;
	b=1dVQg+q+fGHKT4GULCUsXD018de00Bp1y62wmtmS7G1D/NXwW8yDw3pSRxvovmnqQAYP
	 ctY9W5plZ5g2Qap0qk4GIc+Yfh6SK1RMWAcn0U2wpps80di90a+7ITvPoZ1quGEZPb2DG
	 npdxaRc5k3pvKUpRXQ8KOiy2QduDRoQSbrJmP4Scez72kK0Cli5ldcuXghreOlA4ARJOt
	 hskis00ue7WmDmvjQXcNpxr36WkDNS7x7WGu3ZiXwqVB9ikwET07tvtmSri+VfC5+dT1P
	 As9kHwGgL57KMYTkLbkI9X8BiLUoRjnixhPYcHYUZ/yFjgQn0Je8gK5ujxi65pI0/yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cqKx8lLC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAEA606A31C;
	Thu, 19 Nov 2026 01:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cqKx8lLC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D65E1F000C4;
	Thu, 19 Nov 2026 01:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050959;
	bh=aTZpfgRFZS3VV6II3qaQ3oJSWU2sA0Sb1jGmezDRBCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cqKx8lLCXd8aiGtzkCfmFFVTusigRngDQIIfjEPaVpbHTWcawGibNxcWCNw1w1w9L
	 8HBj7iNOpoxc6MM+KoFU/njVPPctNTRWVJX77AHII0evOZED2dsHAILXBeQQjwsOP2
	 KohrWUyuee/otlN3K9n/37rbN8H5WJbRC3nBw5Tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Kijo Park <red993688@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0007/2214] exec: Cleanup POSIX timers right after de_thread()
Date: Wed, 18 Nov 2026 15:28:03 +0100
Message-ID: <20261118150010.454290137@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

commit acb03d3881818581052924a9bbbe92b8741ed448 upstream.

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
[Lee: Context conflict only - no functional change]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exec.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 6797c8cf88f4f..5efe7ae6f9685 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1234,6 +1234,17 @@ void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec)
 	perf_event_comm(tsk, exec);
 }
 
+static void posixtimer_exec(struct task_struct *me)
+{
+#ifdef CONFIG_POSIX_TIMERS
+	spin_lock_irq(&me->sighand->siglock);
+	posix_cpu_timers_exit(me);
+	spin_unlock_irq(&me->sighand->siglock);
+	exit_itimers(me);
+	flush_itimer_signals();
+#endif
+}
+
 /*
  * Calling this is the point of no return. None of the failures will be
  * seen by userspace since either the process is already taking a fatal
@@ -1262,6 +1273,15 @@ int begin_new_exec(struct linux_binprm * bprm)
 	if (retval)
 		goto out;
 
+	/*
+	 * This must be done here to ensure that POSIX CPU timers which were
+	 * armed on the current task are dequeued from me::posix_cputimers.
+	 * Otherwise in case of a TID switch the deletion of the related POSIX
+	 * timer would not remove an enqueued timer because the TID lookup
+	 * of the old TID fails.
+	 */
+	posixtimer_exec(me);
+
 	/*
 	 * Cancel any io_uring activity across execve
 	 */
@@ -1310,14 +1330,6 @@ int begin_new_exec(struct linux_binprm * bprm)
 
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



