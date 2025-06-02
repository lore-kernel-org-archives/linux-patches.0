Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FA91FF61E;
	Mon,  2 Jun 2025 15:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877418; cv=none; b=Z9W8a/n80eGhRejAlie6J7nyZ/chxEgo2a6zIIy/cbiPFXtBM/0qgY8fpcE+th7rtSv4acXDWfzLj1cVMjM7F8STU2gb7CCfSPNvhhKtSRCkWeKQBG0beycmhWgtuE2CKz6C4CTh1XqEvlo3W5ra9buM8eOw0TaOum3tJYDu/v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877418; c=relaxed/simple;
	bh=k9mc60W2B7ng2q+5Fh8fgROGyWuCoikzHsvAoL+alLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jn0yGsTiw4M7Re9BXjiIJv+vR2vKDNy/Ku11Ewx9Ji32uFvDEpJgl3d58YzWACR+orOEUHp3BQC8S+XxIVn0seS7gUGJCQjN19bQ9ZfDFShM/rhP3/aQG83a2SmvtzPWX1rfQR8D8zzHpO7bq8g1fSb6Auw/viRVquU9VMp9Iug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X2/F8NS+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X2/F8NS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1C0C4CEEE;
	Mon,  2 Jun 2025 15:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877417;
	bh=k9mc60W2B7ng2q+5Fh8fgROGyWuCoikzHsvAoL+alLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X2/F8NS+KjZTo6gYAWJ/KyMPupg/dGazpFbilb45FVmJXEEgit1YhN6iNPqrO5sZn
	 XXfU0zDFuQlcNicNzPm9NTSKm2ZBqFsoiBExvgYVIDzpP4OVT8EGNVYXvxCjb7Hd93
	 BvR0zxUC5nHK3Y1ThllSB78mNwGJF+zADSabKrUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kocialkowski <paulk@sys-base.io>,
	Andrew Lunn <andrew@lunn.ch>,
	Corentin LABBE <clabbe.montjoie@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 241/325] net: dwmac-sun8i: Use parsed internal PHY address instead of 1
Date: Mon,  2 Jun 2025 15:48:37 +0200
Message-ID: <20250602134329.581122217@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Kocialkowski <paulk@sys-base.io>

[ Upstream commit 47653e4243f2b0a26372e481ca098936b51ec3a8 ]

While the MDIO address of the internal PHY on Allwinner sun8i chips is
generally 1, of_mdio_parse_addr is used to cleanly parse the address
from the device-tree instead of hardcoding it.

A commit reworking the code ditched the parsed value and hardcoded the
value 1 instead, which didn't really break anything but is more fragile
and not future-proof.

Restore the initial behavior using the parsed address returned from the
helper.

Fixes: 634db83b8265 ("net: stmmac: dwmac-sun8i: Handle integrated/external MDIOs")
Signed-off-by: Paul Kocialkowski <paulk@sys-base.io>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Corentin LABBE <clabbe.montjoie@gmail.com>
Tested-by: Corentin LABBE <clabbe.montjoie@gmail.com>
Link: https://patch.msgid.link/20250519164936.4172658-1-paulk@sys-base.io
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index f834472599f75..0921b78c6244f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -948,7 +948,7 @@ static int sun8i_dwmac_set_syscon(struct device *dev,
 		/* of_mdio_parse_addr returns a valid (0 ~ 31) PHY
 		 * address. No need to mask it again.
 		 */
-		reg |= 1 << H3_EPHY_ADDR_SHIFT;
+		reg |= ret << H3_EPHY_ADDR_SHIFT;
 	} else {
 		/* For SoCs without internal PHY the PHY selection bit should be
 		 * set to 0 (external PHY).
-- 
2.39.5



