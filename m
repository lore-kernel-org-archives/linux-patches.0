Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641401DF27F;
	Wed,  6 Nov 2024 12:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895294; cv=none; b=tNUZ6nKpAf4jgOiV5JPEbzjD/9UoRAkyssCYiH88awqFs/OfUWukor/yatubYCERPU/5973JA4Q0nxbF34Da0c/OwiQwRNBC8UnPEhLME52oKy3Yz1XZu9iz/cOB4hayqethl97aJqWYuDqkkWyRwRNZgOfBvpxY7uZnIgUdF1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895294; c=relaxed/simple;
	bh=IhmiM3uixbZgyPtmL9ftxPCq4cpBp7SCrJm8NRXa7Yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=et30YukSt/DeHa1nnQaHwL/sitGBqIeQFL/01fP0kHxCrbNakeLkKLRfS3elxqVDp2wAJfXtm0M/Tsyl+8xgU/jeUWpcSW+iL8q/zLcoZDdX/eNO1EHYzCODcLOC9BHWSlmtvJI6f3MphuvHW93Pd5scbddul6x6D5snukhfp5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a6pCjkjL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a6pCjkjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D410DC4CECD;
	Wed,  6 Nov 2024 12:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895294;
	bh=IhmiM3uixbZgyPtmL9ftxPCq4cpBp7SCrJm8NRXa7Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a6pCjkjLlv/W+TLF90+u8Sitdh8FcXwrHfkzS8+rGILPWmc+/HviJZyVnlQxNr5CO
	 22hunVfyxlxT/vXYmChEa5Vwasa+y8fFaDobH7svSX+R3hi2jIC792lK+BqNOn4TW+
	 2/+Ii9H+8+UUvpjYiaDRKbJ6Zsz0vFwMsobEfvGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 132/350] mailbox: rockchip: fix a typo in module autoloading
Date: Wed,  6 Nov 2024 13:01:00 +0100
Message-ID: <20241106120324.165703884@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index d702a204f5c10..bf09ab923d1e2 100644
--- a/drivers/mailbox/rockchip-mailbox.c
+++ b/drivers/mailbox/rockchip-mailbox.c
@@ -167,7 +167,7 @@ static const struct of_device_id rockchip_mbox_of_match[] = {
 	{ .compatible = "rockchip,rk3368-mailbox", .data = &rk3368_drv_data},
 	{ },
 };
-MODULE_DEVICE_TABLE(of, rockchp_mbox_of_match);
+MODULE_DEVICE_TABLE(of, rockchip_mbox_of_match);
 
 static int rockchip_mbox_probe(struct platform_device *pdev)
 {
-- 
2.43.0



