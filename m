Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45A11E3772;
	Mon,  2 Jun 2025 14:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875764; cv=none; b=ulNyPGSz+ZR8TwIX8vohO0ksOHKWlXHESWAfp2mixJldL5JDq4mxHmCWHk9HlsQyL3yXsMqou/nY7cDkNfam6/xp6YdjfprJpIvqcLwIEL/GvD9/VNFeAzb+C21G89L6a7B2zhjdAt9ZzINPrVoRr+SXY7SgXKCH72FTKEFEB7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875764; c=relaxed/simple;
	bh=fW97tThfnU5fdPi6U4y9dQo8WpnqqsNI9swbIXoxFTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjBOGb0TjZ4jf24zAWHXPW2fpWLQiWlzzerB+VoRGI8s5xvZtYQDJN/kdQzL4X0YbwWuG4iGWr1k20JMxc4Pt3Mw5vw4FrFz2EApo/n6RmCPJ+JeSyB77Pp9AmFDnWuscqVKjX2Zqftf++8FYb2jdvecZ+WLcPQWdkp9soY3ylo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pjjRxco3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pjjRxco3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBCDEC4CEEB;
	Mon,  2 Jun 2025 14:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875764;
	bh=fW97tThfnU5fdPi6U4y9dQo8WpnqqsNI9swbIXoxFTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pjjRxco3HgS79pTNZ4kS9gizvwW8T6G48REWmanQ+4BU0WPLdb5alzP54Co1UoFvp
	 xZI4/xyCbwjuNl1E0wERL53bMkujJFokT/zhXq4Iv3TyrSPZS2gAr95oBZ/TwGzy/B
	 VxFBtJtLqlLgqie5gVNlsiL4wWWR/PO0eDxCFGyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kocialkowski <paulk@sys-base.io>,
	Andrew Lunn <andrew@lunn.ch>,
	Corentin LABBE <clabbe.montjoie@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 237/270] net: dwmac-sun8i: Use parsed internal PHY address instead of 1
Date: Mon,  2 Jun 2025 15:48:42 +0200
Message-ID: <20250602134317.003717353@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 958bbcfc2668d..d04bc6597e0f0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -936,7 +936,7 @@ static int sun8i_dwmac_set_syscon(struct device *dev,
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



