Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCD01D89F5;
	Tue, 15 Oct 2024 11:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993314; cv=none; b=q2T3Wb0/f+65AOtp4uRCJgOYOSnNX+p9BXcC4/665DG0+f5s8GxMQzkcDeoGj8lZa577jysUWK8UnrEPl4TCoa6+J7cqyuMDiDZF9m1x4KdHzgQ96upljEx3gNdsgNxdOBglibkH/gJah8RNrlqrZL2Cx3wSQ8t1vY3Ta7H1nlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993314; c=relaxed/simple;
	bh=ZttRU153zGv/AknjawzAxOQ9umwT4lIcAzJrIftL1HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpnKZC9wMuIIO2TaM8wsm9AoOfjhUTElxuQTghXXCfHRWBaNVAyDVd3/b1/XndtKTKJ9ffbbx9lhAxY6dnk0ZvsT/2ZlSYGwRokdVXO2buwIUIk4hs9hof3kzbIFq18zoHSYiLMkQFjyMOAr/gQiZdtc96i39CII/wMaosKCaZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OCgT8YL3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OCgT8YL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564FFC4CED0;
	Tue, 15 Oct 2024 11:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993314;
	bh=ZttRU153zGv/AknjawzAxOQ9umwT4lIcAzJrIftL1HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OCgT8YL3FzehLjKb9oiSlJ1HcgwUFF6M/xFyB8Yq5iCdel9kHaXWNRci9yXeoCt3D
	 4I5AyRn1Ig2vh3ZfnwPvKZ0Y/j5qH0uDMS7855OXHemSoY5lZmHLVbiLX3x3Q1IxbY
	 /a6mBQhqRK5sAIj+y5Xn0OZUS35U+CXA8B0BpRrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 374/691] mailbox: rockchip: fix a typo in module autoloading
Date: Tue, 15 Oct 2024 13:25:22 +0200
Message-ID: <20241015112455.190951505@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



