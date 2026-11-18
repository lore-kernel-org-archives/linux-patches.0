Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020723;
	b=lDHVeKODHFFi2zPCh4KKLHD/F/FqVV4bh6+qPIJyTLAwtHTwU1tO3RZtQDK+Uc2+8gyJ
	 VCTy+SkbUJ86ogH+AKPwXixnRms0MAZl4VD16tx2+fabfLx4S9LyO0laulWRU+4JIrwiz
	 4jRESIVSY4y9BEACWvh+sp2N8Irr2LAXJJ+mh2WajtcLWqs2q8UcxSVns7aBHbM996DVb
	 nMBJtYRJ/spIAZqggiVF6C6JKm8n/CPaqmyisQirtzjsdimYqgf1lYr5GGoCVST1+nZNQ
	 NQ8ozEa5aARZRshfAfhh4v+Xwpm4F9ZbFlDujyJXeT092GQE2dUZacN/nv7+uVViJPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020723;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6fqFx4Fuzuwq8oDB8RH2zIWV+gMy6IYWOlslClUaX6I=;
	b=olyzUoA7ftQMJam0McuIKdB8ecNqQ9jxlLtSAHZUfVhFPih+hWqDp/x0mctEFH+RxeEG
	 NnLvo/Y3O6V7EfU8Y5TlGHeN9BlWt+ZGxUIm2+FF+mjDALgjWXeHFVabtoNXpphHzn8ZD
	 hdJTRDjPl0WymrLSXmI+fUtninudvPwixdCq3YZk59BCynmD/SxE2ygGXUhk4ebkqn+vQ
	 BRJe96K4RX9IOfqnID9vBG9YSxLRg8HWTMdwAenvu85YZ2po4ooY0QxtDamOyxX0r0tpn
	 9fLBzn8QHeC+K0rcQsVUIF3tIX7Ka4XaB6TDsklxBWhdviPUs8SX6er9kFpm1PcheCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eayvN+sF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE1F60A382D;
	Wed, 18 Nov 2026 16:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eayvN+sF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4551F000C4;
	Wed, 18 Nov 2026 16:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020722;
	bh=6fqFx4Fuzuwq8oDB8RH2zIWV+gMy6IYWOlslClUaX6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eayvN+sF4LbUn2EfCbw7K163B9W460BDBu0J3FxWuX0UC88DCkn69DIXYCf15ojNn
	 TaXjaPFnqu5uQh7xHejjzJ8ioVfPq+vRadcOIraMpO04PW07xs+HoweumYfU9ga0mM
	 0Lxv5X2tsdkG73dicjBpcJdIyiQu0RT7nttwWJpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2013/2651] ublk: allow a NULL io->cmd in the cancel callback
Date: Wed, 18 Nov 2026 15:54:13 +0100
Message-ID: <20261118150358.722589855@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <tom.leiming@gmail.com>

[ Upstream commit 4915dc0a1834457520ef0592bfd454b26901614f ]

A cancel from the control path, like STOP_DEV's ublk_cancel_dev() after
dropping ub->mutex, takes the command and clears io->cmd under
cancel_lock, then completes it with io_uring_cmd_done(), which takes
uring_lock to remove it from the cancelable list. The server's io_uring
cancel runs ublk_uring_cmd_cancel_fn() under uring_lock in between:

  control path cancel                    io_uring cancel (uring_lock)
  io->cmd = NULL, CANCELED
  io_uring_cmd_done()
    waits for uring_lock                 cmd still on the list
                                         ublk_uring_cmd_cancel_fn(cmd)
                                           io->cmd == NULL: WARN

ublk_cancel_cmd() then sees CANCELED and leaves the command alone, so
nothing is wrong; only warn if io->cmd holds another command.

Fixes: ab03a61c6614 ("ublk: have a per-io daemon instead of a per-queue daemon")
Tested-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20261011063555.1142277-7-tom.leiming@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index ca4cb9d760353..d806c6104c74d 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2910,6 +2910,7 @@ static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd,
 {
 	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
 	struct ublk_queue *ubq = pdu->ubq;
+	struct io_uring_cmd *cur;
 	struct task_struct *task;
 	struct ublk_io *io;
 
@@ -2926,7 +2927,9 @@ static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd,
 
 	ublk_start_cancel(ubq->dev);
 
-	WARN_ON_ONCE(io->cmd != cmd);
+	/* NULL if a cancel from the control path took it meanwhile */
+	cur = READ_ONCE(io->cmd);
+	WARN_ON_ONCE(cur && cur != cmd);
 	ublk_cancel_cmd(ubq, pdu->tag, issue_flags);
 }
 
-- 
2.53.0



