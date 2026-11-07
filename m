Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062727;
	b=Zwb+U4DL6N9xhyMxVW9GQhURLZLVLMO+4RL9rLj9cbsNw8KddrLRvdk6w6WBYw0wW7yU
	 XWRR1Tt/rcXz14LFK9VgHFEitrdhFOdvOkfaVeYkc8Gpr5ZsFrQwCVGZFVnRl2kWPwJVR
	 vexzEDmrUQCE+dA9eUegGm2ybr7TtXv1/cuzvviC2BjgF/5OI6mv4wzf8+cRmyPsDRP4o
	 5SU/TkIpSThH1XX68I2fdZ2y52ah8QrEVG48gLCj4k2YiXqkiSLgdhDjCNCUdzsT52ON+
	 GTg1wBG58Ojkse3xlF7t00VGFmJag3rhK44GuR+RDZUlto2uawbTw0WOk0PpvU9jhrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vBDJ/A6NqCVMtxUZ2mr0OPVqIcd55ZdXcVjipQiBkWM=;
	b=lVmnF/xZ5Ru2jAfQifSa4W7Nran1l2f/FP6VnT9PEibnwf95qzJjUdzQO8dQiYOvwzYJ
	 HNSD4adpflqe90/Ty2MNzwN3zNu0Tx719Nh5Ps+bFC4i9/pf325+lHtOLOL0zGIaYbXvm
	 6gcvHR8BQP+YvGLKS8F3i8xe0asLx1T4Gc7LExIgWRfziASd12qbd8eOGho9EW6tfq3C6
	 My4VqroPXt5IGhd8GLXAt8WsYBJ9vKCOus+Kg3TCfkXTPLLmO72sa75hssgWGefDY9Pqu
	 QYFfKcMR4uDIuHQKzc6LMG9dE4pIxBYOABm/czN/xZDpUEEhKFOh8GnqZJ5mi+PhHcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZjHWeihL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB57606A32C;
	Sat,  7 Nov 2026 14:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZjHWeihL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8EE1F0089F;
	Sat,  7 Nov 2026 14:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062726;
	bh=vBDJ/A6NqCVMtxUZ2mr0OPVqIcd55ZdXcVjipQiBkWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZjHWeihLpxNO4/Q9FFstwjwr3SQb8aMb4vhIDQgV18dqlUvhEE4d8KnXc6nT1rOHJ
	 rNIJFT7IWDqXTr64zBtLztLx9ZFig/eElN0sVhatwq0TD5XcgOfYzkg6upJvx/5pNA
	 E7wH8oYWVARkBah+59YvB9bajkgCsHXoTHQIFWyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 014/869] nvmet: replace use of system_wq with system_percpu_wq
Date: Sat,  7 Nov 2026 08:44:56 -0500
Message-ID: <20261107134852.480685674@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Crivellari <marco.crivellari@suse.com>

[ Upstream commit 3d553be6d295b6cca8fd35cb673fd13934ac4cbc ]

This patch continues the effort to refactor workqueue APIs, which has begun
with the changes introducing new workqueues and a new alloc_workqueue flag:

   commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
   commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

The point of the refactoring is to eventually alter the default behavior of
workqueues to become unbound by default so that their workload placement is
optimized by the scheduler.

Before that to happen, workqueue users must be converted to the better named
new workqueues with no intended behaviour changes:

   system_wq -> system_percpu_wq
   system_unbound_wq -> system_dfl_wq

This way the old obsolete workqueues (system_wq, system_unbound_wq) can be
removed in the future.

Link: https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
Suggested-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 53f6efe00cea ("nvmet-auth: serialize access to DH-HMAC-CHAP state to fix UAF")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c        | 2 +-
 drivers/nvme/target/fabrics-cmd-auth.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index fa9920787a8ff..623b5303de2aa 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -1606,7 +1606,7 @@ void nvmet_execute_keep_alive(struct nvmet_req *req)
 
 	pr_debug("ctrl %d update keep-alive timer for %d secs\n",
 		ctrl->cntlid, ctrl->kato);
-	mod_delayed_work(system_wq, &ctrl->ka_work, ctrl->kato * HZ);
+	mod_delayed_work(system_percpu_wq, &ctrl->ka_work, ctrl->kato * HZ);
 out:
 	nvmet_req_complete(req, status);
 }
diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index 5b010318286e4..af712c6624b36 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -410,7 +410,7 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
 	    req->sq->dhchap_step != NVME_AUTH_DHCHAP_MESSAGE_FAILURE2) {
 		unsigned long auth_expire_secs = ctrl->kato ? ctrl->kato : 120;
 
-		mod_delayed_work(system_wq, &req->sq->auth_expired_work,
+		mod_delayed_work(system_percpu_wq, &req->sq->auth_expired_work,
 				 auth_expire_secs * HZ);
 		goto complete;
 	}
-- 
2.53.0



