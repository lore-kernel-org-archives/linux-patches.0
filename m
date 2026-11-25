Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625835;
	b=YckUuQs/OoR4j8DpHB8wZqNRjrGI+I/AWFsa7H4D9GEDDKDamq1Um4JkdkZ/yjSEYrmb
	 Y4UISVfv8ngGeuQEj1KTfZCjSbSXrm22q9WYf7vx6Yq8ZXcbrkHlcXfjtysSIYZ5+mgQo
	 ZN/klOd/o+UQFztmd2QU3VcnyTk7nKHjL0757p1K09GQNNmHlpPubfkDJTRXOu4Madwzg
	 47NFZNlwTB5iY2upzFqDSh+GB41wPEx9ZgleNqghv032ihePizaiC7Xx4VKu6rKuqFJq+
	 jxo7d3NkswJVHQ/9ct7+LyW1M6VWvpTDKf+YlYpCFdwvr1UIBO/TnY9YNRD4I9i/xyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7LmqUv1Y5opcotJGOLMltUh27tMi2W9/w+mXtKwsPgk=;
	b=N1BuPO2iSbT53wSqsXBa8c63g9PmFr5J7eOZIr964u0DUEbZ3eHDrsP+4rYr3WB1Isv1
	 3RTFgRfK2ifCeE61gWlhZX9xJzAs4uPYtByrD7FitFxSkFxmE/GpLB/6e3PDV47vlx40d
	 Oczv9HrMec3p255V9kUpdQt9a4BI8d+9OlmcmhjyQFRBPwvWiNKaWvrXu88soETVCUHcc
	 mj0mIJGsUFkoJwgNr3b6qxXCrgIpWt0131bq33Aum+4rjJlbKMnwaHBrhP3KKBu206Erv
	 bwb7F8NR/yfetWQ6LvNIJPOvxHF9IQKRrq894XcOg2KNhvxZWiGJIXMnR+hbJq185hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gM9opp4/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099E0606A323;
	Wed, 25 Nov 2026 16:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gM9opp4/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93C71F000C4;
	Wed, 25 Nov 2026 16:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625834;
	bh=7LmqUv1Y5opcotJGOLMltUh27tMi2W9/w+mXtKwsPgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gM9opp4/LhFX428qie+l9EMZJ0xy2mABxC9FzrH5s13ut/rZ666Y6WqTckWSB18LN
	 HtdYoYsGLdtkyuTUJxvQcJSvGPyRfvO1TxFxX6hjvXvhFPSGL07zDDtMCSG1Xffd5r
	 anUyaIuTeA75s7Ex5Uj6ZgS5VxVxDaWHYASScky0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Andrea Parri <parri.andrea@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH 6.12 645/816] sched/uclamp: Reject clamp values above SCHED_CAPACITY_SCALE
Date: Wed, 25 Nov 2026 15:36:33 +0100
Message-ID: <20261125143904.114750501@linuxfoundation.org>
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

From: Andrea Parri <parri.andrea@gmail.com>

commit 8127ec8458df29bd702db602473042ccb9e619b9 upstream.

sched_setattr() accepts sched_util_min and sched_util_max values that do
not fit in uclamp_se::value. A single thread can do:

  sched_setattr(max = 800)		returns 0
  sched_setattr(min = 0xfffffffe)	returns 0
  sched_getattr()			min=2046 max=800

which leaves the minimum above both SCHED_CAPACITY_SCALE and the task's own
maximum.

The range check in uclamp_validate() relies on the + 1 wrapping -1, the
reset value, to 0:

	if (util_min + 1 > SCHED_CAPACITY_SCALE + 1)

That only works for an unsigned type. util_min and util_max are int and
SCHED_CAPACITY_SCALE is a long, so every negative value passes the check,
and so does INT_MAX, whose + 1 wraps.

