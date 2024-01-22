Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C7513340E;
	Tue, 23 Jan 2024 01:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971836; cv=none; b=TnijeFG5whLsviiCDRVfk2JnPYAXPdeBu79jVHLiDLodmTE4Vt45X03BqCsRlsKlkjaNPtW6llHKhN+GBcyeP3JzgPH7m2Jrs2yrVhLAG/S5+jPwiRFbbZB/6XI8CgwfuHuVHFwTXGP7gDxW5mQuwQlBDcQWCr+lCufQH83rN5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971836; c=relaxed/simple;
	bh=66A7L/SeEjA+dh3/Q2yrBgpHcmHQRcGSVFaxPiZLsIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JiPsbSoY96ooFfO2LLhgrdbXW+b+msfKIB+A61QwvfuE7qNzRKcRHD/DtS9wnQ/9LTsOb8iDQ/CI6drA5NkdzxYbS2Zbl0NPUYBCIt0bl1e+BOZx/MviG4IKWd3j26zxz5FiioV2xQqqof4VAWytAdMzCKNBciGo5uCHwOjUOho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ruol4kJO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ruol4kJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0BDC433C7;
	Tue, 23 Jan 2024 01:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971836;
	bh=66A7L/SeEjA+dh3/Q2yrBgpHcmHQRcGSVFaxPiZLsIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ruol4kJOcEmNWsawflaiys8FlaOMS9n5HY2NT2FX7wCwWJziQZ4wUn2SDtI5XiBSB
	 065KQQOrOQmmL0QNtgULC6Jwcxk18BzQEWodYz1w60bmZQt59RK/H2k5DScFqiwTDX
	 RjtnG9IyW7y0BppfMVArKTKoD8J6YzKHPsITORD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 241/286] MIPS: Alchemy: Fix an out-of-bound access in db1550_dev_setup()
Date: Mon, 22 Jan 2024 15:59:07 -0800
Message-ID: <20240122235741.346879585@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 3c1e5abcda64bed0c7bffa65af2316995f269a61 ]

When calling spi_register_board_info(),

Fixes: f869d42e580f ("MIPS: Alchemy: Improved DB1550 support, with audio and serial busses.")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/alchemy/devboards/db1550.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/alchemy/devboards/db1550.c b/arch/mips/alchemy/devboards/db1550.c
index 752b93d91ac9..06811a5db71d 100644
--- a/arch/mips/alchemy/devboards/db1550.c
+++ b/arch/mips/alchemy/devboards/db1550.c
@@ -588,7 +588,7 @@ int __init db1550_dev_setup(void)
 	i2c_register_board_info(0, db1550_i2c_devs,
 				ARRAY_SIZE(db1550_i2c_devs));
 	spi_register_board_info(db1550_spi_devs,
-				ARRAY_SIZE(db1550_i2c_devs));
+				ARRAY_SIZE(db1550_spi_devs));
 
 	c = clk_get(NULL, "psc0_intclk");
 	if (!IS_ERR(c)) {
-- 
2.43.0



