Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0331D9A43;
	Tue,  8 Oct 2024 12:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389495; cv=none; b=EKJS2YKWl3IO6iuoCmkUt3Pv06wbnguMvOzdl1WC1wJatA6MzrEA2I/elyn6RJLnFWLFEd9DZCnznbYEBsDn5sWdOBX/8UoN5V33hi0p/slsF7P7G4dOrVSc2t4NM7JG/UcJ87uqlsik0WGftYUQ4E7lcieho1TNJl5y4s0dUsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389495; c=relaxed/simple;
	bh=4Ebeejko71NiDi+WNL98qfvro8+SXM7NZSVV6Bc+N4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dziJJ6ycY8GmOeRVNwiTo5fzJU9PtHQN/RaMesBeNheH2k+XCG1LJmF7Ss4udPbH5Kt4SkR6iqJdp9rA7qDUbTAPqaXO1gj02+oKinX3q14uaKO7lGk4CPN7dYqP7DMYrqUnftIbuyYKoQl8d0TFS8Rn2n6t2ivwjX1VFtaDG7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mw3a9dAa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mw3a9dAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C62C4CEC7;
	Tue,  8 Oct 2024 12:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389494;
	bh=4Ebeejko71NiDi+WNL98qfvro8+SXM7NZSVV6Bc+N4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mw3a9dAamBU9OHwGeufUEC441sb3xQLMWVV8EPZ453SLZf8wM/JjKie9b56EOMVz2
	 UNputU57gq29w7QWwO/Hwrb2S6mRTxWGnyWTfuvKDXJWhveMubNx1IYqc36bhfqDdl
	 OAUpFZPthqoWqWXAowt/1hTcYEMng/qWjB1d5kDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 011/482] mailbox: rockchip: fix a typo in module autoloading
Date: Tue,  8 Oct 2024 14:01:14 +0200
Message-ID: <20241008115648.744623839@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



