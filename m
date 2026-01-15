Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A3E27A462;
	Thu, 15 Jan 2026 17:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498726; cv=none; b=mR5mM9/bi+o27U2wKMwU+UQgU7M4Ump+ojFjlF20aPkNgmL1v3lRoOc2kpV07/ZLoRN8WU3IGLFXr9Dd74fgAuc+Ith6q3/pbgTrB80pPaZ3i5XzmDgR4s7wdwmDIydfDvPkVWyS2nK1vdU12hg9XjkZ3cUinm7acf3fiO/mPw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498726; c=relaxed/simple;
	bh=7GsEc1/t0pZg8TaqcLGU2X+776VkF+U9ZfO60iWItMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYNNCE5vITNXhDbdMk3EWYeyo+9SpPajvKCIyE4mtyChmLNLpkfc2oYG/zK0tYgN3nYtLBb4wJhiHG5KOyFHPPJB3wgQ6t55qwrvMSdNeWurbZ4hY754ISxy3aDHAvB3/ZMGfhsiIl2cCTip5IYRE7I44g9O3cOcIyFp3oG0JjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x0jIetYI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x0jIetYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E1EC19422;
	Thu, 15 Jan 2026 17:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498726;
	bh=7GsEc1/t0pZg8TaqcLGU2X+776VkF+U9ZfO60iWItMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x0jIetYIDBDqjiN54n8Tzv+Q5/AW91K1aiOyomDJq1Mt00U6Q7IP1l9a55NT8X1QZ
	 xyHlsv2MPu8ST9HDdvEfodSU6xp58oRY6/MkIHw3DW9y/Yj9xQhCtUoxI3Q+JZM0+x
	 p0JTAGp5P06CBKIih7JGhDPKk135YiLSkDV/o7tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Hariprasad Kelam <hkelam@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 499/554] net: ethtool: fix the error condition in ethtool_get_phy_stats_ethtool()
Date: Thu, 15 Jan 2026 17:49:25 +0100
Message-ID: <20260115164304.381519802@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

commit 0dcc53abf58d572d34c5313de85f607cd33fc691 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ethtool/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2111,7 +2111,7 @@ static int ethtool_get_phy_stats_ethtool
 	const struct ethtool_ops *ops = dev->ethtool_ops;
 	int n_stats, ret;
 
-	if (!ops || !ops->get_sset_count || ops->get_ethtool_phy_stats)
+	if (!ops || !ops->get_sset_count || !ops->get_ethtool_phy_stats)
 		return -EOPNOTSUPP;
 
 	n_stats = ops->get_sset_count(dev, ETH_SS_PHY_STATS);


