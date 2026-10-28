Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212516;
	b=dpuWuKUZ7PottoBjhSYMNTtwMZQysKcUved5f+MHZ2jsydZK+uyWJfjgqyXluprpgGAz
	 3ZCcnxizsYyXQgbIEPu+T07lO1Ed3QH5M/pQ8tWJMzFq4U/leRJgr5WVCfrcAH81SSPGe
	 8yY1kGJy7fX6vLM6MGSNA8KGo6FOWLxpywF2Vygm4qwmV2GY/RfaWsErLpRG66P5LZ4qC
	 Ul5QSb61O6f1nABgu28CILWsb96a5zkY0EOPsAoO0aQQRf83qj9sON1Mb34Zfkqp5xNOw
	 pUV3mEBjN0/I7G5KfFMR+qfINosVqnRAra21AfPoopVAqxrQKW+RhLamfA5QIgQWqsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212516;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=40Zvf9B7Q8MM342fAN+aGbgVus60ZH+OxnUDGsjoPdY=;
	b=AThrD8O8aU//b3cPWdODUxpilGnX3r+uNQulEIAWZLrHS7JhVAJyWd5BXBLjxZXA4SNx
	 gKdlaA/YxIScGQJT9Wnok59Lv3+9MJ+/sxZmor7NcWsymrD7xpvq9g2lANTPo+1iQfVlm
	 EtT07ebKdIiU19ncbOKBZCSZ3uCkHToiIUzzIIxUwaxEAwYkSUVwRKcZWw87vkmot/lDT
	 jfSuUpvCgWQbcI9IS+/CbTldulArgq4pG4O7oSA0bhPrqxIsEDYmg+YcR/hRvSLa9LE0d
	 4F/rXZZ9HCkF3FnJmhncstE2rkLRIMWX3T/758XuB5al3ZDLNNxTbJNRvV/qvsbJp1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HkLQg6nW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAF8606A31A;
	Wed, 28 Oct 2026 18:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HkLQg6nW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE69C1F01825;
	Wed, 28 Oct 2026 18:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212515;
	bh=40Zvf9B7Q8MM342fAN+aGbgVus60ZH+OxnUDGsjoPdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HkLQg6nWF9rNdt7oIKaT9UB+0EjdNjflNhVVyyR8JO214xddr7NrfbtD/bAQfBsTq
	 irFaokvqns24Bnh6Va1DQifKNpA/bvpAeNAFG97sD+cK+Td7n5pywT5qBc81NHgzo+
	 rS/TgsihJ3osUAYkXWEkx0nOgVoKU7WnoRaaedYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dohyun Kim <dohyunkim@google.com>,
	Neel Natu <neelnatu@google.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0181/1887] bpf: Fail bpf_timer_cancel when callback is being cancelled
Date: Wed, 28 Oct 2026 17:37:57 +0100
Message-ID: <20261028170503.355051068@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit d4523831f07a267a943f0dde844bf8ead7495f13 ]

Given a schedule:

timer1 cb			timer2 cb

bpf_timer_cancel(timer2);	bpf_timer_cancel(timer1);

Both bpf_timer_cancel calls would wait for the other callback to finish
executing, introducing a lockup.

Add an atomic_t count named 'cancelling' in bpf_hrtimer. This keeps
track of all in-flight cancellation requests for a given BPF timer.
Whenever cancelling a BPF timer, we must check if we have outstanding
cancellation requests, and if so, we must fail the operation with an
error (-EDEADLK) since cancellation is synchronous and waits for the
callback to finish executing. This implies that we can enter a deadlock
situation involving two or more timer callbacks executing in parallel
and attempting to cancel one another.

Note that we avoid incrementing the cancelling counter for the target
timer (the one being cancelled) if bpf_timer_cancel is not invoked from
a callback, to avoid spurious errors. The whole point of detecting
cur->cancelling and returning -EDEADLK is to not enter a busy wait loop
(which may or may not lead to a lockup). This does not apply in case the
caller is in a non-callback context, the other side can continue to
cancel as it sees fit without running into errors.

Background on prior attempts:

Earlier versions of this patch used a bool 'cancelling' bit and used the
following pattern under timer->lock to publish cancellation status.

lock(t->lock);
t->cancelling = true;
mb();
if (cur->cancelling)
	return -EDEADLK;
unlock(t->lock);
hrtimer_cancel(t->timer);
t->cancelling = false;

The store outside the critical section could overwrite a parallel
requests t->cancelling assignment to true, to ensure the parallely
executing callback observes its cancellation status.

