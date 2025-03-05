Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD078253348;
	Wed,  5 Mar 2025 18:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198495; cv=none; b=CqQkdHNeJuI5yLidBhyYGOUcRLcvdXARTRz9/ZwmHxY1A+vaz5GuUSfXLCbcKcncFJ+zLbis8QkeWt292jp9hhToAQnMdy6mUN8O+Jmvp5y1uZWZunNyW4hScqyBlYy4Pq8O9jb6F965XROyGGoVJQvZc4TsCzl85XjlshQeeyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198495; c=relaxed/simple;
	bh=dUc/QTfTLEGPABvlIP0rhrl8bshnUttK/oWLpAqmcCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxXXB3VeCVe0H3ArV7Pr/PatlNFdzkFg2sFB4HDfKProC6+kMXoscFUVSq5wLwG4bJqax71nVbJuTiPNtsDzwIOpJ003yPPaOuwF/jZT4t682DCwiAoOitoJFmqxVir4XW4YS+6c+XQtoGd5YElnGZODMzKphVNk9/eLCL83N+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PPUJJVMm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PPUJJVMm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BD2C4AF0D;
	Wed,  5 Mar 2025 18:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198495;
	bh=dUc/QTfTLEGPABvlIP0rhrl8bshnUttK/oWLpAqmcCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPUJJVMmfkfdwy8Gh+zV+wCca0qoO4to9dCZGt7hlJXgNdYMmaptzEUpH5Up4Ys60
	 h9NOn5AYB1GLJIoHo8dEGrrs49Aq3jPyKgqhkdoPYK4Mi2qXj13Dj1ds17DJah7IFN
	 1V60Jfxs+Ugc+G6EJipGJBRtvI3wp/BYjh+FVZ6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 047/157] net: ethernet: ti: am65-cpsw: select PAGE_POOL
Date: Wed,  5 Mar 2025 18:48:03 +0100
Message-ID: <20250305174507.197050595@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



