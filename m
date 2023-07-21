Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C3920F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A4DC433CA;
	Fri, 21 Jul 2023 19:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967095;
	bh=bSKPCJrYnZhzDos6VxBQxxfHOLqM85Ge9AEQG3UYQdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yL61wm2wGAXsmg+hzE3lOTUsM029B3suK0mIQNgmvSaW67acr7B8T11g9yP86Y85J
	 pdC+yP8gA24UX+/x0QIN2IGgoK/CBLNfcH3T/TjL54KsZncjT+OyNEgnlTRBk1Zv2Y
	 yMmAr1iFpLEzLQgMSwTFv0XY4/uRbjMYEghsCtlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/223] net: dsa: qca8k: Add check for skb_copy
Date: Fri, 21 Jul 2023 18:04:55 +0200
Message-ID: <20230721160522.653180149@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 87355b7c3da9bfd81935caba0ab763355147f7b0 ]

Add check for the return value of skb_copy in order to avoid NULL pointer
dereference.

Fixes: 2cd548566384 ("net: dsa: qca8k: add support for phy read/write with mgmt Ethernet")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 7a6166a0c9bcc..b3f7988668996 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -469,6 +469,9 @@ qca8k_phy_eth_busy_wait(struct qca8k_mgmt_eth_data *mgmt_eth_data,
 	bool ack;
 	int ret;
 
+	if (!skb)
+		return -ENOMEM;
+
 	reinit_completion(&mgmt_eth_data->rw_done);
 
 	/* Increment seq_num and set it in the copy pkt */
-- 
2.39.2



