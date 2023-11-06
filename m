Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30876200BA
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTeYsd1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F2FC433C8;
	Mon,  6 Nov 2023 13:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276415;
	bh=3bYBXkSUnz9AdQQnDJSQMmqLjUrVg9nVmd777WgqfHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTeYsd1JljNslpeYxmcl+5uqJy3Feoz4CedzOepIrfIdmDgHctGu2/TBg+n+q2+to
	 BCr9P7v4qqunlD1GXOhZY2Y9AKZ/Pog/ozs6H2MqyDhcvVWXl1EgoB9tCFlEXh7icd
	 pBMymR0ziRkbbPseNT6+6A7Mqkauhu53OGzGoSfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 34/62] net: chelsio: cxgb4: add an error code check in t4_load_phy_fw
Date: Mon,  6 Nov 2023 14:03:40 +0100
Message-ID: <20231106130303.071269617@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130301.807965064@linuxfoundation.org>
References: <20231106130301.807965064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8d719f82854a9..76de55306c4d0 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -3816,6 +3816,8 @@ int t4_load_phy_fw(struct adapter *adap, int win,
 		 FW_PARAMS_PARAM_Z_V(FW_PARAMS_PARAM_DEV_PHYFW_DOWNLOAD));
 	ret = t4_set_params_timeout(adap, adap->mbox, adap->pf, 0, 1,
 				    &param, &val, 30000);
+	if (ret)
+		return ret;
 
 	/* If we have version number support, then check to see that the new
 	 * firmware got loaded properly.
-- 
2.42.0



