Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028561;
	b=iJkAGsuuFrPVgfphbyNny0BYJADa2VrgXL9pcZI+hLQ+svTwVKHZrL/fGupbau03uOIb
	 zQ9QaPogiquoG2Z5H+5w/+edwgRhGH1P27lEi0O5j5OGk4LrksggYb03nBv2mLBiJ+507
	 9g5qehhE3mng/wOxcpTSMCcwLR9dl+zPAK06TB2yqk9TiCsxa99rbuaM6mv0D2MC+f1ZY
	 pUP9FLr9H7b6y2H+/s9kIngwRZCUbEh55k+V4whMRyCvM0dqV3Qiml+AdC15x3NKz9OZX
	 Wiig1VW0xIvHPAm1obmeUX41Nn3fSrha3mBNDcsWva27Nc4OQNBR6FlI/qwxCzcOhwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lqrNau0BS6Yc5IC3HNkWQGvXeprlL+onEWvrio19S1g=;
	b=t3rN9M/M6kV/UyDlOmw2vbWV+UEoux2RlUQf7d/i7V/APPvjSYFVY6OehG4Ooy9VKJOq
	 jzvnZ+zlGOM1pxB731afJgJg/Hi7ivsZpCvGxI9zlBjG8aSsqiMOaCTKtrAf2zqDH8T2s
	 FO7gjRB7lCurj/QrL+11NA6iShbdiXiSddty2VCo3sNsUThNLJL+khHQTIsY+VMExCdxk
	 +qeI4g4udlMgNGNhezW1KewyM/Rrq0Sn4ee1idE5rh86zDFQflTNvS80BdrEQNr0Q3ucc
	 LS0AAn2sWK+7k0NdhDgqZJlDVyD2CpR9q0uADuvfzpvCbYDuRquwEvlwQYPVJJgcwIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="WQZzI1w/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C9D606A32C;
	Wed, 18 Nov 2026 19:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WQZzI1w/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719231F000C6;
	Wed, 18 Nov 2026 19:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028561;
	bh=lqrNau0BS6Yc5IC3HNkWQGvXeprlL+onEWvrio19S1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WQZzI1w/S0T7yk3Ysa5pTV7FwcvsS6WgXYWMyvmfuqjCtSUg+OiXJduM+iR6o33Ty
	 0sBLKRQiU1VNLxrOeRRk3ojrM/H3cvBfHoa5dqg38FgmKnKRitxlmGVnW6AGDu5YrB
	 zqI4tyR0nLpDtizHSDacZPRcF0x48FJ3p5eOMuN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yufan Chen <ericterminal@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0039/1756] io_uring/eventfd: reset deferred signal state
Date: Wed, 18 Nov 2026 15:36:06 +0100
Message-ID: <20261118150009.398453606@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yufan Chen <ericterminal@gmail.com>

[ Upstream commit 04fe9aeb4f3c0999e6715385664c677469dfd8f4 ]

Recursive eventfd wakeups must defer io_uring eventfd signaling because
eventfd_signal_mask() rejects reentry from eventfd wakeup handlers. The
io_ev_fd ops bit tracks an outstanding deferred signal so that the same
rcu_head is not queued twice.

That bit is only set today. Once the first deferred callback runs, later
recursive notifications still see the bit set and skip queueing another
deferred signal. This can leave new completions without a matching
eventfd wake after the first recursive deferral.

Clear the pending bit before issuing the deferred signal. If the wakeup
path recurses while the callback runs, a new signal can be queued for
the next RCU grace period while the current callback keeps its reference
until it returns.

Signed-off-by: Yufan Chen <ericterminal@gmail.com>
Fixes: 60b6c075e8eb ("io_uring/eventfd: move to more idiomatic RCU free usage")
Link: https://patch.msgid.link/20260503175710.37209-1-yufan.chen@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/eventfd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
index 6a6ec9d4d6402..1859abc536487 100644
--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -35,6 +35,7 @@ static void io_eventfd_do_signal(struct rcu_head *rcu)
 {
 	struct io_ev_fd *ev_fd = container_of(rcu, struct io_ev_fd, rcu);
 
+	atomic_andnot(BIT(IO_EVENTFD_OP_SIGNAL_BIT), &ev_fd->ops);
 	eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
 
 	if (refcount_dec_and_test(&ev_fd->refs))
-- 
2.53.0



