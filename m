Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB922320A
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:09:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E605C433D2;
	Mon,  8 May 2023 11:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544169;
	bh=zBUO6Q+oLZsVeqjAV6ti4PlJPEmV9aqZMSAdbAtyvJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SUvbJ3bX46fhpl2AaW5N+cWQ95Z43nHyS153yrPNfKNQE9wScWIbpmCuqo5RHETfd
	 exTDG5tSnqiiVrIM5gE7R82KbLhvaqIpccZrPBwx/YQiqVgNhz2aHklMrLtb0x2kfI
	 yq6z4v1Nyeb7y9GA4VQ6ikULCqZX+6E11Q8O59KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 324/694] wifi: ath11k: fix return value check in ath11k_ahb_probe()
Date: Mon,  8 May 2023 11:42:39 +0200
Message-Id: <20230508094442.876918776@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 342fcde9d91460f01f65707e16368a1571271a3a ]

ioremap() returns NULL pointer not PTR_ERR() when it fails,
so replace the IS_ERR() check with NULL pointer check.

Fixes: b42b3678c91f ("wifi: ath11k: remap ce register space for IPQ5018")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230217030031.4021289-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/ahb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index 920abce9053a5..bad3946b44bf6 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -1174,7 +1174,7 @@ static int ath11k_ahb_probe(struct platform_device *pdev)
 		 * to a new space for accessing them.
 		 */
 		ab->mem_ce = ioremap(ce_remap->base, ce_remap->size);
-		if (IS_ERR(ab->mem_ce)) {
+		if (!ab->mem_ce) {
 			dev_err(&pdev->dev, "ce ioremap error\n");
 			ret = -ENOMEM;
 			goto err_core_free;
-- 
2.39.2



