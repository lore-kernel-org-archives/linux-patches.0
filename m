Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028277;
	b=3pAAqq4+0H4K46J3euW2GB/bVEpOPR7P9vCRVlqhQmwsOdwNaDvNc/20jLluyhlb5Bqe
	 mxS8UflgxVEwkxYH3yBwsoWn1a8g8iEiptvODpN6of9I31oiWMv975JXHU05R5pvqOSr8
	 ahGsySKYrTR1Jo8U5FFYT72aDEdGPqR+a36LYCO7MYn3f6pZxZN1omR+dWdSj+vFwBb+8
	 5aFLqUz2Ul7Awo7M3JNoBnUHYF2ReC8UVAGluN3Ob8lCrYxsdirCCWCw7Sc0ZtLhWow/T
	 Ecd/zCkI/s/pgXWN6QBx3lEPaTf7Zq0eLSBuVa/vXsMmu5gv0O6qBLXqX26LmChK2bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028277;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0y8Qiqm7Y89P3OjYhBp4K1FVOP/ZOCBOHN+Jpj66VgM=;
	b=K1OOEmwCpVi/U/3Jl5Vkca3K4aL42anfepqrOng0wyT4OGbKV3wE1W10/27dQx88Knti
	 JXjHudMi/cIEFTAfq4tiPiKKAJDPY3I1zJkI5LOumrnezCJR89pbMmqAgcj8nixwEC0Mj
	 7gMko0UMbR7LvLenkL55uLNh8VVbpn/q45f3mOkn4IwbLzRCnz9I4BzVoXNqWl+xFiVBH
	 EwMMiFEPMsyDhAspY9txCgGiXHS7uFrK07FB7bAb8JxEacHpTENHAm8/Pa7Yh1JTHnwdh
	 ZNa+R4vGzTFQInHCWSoI7xY8fB8dUtoa5OwGCXm4J01kR2hEkO83v+MSlfQUiJNeBNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jCl/BLHD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E3D606A320;
	Wed, 18 Nov 2026 18:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jCl/BLHD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BFB1F000C4;
	Wed, 18 Nov 2026 18:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028277;
	bh=0y8Qiqm7Y89P3OjYhBp4K1FVOP/ZOCBOHN+Jpj66VgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jCl/BLHDbddhAg5ZtKtKJnd8kRYww5YsCxvmdoaoYnr4sXd7M1g42ZGBUP3qazLhl
	 0F9py2E/FKa+naBKmhS50s7xs68HVOr3yXb8nZjMMqsaCfPHGIxznWGtmHEhrsOkQ4
	 dEFcbGwGsRZKGwdsszr7o88Sv49/QfkggjNF26p0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2086/2151] rnbd-srv: publish the sess_dev at the end of OPEN
Date: Wed, 18 Nov 2026 16:03:41 +0100
Message-ID: <20261118150237.692077567@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit 08ebf69c78a02afb39b7728f3358c09bc4cf067d ]

rnbd_sess_dev_alloc() stores the empty sess_dev in the XArray as its
first step. An IO message with the new ID from another connection can
find it before bdev_file is set, or hold a reference while a failing
OPEN frees it after a mere RCU grace period. Both are reachable from any
host that can open a device.

Reserve the ID with a NULL entry and store the sess_dev once nothing can
fail anymore. The error path still erases the ID, and no longer needs
synchronize_rcu().

Fixes: 2de6c8de192b ("block/rnbd: server: main functionality")
Cc: "Md. Haris Iqbal" <haris.iqbal@ionos.com>
Cc: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Chris Mason <mason@kernel.org>
Link: https://patch.msgid.link/20261028164415.1262013-41-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-srv.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
index 1180e171cd468..35d9af851701d 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -430,7 +430,7 @@ static struct rnbd_srv_sess_dev
 	if (!sess_dev)
 		return ERR_PTR(-ENOMEM);
 
-	error = xa_alloc(&srv_sess->index_idr, &sess_dev->device_id, sess_dev,
+	error = xa_alloc(&srv_sess->index_idr, &sess_dev->device_id, NULL,
 			 xa_limit_32b, GFP_NOWAIT);
 	if (error < 0) {
 		pr_warn("Allocating idr failed, err: %d\n", error);
@@ -800,6 +800,13 @@ static int process_msg_open(struct rnbd_srv_session *srv_sess,
 	list_add(&srv_sess_dev->dev_list, &srv_dev->sess_dev_list);
 	mutex_unlock(&srv_dev->lock);
 
+	/*
+	 * Nothing fails from here on, so let I/O messages find the sess_dev.
+	 * The ID is reserved, so this store allocates nothing.
+	 */
+	xa_store(&srv_sess->index_idr, srv_sess_dev->device_id, srv_sess_dev,
+		 GFP_KERNEL);
+
 	rnbd_srv_info(srv_sess_dev, "Opened device '%s'\n", srv_dev->name);
 
 	kfree(full_path);
@@ -811,7 +818,6 @@ static int process_msg_open(struct rnbd_srv_session *srv_sess,
 
 free_srv_sess_dev:
 	xa_erase(&srv_sess->index_idr, srv_sess_dev->device_id);
-	synchronize_rcu();
 	kfree(srv_sess_dev);
 srv_dev_put:
 	if (open_msg->access_mode != RNBD_ACCESS_RO) {
-- 
2.53.0



