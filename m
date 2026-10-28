Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213646;
	b=CWr4aun+Wm4rHQi2Bro+RPhLnoD7jpTQuVnNJzrzWGvJ3qn4xTtw9fQRJJOOUHQQADD8
	 OwAMJSqNrXzNHKryz9k9/bF2EwpnkX0+wucQu/TS+fDSgtpCG6v02Qf5mE04CqPXcrUXe
	 RUJM8Jze56n0G2zU3j5YmON7F4Ku5HPDXyN/fNYd9UEe6ue2NAQ890/S7YHsnszFewpwI
	 sWAjCkwLlUbfBIGpHAiqmTo0bArnL/4F0xOtkSOMAMCSOiYu4UadQgK6f0RRrfnh35KD8
	 8BrVhq/pniYdY+BaxkIChit5WY+6ZwZc3gLsK5X8WMo/4so5zYuoj5tu2NAw5UJFSNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tHpEWA/eMbB0oIDw710vJ5bMIfsgcYqp7UPtFHvN2EE=;
	b=Ohtq9ai02J71TBIUIPHT+C+RqPWuQbo6ocrSglmFSeVt9YllDSAZ+QidjaKcAyv/z6PF
	 edGNBPzimg1B+FzHw69GrbhRJMNISAOita0f+7/zctN766Dg6q3X+fwPnT2Byqlx6JaO/
	 X+KKwA4UT658EboW+y5g5nqUcLeXU4eZlKesuA3GJuydSTW7z3uxE3MFUw+++Wyc9hrit
	 2LpNabFFNBcF88w/FDK2OrzZ4q/33Kqw8oxaoJ/Y+a+joD35+8lce9bouNhOLa7kYz7Vp
	 YgLBWz02xI0awlR6ZASktrvrX6UFMJctyhn8dw26NfIaj684Qt2hFMu3E8ETHj/zhVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ht2uyruD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFEF606A31D;
	Wed, 28 Oct 2026 18:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ht2uyruD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CA31F01825;
	Wed, 28 Oct 2026 18:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213645;
	bh=tHpEWA/eMbB0oIDw710vJ5bMIfsgcYqp7UPtFHvN2EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ht2uyruDWUAiCVFX16xjLz8JzJ+aZRvuc1KTRDwattDs2l9Kq0iyHFBu1d4FfIBjF
	 1Jdf121zKflHYvxw+R10wsn8Lbs3TstepSW7aZMfuiuYVq/bD/doBVB2IOaAr56xBL
	 CyG6cWzYN85khuozg1EdCbLK2RJWX8rtt3RDc9jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao-Fu Chen <shf.chen@mediatek.com>,
	Jens Wiklander <jens.wiklander@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0535/1887] optee: register TEE devices only once fully initialized
Date: Wed, 28 Oct 2026 17:43:51 +0100
Message-ID: <20261028170511.520448160@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
[ sashal: Adjusted context to match the older OP-TEE probe initialization sequence. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/optee/ffa_abi.c | 16 ++++++++--------
 drivers/tee/optee/smc_abi.c | 17 ++++++++---------
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/tee/optee/ffa_abi.c b/drivers/tee/optee/ffa_abi.c
index 927c3d7947f9c..f0ecd931035e3 100644
--- a/drivers/tee/optee/ffa_abi.c
+++ b/drivers/tee/optee/ffa_abi.c
@@ -844,14 +844,6 @@ static int optee_ffa_probe(struct ffa_device *ffa_dev)
 	}
 	optee->supp_teedev = teedev;
 
-	rc = tee_device_register(optee->teedev);
-	if (rc)
-		goto err_unreg_supp_teedev;
-
-	rc = tee_device_register(optee->supp_teedev);
-	if (rc)
-		goto err_unreg_supp_teedev;
-
 	rc = rhashtable_init(&optee->ffa.global_ids, &shm_rhash_params);
 	if (rc)
 		goto err_unreg_supp_teedev;
@@ -871,6 +863,14 @@ static int optee_ffa_probe(struct ffa_device *ffa_dev)
 	if (rc)
 		goto err_close_ctx;
 
+	rc = tee_device_register(optee->teedev);
+	if (rc)
+		goto err_unregister_devices;
+
+	rc = tee_device_register(optee->supp_teedev);
+	if (rc)
+		goto err_unregister_devices;
+
 	rc = optee_enumerate_devices(PTA_CMD_GET_DEVICES);
 	if (rc)
 		goto err_unregister_devices;
diff --git a/drivers/tee/optee/smc_abi.c b/drivers/tee/optee/smc_abi.c
index e6e0428f8e7be..89ab5323f9fe7 100644
--- a/drivers/tee/optee/smc_abi.c
+++ b/drivers/tee/optee/smc_abi.c
@@ -1467,14 +1467,6 @@ static int optee_probe(struct platform_device *pdev)
 	}
 	optee->supp_teedev = teedev;
 
-	rc = tee_device_register(optee->teedev);
-	if (rc)
-		goto err_unreg_supp_teedev;
-
-	rc = tee_device_register(optee->supp_teedev);
-	if (rc)
-		goto err_unreg_supp_teedev;
-
 	mutex_init(&optee->call_queue.mutex);
 	INIT_LIST_HEAD(&optee->call_queue.waiters);
 	optee_supp_init(&optee->supp);
@@ -1531,6 +1523,14 @@ static int optee_probe(struct platform_device *pdev)
 	if (optee->smc.sec_caps & OPTEE_SMC_SEC_CAP_DYNAMIC_SHM)
 		pr_info("dynamic shared memory is enabled\n");
 
+	rc = tee_device_register(optee->teedev);
+	if (rc)
+		goto err_disable_shm_cache;
+
+	rc = tee_device_register(optee->supp_teedev);
+	if (rc)
+		goto err_disable_shm_cache;
+
 	rc = optee_enumerate_devices(PTA_CMD_GET_DEVICES);
 	if (rc)
 		goto err_disable_shm_cache;
@@ -1551,7 +1551,6 @@ static int optee_probe(struct platform_device *pdev)
 	optee_shm_arg_cache_uninit(optee);
 	optee_supp_uninit(&optee->supp);
 	mutex_destroy(&optee->call_queue.mutex);
-err_unreg_supp_teedev:
 	tee_device_unregister(optee->supp_teedev);
 err_unreg_teedev:
 	tee_device_unregister(optee->teedev);
-- 
2.53.0



