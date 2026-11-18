Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056991;
	b=hBWVPXiqU8Xbs6cOrjie2W8GfFQjunGXk6bQmL8zhA2AE9vhrU5FLalTcERKt6o87bwQ
	 /ngFIOuGAmONUCIQpdVBoYyZC6N5TL2Yubi46hJQTaxPe7gUl35k+/bfM2sO/J+VmTUXr
	 w0YFj+RY4SRLAuSgsbiPfI7dR/KoAacAgwRdAKat+8HJHxa1Cbr/Y1fzpCC/XBDnNmei8
	 M1Wx4sbadoZWFEUp1XuLajL4GYIAxVQU8eQVF0CJDLNV6o6xcMWFov6eb6TUsxXgZU4fN
	 Ncmo55rjow4VvOyRtIk7/s48IQHMkpL1CDzj2g0Jk2Fidx5lNn/4EFD9gome9QdFQiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MvP/PE4fO/pGvO4PUl8X6CNI4h1KxVykR3QJn4ZvW7Y=;
	b=CO3S1pK8frg6qHQo/Y1QbyGyjn/64oXzx/9iAMCFHkNP+mSuVf0vlIrDRZ9s9s4BtnY6
	 qptuyZJrpZU44zuwaPm0PUeNL93/PMBHtUttfD8ES4Y/VpDp7Or3v5WiEZkve+LAhAo3y
	 N0Lib2pQbYWq/0SOr4wyyLZFA0my/88DoBa+YiUbY+2ASpLGBE2MeDyT7EswWekEozdFB
	 h3ENyrLxMMQxnUvX8Gp/GUCTHD+0rYFmKSkOh9/r9QksI+0j2pOx1qElHTqYZlU7WmAib
	 7l44vmosUDIrMfyZcS0FzLY4b9vzGXDheC1cbqlWKxS6t27trLAO09Jjlg51RfImkOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LbK8coI0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64DC606A325;
	Thu, 19 Nov 2026 02:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LbK8coI0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297DA1F000C4;
	Thu, 19 Nov 2026 02:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056991;
	bh=MvP/PE4fO/pGvO4PUl8X6CNI4h1KxVykR3QJn4ZvW7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LbK8coI0kF/0KTh+f5RMv2gz14jOv9/aN5egbwUigdphDyhQMGL4LQBGB0j/7C57j
	 hiJYEdgpgIdQAPwZyvhbksdT9FbX9YlChY4nDk6Y0lsbAL+aWB0LCw9KpuojEkEmfR
	 eOBLW51GeTpPpDuP2x3YFlo7wRomgxAqZ26SJjfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2185/2214] rnbd-srv: publish the sess_dev at the end of OPEN
Date: Wed, 18 Nov 2026 16:04:21 +0100
Message-ID: <20261118150137.758313046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1ed87cdf71c83..1b278fb60a77f 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -411,7 +411,7 @@ static struct rnbd_srv_sess_dev
 	if (!sess_dev)
 		return ERR_PTR(-ENOMEM);
 
-	error = xa_alloc(&srv_sess->index_idr, &sess_dev->device_id, sess_dev,
+	error = xa_alloc(&srv_sess->index_idr, &sess_dev->device_id, NULL,
 			 xa_limit_32b, GFP_NOWAIT);
 	if (error < 0) {
 		pr_warn("Allocating idr failed, err: %d\n", error);
@@ -797,6 +797,13 @@ static int process_msg_open(struct rnbd_srv_session *srv_sess,
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
@@ -808,7 +815,6 @@ static int process_msg_open(struct rnbd_srv_session *srv_sess,
 
 free_srv_sess_dev:
 	xa_erase(&srv_sess->index_idr, srv_sess_dev->device_id);
-	synchronize_rcu();
 	kfree(srv_sess_dev);
 srv_dev_put:
 	if (open_msg->access_mode != RNBD_ACCESS_RO) {
-- 
2.53.0



