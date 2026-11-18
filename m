Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050722;
	b=UfUUQlBx3AaHV5RP5/3hPZMxgjtKqowQmQVIFgaEVEnL06SDYtr+uMrMAdRYiO83qiiz
	 yMH50z/isnUP91yC07NnTuu5oPgSUV4VkhycF7jl0CX86Arm1hS2CtjK+bExLe54HIj0e
	 T3uwjhvOPyB6AjsK6nFL/Vh0dQ7zLza5uC3xy3eqXZd+MYd/DbKfcTfmGF2EcNeRfz22X
	 eiBWSSFmyqbHHdwOxES8QpYs58aJ0vOfo2pDLSTou34Rvo3r3e3e4ib/b8LkrnurWrOb4
	 KLs5gzX2g/efKd+u/LFlXRLUoXTiwFKyW/ZPSv8ayW0zavZlw1+8dGlfhMX09fqZt0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=71MbvJEemToYRGcH3aBwJ43FlQtJicUEbmjEBSBITBk=;
	b=h48qFcSH9I6geXZM4XX3Yve68mpuTcL9RJpIlhqQ3S7F8Gd8TJIocUdoa0/taPE24nCd
	 vz11wttT5GhWh26rTr1A1nXPuhvd+M6khpvk9HTLWMPASkatWvjrvOjgmvWGTB5MWnm6G
	 m9wjpS789/9j4sDPrPQq/yt57+dJkiBvtYcSOtv0i1MxdzdyuKXQqAgMRVK31UKKaf6oS
	 gcpyqsBALCWoRqsMLLdGncjcODVU7LIliLc1Z9kxJBIkrKsUtv0nWV8aN/PNf7Y6u/8xf
	 nZ9sp5iNPYIHqJAuiy4hcvPXumXW3FvD8a/ITppRX/NFG5uUUa5qowtuUO6HZdTjRwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KJl/F2y6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC10A606A320;
	Thu, 19 Nov 2026 01:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KJl/F2y6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CF01F000C4;
	Thu, 19 Nov 2026 01:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050722;
	bh=71MbvJEemToYRGcH3aBwJ43FlQtJicUEbmjEBSBITBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KJl/F2y64Y567EAqbfsgZDQP8v+1Y6c51SK0g+/rjFpAkyW0uPIvcr3RsTpVwX1Qg
	 rwxjfjo4zkNN2UBORgIb2/NDpc2Zx73TUSyJ0qlUr4v6y/pwBNihZ0RyjxBcuBksmC
	 jMXNZXNbgMaiGvvFfAI/taBQPPC11VECnfl/YhjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2810/2857] rnbd-srv: publish the sess_dev at the end of OPEN
Date: Wed, 18 Nov 2026 16:04:04 +0100
Message-ID: <20261118150342.779856071@linuxfoundation.org>
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
index 7874d60e07bfb..b853ec11e0c51 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -416,7 +416,7 @@ static struct rnbd_srv_sess_dev
 	if (!sess_dev)
 		return ERR_PTR(-ENOMEM);
 
-	error = xa_alloc(&srv_sess->index_idr, &sess_dev->device_id, sess_dev,
+	error = xa_alloc(&srv_sess->index_idr, &sess_dev->device_id, NULL,
 			 xa_limit_32b, GFP_NOWAIT);
 	if (error < 0) {
 		pr_warn("Allocating idr failed, err: %d\n", error);
@@ -788,6 +788,13 @@ static int process_msg_open(struct rnbd_srv_session *srv_sess,
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
@@ -799,7 +806,6 @@ static int process_msg_open(struct rnbd_srv_session *srv_sess,
 
 free_srv_sess_dev:
 	xa_erase(&srv_sess->index_idr, srv_sess_dev->device_id);
-	synchronize_rcu();
 	kfree(srv_sess_dev);
 srv_dev_put:
 	if (open_msg->access_mode != RNBD_ACCESS_RO) {
-- 
2.53.0



