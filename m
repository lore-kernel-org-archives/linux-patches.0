Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AED61F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:11:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8E0C433CA;
	Fri, 21 Jul 2023 16:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955892;
	bh=kAbhavTRXMZLzvAHYvDG4l5HNQLqWxE99a1yblRSVsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNI7L/IdhpQb7c4zwZJWZ7y+jIt7FCeVdhYZOybtxc5EbvsuTqhc/2+o47LIHFRVe
	 9T1HJcEI6aabgt3zr2kdDgano0iuvBedvZJIsM9Fir5MbaF7wBuE3j9wo29/4+uV0h
	 6ammIAV+wUhpojS7PIMvTTlb4Sigl/lRL7INplvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 066/292] net: dsa: qca8k: Add check for skb_copy
Date: Fri, 21 Jul 2023 18:02:55 +0200
Message-ID: <20230721160531.625541357@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
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
index 6d5ac7588a691..d775a14784f7e 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -588,6 +588,9 @@ qca8k_phy_eth_busy_wait(struct qca8k_mgmt_eth_data *mgmt_eth_data,
 	bool ack;
 	int ret;
 
+	if (!skb)
+		return -ENOMEM;
+
 	reinit_completion(&mgmt_eth_data->rw_done);
 
 	/* Increment seq_num and set it in the copy pkt */
-- 
2.39.2



