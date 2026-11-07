Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061382;
	b=ENs2D4IgANeI4GkANtJZx1p+N9qWw8QxNrR5n/7VIQUv95pIkr0boBjiTqMNYFMTDumr
	 7kCDjFH8LuYOZPklcFqbsuN+B7HSPBqbSDGfOW3MqMejGwT5phvmYiJYFe2h0O2/grxCK
	 xD540s6woKAk3XTNvbjY2yFpQq1x7FIvl7JNblA8gHrw7RU1SUoqhs7epvEV8oNyswQ35
	 prPndQWDRTDjzVvpk6eRAgE5On72UtgLExHE8bc1FlQFVrlYpuiKFwcJHfjiLl2/cTbXy
	 Zx9fw8lPQSEaBnDQihZ0WYCc5sLRH25bWi4L75HMaZt/nr3eX6ZFYjbTtkw8bqYI4MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061382;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5Ebdtjkxg9k79jBon8KL7NhPlHN2cb/pvj0Io7a3e6k=;
	b=fwoM2L2XgffwNCjtddKrUvaQnDDMMGE+nQmU6/VbMO+lXpTk1aA4pye6DCaAEVjvt5YM
	 /Zb+PE/y+KN+5FrA95NT/ScSCe+31JvdDdhB03E9dqCkrWs8zqv9cJJN0phKXP+RlDYjO
	 WQ7r835VGKDjYgq6rY+q2AfJzkAu+yy8dv4KX+EnkPz80I/0c8yx7cC0Puy2s3GS+auEa
	 HxJcQjKg+DQTxVDEk9dib97MycjLk+Ex0AKhPlbAFCxrIr5iUlR55k3CEWnpZKCIQem9k
	 a2SmP5IwdP/XC8Gb8cwjCYkm3P8D6kFb14J7j95vzIAwvyprvlxIrbNL9z0689I9v+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t0AZDLIY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C72606A33A;
	Sat,  7 Nov 2026 14:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t0AZDLIY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189C41F0089F;
	Sat,  7 Nov 2026 14:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061380;
	bh=5Ebdtjkxg9k79jBon8KL7NhPlHN2cb/pvj0Io7a3e6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t0AZDLIYaSDK4nI3aQkPVblfX0OiSEZq1l8E5C1AIA+9436CbJ4kUiXMZDJ0ogIRQ
	 UnRXfOAkB1QczKbcxmBBVzGWvvfpD3QYGHF6JPzcsK9h1Ch7FDhSnrtA7sOdPvVVFG
	 adXWxLMp+6dFx6NkxDPF1t0fWZaWJh9r0hledVVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0495/1536] io_uring/waitid: honor task_work cancellation
Date: Sat,  7 Nov 2026 08:41:51 -0500
Message-ID: <20261107135011.363748004@linuxfoundation.org>
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

From: Hui Su <sh_def@163.com>

[ Upstream commit 14572de82e5022899e5856008bc9cac97004a88c ]

io_waitid_cb() may run through the fallback task_work path when
task_work_add() can no longer queue work to the originating task. The
fallback runs from a kworker and io_uring marks such task work as
canceled through tw.cancel.

io_waitid_cb() currently ignores tw.cancel and calls __do_wait().
waitid is task-context dependent: __do_wait() performs child lookup
relative to current, and the retry path also uses
current->signal->wait_chldexit. If the callback runs from the fallback
kworker, current is therefore not the task that submitted the request.

Honor tw.cancel before entering __do_wait(). Complete the request with
-ECANCELED and skip the siginfo copy, since canceled task work may run
without the submitting task's userspace execution context.

Keep the existing siginfo handling for normal waitid completion and
explicit cancellation.

Fixes: f31ecf671ddc ("io_uring: add IORING_OP_WAITID support")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Su <sh_def@163.com>
Link: https://patch.msgid.link/20260818103336.1922818-2-sh_def@163.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ sashal: Replaced the upstream tw.cancel check with io_should_terminate_tw(ctx) and the (req, ts) callback signature, and kept the existing copy_si parameter instead of hardcoding true. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/waitid.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 8811b5e275cc7..197b831c5e798 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -250,6 +250,11 @@ static void io_waitid_cb(struct io_kiocb *req, struct io_tw_state *ts)
 	int ret;
 
 	io_tw_lock(ctx, ts);
+	if (unlikely(io_should_terminate_tw(ctx))) {
+		io_waitid_complete(req, -ECANCELED, false);
+		io_req_task_complete(req, ts);
+		return;
+	}
 
 	ret = __do_wait(&iwa->wo);
 
-- 
2.53.0



