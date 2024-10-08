Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62EE190663;
	Tue,  8 Oct 2024 12:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391117; cv=none; b=eEcjnmqxh1cX63SHa7u8yW70ckiTSXFjJrMXeVeV5B505GdkrTnM0UoV1FR7v5nAYgYFp3SgWqTB/vYD1QQMKJ8JsIrl4vDCte713cnZSpO9K/TYAEW+Xbm394gn5tk2uxkUQXp6pz3wQLh/1pBVorH1xj5IajrM1KCTq69s53U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391117; c=relaxed/simple;
	bh=6LfyBdfai0A4pDQYPfZA2ASbw926mU3V92OTd3nmwLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqBTq/839qz51ELHdkCfgXU0blod2Xq3e1fyegxea3Dg+70HHlPNOCPmNpeKXXRhg5VB7TN81W2o0/BY7oKnyNnq1/HndIq4WZ4YuAOBq9FX44Qx/07Tifc6Yd5lRAVoDO0qq2zeng3CJny9a3pk7QQlY2pgAkwkjfhqVMA1bF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tR9+3Fh+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tR9+3Fh+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1B7C4CEC7;
	Tue,  8 Oct 2024 12:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391116;
	bh=6LfyBdfai0A4pDQYPfZA2ASbw926mU3V92OTd3nmwLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tR9+3Fh+UnkQkov2Rt+odx0wCeXWNplFDyATgIuvLkOtDa/+q9BQOJXzuVh1IxpmZ
	 6cKY1F+WHO6XVSXw0QnW9TcuAYXjSuELxwSPwshGZi+IF4Rms/qmGpz/i3BJ4sCCBQ
	 6ITn0QrvQkJoDjSsFfPbmwpL30mdx0Fp+JM/E2A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 013/558] mailbox: rockchip: fix a typo in module autoloading
Date: Tue,  8 Oct 2024 14:00:43 +0200
Message-ID: <20241008115702.744232945@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



