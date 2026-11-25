Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618952;
	b=FiGN5BjE1ad43f3e/7pag3Dl5C2THctlnbDpWQ7GyP4jM2AldWy3uNaxIGczC7qofn5d
	 b7JKtHRn8MZU8Kp/9FezMcRUcCz4rGXEE7oq+Ugbl3IBMYFKeQ/3fWXUo5QCiBXnA+4lL
	 amIefJeXhPStHx51uIxB+vaHclks5jQW7MLfjPsabE/rP4AgbjAV+4R0IxjB5x5l2Rht6
	 4c+tXJc62uKqs6kdsk+TJReSxRUyAz1W/u1rJnGVFkeGuNSTaIRdDjEheHWJvncGpFboT
	 RkERh0bLndqMYaOixi0EucNFQhdQyE8ui7LwzUPJsYXK3Vj/lWTGHzft8VUGNfqAp4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uJoy3XVWv+If9/WJUrfPdEe7uE/UPjVGXr0P4wH+kVc=;
	b=wRaJkxK8zojTOvcWzCvEVpxtuvFtiNIVd4rPhqtHqWJZ/flGlpU0qmgVYbHvAYkycCSv
	 NYSQZSEmljzFwK+T03ywmeEMayszo0N357w92DHe3G7Hxeentts9A4h1vf7ZMqofQK8Z2
	 tP/VYZ7+l8miGHOljYuYKBKuyvzasqsGCIKPK/Ko/4KNZUYDMo/RI+JXMgegSaG6lWv60
	 RvRb9IUc8AzJX5DNSNm17/72kbtKz2dnYT59zWNqtpSXiY/FMoWqEiX8RKI+Cl+wiJsb3
	 Tx+LJj58zWUbgJAd8HxMwBNvB3aDRuVrBC/yf7Eo0icbIhUQXdGx/Q0vuv/dUhJuK6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="IxJ3D/JN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5B4606A321;
	Wed, 25 Nov 2026 15:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IxJ3D/JN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DABE1F000C6;
	Wed, 25 Nov 2026 15:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618952;
	bh=uJoy3XVWv+If9/WJUrfPdEe7uE/UPjVGXr0P4wH+kVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IxJ3D/JNtoMOUkuL9qbEb0fTjd3fgntSUTjEMlMWPCWpnHGwwRrMqK69UKMY1scka
	 VpDa00OxbI99ANWGaVrh7rgczO+2NUgUVN+XB0TsvbHqEQ/ABuZNaQQarkYLtDYul4
	 9YtGCVmX0eGi4GfRmPGnomzn1cNYqs00KVc17adE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Korenberg <socketpair@gmail.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0440/1005] ublk: publish a new device by its id only once it is set up
Date: Wed, 25 Nov 2026 15:29:38 +0100
Message-ID: <20261125143832.056887264@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Mark Korenberg <socketpair@gmail.com>

[ Upstream commit e5c463e5074a940c644d54d8fc29aba06709aab0 ]

ADD_DEV stores the device in ublk_index_idr when it allocates the id,
and control commands find it there as soon as ublk_add_chdev() has
initialized its struct device, before the char device is added. If
dev_set_name() or cdev_device_add() then fails, ublk_add_chdev() drops
the initial reference to free the device. A DEL_DEV that found the
device meanwhile waits for ublk_ctl_mutex, then calls ublk_remove():
cdev_device_del() of a device that was never added, and a second put of
the initial reference, which frees the device under the callers still
holding references.

Reserve the id with a NULL entry, which idr_find() and the idr iterators
skip, and store the device once ublk_add_chdev() succeeded.

Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Signed-off-by: Mark Korenberg <socketpair@gmail.com>
Reviewed-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20261105-ublk-del-gendisk-hang-v1-1-913a91a4314d@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index cc4e72fd5d4df..8d3406147b96e 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -4403,14 +4403,18 @@ static int ublk_alloc_dev_number(struct ublk_device *ub, int idx)
 	int i = idx;
 	int err;
 
+	/*
+	 * Only reserve the id: the device is published by
+	 * ublk_publish_dev_number() once it is fully set up.
+	 */
 	spin_lock(&ublk_idr_lock);
 	/* allocate id, if @id >= 0, we're requesting that specific id */
 	if (i >= 0) {
-		err = idr_alloc(&ublk_index_idr, ub, i, i + 1, GFP_NOWAIT);
+		err = idr_alloc(&ublk_index_idr, NULL, i, i + 1, GFP_NOWAIT);
 		if (err == -ENOSPC)
 			err = -EEXIST;
 	} else {
-		err = idr_alloc(&ublk_index_idr, ub, 0, UBLK_MAX_UBLKS,
+		err = idr_alloc(&ublk_index_idr, NULL, 0, UBLK_MAX_UBLKS,
 				GFP_NOWAIT);
 	}
 	spin_unlock(&ublk_idr_lock);
@@ -4421,6 +4425,19 @@ static int ublk_alloc_dev_number(struct ublk_device *ub, int idx)
 	return err;
 }
 
+/*
+ * Make the device visible to control commands by its id. Before its char
+ * device is added, DEL_DEV could find it and remove a char device that was
+ * never added, and drop the reference that ublk_add_chdev() drops on
+ * failure.
+ */
+static void ublk_publish_dev_number(struct ublk_device *ub)
+{
+	spin_lock(&ublk_idr_lock);
+	WARN_ON_ONCE(idr_replace(&ublk_index_idr, ub, ub->ub_number) != NULL);
+	spin_unlock(&ublk_idr_lock);
+}
+
 static void ublk_free_dev_number(struct ublk_device *ub)
 {
 	spin_lock(&ublk_idr_lock);
@@ -4971,6 +4988,8 @@ static int ublk_ctrl_add_dev(const struct ublksrv_ctrl_cmd *header)
 	 * ublk_add_chdev() will cleanup everything if it fails.
 	 */
 	ret = ublk_add_chdev(ub);
+	if (!ret)
+		ublk_publish_dev_number(ub);
 	goto out_unlock;
 
 out_deinit_queues:
-- 
2.53.0



