Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618248;
	b=kJer+iQEmZOl8g3PABXxqtCG4IVn85jDKjtI4iAA0NuBLfzhuRIO4yy8RSbm3zW01dyj
	 9YHSsjbJ2qGwlCsK3mu2ZxDSuTYzxrYKHssmU9abL07UblcuqhmjDCN1Y9sj22yGLbjwj
	 C4GuuGL3y7ySBTASHNHJaC4rbiRunJQhY3b7LK2B2nAFJRFns4cUnjDODhfQ/8/V5fmGx
	 pB0hJNP5NZhz4NrALatO6VE0sZnzusfh3mrT64TUj5BC3/M7n+05AYv5D7OefNQxSbyKZ
	 YaldFNEvrq4mZftFCdU5SBk11iKm/pMO8Ml7SvbAjX07oQ47wshW3KYurjs8d4Y1VEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618248;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TxBH+E5rq0h/s/BEiiEPuWq2M4Hs5Hmfqde9LUOi4W8=;
	b=iyiaDg1nBNZPzyY6fsFbAh9olJLEEUUy8nLm3dMCTjY7xbG6bNo3ZMTx8nleaR3JFX6J
	 1ui7FTfP09cZfq67HLnqS4bhdc2NYJ62PImS9X5/D7tDNcLchHRTMAhnIiJ0rMHSVCse3
	 x3Gulnvr3dHabAt4SmHc6Qwqpb2d4pFABnKGB9hac1REJOrWq5Le0dJyaZ79cOcjrCBtE
	 FzlTXQoE0n26GGjk1Oc0HOkQxde6wMpGZwZQ5NXcK/bSIRWevXUdhkWrReqr2oeN5nMnc
	 zyvZVxhUktBdSBqjb4RFZBYfqUT6Lj8OFw/ZUh2NloEOGOxS98suTJoLXXbS6NjmBDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lpXJRrd2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7870E606A31E;
	Wed, 25 Nov 2026 14:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lpXJRrd2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8352E1F000C4;
	Wed, 25 Nov 2026 14:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618248;
	bh=TxBH+E5rq0h/s/BEiiEPuWq2M4Hs5Hmfqde9LUOi4W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lpXJRrd2cXAh7Tr7LnF6a325lec/d4Z9inVIJ+6Gs7f+UCjJ4J/9XB7i2xRBOWjEH
	 HNrW7ikfc9spTbxySi6TeXR1+7pxpztXiiKt6fgjVX3oEP7CFNxyMJ+OWFiyus60J/
	 NnlWt4gsC1klwt4d3cV6TaNP4gEtVrg8nCoKbaTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0174/1005] net: stmmac: initialize est_lock at probe time
Date: Wed, 25 Nov 2026 15:25:12 +0100
Message-ID: <20261125143825.818485852@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 98caed39c1db002b2c34b8040ab765c5fa9c6675 ]

priv->est is allocated with devm_kzalloc() on the first TAPRIO REPLACE
and priv->est_lock is initialized in the same place, which ties the
validity of the lock to whether TAPRIO has ever been configured. The
lock is also never destroyed.

Initialize priv->est_lock in __stmmac_dvr_probe() next to priv->lock
and destroy it in stmmac_dvr_remove(). This keeps the lock valid for
the entire lifetime of the device, independent of the TAPRIO state,
and removes the lazy initialization from the TAPRIO configuration
path.

No functional change intended.

Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20261029-stmmac-est-fixes-v5-1-85b830a795a9@oss.qualcomm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 23d96de472f7 ("net: stmmac: re-apply taprio offload in __stmmac_open() and stmmac_resume()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c   | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index f6400d439b9b1..c74dcc2d37dbe 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -8145,6 +8145,7 @@ static int __stmmac_dvr_probe(struct device *device,
 	stmmac_napi_add(ndev);
 
 	mutex_init(&priv->lock);
+	mutex_init(&priv->est_lock);
 	rwlock_init(&priv->ptp_lock);
 
 	stmmac_fpe_init(priv);
@@ -8278,6 +8279,7 @@ void stmmac_dvr_remove(struct device *dev)
 
 	destroy_workqueue(priv->wq);
 	mutex_destroy(&priv->lock);
+	mutex_destroy(&priv->est_lock);
 	bitmap_free(priv->af_xdp_zc_qps);
 
 	pm_runtime_disable(dev);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 399d5cb427005..fc6ec39f2108b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -1028,8 +1028,6 @@ static int tc_taprio_configure(struct stmmac_priv *priv,
 					 GFP_KERNEL);
 		if (!priv->est)
 			return -ENOMEM;
-
-		mutex_init(&priv->est_lock);
 	} else {
 		mutex_lock(&priv->est_lock);
 		memset(priv->est, 0, sizeof(*priv->est));
-- 
2.53.0



