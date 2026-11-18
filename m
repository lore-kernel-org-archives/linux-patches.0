Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022253;
	b=otwaTsBNxB20i7DQllhzLQhoSJi20sbj3itSxjdRrS87PaVDU+VJo5nCecNziCcRX1c+
	 ZSx3BN9NvpWFX8yjKQZPL1dYYwnFZiGVNlJNqz7Zg3jWNaLbXxvA40MTcEGpoHfntXy4r
	 tm3lpq60lklGs0WxT2x8vqzcNpC5Idv0FAREuAmmO5HaunFQBJphXeumR0bJjjHXHSUJg
	 iTtqq9Dwf+P6hGLQarfDYxCnva7lfCZJTRZ0RUviaqO5vTaTWVhamsL4krriD8f1dmGMj
	 7rnStqaL2EAY3UjwMHs2zpNm7MdH2QtAE5XXkmXEWm+FoswvUcugyTz4IRqvk45eiPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022253;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tBU83PJMtSVlkt6BQ94YNXrKH3ZY6+npKL3JSTOf4HE=;
	b=j1HvA4H5INB1He2ISSwYcnsggnEbX8s1+G82ExrpRLZPu8hKqsfvpNzoJVUfDafTahgW
	 81aa2y6tFN+zOfRM3KvqeWsfYj+IgP8iDTvidpPa9byizsxnfFrbFcGs7N+loZhy695x2
	 Vt3X8qFaUuZXkuHw2cmoxu+Tl/QcjUe2JjfZbovI9TML60LEd8JBiFtF9bm+vKuM+d05R
	 xyO50ybCSEB/UewTuE2z11sd854zfTb11OWHb/PhBaPbqaHeNhTMCODHIgN5Wj00zMBSS
	 4DHjaAHxCzJ+okWvTV+Dcj8n5HX60d8q7uV3ZvLmO52bOsMMm6z+gEodipZ9mlz4zAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0TWw3MiE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4369606A32F;
	Wed, 18 Nov 2026 17:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0TWw3MiE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495C91F000C4;
	Wed, 18 Nov 2026 17:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022252;
	bh=tBU83PJMtSVlkt6BQ94YNXrKH3ZY6+npKL3JSTOf4HE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0TWw3MiE+tzRz+rQ1kgnLT/MD8NvzO1sXwWxP1gTzLyDp/xL+k2QvEFMpGr+bcuDE
	 mujx2/ZE/LYNKCdhnEnUFYczdbvcktanDnP6Ao/1F2w3kBixK+ngImGfHI+shgelO2
	 RN13fFjdym/r/OYgVVwJPXmRC6fCdXLuoF5Yz5zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2597/2651] rnbd-srv: publish the sess_dev at the end of OPEN
Date: Wed, 18 Nov 2026 16:03:57 +0100
Message-ID: <20261118150417.770346168@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 1cfa2c5807597..1c80e8fe02671 100644
--- a/drivers/block/rnbd/rnbd-srv.c
+++ b/drivers/block/rnbd/rnbd-srv.c
@@ -431,7 +431,7 @@ static struct rnbd_srv_sess_dev
 	if (!sess_dev)
 		return ERR_PTR(-ENOMEM);
 
-	error = xa_alloc(&srv_sess->index_idr, &sess_dev->device_id, sess_dev,
+	error = xa_alloc(&srv_sess->index_idr, &sess_dev->device_id, NULL,
 			 xa_limit_32b, GFP_NOWAIT);
 	if (error < 0) {
 		pr_warn("Allocating idr failed, err: %d\n", error);
@@ -802,6 +802,13 @@ static int process_msg_open(struct rnbd_srv_session *srv_sess,
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
@@ -813,7 +820,6 @@ static int process_msg_open(struct rnbd_srv_session *srv_sess,
 
 free_srv_sess_dev:
 	xa_erase(&srv_sess->index_idr, srv_sess_dev->device_id);
-	synchronize_rcu();
 	kfree(srv_sess_dev);
 srv_dev_put:
 	if (open_msg->access_mode != RNBD_ACCESS_RO) {
-- 
2.53.0



