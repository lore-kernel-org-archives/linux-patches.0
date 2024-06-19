Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056B31422B8;
	Wed, 19 Jun 2024 13:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802866; cv=none; b=FvJ5RpFFWCPiXxC0/+4QMhz8oTEv/19oD8TQnyS1C/UT5cJi8+KWFB1cDgGfRAPXXZE2sywqD0xWGSONqdAzwW+CRRhDTLO4j7emn8gpZ3MxsKVJcGIepKZAbKpCYyVJB9lI0l2W8QUTbnJGnGj4baYrcKvuszYqZ59LEG8sySs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802866; c=relaxed/simple;
	bh=kE7AFNbmhg9hG47jo/kt4+jgU+o8QzF1Cx0CLM5iVWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDT3tUVqGBwULDcFfqm/58mPhJOFmBM5ajiwLWczCHX9duDqSGNB/E1ciPI+T8YupY3SM6JJaegLw8Yk1RXX8OgPoyq6Sz7i6JG3DVC4069fYqwRQ9ysWXHTrQmom4dcGA3QxcnDAoW768G/JXQiIfMGaiCK3OP42o0N7gObmYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ci8jBYPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ci8jBYPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D811C2BBFC;
	Wed, 19 Jun 2024 13:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802865;
	bh=kE7AFNbmhg9hG47jo/kt4+jgU+o8QzF1Cx0CLM5iVWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ci8jBYPnx9kueb9GgZLEdHA0qB5mjOhlYs1JY2oBltXMZhsrRN4DLCRjoXW5L18U+
	 o4+gSp0Gv8UhtFPr+VsdYFor3sTmPsm5KE9p3afTDXa5EaFYCtn8hM7o9F1zS8SP6R
	 HK3t5kuMVxi1YhfCIhVrLeEPW737tTON/uovAW3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Hariprasad Kelam <hkelam@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 072/281] net: ethtool: fix the error condition in ethtool_get_phy_stats_ethtool()
Date: Wed, 19 Jun 2024 14:53:51 +0200
Message-ID: <20240619125612.614151237@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 5a55270aa86e8..e645d751a5e89 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2220,7 +2220,7 @@ static int ethtool_get_phy_stats_ethtool(struct net_device *dev,
 	const struct ethtool_ops *ops = dev->ethtool_ops;
 	int n_stats, ret;
 
-	if (!ops || !ops->get_sset_count || ops->get_ethtool_phy_stats)
+	if (!ops || !ops->get_sset_count || !ops->get_ethtool_phy_stats)
 		return -EOPNOTSUPP;
 
 	n_stats = ops->get_sset_count(dev, ETH_SS_PHY_STATS);
-- 
2.43.0



