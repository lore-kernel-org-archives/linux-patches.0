Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046910;
	b=eQ+PkG0NcaxvETxW6BaDjdu1f4RudlmgQsoYQGrMeO/Xn2GYzLwdlOcqW34iqH7+MntO
	 kPvXWA06qgLI2hPmK2V28gaK5XWZcrAj7SV+8BYqw7hHJ08gvyu2Wjsm6oTY3Jtlu52RO
	 3EpngB/+iUKr/0/Vr5dRjJl6UQJmnamHGGx3sSzb5HhunHsTdCKEV+eUq4ddQMhlqGfLU
	 erJlPoZTC0iL2qJyzWSEzqOCZPRFPg7CXruUPf44rIlf9CNE7CPZkf9YrAryw/tZ0+m4E
	 EVgcKAb1qrJkMg28SBiRfIYljjRhLYd0tGts6cpHHVKGrkqazP7w6R5ETLS6O/NujRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1a8mfnZOworQX8+Oh5dbglrz7b6cWoOT1U7UxqkxXiY=;
	b=KBX/3qbE5gCGY5/LaVJpLNdS0z88zXDQZa066NaZ3KhotO3l/ZJtHKETzRiuDx06I+k2
	 Wa7h0bsCXl35guq9RnOVZJVTRt1tO24ytC8cE+5Hu5iZxuEBycPEwM68f56N4MUn+QJm8
	 5Znf6KObwO5E2fQ6xOCN9NK2W27rlsmfLrfzjLvjeFo/qXxPao0eOYeQ83iXDFpBfFDAU
	 opy+E5Ziq74v4jKTqkKnKDMjDI3i/IqbpHLPJRjOB6kqnnjTI1LgtpOlj56XhmQO42OLg
	 K220cY3Ysre+nhalL6YvgzSyRhJv5gHNNknP5xNClhXjVY3sjdoBv+delIQAkc+v6YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1brY0gb1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211B7606A31C;
	Thu, 19 Nov 2026 00:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1brY0gb1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F9E1F000C4;
	Thu, 19 Nov 2026 00:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046910;
	bh=1a8mfnZOworQX8+Oh5dbglrz7b6cWoOT1U7UxqkxXiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1brY0gb1aK41kcQoOm9eqQtLWKmEFJFx0VCg0nun8B8UzBFYNN6IDAxaK3VRfZHg5
	 GWplzJxMyJRBxUwbkLWIMCbUtX40YK2iZKs39n5Nw8vobmWOkFyRpE5iMLzk/8eQbX
	 iaT4IvEn7hsYLVZzzaeeIYd2iVwaEnuj70qOFrHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1449/2857] mailbox: altera: shut down RX polling timer on channel teardown
Date: Wed, 18 Nov 2026 15:41:23 +0100
Message-ID: <20261118150253.486140715@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 0cf10e65639cba32d05994f85e6a8f08dd0ffe08 ]

The RX polling callback unconditionally rearms the timer after it
processes mailbox data.  altera_mbox_shutdown() uses
timer_delete_sync(), which waits for a running callback but does not
prevent that callback from rearming the timer after the deletion.

Use timer_shutdown_sync() for the final polling teardown so the timer
cannot be queued again while the mailbox channel is being released.
The timer is reinitialized with timer_setup() on a later channel startup,
so polling mode remains reusable.

Fixes: f62092f6d77d ("mailbox: Add Altera mailbox driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
[ sashal: replaced del_timer_sync() instead of timer_delete_sync() with timer_shutdown_sync() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox-altera.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/mailbox-altera.c b/drivers/mailbox/mailbox-altera.c
index afb320e9d69ce..e81c8bac651af 100644
--- a/drivers/mailbox/mailbox-altera.c
+++ b/drivers/mailbox/mailbox-altera.c
@@ -270,7 +270,7 @@ static void altera_mbox_shutdown(struct mbox_chan *chan)
 		writel_relaxed(~0, mbox->mbox_base + MAILBOX_INTMASK_REG);
 		free_irq(mbox->irq, chan);
 	} else if (!mbox->is_sender) {
-		del_timer_sync(&mbox->rxpoll_timer);
+		timer_shutdown_sync(&mbox->rxpoll_timer);
 	}
 }
 
-- 
2.53.0



