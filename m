Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F127B1F471B;
	Wed,  6 Nov 2024 13:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898245; cv=none; b=N/5BaYOydaxRh/+6hmwvwW7EDk1+qM8f/3Z60a0o8YMmB5+lOtNu6jFwFZQxyKouT+/W5T457QchTXvSlaIihQcq41CNT83w+2mQ175Hc6WgGR7kHFXO7U8aKY2Z7rsSHWXiezgx3wSicvdSPjk/F1pdnNuZsFl5pBiEoiOOuFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898245; c=relaxed/simple;
	bh=vagRmYK6GNa0gProiSHJpO+dpd0M4xbRJuUboCa9EGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDrlOG8YfVm9j4ySPa5MnZZLP+WI8ZMlysaDyfaqo0z7339o4vsrR5MWtU6GUwf/EJyxpe9URT/217Tq1SB+PcSobZDLqxgTVetdeg1qO5aOFIXX69JJKnHlWaIBJZEe/KUNFVG/Ycj/4L6YW8JuZ1BcPjCULzinHCk+H94L230=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2npizpyU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2npizpyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C891C4CECD;
	Wed,  6 Nov 2024 13:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898244;
	bh=vagRmYK6GNa0gProiSHJpO+dpd0M4xbRJuUboCa9EGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2npizpyUY+GZLknCtKwNoVPJ8tFMjTH1sAhzSttiff5b8lobTjaJctIFuzB+2rPqY
	 Qts2nUw4ggJNRPUzHT0goFKbwQe1qQQ76+nZhcLsHtzmAr1JKqPKyLbFQyjv9pSs/r
	 bKuTXkvab0reZSRU9AHZ+UmJxcCKQTKu4GCnzUqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 173/462] mailbox: rockchip: fix a typo in module autoloading
Date: Wed,  6 Nov 2024 13:01:06 +0100
Message-ID: <20241106120335.794641684@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liao Chen <liaochen4@huawei.com>

[ Upstream commit e92d87c9c5d769e4cb1dd7c90faa38dddd7e52e3 ]

MODULE_DEVICE_TABLE(of, rockchip_mbox_of_match) could let the module
properly autoloaded based on the alias from of_device_id table. It
should be 'rockchip_mbox_of_match' instead of 'rockchp_mbox_of_match',
just fix it.

Fixes: f70ed3b5dc8b ("mailbox: rockchip: Add Rockchip mailbox driver")
Signed-off-by: Liao Chen <liaochen4@huawei.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/rockchip-mailbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/rockchip-mailbox.c b/drivers/mailbox/rockchip-mailbox.c
index 979acc810f307..ca50f7f176f6a 100644
--- a/drivers/mailbox/rockchip-mailbox.c
+++ b/drivers/mailbox/rockchip-mailbox.c
@@ -159,7 +159,7 @@ static const struct of_device_id rockchip_mbox_of_match[] = {
 	{ .compatible = "rockchip,rk3368-mailbox", .data = &rk3368_drv_data},
 	{ },
 };
-MODULE_DEVICE_TABLE(of, rockchp_mbox_of_match);
+MODULE_DEVICE_TABLE(of, rockchip_mbox_of_match);
 
 static int rockchip_mbox_probe(struct platform_device *pdev)
 {
-- 
2.43.0