It would be necessary to clear this cancelling bit once hrtimer_cancel
is done, but lack of serialization introduced races. Another option was
explored where bpf_timer_start would clear the bit when (re)starting the
timer under timer->lock. This would ensure serialized access to the
cancelling bit, but may allow it to be cleared before in-flight
hrtimer_cancel has finished executing, such that lockups can occur
again.

Thus, we choose an atomic counter to keep track of all outstanding
cancellation requests and use it to prevent lockups in case callbacks
attempt to cancel each other while executing in parallel.

[ Backport to 6.1.y: mapped the atomic cancellation guard directly onto
  the pre-refactor bpf_hrtimer layout. ]

Reported-by: Dohyun Kim <dohyunkim@google.com>
Reported-by: Neel Natu <neelnatu@google.com>
Fixes: b00628b1c7d5 ("bpf: Introduce bpf timers.")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20240709185440.1104957-2-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 4cd7854932944..d5dcc172647c8 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1110,6 +1110,7 @@ const struct bpf_func_proto bpf_snprintf_proto = {
  */
 struct bpf_hrtimer {
 	struct hrtimer timer;
+	atomic_t cancelling;
 	struct bpf_map *map;
 	struct bpf_prog *prog;
 	void __rcu *callback_fn;
@@ -1204,6 +1205,7 @@ BPF_CALL_3(bpf_timer_init, struct bpf_timer_kern *, timer, struct bpf_map *, map
 	t->map = map;
 	t->prog = NULL;
 	rcu_assign_pointer(t->callback_fn, NULL);
+	atomic_set(&t->cancelling, 0);
 	hrtimer_init(&t->timer, clockid, HRTIMER_MODE_REL_SOFT);
 	t->timer.function = bpf_timer_cb;
 	WRITE_ONCE(timer->timer, t);
@@ -1331,7 +1333,8 @@ static void drop_prog_refcnt(struct bpf_hrtimer *t)
 
 BPF_CALL_1(bpf_timer_cancel, struct bpf_timer_kern *, timer)
 {
-	struct bpf_hrtimer *t;
+	struct bpf_hrtimer *t, *cur_t;
+	bool inc = false;
 	int ret = 0;
 
 	if (in_nmi())
@@ -1343,14 +1346,40 @@ BPF_CALL_1(bpf_timer_cancel, struct bpf_timer_kern *, timer)
 		ret = -EINVAL;
 		goto out;
 	}
-	if (this_cpu_read(hrtimer_running) == t) {
+	cur_t = this_cpu_read(hrtimer_running);
+	if (cur_t == t) {
 		/* If bpf callback_fn is trying to bpf_timer_cancel()
 		 * its own timer the hrtimer_cancel() will deadlock
-		 * since it waits for callback_fn to finish
+		 * since it waits for callback_fn to finish.
+		 */
+		ret = -EDEADLK;
+		goto out;
+	}
+
+	/* Only account in-flight cancellations when invoked from a timer
+	 * callback, since we want to avoid waiting only if other _callbacks_
+	 * are waiting on us, to avoid introducing lockups. Non-callback paths
+	 * are ok, since nobody would synchronously wait for their completion.
+	 */
+	if (!cur_t)
+		goto drop;
+	atomic_inc(&t->cancelling);
+	/* Need full barrier after relaxed atomic_inc */
+	smp_mb__after_atomic();
+	inc = true;
+	if (atomic_read(&cur_t->cancelling)) {
+		/* We're cancelling timer t, while some other timer callback is
+		 * attempting to cancel us. In such a case, it might be possible
+		 * that timer t belongs to the other callback, or some other
+		 * callback waiting upon it (creating transitive dependencies
+		 * upon us), and we will enter a deadlock if we continue
+		 * cancelling and waiting for it synchronously, since it might
+		 * do the same. Bail!
 		 */
 		ret = -EDEADLK;
 		goto out;
 	}
+drop:
 	drop_prog_refcnt(t);
 out:
 	__bpf_spin_unlock_irqrestore(&timer->lock);
@@ -1358,6 +1387,8 @@ BPF_CALL_1(bpf_timer_cancel, struct bpf_timer_kern *, timer)
 	 * if it was running.
 	 */
 	ret = ret ?: hrtimer_cancel(&t->timer);
+	if (inc)
+		atomic_dec(&t->cancelling);
 	rcu_read_unlock();
 	return ret;
 }
-- 
2.53.0



