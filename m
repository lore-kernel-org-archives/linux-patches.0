Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061861;
	b=TeoxMk8Dxfa60gj4jqK+5vxnx7ohpDahW1Bq977b/B7VM/1dEKxTwtUM8XdAshosFzbr
	 QHojzdyf9tix699m0fL+a9PP6T/umi+fZ8Q4LRYKuY6Pkel4vxri2nFAyWRhMYQgRHtHX
	 iQFM7DRYCdRgDf5PiHT/6p81ErpJRWxnEpewmnCSDk1rZ7YJ2R06eY8oDQrRR9kdrQ2Ho
	 xYzGGHLcvTeL3Q3PaL4g13Q2kG6Jq0KSyHPYNOUE+r16oqlcicMICIvaB8carfIhO9WbP
	 JKAktkfbNR6o/Jqw6pAQ1UXFezTcUhVln/1s7PvBIuhWTYPfOeytVPuMHFT4FgE7gLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061861;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iyF1w7XWT7tJUjziMlJGMSNaO0vkJ1/F/TmQchWorxg=;
	b=OYz1ncDfQMKH52PsWovk6On+K/sTYCPzT9qOKLX+o1K6hFbnOgaNTyphtzYT43gPchKy
	 n5TjHGJGOisYP74c0YDe2m8HvqjeEwgeDyvZta9fW7zvSLwCE6RM+WOevuGVJlUe818Cp
	 inbeiXpNPuMTytO0XSmROQGud8TUvO1+TztJHKAu5Dis2IbC4fe+KBRFSOrXnWMJaNIhX
	 1F5bedKmRz3rsvooj4mg/VO3L/GldHdjff86mE02vr2u09MurydOhZfk2snmXdL9zokxO
	 ocd048Jr7XbU2blRzHz2QWgsvng7pDi4NCAPBPutH7uRa3W/3lrLrmvZwX8r5XFoh3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hJUZEpX0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E861606A32C;
	Sat,  7 Nov 2026 14:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hJUZEpX0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10501F0089F;
	Sat,  7 Nov 2026 14:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061860;
	bh=iyF1w7XWT7tJUjziMlJGMSNaO0vkJ1/F/TmQchWorxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hJUZEpX0qUXB8ArAzAU8OoR749cmanuycxYAifFGg06/ip4eO7BfAWHwiqy5eknAl
	 uzjBzVuA2PTiOyQxsHtUZTHMPvJj/3zZJTS552kYFIxpTCGop4olkIz4x8KJkDBQ73
	 70Bw04gLHy/6OKf280Sul6WEnLHTYl94Z2zsm8KQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0878/1536] nvmet: replace use of system_wq with system_percpu_wq
Date: Sat,  7 Nov 2026 08:48:14 -0500
Message-ID: <20261107135022.206377307@linuxfoundation.org>
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
index 72a5de1f8252d..c8ff53faddbc3 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -1003,7 +1003,7 @@ void nvmet_execute_keep_alive(struct nvmet_req *req)
 
 	pr_debug("ctrl %d update keep-alive timer for %d secs\n",
 		ctrl->cntlid, ctrl->kato);
-	mod_delayed_work(system_wq, &ctrl->ka_work, ctrl->kato * HZ);
+	mod_delayed_work(system_percpu_wq, &ctrl->ka_work, ctrl->kato * HZ);
 out:
 	nvmet_req_complete(req, status);
 }
diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index 83571f5a50d99..92e75ebe7a173 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -360,7 +360,7 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
 	    req->sq->dhchap_step != NVME_AUTH_DHCHAP_MESSAGE_FAILURE2) {
 		unsigned long auth_expire_secs = ctrl->kato ? ctrl->kato : 120;
 
-		mod_delayed_work(system_wq, &req->sq->auth_expired_work,
+		mod_delayed_work(system_percpu_wq, &req->sq->auth_expired_work,
 				 auth_expire_secs * HZ);
 		goto complete;
 	}
-- 
2.53.0



