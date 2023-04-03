Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9C96FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE62C433EF;
	Mon,  3 Apr 2023 14:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533307;
	bh=7ghJs8LmqnVNF5ZFjS+B5Kels7rqILpJKIg1J9yyst4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RHlmfihx48BlsfiQyYMNjpozahANwCdG1FjeiMLZ6PeWru0AHE+Op1rJ2liFcMCgJ
	 ngUcj1lSi65RktNVRQoXF2EUBw4Le2Zt7hx/U/F4/VAuHcZdqUiShYj7DD4JieDpMS
	 aG6FeBUXCXkoRGPoeWDgq5dBPDkpQpqIKjT92Ld8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 116/187] bnxt_en: Fix reporting of test result in ethtool selftest
Date: Mon,  3 Apr 2023 16:09:21 +0200
Message-Id: <20230403140419.785882796@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 83714dc3db0e4a088673601bc8099b079bc1a077 ]

When the selftest command fails, driver is not reporting the failure
by updating the "test->flags" when bnxt_close_nic() fails.

Fixes: eb51365846bc ("bnxt_en: Add basic ethtool -t selftest support.")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index ec573127b7076..7658a06b8d059 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3738,6 +3738,7 @@ static void bnxt_self_test(struct net_device *dev, struct ethtool_test *etest,
 		bnxt_ulp_stop(bp);
 		rc = bnxt_close_nic(bp, true, false);
 		if (rc) {
+			etest->flags |= ETH_TEST_FL_FAILED;
 			bnxt_ulp_start(bp, rc);
 			return;
 		}
-- 
2.39.2



