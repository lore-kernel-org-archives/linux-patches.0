Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6020F19E7EF;
	Thu,  6 Jun 2024 14:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683114; cv=none; b=lJXU9SZto/lcl9m/r4WYf1o0FaSxJwAhCi20rEBZfyWPq0mPvl1vPBAXO1FDdksJsV7W+DAto4GLc+tQnP2ESpZg7xXHn7ud77YCFVIERis0mevKu1KQ2aTZ9yxXPMxgMdpWJDV4f4gAHe1/09X4SNXQ+V4VVa54k4bUoHB/fCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683114; c=relaxed/simple;
	bh=tncSrIyGdxfIbXUENZbJjppyRLsAys4zDbElrqnMZhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6Y2eC5RZB2D6tJ0SvfjC4tAw/XG0IsLeZE/r6s/ZaaNHN9jxUVksxu2ONthNx8KTWKmyWLzsM7FKLjLaBcNxvFoFlKZfEN6qRBEyOPxeMH4MvfdPepOU3wqR5fwsSYeqVIw58vtHF4cZ0Nk6LNmdloNtKdYVpK08Fgnv9JmrTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZdYLqnj+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdYLqnj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE25C2BD10;
	Thu,  6 Jun 2024 14:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683114;
	bh=tncSrIyGdxfIbXUENZbJjppyRLsAys4zDbElrqnMZhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZdYLqnj+v51uaDc+71tyTBunMsNwqSwqhUWB9/1nd9rii9LIwN4HkayZ5p9ldqsJW
	 7TifWljVwONYZ537dqe+b7gKWxH5QBlQZpZRZCIL/p43BEnFh1MFvi6JNyluNcp2bh
	 IAt38Ia/F4QY0PyFuX9ME+JXV9nrTPl2Wz+2Ks7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duanqiang Wen <duanqiangwen@net-swift.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/744] Revert "net: txgbe: fix clk_name exceed MAX_DEV_ID limits"
Date: Thu,  6 Jun 2024 15:55:19 +0200
Message-ID: <20240606131733.960711425@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Duanqiang Wen <duanqiangwen@net-swift.com>

[ Upstream commit edd2d250fb3bb5d70419ae82c1f9dbb9684dffd3 ]

This reverts commit e30cef001da259e8df354b813015d0e5acc08740.
commit 99f4570cfba1 ("clkdev: Update clkdev id usage to allow
for longer names") can fix clk_name exceed MAX_DEV_ID limits,
so this commit is meaningless.

Signed-off-by: Duanqiang Wen <duanqiangwen@net-swift.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://lore.kernel.org/r/20240422084109.3201-2-duanqiangwen@net-swift.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
index e457ac9ae6d88..4159c84035fdc 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -551,7 +551,7 @@ static int txgbe_clock_register(struct txgbe *txgbe)
 	char clk_name[32];
 	struct clk *clk;
 
-	snprintf(clk_name, sizeof(clk_name), "i2c_dw.%d",
+	snprintf(clk_name, sizeof(clk_name), "i2c_designware.%d",
 		 pci_dev_id(pdev));
 
 	clk = clk_register_fixed_rate(NULL, clk_name, NULL, 0, 156250000);
-- 
2.43.0



