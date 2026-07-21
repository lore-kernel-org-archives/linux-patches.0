Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D694C46D2A4;
	Tue, 21 Jul 2026 17:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653960; cv=none; b=bHRvx5lOxg+TS6Z+d3NkqMVRcGYqRuEd9BAzX08C06lvvDGeioh/CZYWWdPYOYPfSlHQUUn+dACm7YofLrB+03ZV9Y/hEKrkhSLdyRjNrBIJCbgsSgCqnv1vN1r0gS294s6in8MKDReRabNYb1byKHpyrkh4kK1S85T/F8VqO1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653960; c=relaxed/simple;
	bh=KBi4jfoNnCyv3aDr4VUAv/YaT/t8lbZeP4+1AZJ4BD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqZ6d8aD6wjwGRmZtzuJa/2k9+B0UxeYa52o23oD7d4LobQq1vlqnJt282FxsUPyYt/Z/dA9U7yDHhX0i/fU5WJx6VqRNznLx/2SK39QO3wH/0UNHZqxbEVBQKdCm3o0n2Am3+9rWhGqdaZluRYhvseBNYNfO+Ezefg5aM+2njU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rs7C/Ys2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rs7C/Ys2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D121F000E9;
	Tue, 21 Jul 2026 17:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653959;
	bh=Ntsh7OAyrlJ/MPVf6EWJW1e0pcOHCkV7mPrBVuCujw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rs7C/Ys2w2eScF13ZY2P8ZQMlyy0fhT/P6bnJ6utiLpjp7BGxdnaOoKJ710X6ji1d
	 o3yzLgTom26GzjxQ1Xt0oFOFULBv37gPYVd7vjGRQQuP1geGfBqkigcZoUUJ8AaGNf
	 eMt9rcjGoLEgppY9sP+jFYrRyvSWO2hq+8xz7XoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1481/2077] net: mdio: select REGMAP_MMIO instead of depending on it
Date: Tue, 21 Jul 2026 17:19:14 +0200
Message-ID: <20260721152627.732316285@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 1a3267a8c9ecabb8e27f5cbda6d19295d5e41beb ]

REGMAP_MMIO is a hidden (non-user-visible) tristate symbol. Using
depends on it is incorrect because there is no way for the user to
enable it directly. Change to select, which is the convention used
by every other driver in the tree that needs REGMAP_MMIO.

Fixes: 8057cbb8335c ("net: mdio: mscc-miim: Add depend of REGMAP_MMIO on MDIO_MSCC_MIIM")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260702032653.1580616-1-rosenp@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
index c71132f33f8472..733fa0b1cd3aef 100644
--- a/drivers/net/mdio/Kconfig
+++ b/drivers/net/mdio/Kconfig
@@ -122,7 +122,8 @@ config MDIO_MVUSB
 
 config MDIO_MSCC_MIIM
 	tristate "Microsemi MIIM interface support"
-	depends on HAS_IOMEM && REGMAP_MMIO
+	depends on HAS_IOMEM
+	select REGMAP_MMIO
 	help
 	  This driver supports the MIIM (MDIO) interface found in the network
 	  switches of the Microsemi SoCs; it is recommended to switch on
-- 
2.53.0



