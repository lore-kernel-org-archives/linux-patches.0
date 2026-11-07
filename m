Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061360;
	b=T8zgokyIjGCttbowov7Q5iXHajst52xL7flp1gVWUVOOutoR+BKc8F6K0+RMAtdlb+JY
	 VURtMznmFfzn5JG00J4LbMTddbDewaVK2vPoyxWPmmrjsAIsUZEbX0CAd6NB6ceGb/wNL
	 MuoBjm9VoiirjpBoSDnBpZ1kKLaGXlSBNO5jEzirRKNZt2UrdvOj1cj34X5PRW+gRLd0v
	 6Xjd0xl4k+okbI51w/wXmxxRNq2Mqai9MUrRsQY+F4KBjMJAJr1M+sGwXswlkbxFy4HSM
	 V4ulOmUznrJ+yiYik0YxPBYgs5cKDWu4mOPENYr7lKrpNKW0VLF6H9+/HkRrdgAb+cQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KJV3r3pgc8D0w1dv8PtT8RcAoTQJwtggSqxFIMXoMtw=;
	b=rHNpsXn2Qhl91shDqfpbAZFI3jLHH9JV89syL+io8sqQ34l9DHSTZhR8ivuen5cWaQFC
	 YQYDZV1darDEAkYGlMlkuxOSaq/QEEayk7FVaOyweafmMw7MZzOE7Zajg2LqJIspahLw4
	 EsHJHGMjRQfNblf5QMkuP48jC12NJa8km46GfPuqiTsnz60w5tPaVTxsMPqTxtwQ7gT5y
	 8UOF/9SQz/ADX0J6FOXcog/X3jIT7DJPbIinArkAxFkMdsMvuEoRF9wE6rGCxlc4/c/Vn
	 7JYftNBpMBgLeKrpumtxRTr53O59jhy91+lOvR8rlG/ZlaADDyPO5JjZfNCTOVPh6bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZjyS9G1I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E8C606A326;
	Sat,  7 Nov 2026 14:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZjyS9G1I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321EF1F008BE;
	Sat,  7 Nov 2026 14:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061359;
	bh=KJV3r3pgc8D0w1dv8PtT8RcAoTQJwtggSqxFIMXoMtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZjyS9G1IkUTA7lwWrwyXyeZQjxFQaO3GQfvYv31WcQDZTmw134O+JW/UHepq4NkOM
	 rT3Z6cCWD9zVuGSltY/RepHIMhV7Rm2Qpr+cvtPpM7I2C6hX6yB4fwB71wDq3R0Xan
	 uPiOETJwYtc1XJQBIE7aQnlDUH0q2zfa0KQBejQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	fangqiurong <fangqiurong@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0484/1536] sched_ext: Fix exit_task leak on fork failure during enable
Date: Sat,  7 Nov 2026 08:41:40 -0500
Message-ID: <20261107135011.078578653@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: fangqiurong <fangqiurong@kylinos.cn>

[ Upstream commit 03506edca637a8465dba9f635c50e9884fbcaf4e ]

scx_fork() initializes tasks when scx_init_task_enabled is set, but
scx_cancel_fork() only exits them when scx_enabled() is true. A fork
that fails in the enable window (between releasing scx_fork_rwsem and
setting __scx_enabled) runs ops.init_task() but never ops.exit_task().

Gate scx_cancel_fork() on scx_init_task_enabled.

Fixes: 4269c603cc26 ("sched_ext: Enable scx_ops_init_task() separately")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: fangqiurong <fangqiurong@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
[ sashal: Applied the fix to kernel/sched/ext.c with the older variable name scx_ops_init_task_enabled in place of scx_init_task_enabled. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index ded7a0dd2e533..b18c3b4763b79 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3888,7 +3888,7 @@ void scx_post_fork(struct task_struct *p)
 
 void scx_cancel_fork(struct task_struct *p)
 {
-	if (scx_enabled()) {
+	if (scx_ops_init_task_enabled) {
 		struct rq *rq;
 		struct rq_flags rf;
 
-- 
2.53.0



