Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B106A1D142;
	Mon, 18 Dec 2023 14:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uveDC7Zp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334F5C433C8;
	Mon, 18 Dec 2023 14:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908267;
	bh=jvjtqzqszSFYTaOEmZtya42b2bJViMLDFNw8tca22WU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uveDC7ZpJVP0tPhBdFSQnkRV0L3S89GRSy+ricN3WJLKINgCDCH7omyK73UDTACr6
	 F/+tKHwG0lhZTUEArXwaYiPZCMY7iLj1pPAlmJn0b8Ljgl8b+7VpqIApZItoByQ5f2
	 SabNAnMl/1o2kHVsNmilZKMCjQyunOc9xwN7wc1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Keguang Zhang <keguang.zhang@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/166] stmmac: dwmac-loongson: Add architecture dependency
Date: Mon, 18 Dec 2023 14:50:53 +0100
Message-ID: <20231218135108.883607678@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <jdelvare@suse.de>

[ Upstream commit 7fbd5fc2b35a8f559a6b380dfa9bcd964a758186 ]

Only present the DWMAC_LOONGSON option on architectures where it can
actually be used.

This follows the same logic as the DWMAC_INTEL option.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Keguang Zhang <keguang.zhang@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 06c6871f87886..25f2d42de406d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -269,7 +269,7 @@ config DWMAC_INTEL
 config DWMAC_LOONGSON
 	tristate "Loongson PCI DWMAC support"
 	default MACH_LOONGSON64
-	depends on STMMAC_ETH && PCI
+	depends on (MACH_LOONGSON64 || COMPILE_TEST) && STMMAC_ETH && PCI
 	depends on COMMON_CLK
 	help
 	  This selects the LOONGSON PCI bus support for the stmmac driver,
-- 
2.43.0



