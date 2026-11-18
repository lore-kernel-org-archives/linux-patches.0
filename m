Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044865;
	b=bzt80oXSCCkMUtvJxlcFnUOmMh2h0Ql5bFTHJ60pM5VPR5UlVCnaewsqNe8DCMzDli0d
	 QV+fHu4XPDaRi9aH5GZJbH6Ac5VQAxz1oVFvufp1CgQn62F9QmAr2VeR2mYNTJx5LAUZX
	 U3O8U4mRdjXZmg9YgbhtSj/gbQ4r0cOb6WRahpJrv9ZT8/eiP2fqiMPGTVAHLxbAFJ5Ty
	 mEAzqwaurpBW0Ak4cWo63cGNzDiBRzY8JHpNyUcLV3WxwhC5fDRWb8xuL+8Q29t5E+uFe
	 Y4/u4vcHsvffgrATZh0kJzjGzAJTn2ZeO1vBtDTNlo0bF5Chog6n89XAFCrqM3IGW6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=37OWwsZwX3Q3fPI0yHzFLT3iosRDcGDpJYR46HdR9zs=;
	b=lOBMncIscSUoOUcs/go0elTEHINkpgkRK8TRsVqIPb87fp+IA8uCej4HmKFZRuIm0F4K
	 ojyJAKT30qM7bVocdRSd/NiMsQ03qiEPo3U2UomGfMM6ETQBX9kbeTKA4QM4XHKbT2qpi
	 RuMoeQOLN2kYZkOzu+lBiVIw5v7Jov1BMP6DpwFFG5pHw2R0s/k1Q7US0cbBJ/mFpuBPb
	 m4Zpqc32DZ/Pkn6DOhzGfIyhVvu37oCiA9IpyEwsIH7/3qMwVcqT1D3F3/Qua5r+9L/e3
	 ren9PryE0uAtvO8d8AIwipAfJJ3cMe9ZbWnl6J7n72vdEH2PRDppy2e1aRP/JqoChVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cdAOO0i6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B890606A9D8;
	Wed, 18 Nov 2026 23:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cdAOO0i6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F711F000C4;
	Wed, 18 Nov 2026 23:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044865;
	bh=37OWwsZwX3Q3fPI0yHzFLT3iosRDcGDpJYR46HdR9zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cdAOO0i6XkyzEXNZz9rw2CRZbSSx8KW5nifXbLGR2NpYINRZVnMo9srIJ+7YT3GSO
	 +ZQv1HJnOuvAIYYT5OD7SS4ndtw91TueZ77HBDkZCR6FftoFCP5pwf1CiAtS0u/X/w
	 oKCpo1bcSSrTetgkffFNHbOcNdHrZrtKceYGn0JI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0717/2857] aio: prevent eventfd/epoll recursion on poll
Date: Wed, 18 Nov 2026 15:29:11 +0100
Message-ID: <20261118150227.362996359@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit 398e3fa789aa5ffddc8689d8cbc7b31e1824130c ]

aio_poll_wake() can complete a keyed poll request inline while the
provider waitqueue lock is held.  If the polled file is an epoll instance
and the AIO result eventfd is watched by that same instance, signaling the
result can feed back into epoll and try to take the provider waitqueue lock
again.

For example, a timerfd wake can follow this path:

  timerfd -> ep_poll_callback -> aio_poll_wake -> aio_complete
          -> eventfd_signal -> ep_poll_callback -> ep_poll_safewake

The second ep_poll_safewake() recursively acquires ep->poll_wait.lock.
eventfd_signal_allowed() does not prevent this because the wake chain did
not begin in eventfd, so the task's eventfd recursion bit is still clear
when aio_poll_wake() decides to complete inline.

An unprivileged process can construct this graph and make a CPU spin on the
recursive lock.  DEBUG_SPINLOCK reports "BUG: spinlock recursion", and
lockdep reports the same epoll waitqueue lock as both held and requested.

Always defer eventfd-backed poll completions through the existing
aio_poll_put_work() path.  At this point the request has already been
detached from the waitqueue and active request list, so the work item can
publish the completion after the provider callback releases its lock.
Poll completions without a result eventfd remain inline.

Fixes: e8693bcfa0b4 ("aio: allow direct aio poll comletions for keyed wakeups")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Link: https://patch.msgid.link/20260813133843.2933127-1-4ncienth@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/aio.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index 3e3bf6fdc5ab6..fd606a9bd701e 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1797,7 +1797,12 @@ static int aio_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 		list_del_init(&req->wait.entry);
 		list_del(&iocb->ki_list);
 		iocb->ki_res.res = mangle_poll(mask);
-		if (iocb->ki_eventfd && !eventfd_signal_allowed()) {
+		/*
+		 * We hold an arbitrary provider waitqueue lock here.  Signaling a
+		 * result eventfd can feed back through epoll and try to take the same
+		 * lock again.  Defer all eventfd-backed poll completions.
+		 */
+		if (iocb->ki_eventfd) {
 			iocb = NULL;
 			INIT_WORK(&req->work, aio_poll_put_work);
 			schedule_work(&req->work);
-- 
2.53.0



