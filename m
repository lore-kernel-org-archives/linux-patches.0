Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062152;
	b=l1fCFSTvlik3NTZIPu+2tHlNmYtnbZNt66C94N1oGp4+u9dww7vmp2aTpCaUqxWJSLfH
	 I1F1oismhp/ulXgGvWJfHtrUkWx4ZwD0WfgDvBKk0+7nx1Zig0ZszmtqmGQOayHBddXZ6
	 2cQ3WeZXjL8OBTJmMQz4trWTlc51k8izIrlG7bYUQZMlPIL986IJu2CGYsYDF8g4l4bKu
	 41AthO9987EILDRV3/NM2E+oNVWG6UxnvNfCXE3lk05NW8TorZeXWHa13IglytkUkIH6x
	 vimvl7/uxqS5/wHAe1nITBshr+cO2u4S+UXs8PEH6sTlgrCHoogpqacpTxVEPzyKQ9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i4C+RKgVGuGL9iqZZrwpo5TA8fhDOihzU6wN1I8mGBc=;
	b=23fEr0MxLHjMs2XjYMAv2mW7B5cBtLTVUasyBNbvIn1a6qmdb7Z4+/DhSIBIr6wWoWPp
	 XbpJHiRouZxpo65OjDGoRXf9qb7P4r3dWuZcL2y7pMN4OhEbcb6LIkDDv20hB8WujpIEA
	 yl+qq2gE5UKIcygopWT1ZiJUqR8ji3cZRT3Sfuq/4OLGczTEh1Piv+WaBnb8YOnMQWOHm
	 v/4HavZLmOlbkTXJySrseQvGOOlkOvIBoGjoWf5gU6zKHPgEpC4sIg76H10D+4CKLGPxE
	 Z68Hpk3rKloe92o+3TCDfZRpmKzKtnoqlApQWRserLFO0nhC7osZ2Aef7lx1PqQaO9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MWRr6zFp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02279606A66A;
	Sat,  7 Nov 2026 14:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MWRr6zFp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A292D1F008A6;
	Sat,  7 Nov 2026 14:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062151;
	bh=i4C+RKgVGuGL9iqZZrwpo5TA8fhDOihzU6wN1I8mGBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MWRr6zFporGl+5fNBaqO1LfPTU/vdRL5VUZd7CLR1KhYLlY+JjpdD5VCM1UiaHbc8
	 debCkIoCuapg/W6NLoPZneYQI3od0v0hsa/adAMYN3quftBCUI5SGOo5zcs30MnsSL
	 BkLv4X6gYi+ug7YlwwwdIt7fs/7jAAJbCyBRsuRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Iwona Winiarska <iwona.winiarska@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1078/1536] peci: aspeed: Initialize state before requesting IRQ
Date: Sat,  7 Nov 2026 08:51:34 -0500
Message-ID: <20261107135027.971632393@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 61cf765b654b76a62510269521a65e4e4a488f4c ]

The PECI interrupt handler uses the lock and completion object as soon as
the interrupt is delivered. Initialize both before registering the
handler so an early interrupt cannot access uninitialized state.

Fixes: a85e4c52086c ("peci: Add peci-aspeed controller driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Iwona Winiarska <iwona.winiarska@intel.com>
Link: https://lore.kernel.org/r/20260902142600.3580382-1-runyu.xiao@seu.edu.cn
Signed-off-by: Iwona Winiarska <iwona.winiarska@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/peci/controller/peci-aspeed.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/peci/controller/peci-aspeed.c b/drivers/peci/controller/peci-aspeed.c
index b93eb6f43b98f..e5961ed11a8c2 100644
--- a/drivers/peci/controller/peci-aspeed.c
+++ b/drivers/peci/controller/peci-aspeed.c
@@ -527,14 +527,14 @@ static int aspeed_peci_probe(struct platform_device *pdev)
 	if (priv->irq < 0)
 		return priv->irq;
 
+	init_completion(&priv->xfer_complete);
+	spin_lock_init(&priv->lock);
+
 	ret = devm_request_irq(&pdev->dev, priv->irq, aspeed_peci_irq_handler,
 			       0, "peci-aspeed", priv);
 	if (ret)
 		return ret;
 
-	init_completion(&priv->xfer_complete);
-	spin_lock_init(&priv->lock);
-
 	priv->rst = devm_reset_control_get(&pdev->dev, NULL);
 	if (IS_ERR(priv->rst))
 		return dev_err_probe(priv->dev, PTR_ERR(priv->rst),
-- 
2.53.0