uclamp_se_set() then truncates what got through to the 11 bits of
uclamp_se::value, but computes the bucket from the full value. A minimum
of 0xfffff800 is stored as 0 in the top bucket, where uclamp_rq_max_value()
takes it for the highest active clamp once a higher value leaves the rq.
The rq clamp falls below what the remaining tasks requested, and emptying
their bucket trips the WARN_ON_ONCE() in uclamp_rq_dec_id(), without any
privilege:

  WARNING: kernel/sched/core.c:1862 at dequeue_task+0x2a3/0x2b0, CPU#0: repro/126
  Call Trace:
   __schedule+0x933/0x1320
   schedule+0x36/0x100
   do_nanosleep+0x61/0x190
   hrtimer_nanosleep+0xb5/0x1d0

Make util_min and util_max unsigned int, so that -1 is the only value that
wraps. The pair check below is unaffected, since it skips -1 explicitly and
anything else is at most SCHED_CAPACITY_SCALE by then.

Requests that were only accepted because of this now fail with -EINVAL.

The following program triggers the warning when run by any user outside
a child cpu cgroup. With this applied, its 0xfffff800 request fails with
-EINVAL and the warning no longer appears:

  #define _GNU_SOURCE
  #include <pthread.h>
  #include <sched.h>
  #include <stdint.h>
  #include <sys/syscall.h>
  #include <time.h>
  #include <unistd.h>

  struct attr {
      uint32_t size, policy;
      uint64_t flags;
      int32_t nice;
      uint32_t prio;
      uint64_t runtime, deadline, period;
      uint32_t util_min, util_max;
  };

  static volatile int stop;

  static void set_min(uint32_t v)
  {
      /* KEEP_POLICY | KEEP_PARAMS | UTIL_CLAMP_MIN */
      struct attr a = { .size = sizeof(a), .flags = 0x38, .util_min = v };

      syscall(SYS_sched_setattr, 0, &a, 0);
  }

  static void burn(long us)
  {
      struct timespec s, n;

      clock_gettime(CLOCK_MONOTONIC, &s);
      do
          clock_gettime(CLOCK_MONOTONIC, &n);
      while ((n.tv_sec - s.tv_sec) * 1000000 +
             (n.tv_nsec - s.tv_nsec) / 1000 < us);
  }

  static void *bogus(void *arg)
  {
      set_min(0xfffff800);
      while (!stop)
          burn(1000);
      return arg;
  }

  static void *worker(void *arg)
  {
      long v = (long)arg;

      set_min(v);
      while (!stop) {
          burn(v == 800 ? 300 : 1500);
          usleep(100);
      }
      return arg;
  }

  int main(void)
  {
      pthread_t t[3];
      cpu_set_t c;
      int i;

      CPU_ZERO(&c);
      CPU_SET(0, &c);
      sched_setaffinity(0, sizeof(c), &c);
      pthread_create(&t[0], NULL, bogus, NULL);
      usleep(50000);
      pthread_create(&t[1], NULL, worker, (void *)500L);
      pthread_create(&t[2], NULL, worker, (void *)800L);
      sleep(15);
      stop = 1;
      for (i = 0; i < 3; i++)
          pthread_join(t[i], NULL);
      return 0;
  }

An LLM helped find the warning and write this patch and its tests.

Fixes: 480a6ca2dc6e ("sched/uclamp: Allow to reset a task uclamp constraint value")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Cc: stable@vger.kernel.org
Link: https://sashiko.dev/#/patchset/20261016062629.2102883-1-sh_def%40163.com
Link: https://patch.msgid.link/20261102134831.243255-1-parri.andrea@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/syscalls.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -321,8 +321,8 @@ static bool check_same_owner(struct task
 static int uclamp_validate(struct task_struct *p,
 			   const struct sched_attr *attr)
 {
-	int util_min = p->uclamp_req[UCLAMP_MIN].value;
-	int util_max = p->uclamp_req[UCLAMP_MAX].value;
+	unsigned int util_min = p->uclamp_req[UCLAMP_MIN].value;
+	unsigned int util_max = p->uclamp_req[UCLAMP_MAX].value;
 
 	if (attr->sched_flags & SCHED_FLAG_UTIL_CLAMP_MIN) {
 		util_min = attr->sched_util_min;


