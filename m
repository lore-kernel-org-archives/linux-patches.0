Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE773BD62F;
	Mon, 23 Mar 2026 16:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283194; cv=none; b=FIu6RX9wF4Bqvj/BJ3tvlWphPZ7GS+25v3f2ds5plDeWvkLd775luPu3P06QJgZSbnyY25dA9BSRISS5ArdUqUBxz6439MEZ65H5Wa8wlVgZGn0eW4J2BjskI3/NCz1tCCohxHjkGVao9dEmiKHuPSNIDN6v2pF5FsLX2X3VgNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283194; c=relaxed/simple;
	bh=7KneFUsKcZgwNifw9ln2J6VPhA/r8+vRT6K3ZtH1PKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIWSkrZjbc8xjjscryzW9qyFzY+8RLM1sOu+ivezts7lxVjEiLMyxl8du2VDz49DHc8odv4/5ourPV9rxFg/2tYSHcwwEQskhyD2SDQBs2Hv4hEzjhhWvkTB4D30fWC8a8XAIltxu/CmlZc1vAY45m76erimlmkwbnqLTkR/eBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZCp984Om; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZCp984Om"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CDCC4CEF7;
	Mon, 23 Mar 2026 16:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283194;
	bh=7KneFUsKcZgwNifw9ln2J6VPhA/r8+vRT6K3ZtH1PKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZCp984OmRQPzmNc8b/I/UnyKmyrpHOa+l3Ovv5UQB/wc8jbUKlAZ5FDs0YNB9agn3
	 vQoSmPMv+qa/Uwez6YSmIxSXyTK/xw6RqS+VAyPIizVrGTz5cV32SbRNYglCqGECDZ
	 1eynl2xuIuNosMehfeeun8hEw9ZYaVyMbxSH0t58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 420/481] net: bcmgenet: increase WoL poll timeout
Date: Mon, 23 Mar 2026 14:46:42 +0100
Message-ID: <20260323134535.429847091@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit 6cfc3bc02b977f2fba5f7268e6504d1931a774f7 ]

Some systems require more than 5ms to get into WoL mode. Increase the
timeout value to 50ms.

Fixes: c51de7f3976b ("net: bcmgenet: add Wake-on-LAN support code")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260312191852.3904571-1-justin.chen@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index 56781e7214978..3ab506ed94252 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -101,7 +101,7 @@ static int bcmgenet_poll_wol_status(struct bcmgenet_priv *priv)
 	while (!(bcmgenet_rbuf_readl(priv, RBUF_STATUS)
 		& RBUF_STATUS_WOL)) {
 		retries++;
-		if (retries > 5) {
+		if (retries > 50) {
 			netdev_crit(dev, "polling wol mode timeout\n");
 			return -ETIMEDOUT;
 		}
-- 
2.51.0



