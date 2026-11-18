Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033199;
	b=CHsoTPIANjo07mqjPI6vTPYJLH4R7V+pqYzlXXHMomOcO5+Tc0D1xVK7qUpUjRnQeZ+g
	 n+2N6+ctmADimRzmQS3VZh7DYt0Ah9fwyJ1AwARkZlEZaDwIAMEULek6Y+MIX4NcAD4Yi
	 VXD4INn6ZzhgCkyqOr6KuX9uX+Y6n5funFhYEJYYTLpjIlsxsdRVrc1xcm2MBzMuq+k5h
	 OfB+owm3VDUWHO1fs9W3ICa8jAAWQexfEBTmoVJ03dPT/iEgwU3lHmj7tq+gOck9gLM2n
	 40u1yG5kAnht52zwDMnPoV6GhQiU01y0VCT9pdjmabYOtksF18iAY6wh5y6eEO1r3Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8SsKyAXE/DD58EM9hoxkLKXfqGqFSsKcYxRw3NHIlyw=;
	b=vdFnv527umGfN4hZUX4JY8f/I3iGPCaOODHpTC1UOKnqRC1goRUbi5QsZ1UvUrOW9UkA
	 A6+iTP9naEDSrlj3szacSsw18wuQzahrRlDNNnyVr8rpg7Uh/K7QyGkHNSHmvR/ESqTIz
	 z9/klC0EMaIpC7bSINfsmXmaiJsFIm3K/i6PHutTbiIiaRhbppMYDVQxaPNmC/pLQNEUt
	 3patdpLACzpx3rTvWIfegZZ5id59IuZZaHLxV7Pt+DYuGVRCBUOWsWDnYgA4t4SMj9hmN
	 NqMWqh4Kk6FnVFd9aHLQJQrsdk3ltCwd8gqRdAxzkzCu6/ZUHNcxeUD5pu4hJ26NETQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lUINwSle;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AF0606A33A;
	Wed, 18 Nov 2026 20:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lUINwSle
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8DE1F000C4;
	Wed, 18 Nov 2026 20:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033199;
	bh=8SsKyAXE/DD58EM9hoxkLKXfqGqFSsKcYxRw3NHIlyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lUINwSleGAMlqCwZ0WlisS8mvUF44zxA94Uif69eS+UtIJJv95flQ54f9AZycXUEG
	 YVZU3ptsWVBtDyE2R/C8d/wCeE8u9Yq1DKZZBJ1KnFuQKeYC1VWem8j7KArjBqasrX
	 8JBeS/Usd4vdE1LBJZJGteTEQG+uNCXtbwKh+z70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1682/1756] rnbd-srv: publish the sess_dev at the end of OPEN
Date: Wed, 18 Nov 2026 16:03:29 +0100
Message-ID: <20261118150116.658742534@linuxfoundation.org>
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
index dc944a194cc3d..ced4e435f963f 100644
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



