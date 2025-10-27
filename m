Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D019321F48;
	Mon, 27 Oct 2025 19:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593203; cv=none; b=O/3HOoVgEZX9jKZ+DyKUbISkbyt4xNkEvbu4JnGmkRjtJ7ELVUWAh+Som/LySKN4ySvOhcyYPSkHn3PYutAP2hrl7AUVBsXe7WF5td2/LkWYgqi8pN62+aRitrCkQ7wXzTUcNigapzFLltjC//dtoQw5B0t8M4YX4Rw9QMbTKUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593203; c=relaxed/simple;
	bh=UNi115xtzT1ELnd2k20KtsaGudcfTIiSlL/RH8MsdWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+9yBMnNJvpkB9k6i9rCA3UD3yBS7R2pwSWllM0M3Uqab4aga7G7pongQ73qDPUbbkEeOEJszezrATIyWyxdOZnYGZRXXaOLnYzEZF6LcNb2+5L8t7ystpOgZ/cXG1CBTS/3Zu92uBy52tOHEWw+SG9UvX2ey77NLob9XC5LZF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nu2YJzS2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nu2YJzS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1671C4CEF1;
	Mon, 27 Oct 2025 19:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593203;
	bh=UNi115xtzT1ELnd2k20KtsaGudcfTIiSlL/RH8MsdWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nu2YJzS2iw8F80YirTxrMhru4Yvs1ofLqEJe+wXBYMugaCE4sZmR7OalfiYSWDljG
	 mi0avsP/eYamQefbFhJ0egJ27GN4VNmHdCit9Nr2CteWWybEDWukfyJB5R7ZRwHf6Y
	 bIpNuysNeaMn5+LBUJqqn52jhBO94mpgX1zELapM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 052/184] net: hibmcge: select FIXED_PHY
Date: Mon, 27 Oct 2025 19:35:34 +0100
Message-ID: <20251027183516.298685293@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit d63f0391d6c7b75e1a847e1a26349fa8cad0004d ]

hibmcge uses fixed_phy_register() et al, but doesn't cater for the case
that hibmcge is built-in and fixed_phy is a module. To solve this
select FIXED_PHY.

Fixes: 1d7cd7a9c69c ("net: hibmcge: support scenario without PHY")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/c4fc061f-b6d5-418b-a0dc-6b238cdbedce@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/hisilicon/Kconfig b/drivers/net/ethernet/hisilicon/Kconfig
index 65302c41bfb14..38875c196cb69 100644
--- a/drivers/net/ethernet/hisilicon/Kconfig
+++ b/drivers/net/ethernet/hisilicon/Kconfig
@@ -148,6 +148,7 @@ config HIBMCGE
 	tristate "Hisilicon BMC Gigabit Ethernet Device Support"
 	depends on PCI && PCI_MSI
 	select PHYLIB
+	select FIXED_PHY
 	select MOTORCOMM_PHY
 	select REALTEK_PHY
 	help
-- 
2.51.0



