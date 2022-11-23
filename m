Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E921C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4BEC433C1;
	Wed, 23 Nov 2022 09:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196952;
	bh=yTXE314GzzI5gfjgaTfmtAOgLsRR4xsxKctvr/yHAy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LpGLi5JwXaPROBQKqCH4IkJYrnNGor4PLflKHj9WOSlwABzG4t+mGunK9ECNYLrWf
	 Rw/2jZ1Qk5vl2oaJ77Y27uMZAtgGPfyAeHHPfMyhp7/Xnn8oD73mNSUwFn6rSqpvJN
	 gUWDKJfY7w+oScyBD4WQizImdKKbTZq/YbmfMNV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 158/314] net: caif: fix double disconnect client in chnl_net_open()
Date: Wed, 23 Nov 2022 09:50:03 +0100
Message-Id: <20221123084632.727362325@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 8fbb53c8bfd8c56ecf1f78dc821778b58f505503 ]

When connecting to client timeout, disconnect client for twice in
chnl_net_open(). Remove one. Compile tested only.

Fixes: 2aa40aef9deb ("caif: Use link layer MTU instead of fixed MTU")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/caif/chnl_net.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/caif/chnl_net.c b/net/caif/chnl_net.c
index 4d63ef13a1fd..f35fc87c453a 100644
--- a/net/caif/chnl_net.c
+++ b/net/caif/chnl_net.c
@@ -310,9 +310,6 @@ static int chnl_net_open(struct net_device *dev)
 
 	if (result == 0) {
 		pr_debug("connect timeout\n");
-		caif_disconnect_client(dev_net(dev), &priv->chnl);
-		priv->state = CAIF_DISCONNECTED;
-		pr_debug("state disconnected\n");
 		result = -ETIMEDOUT;
 		goto error;
 	}
-- 
2.35.1



