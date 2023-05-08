Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DD7168C9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0864C433D2;
	Mon,  8 May 2023 11:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543818;
	bh=w7nWp0v0nn2KG45md7CI3TUuCyLuzJymYTR6tDZGHDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYDxc2Enhg1vh6CU08DYSEtg1mCO3yy0/RHOGwMvg+/8VmAr3opGn+ReQgnWt6xk2
	 ezOPW/nkUdaKvPQSm5vvkS/ntmOkyMfZk27qyUxFySx+yCQH6oY+yZy2SGQW6Et08f
	 AHxcdVc6vk0fZIvxIL3w4f1INQWHFLe2ElCHmw98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Jesse Taube <Mr.Bossman075@gmail.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 180/694] soc: canaan: Make K210_SYSCTL depend on CLK_K210
Date: Mon,  8 May 2023 11:40:15 +0200
Message-Id: <20230508094438.273355955@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jesse Taube <mr.bossman075@gmail.com>

[ Upstream commit 49f965b6fbca63904d7397ce96066fa992f401a3 ]

CLK_K210 is no longer a dependency of SOC_CANAAN,
but K210_SYSCTL depends on CLK_K210. This patch makes K210_SYSCTL
depend on CLK_K210. Also fix whitespace errors.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/all/42446784-a88b-df09-41e9-5f685b4df6ee@infradead.org
Fixes: 3af577f9826f ("RISC-V: stop directly selecting drivers for SOC_CANAAN")
Signed-off-by: Jesse Taube <Mr.Bossman075@gmail.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/canaan/Kconfig | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/canaan/Kconfig b/drivers/soc/canaan/Kconfig
index 2527cf5757ec9..43ced2bf84447 100644
--- a/drivers/soc/canaan/Kconfig
+++ b/drivers/soc/canaan/Kconfig
@@ -3,8 +3,9 @@
 config SOC_K210_SYSCTL
 	bool "Canaan Kendryte K210 SoC system controller"
 	depends on RISCV && SOC_CANAAN && OF
+	depends on COMMON_CLK_K210
 	default SOC_CANAAN
-        select PM
-        select MFD_SYSCON
+	select PM
+	select MFD_SYSCON
 	help
 	  Canaan Kendryte K210 SoC system controller driver.
-- 
2.39.2



