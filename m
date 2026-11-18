Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033479;
	b=aqzWQvKJ2DNncwFNBCXat2tQ0pdUZHkWYs5noAaeYskofxlQ2UdF/WH9wMU/ETKE2ZA3
	 UXUV1B7LtVqXWWPJTa6nF7343dyiUB8x8qhDw9aF1sfO5R9yvYefEpmIUTNfTofA59Y7I
	 Uj1T6k3UcR1Naku7fNn8vuum+qwzN7dQ6p4pF0O9hnvd+IYlkoohTIu+H7gDj23h/w717
	 lKrcBec+BFMrDAsknzIqiKQ7t6MJS11NIc6tybtYSXjkHkUmlGTqV1RUBbMkkYYkrHDYI
	 bHL+X6+g5dCWB6DKyaBL9cspplWP9Dzc0cH2aUTnAtnG3bV3PsvfWy+eeK3Ao5GPcxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R+gyPkiArQqprj2u2fFZxD0P2V/ZUKGq6IFJhHe+Bns=;
	b=MXJ5XEFMV5C4Da+QKaXeHCQrXG8G6oRXilBqiOA/61A/T1xgRK3hP56M/qtKZr8HXHWq
	 Aq4oLj+AWsBLN+tMTXI6+nHRzNmGxr68nlGhStrI/FbQA2DqOve9RDCasVO9jebkUkAcQ
	 k5xd6RIQOq1+lcYOY6Dwj3WKGSu9/COi2IcN25f1OFk1mI/usQLAoqJLlxzfrDjJrjvQk
	 M852yEXu8eQYfaR0Nqwv9FgXBeWiVBPs6sVZk6/+x2BSP3LwtXxtfiKmtUpIQn5IvXkOF
	 HuzfdLjakhwmxZUXkqsfucOSGC9uKbUcSggJ2rqur+J+uyB5KQmTWUJfnibYjm35ZFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zHKF7bdU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427AB606A32C;
	Wed, 18 Nov 2026 20:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zHKF7bdU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C7B1F000C4;
	Wed, 18 Nov 2026 20:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033479;
	bh=R+gyPkiArQqprj2u2fFZxD0P2V/ZUKGq6IFJhHe+Bns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zHKF7bdUBSQhB6YP3sc15qiYflfl7NCqzuN6eBmD9m1bAe/R0WEzw2Y4p2vFOjmdB
	 pg0FLYkYNb7498uoK6c7DLu1ftAGxpjBT9DfNuygqppeopMmvOJ95yxkInDNNI0y2i
	 oLVNg+bauxYJj2sYS9AsT4M+CIZmnXrMTdVsYbJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0011/3318] fork: move the coredump and exec checks into create_io_thread()
Date: Wed, 18 Nov 2026 15:10:33 +0100
Message-ID: <20261118150313.998777179@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit e760200370e4de054b6b5f568a7faa911e2956bb ]

Only a PF_USER_WORKER thread returns from get_signal() after a fatal
signal and can go on to create a thread. get_signal() sets PF_SIGNALED
before it dumps core and before it lets a PF_USER_WORKER thread return.
That flags sticks.

The exec'ing thread itself is never signaled. But it doesn't need the check
anyway as we moved cancellation of io_uring requests before de_thread().
create_io_thread() is the only way a signaled thread creates another
one. vhost_task_create() is reached from ioctls alone.

io_should_retry_thread() doesn't retry -EINTR, so io-wq callers give up
the same way they did when copy_process() refused.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lore.kernel.org/r/aq0VLTyxNatFmLOK@redhat.com
Link: https://patch.msgid.link/20260921-work-coredump-fixes-v3-13-8e4adb1619e6@kernel.org
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: 1f978881ce6c ("fork: don't create io threads once PF_POSTCOREDUMP is set")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fork.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index 396a1d4b05e59..802bccf2dea74 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2867,6 +2867,10 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
 		.user_worker	= 1,
 	};
 
+	/* A creator past its fatal signal gets no thread. */
+	if (current->flags & PF_SIGNALED)
+		return ERR_PTR(-EINTR);
+
 	return copy_process(NULL, 0, node, &args);
 }
 
-- 
2.53.0



