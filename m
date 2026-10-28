Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209213;
	b=WfgVmEHyvGoTKHIUOjjN/TzoWWrmK2H+Gv5CapCWOurknDSWMr8GGbP7sGVIUbEQXSZa
	 YTC6ueU3khtyWlrU73WeiCOQH8C6F7R1hciUDwc+P5ekog+qtS7YEuzfAN12vy6VQ/NcF
	 c/apMVHSHEX+h4PbFoh73ED4uHik+GFsyYY0iZu6Nc/ymV9587IuNnWbX2BKdXIiF5zNi
	 KtD9bTYloJPHxa6BSWiP0bDKcyxLIUGd9k25mDlI8a0kv7rWmUjSxkCMLuLSJNYpldTqd
	 jk/GJzYfzL8oEx0nL1ZQdURxtJTcnROTBrKqh0+sbs73AGwDyQ3AWs6uBSqUDaIhE9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eOHfVxGi5ZY82vEjI5XQ3Hne1+79u+G/gOcsEVodIYk=;
	b=TzUh69egl3paf5P+h/r25f7MI4VeHP1iE5Y0iEZKF01l0joHTwulJ0nd8HXICGSVs1TT
	 dA22XwQpLO2WIKPu9EF8hN75YGlp+nU+Lmzm+AxuVMMtNf65RUUS8T338nxG1ZXlz4o+a
	 JkKNznKmNxdebnrdUMAML6uvzfri79GEyJmHs95KDrjZF1DvccNp3nCyN4l79CdAhCK4t
	 YJ9ACNL3CIW0jV3hQGJQRKFWjqAb67KH7dBk59S22MBMFBOVUE67/ZyxC3k0TvIElf6NH
	 ZbqTfzLx7irIy933KxEF3MfOrT+tLWdfmDOUjTcJLyl0QlgDKlHKXzY0wwcRp9J1jdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k31xZcYR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56948606A31A;
	Wed, 28 Oct 2026 17:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k31xZcYR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822B81F01825;
	Wed, 28 Oct 2026 17:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209213;
	bh=eOHfVxGi5ZY82vEjI5XQ3Hne1+79u+G/gOcsEVodIYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k31xZcYRdFZJQhtm4DMz4WY/+JrLYKUn0XMjFKHv2ElVuXOXi2OCoVrWkEkyH0Ha6
	 gPqDdpglgf2Z348+y4u0jWfxeDh9E1OXEEotLfXv3LEiFhncKB1IdNqIdMH9onnoWi
	 K3nTo8NhFHklDi6bNgO7KT9/6NYuFN5LyK2Dl85w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao-Fu Chen <shf.chen@mediatek.com>,
	Jens Wiklander <jens.wiklander@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 392/516] optee: register TEE devices only once fully initialized
Date: Wed, 28 Oct 2026 17:59:04 +0100
Message-ID: <20261028170012.766831573@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shao-Fu Chen <shf.chen@mediatek.com>

[ Upstream commit c108feca0a096f8db25d1b69130035025e9e936d ]

optee_probe() called tee_device_register() on both the client and the
supplicant device before the rest of struct optee had been initialized.

tee_device_register() calls cdev_device_add(), which does two things at
once: it creates /dev/tee0 and /dev/teepriv0, and it links the device
into the tee class so that class_find_device() can find it. From that
moment on the device is reachable both from user space via tee_open()
and from kernel space via tee_client_open_context(). The only gate in
teedev_open() is tee_device_get(), which merely checks that
teedev->desc is non-NULL, which was already set by tee_device_alloc().
Therefore, there is effectively no gate at all.

A context opened in that window can run against a struct optee where

  - optee->call_queue.mutex is not initialized by optee_cq_init()
  - optee->supp mutex and completions is not initialized by
    optee_supp_init()
  - optee->rpmb_dev_mutex is not initialized yet,
  - the message argument cache is not initialized by
    optee_shm_arg_cache_init()
  - optee->ctx is still NULL

Any open session or invoke during this window takes uninitialized
mutexes and dereferences a NULL pointer.

Fix it by moving both tee_device_register() calls down to the point
where all of struct optee is set up.

Fixes: 4fb0a5eb364d ("tee: add OP-TEE driver")
Cc: stable@vger.kernel.org
Signed-off-by: Shao-Fu Chen <shf.chen@mediatek.com>
[JW: adding fixes and cc]
Signed-off-by: Jens Wiklander <jens.wiklander@oss.qualcomm.com>
[ sashal: adapted separate FF-A and SMC probe changes to the unified optee_probe() with optee_remove() cleanup ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/optee/core.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/tee/optee/core.c b/drivers/tee/optee/core.c
index 6ea80add7378f..f45883476b122 100644
--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -707,14 +707,6 @@ static int optee_probe(struct platform_device *pdev)
 	}
 	optee->supp_teedev = teedev;
 
-	rc = tee_device_register(optee->teedev);
-	if (rc)
-		goto err;
-
-	rc = tee_device_register(optee->supp_teedev);
-	if (rc)
-		goto err;
-
 	mutex_init(&optee->call_queue.mutex);
 	INIT_LIST_HEAD(&optee->call_queue.waiters);
 	optee_wait_queue_init(&optee->wait_queue);
@@ -744,14 +736,24 @@ static int optee_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, optee);
 
+	rc = tee_device_register(optee->teedev);
+	if (rc)
+		goto err_remove;
+
+	rc = tee_device_register(optee->supp_teedev);
+	if (rc)
+		goto err_remove;
+
 	rc = optee_enumerate_devices(PTA_CMD_GET_DEVICES);
-	if (rc) {
-		optee_remove(pdev);
-		return rc;
-	}
+	if (rc)
+		goto err_remove;
 
 	pr_info("initialized driver\n");
 	return 0;
+
+err_remove:
+	optee_remove(pdev);
+	return rc;
 err:
 	if (optee) {
 		/*
-- 
2.53.0



