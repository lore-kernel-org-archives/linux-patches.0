Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4014DC123
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 11:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68DDC433C9;
	Mon, 19 Jun 2023 11:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172552;
	bh=bmUyoeaeEcyjZ4zOZ+43Ae8D+MVj0J803yJGKXcZaPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oOJJIhzXm0uTpdr6KozrxhMmJuGmncL3Sob7cze5qDlIRCQSOc0sqJhJJYJ25CMqy
	 HJLuG2gqyMaAzY1+eZAup0h18CZTPeIg47eaqBJXYwuigfkZ71u/zx3PPqZDnkvPA/
	 TjiqchdF0njBTSTGdq1bRLtXYUSieH4WdizeUAxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 083/107] net: ethtool: correct MAX attribute value for stats
Date: Mon, 19 Jun 2023 12:31:07 +0200
Message-ID: <20230619102145.367541181@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 52f79609c0c5b25fddb88e85f25ce08aa7e3fb42 ]

When compiling YNL generated code compiler complains about
array-initializer-out-of-bounds. Turns out the MAX value
for STATS_GRP uses the value for STATS.

This may lead to random corruptions in user space (kernel
itself doesn't use this value as it never parses stats).

Fixes: f09ea6fb1272 ("ethtool: add a new command for reading standard stats")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/ethtool_netlink.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index f7204bdfe8db1..97e5d303810f2 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -743,7 +743,7 @@ enum {
 
 	/* add new constants above here */
 	__ETHTOOL_A_STATS_GRP_CNT,
-	ETHTOOL_A_STATS_GRP_MAX = (__ETHTOOL_A_STATS_CNT - 1)
+	ETHTOOL_A_STATS_GRP_MAX = (__ETHTOOL_A_STATS_GRP_CNT - 1)
 };
 
 enum {
-- 
2.39.2



