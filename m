Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E562673B7;
	Tue,  8 Apr 2025 11:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110551; cv=none; b=qFrtuxOIbE1TsZ4t04JIhvw6LpIfkg/aB40nnv5jOUeEcCAatkMF/LUo8trTNf6sifWwEIu/FG+N0XxsOPCMw/ARVcB0N3o4aZU0lDXv8KXdZyTWvnvY3vWY5gZaGEyBtB8ImJ1ZqPpeASJgoC34k3cJ+xtN6viN7f3JrlMYJvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110551; c=relaxed/simple;
	bh=4cFjnh/qd6s37BITAKYOTVOQg0yjjZ50GRbYkhPGvmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPij6bYblAPK8YpYg7W4MLhSobvmJt5t9YW435ULBCoJhXnGebfSI91BSjG7YM1bgTVgDcbbYNoRmRz71OsHTvbpJTKXS1xbUNiHj5m/BuHVBqK1wnOkGWdSZisWwPChxfjCs0VlizN9DVjwwcyvBIh98NiL1Pwt9cAJrdnqhGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kr7O0KiY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kr7O0KiY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56666C4CEE5;
	Tue,  8 Apr 2025 11:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110551;
	bh=4cFjnh/qd6s37BITAKYOTVOQg0yjjZ50GRbYkhPGvmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kr7O0KiYowiAvoM5n1jh4e+EDDum65tc2JSEY9ZtUqZAI976Flfmaeq+wHs3vdDaw
	 2TjZj7o1JK2e7uJFiXZb9JOk1ZFEON3BUVgw3upMwtypS1Ui4GESGOHqlYnzUuYOPf
	 KUe/De5OD0IqqtphwBDSgTQKtswUa1Gbr/PYaug4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin van der Gracht <robin@protonic.nl>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 106/731] can: rockchip_canfd: rkcanfd_chip_fifo_setup(): remove duplicated setup of RX FIFO
Date: Tue,  8 Apr 2025 12:40:03 +0200
Message-ID: <20250408104916.741362612@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin van der Gracht <robin@protonic.nl>

[ Upstream commit d9e1cc087a55286fe028e0f078159b30d7da90bd ]

The rockchip_canfd driver doesn't make use of the TXE FIFO.

Although the comment states that the TXE FIFO is setup, it's actually
a setup of the RX FIFO. The regular setup of the RX FIFO follows.

Remove the duplicated setup of the RX FIFO.

Fixes: ff60bfbaf67f ("can: rockchip_canfd: add driver for Rockchip CAN-FD controller")
Signed-off-by: Robin van der Gracht <robin@protonic.nl>
Link: https://patch.msgid.link/20250219-rk3568-canfd-v1-1-453869358c72@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/rockchip/rockchip_canfd-core.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/can/rockchip/rockchip_canfd-core.c b/drivers/net/can/rockchip/rockchip_canfd-core.c
index d9a937ba126c3..46201c126703c 100644
--- a/drivers/net/can/rockchip/rockchip_canfd-core.c
+++ b/drivers/net/can/rockchip/rockchip_canfd-core.c
@@ -236,11 +236,6 @@ static void rkcanfd_chip_fifo_setup(struct rkcanfd_priv *priv)
 {
 	u32 reg;
 
-	/* TXE FIFO */
-	reg = rkcanfd_read(priv, RKCANFD_REG_RX_FIFO_CTRL);
-	reg |= RKCANFD_REG_RX_FIFO_CTRL_RX_FIFO_ENABLE;
-	rkcanfd_write(priv, RKCANFD_REG_RX_FIFO_CTRL, reg);
-
 	/* RX FIFO */
 	reg = rkcanfd_read(priv, RKCANFD_REG_RX_FIFO_CTRL);
 	reg |= RKCANFD_REG_RX_FIFO_CTRL_RX_FIFO_ENABLE;
-- 
2.39.5



