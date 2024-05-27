Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63759155C81;
	Mon, 27 May 2024 19:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837547; cv=none; b=qUNTtIswn71SSwvu3V9APhYL+hfbGPEx2EHlnHQmh9+ltrRLMx3NuxFMkcBs6QJlnInvTqvtWBVv8KJWCekosTJFjwUSyWbzMdsTe68ZqnrZbz7EPcow+TPo8IrvnRUgsiNUBclgQoYipuno2htaFX8+t3dvHlLUoTYyX1+awVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837547; c=relaxed/simple;
	bh=UG/daOBvm7WEhWb+IxBXZW68cLcInkkVE0Vfwa22qE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSVIONu9tWyB9ligzlRMZj/pJOuewk5acax/wV/2ct5JEDAAWW1H7hxX+O4cvDv/7tIQX0MUMtHK/yjcl/SWzJUHYL/IlfXuCWgYcXGlWleO8LuZkufPZCRKZLYciwQoPNbZJ6hhdFHz354PazZfbSpykTprLBB7Njhyb+uIsEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aWeRcK20; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aWeRcK20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0F0C32781;
	Mon, 27 May 2024 19:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837547;
	bh=UG/daOBvm7WEhWb+IxBXZW68cLcInkkVE0Vfwa22qE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aWeRcK207Cw0D/0IBmtwglrEpNiWEKmR35QqiuzoNwSTg84HKz3Mi3xgSI3w8eu+x
	 QajR+TuGTb/U3P9JHfyn2MmWezDW914jDW13NigxGX4DOOe8k8qcsl+m6Tj0AZwYqB
	 h6sjrgPnD25b70CG5hmiCRbbjYuoNnpK4zlpOpQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duanqiang Wen <duanqiangwen@net-swift.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 054/493] Revert "net: txgbe: fix clk_name exceed MAX_DEV_ID limits"
Date: Mon, 27 May 2024 20:50:56 +0200
Message-ID: <20240527185631.039241289@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 29997e4b2d6ca..1b84d495d14e8 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -556,7 +556,7 @@ static int txgbe_clock_register(struct txgbe *txgbe)
 	char clk_name[32];
 	struct clk *clk;
 
-	snprintf(clk_name, sizeof(clk_name), "i2c_dw.%d",
+	snprintf(clk_name, sizeof(clk_name), "i2c_designware.%d",
 		 pci_dev_id(pdev));
 
 	clk = clk_register_fixed_rate(NULL, clk_name, NULL, 0, 156250000);
-- 
2.43.0



