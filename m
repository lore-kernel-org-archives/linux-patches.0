Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043713;
	b=Ch526lpjtVuoiLcM3/v7Ei5ay7Cy1z+8KtIoQen4PGAk3jADfn4qZLM0Onaq3mnri9hv
	 2qfH5PNTIqIbdg3NIUShjxWSUf08TOJKJ5zu1MIdn2nQ2SD0tCkZaSQcAPlMFJgyFa8Xg
	 WkzNjRosMMc4FhG2gVlRXHV17xrpYNO3cmtoDZOQYZ9I5IBsIx67Avtba0K4b59HKewQ8
	 E56LdPej+ZhITHKprtvUmfCHDanZiwp/k++MvovQMNyC+fFUfsM2k7pwbPDLDzGrpZ9JJ
	 5Q5/RqIa8+Us5hZ2iJGl3jzYQAnWZc6xulzJT8/UXdUhzqrdQwQbLCEadT9lFJNmJNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pGUNKPEE3L+6He26an0/JNG3KyQQ1xVyJ97QQSUbvKs=;
	b=GWiK6/eTvaTIQGUE9eRrpwlzZK8bpgv40tP9SEELdqF0GzctkHlYqD0NOTa3KxDzoHP4
	 tmPMBZ7SfyDekXRk/lu5MP79PwE/ThWowwycKwfCRh6sRPUN2hJMpzOZNIIyInEs8OBGm
	 dux/HscALEuMmbT4mrEYLLFIeCbsh6d/Ia1H4b6swx1vUy9WBRnDC6+hFLsiqs/vSH28V
	 AAg2EkW/Fp2a0uG7yhXHxT7WDexc2jN4q84sMFZfLzfGcBFgEojkpCx+XXc4QWMdRVRoN
	 /5YJvlPWmJOZIc+xzHgmJBU+UPKH3FuznlVXz9oZgmZnjPIn/L74RGa7CiEmousfM4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KCpSFazh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF05606A320;
	Wed, 18 Nov 2026 23:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KCpSFazh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829671F000C6;
	Wed, 18 Nov 2026 23:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043713;
	bh=pGUNKPEE3L+6He26an0/JNG3KyQQ1xVyJ97QQSUbvKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KCpSFazhIzMJCU04VjfCUClwjy/nEUxm90V8zN8mGb2v9+SLy+U3eGHHip3ruzaui
	 LFHF3Rpi651rj5cm9e+HxNGmiXQCAPlnLww5CQwaq4jsv0HiZu3Y+fL5TgSSfGHkL3
	 vWPADPY9HeGVKs0uxrkUyYWfQo/yTJ77cwMHeZwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	Andrea Parri <parri.andrea@gmail.com>
Subject: [PATCH 6.1 0307/2857] kcsan: Avoid division by zero in kcsan_prandom_u32_max()
Date: Wed, 18 Nov 2026 15:22:21 +0100
Message-ID: <20261118150212.495544468@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Parri <parri.andrea@gmail.com>

commit 99b6fcce87037cfb6b5e177848342e97f5141205 upstream.

KCSAN's skip_watch, udelay_task and udelay_interrupt parameters can be
changed at runtime through /sys/module/kcsan/parameters/, where 0 means
watching every access or not delaying at all. With the default
CONFIG_KCSAN_SKIP_WATCH_RANDOMIZE=y and CONFIG_KCSAN_DELAY_RANDOMIZE=y,
writing 0 to any of them makes the next watchpoint setup divide by zero:

  # echo 0 > /sys/module/kcsan/parameters/udelay_task
  Oops: divide error: 0000 [#1] SMP NOPTI
  CPU: 0 UID: 0 PID: 93 Comm: sh Not tainted 7.3.0-rc5 #3 PREEMPT(lazy)
  RIP: 0010:kcsan_setup_watchpoint+0x1b5/0x410
  Code: ... 65 89 05 ad 8d 98 02 d3 ee <f7> f6 29 d7 e8 22 0e 0f 01 ...
  RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
  ...
   __show_trace_log_lvl+0x1bd/0x315
   __die_body.cold+0x19/0x2b
   die+0x34/0x50
  ...
  BUG: TASK stack guard page was hit at ffffd3ab001fbfe8 (...)

reset_kcsan_skip() and delay_access() pass these values unchecked to
kcsan_prandom_u32_max(), which returns "state % ep_ro". delay_access()
halves the delay for compound and assert accesses, so
udelay_interrupt=1 is enough there.

The oops path runs instrumented code, which faults again until the stack
overflows. With skip_watch=0 the guest hangs without printing anything.

The division came in with commit 71a076f4a61a ("kcsan: Rewrite
kcsan_prandom_u32_max() without prandom_u32_state()"). Before it, the
helper scaled the random value with a multiply-shift, which yields 0 for
ep_ro == 0. Go back to that via reciprocal_scale().

Tested in an x86-64 KCSAN guest with virtme-ng: after this patch,
writing 0 to each parameter, or 1 to udelay_interrupt, no longer
oopses. skip_watch=0 now watches every access, which is very slow with
the default delays but completes when they are set to 0.

Fixes: 71a076f4a61a ("kcsan: Rewrite kcsan_prandom_u32_max() without prandom_u32_state()")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Reviewed-by: Marco Elver <elver@google.com>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kcsan/core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/kcsan/core.c
+++ b/kernel/kcsan/core.c
@@ -290,8 +290,9 @@ should_watch(struct kcsan_ctx *ctx, cons
 }
 
 /*
- * Returns a pseudo-random number in interval [0, ep_ro). Simple linear
- * congruential generator, using constants from "Numerical Recipes".
+ * Returns a pseudo-random number in interval [0, ep_ro), or 0 if ep_ro is 0,
+ * which the runtime-tunable callers may pass. Simple linear congruential
+ * generator, using constants from "Numerical Recipes".
  */
 static u32 kcsan_prandom_u32_max(u32 ep_ro)
 {
@@ -300,7 +301,7 @@ static u32 kcsan_prandom_u32_max(u32 ep_
 	state = 1664525 * state + 1013904223;
 	this_cpu_write(kcsan_rand_state, state);
 
-	return state % ep_ro;
+	return reciprocal_scale(state, ep_ro);
 }
 
 static inline void reset_kcsan_skip(void)


