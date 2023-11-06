Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978EB200A5
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCApBTdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BFCC433CA;
	Mon,  6 Nov 2023 13:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276013;
	bh=bCDL0ydR2reZld0XYEJvcu1lC1GDh36dzykxdCvZc1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dCApBTdDJb6bM/fex3x2p5op2RjyZ5ibaMPUxbCrOh4aukBltMzhY4vBn5Sk5EpmP
	 1gLGD2tEpOeLO7PrubhQByIzqUsfB9OS4qm9H1lRSpq9DQM7EGeIwVi9+LBZJ5xIsJ
	 Y81a6Prpt57+W2OgaN9riLjJkwIEkG5lsMP0UBoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 39/48] net: chelsio: cxgb4: add an error code check in t4_load_phy_fw
Date: Mon,  6 Nov 2023 14:03:30 +0100
Message-ID: <20231106130259.203011682@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130257.862199836@linuxfoundation.org>
References: <20231106130257.862199836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 9f771493da935299c6393ad3563b581255d01a37 ]

t4_set_params_timeout() can return -EINVAL if failed, add check
for this.

Signed-off-by: Su Hui <suhui@nfschina.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index ecb8ef4a756fc..6ffd5f3dcf059 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -3710,6 +3710,8 @@ int t4_load_phy_fw(struct adapter *adap,
 		 FW_PARAMS_PARAM_Z_V(FW_PARAMS_PARAM_DEV_PHYFW_DOWNLOAD));
 	ret = t4_set_params_timeout(adap, adap->mbox, adap->pf, 0, 1,
 				    &param, &val, 30000);
+	if (ret)
+		return ret;
 
 	/* If we have version number support, then check to see that the new
 	 * firmware got loaded properly.
-- 
2.42.0



