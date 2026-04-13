Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDDD317152;
	Mon, 13 Apr 2026 16:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099196; cv=none; b=m5Sm5bdo23SJ2xEvH2wuDU7QA3JGgPVN3SCjNlERdZ7R+br2EFdY04Fg00rdoa8Fmz9QfFqUWHelsrxX+96hwZNajavryFGr1kAcOTssobOhrVnlFY0Wep1YFBAEgoNPHU89h0Lv3kCbqWkf7ZuZMVLSK06uxWa+Cc8AelYZCsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099196; c=relaxed/simple;
	bh=wizM17vdKPEV55yfUZuIROH1EaGga+BhzmyHBY+Hs/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3GXY1R1vkmdM/iz5cc0oz6TTKyOLXhb7uDVG8rQnqzoS46mzDB1GwQ/mIOEq2kVE7IOiFEbBNhTWnLnTdJeK7ZwVAE954WeJ/P3uxav8d+sjQJbMG8MUAioTa02BgwErQFpajA3aDbVoEfGefwbqsBGbSqAjCloKksULErb+/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zqOvur6T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zqOvur6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A4CC2BCAF;
	Mon, 13 Apr 2026 16:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099196;
	bh=wizM17vdKPEV55yfUZuIROH1EaGga+BhzmyHBY+Hs/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zqOvur6TVViCAwZ8oFIiSFOoe467OG8qthOupWpNIFUrBHTjyGYNRuedZyqm+6Jqq
	 Gsv6/lj6vxM7zGxS4+wQtEWLZt4yz1RPcaFApa/qtPTzYEwnownKjwWJaGrFQ6QVDc
	 hS1A6+pLfnCrfdr0rFz687lexYfEcNQHOKYp9Mpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 214/491] net: bcmgenet: increase WoL poll timeout
Date: Mon, 13 Apr 2026 17:57:39 +0200
Message-ID: <20260413155827.078216407@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 35c12938cb348..ac402631576cc 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -102,7 +102,7 @@ static int bcmgenet_poll_wol_status(struct bcmgenet_priv *priv)
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



