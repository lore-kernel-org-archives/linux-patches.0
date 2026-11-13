Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591442;
	b=EbJHLZ+scc/WEyQ+Wmlj1stiMwl50faj8kzBWztnLPTeTxtghRPzJSTy2EMrp9SQXWt4
	 BH4DxtjyR0+G8meu4LpNz5XXLOOR/D9fGjTj1BbUgseRkhYLUb55xWDabp/EHan6V7dMa
	 l33FGKi+b4TXm6cbEQKDlyGTCebu+Ug4LXcvoTaW34kUfTPrPBNkPEFIkt9yvVxU2K2j2
	 aagOOEQ0BHwhgTiB+rEqklD4PRtRmxa+qUAKKCYhf3AQxB6Rwm3AReJIjv5T17+gVeG/W
	 2tI4W3amEquzPbyBewUIwb9qmK0vMmumXo1zDSYhiKwd6ncy5dkVMWv33zzLTuuQvEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q+1kYzgOYNIexr8LprNFU9EfzfoMYoenAoxGXuMHPlc=;
	b=UQ4dXhp3bbt+nkxKFWGV+6YnTD5UyjTUXBDY+jeNbZwLHN9i+ZhAAb1vU/df6mkFR/rI
	 wh7uvxCwscgZvYJrA5aAKr9PI8G/6vr0lwSf6vPhGM0sV2T/EZkACKqlpHhZOa5A/fXuF
	 54WHZWw28vbHC8kcJw7gKIM4+ztWGHtN+TX/XKSD5NlQ4LX7N9KsF0Y1FfDYjDgvE+KzS
	 uXKwv/Gqjm0SSgowe/6sS6xVuMI73sdkiiK0YyWXUwPFL2NUeXBJJhh6PohJ3AG47fNW5
	 nZ1vjX6eO1Pu4bowdfw1mIvJdLEV2Dzqp6swNZqAOBoBCh3cX9usnn/8v4D3oN7TWuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IYEM7GL4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370EC607C357;
	Fri, 13 Nov 2026 17:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IYEM7GL4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6ABA1F000C4;
	Fri, 13 Nov 2026 17:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591442;
	bh=q+1kYzgOYNIexr8LprNFU9EfzfoMYoenAoxGXuMHPlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IYEM7GL4ptAVyMyQCmy3Ym3p9zF7G8SeWHDTAMpzFlw89GmHb+qceZK6wax2PykTm
	 YQ75u/dUvtrO2P44S4InsjHqmuuApWeCANgBqZAVcHl1gtQjmv4qMOLZQxXpNQ+IK/
	 gKq/xS4rtJDFX837MV4DGBek5VWi+7pddEVC2fSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 533/670] mailbox: altera: shut down RX polling timer on channel teardown
Date: Fri, 13 Nov 2026 10:51:37 -0500
Message-ID: <20261113153829.973979415@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
[ sashal: adjusted the patch to replace del_timer_sync() where upstream replaces timer_delete_sync() ]
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



