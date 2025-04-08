Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1A226A1DE;
	Tue,  8 Apr 2025 12:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116389; cv=none; b=U58BT5LzkU0MjeK/zexl8V9hd4KgLkrOIg5p8cYHBujeJYiMb8S7FoXNiD6k14w9iHVClzFweXPyk6bMijB+cxu4PKriGvwz4xDF8/Y3PJev80FXr3nTn3+ZV9PFtiRl5zsEWQ3ar6zKcPQy2wWJQkVaEt0Bqb7RZcEFEf+IxTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116389; c=relaxed/simple;
	bh=ks/1pFT+oQhJjUG/n3uyHqpaXesmOCnajAEjPFNIDD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KL+U96YucZirY+84jLtYBZ+InhrV9tVdgdyUQB48GyFzRQlN3ZcH/fJXUrTfJSzpAyr2ZiauZcGjWRCJQ8+xVdLiwba9auA3TT0dv+FEv+IQ5yAegQnBwOABoVoxRtu95JoAN8QMpV2m8zjksC04UhIAA0C5PZEXiNvzsx0AAAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yf2yrpcr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yf2yrpcr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78916C4CEE5;
	Tue,  8 Apr 2025 12:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116388;
	bh=ks/1pFT+oQhJjUG/n3uyHqpaXesmOCnajAEjPFNIDD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yf2yrpcrVReSBw4AhDO09KHNYs/dYMFxuU+cfHGupDkHrOi5913yPQvbz2mKJt2fg
	 eAQfx6NWMpq3HEKxv/VVKOLHGxeL4h61trFS9o3vCxPulhWps1Y5ro1qoN1lYJyCiy
	 l5Tssz4ivpFPBEyZ9BRFmfo1ncwPWdW3gW6gUuGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Bakker <kees@ijzerbout.nl>,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 121/423] RDMA/mana_ib: Ensure variable err is initialized
Date: Tue,  8 Apr 2025 12:47:27 +0200
Message-ID: <20250408104848.544550550@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 457cea6d99095..f6bf289041bfe 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -358,7 +358,7 @@ static int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct ib_umem
 	unsigned int tail = 0;
 	u64 *page_addr_list;
 	void *request_buf;
-	int err;
+	int err = 0;
 
 	gc = mdev_to_gc(dev);
 	hwc = gc->hwc.driver_data;
-- 
2.39.5



