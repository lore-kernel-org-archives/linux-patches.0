Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B93F26D4F9;
	Mon, 23 Mar 2026 14:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277335; cv=none; b=JvLCvh3VUcUBRyKBYuv1DRp85DAAWt66APEAboEHo43F6NuqRORKlwoVqlKiAjt1PtiD38p3iT7bDF/93IVMJWDxA3lB9Jekad+fOUCe64NrQARfCosYLnucv8nDsBOhL1oCRrHXeItFxXrNLhbd0BSODIxM+K98teXj34eKmTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277335; c=relaxed/simple;
	bh=Hbu9EyEINJIE68gHugAIJ7viTeFGJX0xbrycsZ5aWn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Enwf8YOSyBldPHXVbIZaC2LVNe0yM8+7+cqnPUNqQN+VwbBGnKuGm3Xg3PpzSzITDaQ4pob23ElSTklKPyO56+Em6XPZATGn9tu7tB08mhNyN1P1smw485XPSODG2oDn1jKuEhQUqXm5llRiZak/xnRPNPY/Hh0g+5ZTQGcPDcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GUgKNgRk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GUgKNgRk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4A2C4CEF7;
	Mon, 23 Mar 2026 14:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277335;
	bh=Hbu9EyEINJIE68gHugAIJ7viTeFGJX0xbrycsZ5aWn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GUgKNgRkkT2VZXhas7uWOsEB7+CmShNAAJMjq/R9DCUL0choVymUTd7cxV5P15Xk5
	 9CtofXSeX9wFUD3SYrhIGSoeceG1ovb4AHcLBT5MfSwAOt3BJAoCWOZdakWe/fT+0d
	 ndtTRQkBiA9XMLehyZIYlvgMx8WNZJq420k3MXp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 401/460] net: bcmgenet: increase WoL poll timeout
Date: Mon, 23 Mar 2026 14:46:37 +0100
Message-ID: <20260323134536.417265493@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3b082114f2e53..2033fb9d893e0 100644
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



