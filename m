Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9347119C542;
	Wed,  5 Mar 2025 18:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198062; cv=none; b=UWuy7k/1LBOmavKsAXksynTDqmJ0Uts49gW6NcYoa52b82DzJ2Q3oLDMxQn1JXAwnd4eNFzlnXkHWVoyu7BCccFyjzY+lQzHqTNSnhjp117b9krY2ZNE20H6qnZR2XjACkV0mN/3LKSnoBV/Ez6kOF+gcMFR2PEvyUTBz2VS+ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198062; c=relaxed/simple;
	bh=ZX/i6anOEqVF6MWpmVXY1n4KznvWPgk1No/dRoXT6Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrD7CTa9zV0JEUvy3KaAdL5OvxRrMw37gJRY/pbzomAmfhSYPSwEZm8InrFGO/FJZZ60s34ZtEibyNDCAmzIJiUMfXRSnhtJnrZYGCqkQBv9w7+oF9y+2XXGvSpWSo9WZxkv2zxWk/JPaDIMEH5u/ITe7Mr10zo3wgOXYGO8mvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EIwiPvC+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EIwiPvC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CD9C4CED1;
	Wed,  5 Mar 2025 18:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198062;
	bh=ZX/i6anOEqVF6MWpmVXY1n4KznvWPgk1No/dRoXT6Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EIwiPvC+9Uuni2O90jwv+C3zVLaHKh4lye1My6pFCqQbZSi/4I+wojr9qKz3mE6Pn
	 vML3xK3seR0vbzFo8HOee4lF/xQQjtDhzkCPhaOi9IRlIJxBRd4wQPDaDFTkX8ZmX+
	 /654g4kIMEetxkXQz+Gs8YwphkDwxDkZjalPmIRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/150] net: ethernet: ti: am65-cpsw: select PAGE_POOL
Date: Wed,  5 Mar 2025 18:48:01 +0100
Message-ID: <20250305174505.914607309@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit bab3a6e9ffd600f9db0ebaf8f45e1c6111cf314c ]

am65-cpsw uses page_pool_dev_alloc_pages(), thus needs PAGE_POOL
selected to avoid linker errors. This is missing since the driver
started to use page_pool helpers in 8acacc40f733 ("net: ethernet:
ti: am65-cpsw: Add minimal XDP support")

Fixes: 8acacc40f733 ("net: ethernet: ti: am65-cpsw: Add minimal XDP support")
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/20250224-net-am654-nuss-kconfig-v2-1-c124f4915c92@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index 0d5a862cd78a6..3a13d60a947a8 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -99,6 +99,7 @@ config TI_K3_AM65_CPSW_NUSS
 	select NET_DEVLINK
 	select TI_DAVINCI_MDIO
 	select PHYLINK
+	select PAGE_POOL
 	select TI_K3_CPPI_DESC_POOL
 	imply PHY_TI_GMII_SEL
 	depends on TI_K3_AM65_CPTS || !TI_K3_AM65_CPTS
-- 
2.39.5



