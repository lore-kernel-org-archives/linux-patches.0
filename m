Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEAB1A76A5;
	Mon, 14 Oct 2024 15:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918649; cv=none; b=e+Quvq1pxfqV29u7+9AAk++JvkFbsdvcRdEwgLyf48Aqr6LoBsetee4e1R34jejKP0Pb7pIL+qsdr7j+d4ahXXUI5FZPSRqaf3u1/fmpTw5dbOM1YvYc7DmWvag7pSYKyLfto6unKen81wVXdY4A5wxWDrOZkpS9aQCNW4Dz6Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918649; c=relaxed/simple;
	bh=a/MblO053RNN6ySOqXr0/vGFUNTASZ5LAJaNL2SCaIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6xb4504SH5FruGVEbSifMQnu5XOD9eJXbBjEkIdsRuEpgtDsnnR2gvbMl6VnW0Ela4oy5ZCgEwYH62rx2KjCNfBf9jXp6ZY7pkY3vUeQ/Xjf2eGP+rjZS3IpCIMFvlGEPmNno30hIkq/gxpKjIPPyeuerwxu4sAaIWoC72DYUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNh5Z1Yz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNh5Z1Yz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2E0C4CEC3;
	Mon, 14 Oct 2024 15:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918649;
	bh=a/MblO053RNN6ySOqXr0/vGFUNTASZ5LAJaNL2SCaIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNh5Z1YzZNav9QEp3YLq/yXqqRXjOu6/etfPQwFO3N6bzxY73KK6UdixE1rfvc0b/
	 WpaR8O9fTeyB0bpyfHGoJX3KTOm9Lrk51fmCRnmv7wIVul3AfYlCJZwju66BYhQ6DZ
	 o6VjDQ/wJh8Q4wnD365zs/l3C0FvNaselO520iw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 382/798] mailbox: rockchip: fix a typo in module autoloading
Date: Mon, 14 Oct 2024 16:15:36 +0200
Message-ID: <20241014141232.959285220@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



