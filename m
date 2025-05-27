Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF882263F5E;
	Tue, 27 May 2025 17:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368528; cv=none; b=cnhCCCwGGn9R+dee7/8VuQPp97zhqqLyxBfjmG80cDgusIJWM1yaMUVCTQH4nYAw0vdOaNjYuLkj7WXihj3CrhNczpEKBjqx8+4npe8P2bpbF8HHMsotqx9hjIpRDOWwJpr+a0tmMC1y0kkxxTGzPIbqoxYqJUm0ebC2Q+5iG8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368528; c=relaxed/simple;
	bh=0foBsOC6cuwOWvaA3aSDoyaFFPytdh00qO0NqdUWURw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jhg1GAzjZdVFH3sx4t2vc/UaG71cxD11isR5uUZg3EwVx1SMbWuqk+J/ZW9LayFzxZHXiSK9oT4a5ta2s3NWFXV0wvWf6GplcAyPhvmuRJwRD8asyPkXV/nAEGOxKUgpaG2sxohCTNauJS3l0nbNuvcrnu3BrWh0of9Xtnldec0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rqgG9lFG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rqgG9lFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4FCC4CEEA;
	Tue, 27 May 2025 17:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368527;
	bh=0foBsOC6cuwOWvaA3aSDoyaFFPytdh00qO0NqdUWURw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rqgG9lFGjc1+dGQKiX/AtjndQ/72IPsD3aa7eGj475fBPwjttpIE/goSFGaVHvtAs
	 JHbLLZS4KE/7Jpwt1NjDkWwu6NO6CQvAHOpTrHNsjAl3321QXebJDZXPnbiOz8pVnQ
	 oTJrGzpHlx9fq1+yyDlH1dIcOcna5y54Fm9cvB2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kocialkowski <paulk@sys-base.io>,
	Andrew Lunn <andrew@lunn.ch>,
	Corentin LABBE <clabbe.montjoie@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 708/783] net: dwmac-sun8i: Use parsed internal PHY address instead of 1
Date: Tue, 27 May 2025 18:28:25 +0200
Message-ID: <20250527162541.948936694@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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
index 4b7b2582a1201..9d31fa5bbe15e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -964,7 +964,7 @@ static int sun8i_dwmac_set_syscon(struct device *dev,
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



