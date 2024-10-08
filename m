Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288A71C32EB;
	Tue,  8 Oct 2024 13:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393009; cv=none; b=oH1Rm2z0eOh9Nji2Clxuavq1N3QXR4Layl/gXrAXS43+n4h1uTUdnRsrUw379vlrUuGigMKwJlivDZUNHop5LBGBZMJW5QCLvwArBasyfqVnbGqVwTNTnJuOeHprqiK7GGrZvwkCUP9oye0zw7eAXYV77430Mf0n9IGyDOHI4xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393009; c=relaxed/simple;
	bh=vCbsXhEFb4l7Cq11jiZ0EWfVTpiai+BQWj3Oiv6FKg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1ajVqG+lLA69QVqOiGyc8W9mPojd7QX5lP37suJJylllTYqooR/5CmdA2PN3hxhAJIE0kXUvXSjnsfYEYnSxl13QwxW+6owr5pmCC0Rrnx0paBSm+sjVDS/jgO26VtDbfyLjF+364E0CHXstyNTwVS847LqzNlSMgPvhfutWBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BVBqbIu1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BVBqbIu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5CDC4CEC7;
	Tue,  8 Oct 2024 13:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393009;
	bh=vCbsXhEFb4l7Cq11jiZ0EWfVTpiai+BQWj3Oiv6FKg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BVBqbIu1Wxvsnzlg0rOe82N2PMP3zkqwASTxERw/91P9vmz/NM7t2TlEY0OkJdEdd
	 C2P8N3FmeOtYuTNhFJKQYHdt20v6kJSe5zX1DMlM2Kb81c3dqlA+r9GtvwLiahppQy
	 KLFeUm4Hi8OS1Nabkm5ddL8ETtGUtW+fVLQpA8rM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/386] mailbox: rockchip: fix a typo in module autoloading
Date: Tue,  8 Oct 2024 14:04:13 +0200
Message-ID: <20241008115629.649215922@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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
index 8ffad059e8984..4d966cb2ed036 100644
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



