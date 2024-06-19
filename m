Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AF7146580;
	Wed, 19 Jun 2024 13:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802042; cv=none; b=fVMzdh2A0kUmFfIGHZLptC5W43JbWqXl54Rj/bhYn/VzIYxPDapAfiTmFH9WfKIkll2koZgJc3H1aaz9zjctVANxQtwgedWOT71MXw6njwykAP8xAnOetG6oKfU5HT/VaadWPEcWpZN7ZdYNneRqKOJbsxInl+NIY1ZSdKr0BIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802042; c=relaxed/simple;
	bh=7KUq728QZzsRt1MoN1umbGw9jlsMZUrhkO/9awCpQCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BdwRnwVu54d7FomwLS7J+r6IXw8HOPEqF9LtJNv9Xs6cVWXdAP3Xi475+6PFSXqnmJ+q14XG1Y5/5hhSSKusPjvKyDLDUApC5HhypdZ0FpI7SZAdcBeJOVIW5TgM1grfIy4qL/rgK/heQgcLG4+5FCsF5CElPd/Xfe9SbMmdpqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LaSacVze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LaSacVze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366BAC2BBFC;
	Wed, 19 Jun 2024 13:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802042;
	bh=7KUq728QZzsRt1MoN1umbGw9jlsMZUrhkO/9awCpQCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LaSacVze6VWL27VUiwFV5Itv5NBJXQ0Lr/gXpuOW84FKO6L0QhfKJfT9RtV5s65bn
	 D6Q/WlV/ACdG7x++J0oFsw1HO9J1W4wWzJ96WBcJ967EIkKgx0eJBvWt/Sm8c9xRWh
	 w4haaCmRm1QowrYA4a0ltL8okDmEz5rH1lMQzD54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Hariprasad Kelam <hkelam@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/267] net: ethtool: fix the error condition in ethtool_get_phy_stats_ethtool()
Date: Wed, 19 Jun 2024 14:53:34 +0200
Message-ID: <20240619125608.777859141@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 0dcc53abf58d572d34c5313de85f607cd33fc691 ]

Clang static checker (scan-build) warning:
net/ethtool/ioctl.c:line 2233, column 2
Called function pointer is null (null dereference).

Return '-EOPNOTSUPP' when 'ops->get_ethtool_phy_stats' is NULL to fix
this typo error.

Fixes: 201ed315f967 ("net/ethtool/ioctl: split ethtool_get_phy_stats into multiple helpers")
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Hariprasad Kelam <hkelam@marvell.com>
Link: https://lore.kernel.org/r/20240605034742.921751-1-suhui@nfschina.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 0b0ce4f81c017..7cb23bcf8ef7a 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2134,7 +2134,7 @@ static int ethtool_get_phy_stats_ethtool(struct net_device *dev,
 	const struct ethtool_ops *ops = dev->ethtool_ops;
 	int n_stats, ret;
 
-	if (!ops || !ops->get_sset_count || ops->get_ethtool_phy_stats)
+	if (!ops || !ops->get_sset_count || !ops->get_ethtool_phy_stats)
 		return -EOPNOTSUPP;
 
 	n_stats = ops->get_sset_count(dev, ETH_SS_PHY_STATS);
-- 
2.43.0



