Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D70027CCF0;
	Tue, 27 May 2025 17:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366003; cv=none; b=cKYqVbIWuY1HH8T7wYFZ+InqQUbiaeTx+MdzgNDJc5itIWLTqugxk/lBRFsdrm6qTLw3XZ16FOPzTVWUG4t+k65W4LDF0ibMry6ZzzjrPVSKC6PzhZqQefmKt/AvcM66AinK4rneOJeMd0Z0vfjiTqe6zBvNEPQ7U5CIrd5G7TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366003; c=relaxed/simple;
	bh=OpAJbaK8CE1ULwAs9j5mW4HX+dRn+YQHzqwzRzARw/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrVfw9gOCNx6ui2FsOXwhtwH6a/AAxvsfADBSiazDz59yNumkFnZeqhQWy5NIYKhNaolfoVZe+Z6P1ndAIyB8BENO4sURlsQYyRJuqyO8BNn+9ySE1IMjh8B7zZn5qsEiQuQG5xBxQyENd2HSNDvRicIOJuvfnx9rm0IZNhHaow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2QQ8aSi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2QQ8aSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D3AC4CEE9;
	Tue, 27 May 2025 17:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366003;
	bh=OpAJbaK8CE1ULwAs9j5mW4HX+dRn+YQHzqwzRzARw/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A2QQ8aSi/Zl40j7MHImpGDIRIEMHiI8ni7DsLzs7AdIzcsvI8419nU5H4MdVvdz1t
	 xEbT6/ADvLqmy5zuIcMoFMHnOzjFbZVVjDuO8OdeD+OFyhI8RRcFJnFQ67ACaooAts
	 aIXJvQqImbouthoA5sADH+uXfEUxBYv98DeroTF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kocialkowski <paulk@sys-base.io>,
	Andrew Lunn <andrew@lunn.ch>,
	Corentin LABBE <clabbe.montjoie@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 560/626] net: dwmac-sun8i: Use parsed internal PHY address instead of 1
Date: Tue, 27 May 2025 18:27:33 +0200
Message-ID: <20250527162507.721371527@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4a0ae92b3055c..ce8367b63823a 100644
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



