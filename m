Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023974;
	b=yHeYo+VFLvrLdMo7jWd9CmLZ83mKnOGI0/wrH1asXUyoX7qOSD2hhk0blK3dfrgRJCYT
	 F+/DkI+X5suiab75W5Gfva9kREXgcjgdYbwEVsD3OiTMx1R6M3sgwfOXAGp6ctILClhX7
	 bg69IbglPT8GDxVtF7CWLOysHeYUI8E0bZe8oItFIHgBmBvPSw+eB37l2EQTh2fFLQjFD
	 vOevOCCPLLALtecdPpqQJgdaZ8u8+nUBZpTbPvEAOGTpmK21vPgLS0Ue3oNcqMVVdc4Qv
	 /VoAI4jhL7V/xWNnejClsgGCoSxD9F/9bh1xMl5zPtSMWmvmVEG4Qqlk+D2E324XHAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wwE0oapATt9NDiO14R7XBkmAQNgxgFeVxuIcBhvDpFs=;
	b=SySstBnJ3drP1MskBJGrDnxpMcdd69zP9di+L1/LjiP3twxIuGRV1ac1CRb8uU/rBtPv
	 VYW8m4Y/zbtq25unUYR1zADk+bZ5FurexBYMGwAcVYnJuN6AB3AzGB/1vnmkFbHYiFxvw
	 YJXqoq+rWtXgM7e8ub8UbIO2ijxqiOqZN9GwvhYjgrlfI9uNIoyyyuIxkadIpq7iJn2IJ
	 kn/DbAenJCShCssdNth78eWHpS3ffNSzMBTNKfpf0ljUur2milcS56t0EJ2o+A4RF402V
	 hXQ+KVDWIIqCX1CBw+CCAmQpA8/2ZTWmmnB35l1oW7GHTzKAMLhfVUtxZYiIf30hePQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZuKBYRdP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC198606A31C;
	Wed, 18 Nov 2026 17:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZuKBYRdP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C843F1F000CD;
	Wed, 18 Nov 2026 17:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023974;
	bh=wwE0oapATt9NDiO14R7XBkmAQNgxgFeVxuIcBhvDpFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZuKBYRdPeytMIaxxRO/6hN3m5PL7YDHLmIqjZrXHs+BIlrqBc5naPZ9fXRqYh8Civ
	 wy2Q+376qRpzArZK+qRdwY0VqeY3S2TtB+hJnrWkOlKDjyfP1ONuLeRYJQArULcvDj
	 FzvSY9mumJjUr4hxzQRtFQRBUPilCmDwXudxycIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Thomas Huth <thuth@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0519/2151] crypto: qat - fix active_devs leak on crypto alg registration failure
Date: Wed, 18 Nov 2026 15:37:34 +0100
Message-ID: <20261118150140.948731524@linuxfoundation.org>
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

From: Ahsan Atta <ahsan.atta@intel.com>

[ Upstream commit 178829f1b5b259938188a10f4103fdb901b6435e ]

adf_dev_start() registered both alg sets in a single condition.
If qat_algs_register() succeeds but qat_asym_algs_register() fails,
ADF_STATUS_CRYPTO_ALGS_REGISTERED is left clear, so adf_dev_stop() skips
qat_algs_unregister(): the skciphers and aeads stay registered with
active_devs stuck at 1, pinning the module.

Both helpers leak active_devs internally as well - they increment it and
return without decrementing when a crypto_register_*() call fails, and
the asym path also leaves the already-registered akcipher behind.

Split the registration in adf_dev_start() so that an asym failure
unregisters qat_algs, and unwind active_devs (and the akcipher) on the
error paths of both register helpers. While at it, propagate the error
code returned by the register helpers instead of a blanket -EFAULT.

