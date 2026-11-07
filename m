Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064674;
	b=NLxLgxzBI6O3GGkB9gpIKEXhMpifNH6tPL5Rmfop41dpabyTYJl06Rpl48HXLOzLJD6H
	 /0wjA0cKo9nZvpBsfEFJp/gPuhxnKbQ6WWpohp/ZUkJjUnFWk0JtL2QG0eluKBakaQxAW
	 VSLGX70mzSD/epCnMmvPOFe7UVIFZce57XpTWzM+4OLk/Lgh0d8AwJFKbclKFv4CsloD+
	 CIsPjgNYxp4EpRJ9Pa9dzUKFp0imqvLs0WsBOVx5SR3cx06YJqDjLvSviT4Sx1yQwFhqJ
	 pADxKXHI33x2i/VMEOcGiKp9xCcHJlwhOFmiK4Dv3GWHBhM0JbcjVr0TRjmA0Y4V9Ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KZibGajun3azg9tYCbY4KJygAUQULKwzwgjnZhnP8RY=;
	b=0k8CSwLrlVJIsSyBec3CTxHbWZBZkT2rMNzi9X11kARfSjlkASyDawez2Eiiz7a3sJU5
	 8OjuCQKfnOY2Y0e6aKUSdIyAX+H13aYamyu0KdZG2RUKYr5H4saq6ThukVx87SH9cc6fk
	 2gadJ5z9aUCkI+ztTezOky3SaJrWAPwVYoaweUV5Rz49ZfqLPySm6VaS3oKWCpouSVjPD
	 sGWlKMdFlFafIAX5V1W7Gx/3/SElVksC8EsxZGdlopUHZQV3RWArz03Se+3RrUM7JPNKP
	 YsJEJ/GhQsYtjtUb42FdUoHhQzkCqVf5RX6MYPjfozX5XHoumbdh8ZGx7hNx8IxpmhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LRQ8UA9V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4487606B894;
	Sat,  7 Nov 2026 15:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LRQ8UA9V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516311F008A2;
	Sat,  7 Nov 2026 15:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064673;
	bh=KZibGajun3azg9tYCbY4KJygAUQULKwzwgjnZhnP8RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LRQ8UA9V/loWWHJ6+rzQJ52fLJQqSrBAcQs+Ut80DMVjrOYNamkK07vUiby1FDLEO
	 gUoW3tmjjlqnQ7z9c0AvIxY5vRu/iip9jit3cjF3kLKA2MsG3RDsqHUeSPv2y7z7BE
	 RzFC/ZebM+k2dBSNSAq+3Z48rtBInPBNGiosrmBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0632/1257] mailbox: altera: shut down RX polling timer on channel teardown
Date: Sat,  7 Nov 2026 08:48:48 -0500
Message-ID: <20261107134956.746564350@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox-altera.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/mailbox-altera.c b/drivers/mailbox/mailbox-altera.c
index 17278c2571d34..7cb91413ef7fc 100644
--- a/drivers/mailbox/mailbox-altera.c
+++ b/drivers/mailbox/mailbox-altera.c
@@ -270,7 +270,7 @@ static void altera_mbox_shutdown(struct mbox_chan *chan)
 		writel_relaxed(~0, mbox->mbox_base + MAILBOX_INTMASK_REG);
 		free_irq(mbox->irq, chan);
 	} else if (!mbox->is_sender) {
-		timer_delete_sync(&mbox->rxpoll_timer);
+		timer_shutdown_sync(&mbox->rxpoll_timer);
 	}
 }
 
-- 
2.53.0



