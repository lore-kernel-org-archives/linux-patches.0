Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DF3264FA0;
	Tue,  8 Apr 2025 11:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113311; cv=none; b=OML33aQ1Wojv7ZZeA65A2+xWm3s4/+FtbG9BY9DzMb/iXnFORWIJz0QxyF/e1EKJKRGzAL+x2ONg1cpyFFIQb6zY/HP+hEFxTZKYZhctwZ2dOT20HYbcOQ7PVIclc8NfjSmxfo+7Y3yQ0AG8b6qpbJeb6FgAUGFu4nS6+CJRUis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113311; c=relaxed/simple;
	bh=qxSbjpxzuet8zDF59GqzN3A/96wyDmMiHll9x2Fy0e0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b45XQDlr54aSd5duQYueZsA89kwIUXnPwjuqB6J3sxoNY3px91mWEzsM8kuD+EPXNdNy7V/wohSy18DZzUhBsY9KGnYYuazaD3xnXAD6pGcFZgSXTP27yWQxlVnaGSEM+coWOcBgPrIO2EQR8R+fokXBBMjmnJbX55adax5EOow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3CKwC8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3CKwC8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90730C4CEE5;
	Tue,  8 Apr 2025 11:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113311;
	bh=qxSbjpxzuet8zDF59GqzN3A/96wyDmMiHll9x2Fy0e0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3CKwC8AbjpREss9OrqMK567xKuS/ltE6du/dN2BVejE2H9u+iJ0OQpTi4WpBRcY9
	 jpAg0USGbeo83xlclWneSLr1mhCf/WPv/P08FIt2GtQabhltEshD4ckgNw4IkAbmCT
	 MGSW1tKthk6MWILm5Ty0A9CUdC/DVqpMbf1gKKHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Bakker <kees@ijzerbout.nl>,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/268] RDMA/mana_ib: Ensure variable err is initialized
Date: Tue,  8 Apr 2025 12:48:04 +0200
Message-ID: <20250408104830.466805935@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kees Bakker <kees@ijzerbout.nl>

[ Upstream commit be35a3127d60964b338da95c7bfaaf4a01b330d4 ]

In the function mana_ib_gd_create_dma_region if there are no dma blocks
to process the variable `err` remains uninitialized.

Fixes: 0266a177631d ("RDMA/mana_ib: Add a driver for Microsoft Azure Network Adapter")
Signed-off-by: Kees Bakker <kees@ijzerbout.nl>
Link: https://patch.msgid.link/20250221195833.7516C16290A@bout3.ijzerbout.nl
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mana/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index 6fa9b12532997..c4c49a3f11b0a 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -327,7 +327,7 @@ int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct ib_umem *umem,
 	unsigned int tail = 0;
 	u64 *page_addr_list;
 	void *request_buf;
-	int err;
+	int err = 0;
 
 	mdev = dev->gdma_dev;
 	gc = mdev->gdma_context;
-- 
2.39.5



