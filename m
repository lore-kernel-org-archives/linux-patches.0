Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7224D1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF62C433D6;
	Wed, 23 Nov 2022 09:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195048;
	bh=D28NUY+OgrZDPRI55/TXjC2f3gyGpINTmypgydaw21E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NUscDXL+kZiIx7HfKNp7HT7AWmWQ9N0Ais6Chj3ChA6C49Ul4YeQHfAxwzXNTbxbH
	 qA3/hjGepbUU3l00YpA10f/x13H5yXHwMY5b3wf73yFT4fRMQ5rIaipHfH+My4cESs
	 UJYI2pr+davEnumjszrgpYRuiLxBpCqeGoyGfTng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 102/156] net: caif: fix double disconnect client in chnl_net_open()
Date: Wed, 23 Nov 2022 09:50:59 +0100
Message-Id: <20221123084601.669918826@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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
index 910f164dd20c..4dfac31f9466 100644
--- a/net/caif/chnl_net.c
+++ b/net/caif/chnl_net.c
@@ -314,9 +314,6 @@ static int chnl_net_open(struct net_device *dev)
 
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



