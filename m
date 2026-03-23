Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A953AC0C2;
	Mon, 23 Mar 2026 13:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274205; cv=none; b=Bj54vbKgEJibgwGD7b3jV7VicaF+evUqiZVqVeSDeABLHKxMKGW+f9ihLt9IpKsYyA8PgtzYFFyNNMh+ThW9mQz1g0s+DdUz64ws4eWl6eDbviFxjWsMa3QQtXL15vOI9oovKw4hJrLlr805xZA8GwCNbD/23l+35XADAG+CPOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274205; c=relaxed/simple;
	bh=p6G+Fr/FbnNRrqirKrXcT30zTCSXdJzF2BBzqBN0R8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNVn3jJNnh0m650oYXT+KNNU4qVbJZWzfWFYX6a4iDWrr01rsXncr9lz136u+T4tlJ+Z3OSQgk8UXij8lzSGMNAUi0kZtyP5yYq/hoT9Md/N8wVp8G3tBwERrjQhugpNLk9WfXniL+h1/zXq4T7QerLwEBWAraOD2pKS6au4fuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BOzlPIZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BOzlPIZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B98AC4CEF7;
	Mon, 23 Mar 2026 13:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274205;
	bh=p6G+Fr/FbnNRrqirKrXcT30zTCSXdJzF2BBzqBN0R8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BOzlPIZcGQsTj+zz0iJhY5JdQJCRTrui6aiqsZHCEAfm6AgeYbNrXFoa9iL3vbRJN
	 UgswvgyUHoJ07vWRx0rKnlCdIy3TyVzcRJ/O7D512Uw4DaKJQpfK+jMgZoGPCfXfXR
	 GRTlyv+VBxRQJxJFa1d4/Xv9IbTm0pE8homldvZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 143/220] net: bcmgenet: increase WoL poll timeout
Date: Mon, 23 Mar 2026 14:45:20 +0100
Message-ID: <20260323134509.078701088@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 8fb5512882980..96d5d4f7f51fe 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -123,7 +123,7 @@ static int bcmgenet_poll_wol_status(struct bcmgenet_priv *priv)
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



