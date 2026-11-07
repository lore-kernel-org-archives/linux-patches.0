Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063004;
	b=fQ8jfTKKOyMtvl3qZD7wtbRbf2x0yi5aZ7A7ne4U9df+tTgQQNueLO3iLdPIBawgUqJ1
	 T2/7nFNQlXL4YmRoizN0Hw2+xDtnIvx7ht1jM+PeVAfxT/7+O4xZhRoTp4QmvTYZsVkLS
	 ULtbE+cD5Mgjg/EnwZjw3KhAQriqnwEpoqRBLiQnyuGzldCsnM/4etvOoDyFU+R0dHKXu
	 JSZqrJ6oP0Ky22AMAazdF8KlpbkzYlaHBJt0WKN17O+5VY2A0s1QkbuNaGnM/VQww8Qsg
	 y739n/JjezGRYzWZyypLpniSbFaqz0i/u8e+so2WfMjoxB2vOdsLWk/CKSt58JfcH+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063004;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xiXrAaPvtoDWi/wvGO7MjZxTJBa2cyIcWtxLjX3sZ98=;
	b=NYd0iZmUPJu8/FCGpSWFnc0naoxEMwkPC/S0FoHPbmdiCUkj7M1URELPVyooh6dmVFP6
	 nmKmhhtTco/QCXOD8PbxUSPN1LKvtdxb794lyZGVqNJjEv2tOSEeTAKA7Qn+tSit821mJ
	 nhjAGgtfbJnIbTr337gZXTCGRwGNQPujmDMt3fMYCOSaySOGFEgEniTgCKef75IFJaUjv
	 Y8hT/8sYC9yO+ub1ap5TR/hNMabTPSeq/IaZSV9BlpTUuKd+f1ULMBERONTk1sfyExM/n
	 NrxpbdPrRo7ll/HJUPKVvipwnYz7XQROhTvCXSMavDgHoCm3mmBDxzLjVH9C950q51Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LKJkVL6H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CBD606A33B;
	Sat,  7 Nov 2026 14:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LKJkVL6H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106561F008A1;
	Sat,  7 Nov 2026 14:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063004;
	bh=xiXrAaPvtoDWi/wvGO7MjZxTJBa2cyIcWtxLjX3sZ98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LKJkVL6H6kfv7SG0zz1F8epFoSBoLEV2tFEspa7bUsXIWkrz8RNdpZ0linOy7hNxg
	 jWrnRdtJZcQnVJuSfTiUxKU/Vhy3O+qTUzg0bxVROlHkuTrT91A9pJo/2eGL7TqiD3
	 aOcjDmttg3xvnv8nD4Q8Gsx/YTNbrwUvm2YQI8hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Iwona Winiarska <iwona.winiarska@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 257/869] peci: npcm: Initialize state before requesting IRQ
Date: Sat,  7 Nov 2026 08:48:59 -0500
Message-ID: <20261107134900.484801114@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 425125e6d408b5969afb99c3e95a391f1f1ad81d ]

The PECI interrupt handler uses the lock and completion object as soon as
the interrupt is delivered. Initialize both before registering the
handler so an early interrupt cannot access uninitialized state.

Fixes: 3e16184a1bd8 ("peci: Add peci-npcm controller driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Iwona Winiarska <iwona.winiarska@intel.com>
Link: https://lore.kernel.org/r/20260902152256.3591658-1-runyu.xiao@seu.edu.cn
Signed-off-by: Iwona Winiarska <iwona.winiarska@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/peci/controller/peci-npcm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/peci/controller/peci-npcm.c b/drivers/peci/controller/peci-npcm.c
index 9318689912412..3cc4e959aff36 100644
--- a/drivers/peci/controller/peci-npcm.c
+++ b/drivers/peci/controller/peci-npcm.c
@@ -253,14 +253,14 @@ static int npcm_peci_probe(struct platform_device *pdev)
 	if (priv->irq < 0)
 		return priv->irq;
 
+	init_completion(&priv->xfer_complete);
+	spin_lock_init(&priv->lock);
+
 	ret = devm_request_irq(&pdev->dev, priv->irq, npcm_peci_irq_handler,
 			       0, "peci-npcm-irq", priv);
 	if (ret)
 		return ret;
 
-	init_completion(&priv->xfer_complete);
-	spin_lock_init(&priv->lock);
-
 	ret = npcm_peci_init_ctrl(priv);
 	if (ret)
 		return ret;
-- 
2.53.0