Fixes: 9b2f33a1bfcd ("crypto: qat - fix unregistration of crypto algorithms")
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../crypto/intel/qat/qat_common/adf_init.c    | 24 ++++++++++++-----
 .../crypto/intel/qat/qat_common/qat_algs.c    | 15 ++++++-----
 .../intel/qat/qat_common/qat_asym_algs.c      | 26 ++++++++++++++-----
 3 files changed, 45 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index fe397f39a6c4f..c1e89b0718442 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -250,13 +250,23 @@ static int adf_dev_start(struct adf_accel_dev *accel_dev)
 	clear_bit(ADF_STATUS_STARTING, &accel_dev->status);
 	set_bit(ADF_STATUS_STARTED, &accel_dev->status);
 
-	if (!list_empty(&accel_dev->crypto_list) &&
-	    (qat_algs_register() || qat_asym_algs_register())) {
-		dev_err(&GET_DEV(accel_dev),
-			"Failed to register crypto algs\n");
-		set_bit(ADF_STATUS_STARTING, &accel_dev->status);
-		clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
-		return -EFAULT;
+	if (!list_empty(&accel_dev->crypto_list)) {
+		ret = qat_algs_register();
+		if (ret) {
+			dev_err(&GET_DEV(accel_dev), "Failed to register crypto algs\n");
+			set_bit(ADF_STATUS_STARTING, &accel_dev->status);
+			clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
+			return ret;
+		}
+
+		ret = qat_asym_algs_register();
+		if (ret) {
+			dev_err(&GET_DEV(accel_dev), "Failed to register crypto asym algs\n");
+			qat_algs_unregister();
+			set_bit(ADF_STATUS_STARTING, &accel_dev->status);
+			clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
+			return ret;
+		}
 	}
 	set_bit(ADF_STATUS_CRYPTO_ALGS_REGISTERED, &accel_dev->status);
 
diff --git a/drivers/crypto/intel/qat/qat_common/qat_algs.c b/drivers/crypto/intel/qat/qat_common/qat_algs.c
index 91663805d9e60..f954e7c0e4d0d 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_algs.c
@@ -1320,19 +1320,22 @@ int qat_algs_register(void)
 	ret = crypto_register_skciphers(qat_skciphers,
 					ARRAY_SIZE(qat_skciphers));
 	if (ret)
-		goto unlock;
+		goto err_dec;
 
 	ret = crypto_register_aeads(qat_aeads, ARRAY_SIZE(qat_aeads));
 	if (ret)
-		goto unreg_algs;
+		goto err_unreg_skciphers;
 
-unlock:
 	mutex_unlock(&algs_lock);
-	return ret;
+	return 0;
 
-unreg_algs:
+err_unreg_skciphers:
 	crypto_unregister_skciphers(qat_skciphers, ARRAY_SIZE(qat_skciphers));
-	goto unlock;
+err_dec:
+	active_devs--;
+unlock:
+	mutex_unlock(&algs_lock);
+	return ret;
 }
 
 void qat_algs_unregister(void)
diff --git a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
index aa809e6d67bfe..4292efd7c3967 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
@@ -1340,13 +1340,25 @@ int qat_asym_algs_register(void)
 	int ret = 0;
 
 	mutex_lock(&algs_lock);
-	if (++active_devs == 1) {
-		rsa.base.cra_flags = 0;
-		ret = crypto_register_akcipher(&rsa);
-		if (ret)
-			goto unlock;
-		ret = crypto_register_kpp(&dh);
-	}
+	if (++active_devs != 1)
+		goto unlock;
+
+	rsa.base.cra_flags = 0;
+	ret = crypto_register_akcipher(&rsa);
+	if (ret)
+		goto err_dec;
+
+	ret = crypto_register_kpp(&dh);
+	if (ret)
+		goto err_unreg_akcipher;
+
+	mutex_unlock(&algs_lock);
+	return 0;
+
+err_unreg_akcipher:
+	crypto_unregister_akcipher(&rsa);
+err_dec:
+	active_devs--;
 unlock:
 	mutex_unlock(&algs_lock);
 	return ret;
-- 
2.53.0



