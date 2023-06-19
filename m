Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FCE3C23
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:38:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFECEC433C0;
	Mon, 19 Jun 2023 10:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171100;
	bh=GDLL1JR5A1Suqs/jBdFYy2705BvAbfQy+cFX3FmHHxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kpKLDB9hThhahP3GcVOSDLAMWqkxHXm6xicEi9Wj+ly2NqmICeNGeaDGAQmwyh79Y
	 CN7HXCsGDFRXsRj7kHjezpq10/ryJewI28v2mK2uTqUCTaEGciZ5CfItVsLzAajI+X
	 gzz54ybFyUvDFRb93a8ZoN9w7nmJJMfF+ZiXordM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 147/187] net: ethtool: correct MAX attribute value for stats
Date: Mon, 19 Jun 2023 12:29:25 +0200
Message-ID: <20230619102204.757516595@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
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
index d39ce21381c5b..b8171e1ffd327 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -781,7 +781,7 @@ enum {
 
 	/* add new constants above here */
 	__ETHTOOL_A_STATS_GRP_CNT,
-	ETHTOOL_A_STATS_GRP_MAX = (__ETHTOOL_A_STATS_CNT - 1)
+	ETHTOOL_A_STATS_GRP_MAX = (__ETHTOOL_A_STATS_GRP_CNT - 1)
 };
 
 enum {
-- 
2.39.2



