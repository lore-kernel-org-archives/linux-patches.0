Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D2212FF86;
	Tue, 23 Jan 2024 00:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969060; cv=none; b=iVxV7sWEdDLabgFEoktSDrWmfnGm7r3ApyQlE/w9fTvVKCzZcmQkHLKLWS1ZIacgSzT+fWkqWnouNP/CyC7yDPJKxFpUmEdTngf3mZejuWCIFiZ0+DelT1OsNulWwCK7/ytEziYITyi2Uor8X/zk+di8gLySoHjPBafqYVYvo/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969060; c=relaxed/simple;
	bh=lutKwh8mLi5DFXL549d5HGPusiOiPABZ1I6IrLxAvT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEaxyzN5+7yABAdVNwAXpU+6+qgwLWzG5ary8kg7Duh6nOdUe58ggiz5cnBZg3UlOYOaLDLSOm0df7PGExl0y+m4InDDlkDXt/KQpnYpRGWRwwE6TGkr2ROwR28IeOrPUPeOthfZJaoY5SZL6Sw9TTNp4SP1TxYDwo7cEdxiLE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tXDumnGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXDumnGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF07C43390;
	Tue, 23 Jan 2024 00:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969060;
	bh=lutKwh8mLi5DFXL549d5HGPusiOiPABZ1I6IrLxAvT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tXDumnGQQ3NSjqfXclyQLpgPl4ZiStIu27vfEOEnSOZTOVB1WMJW7oJXIOB/BC6xV
	 AWEA81xo/yVwfwLiiDWK0Fw6uAocy0GeY5Z0PGwMxyk7Pus5/F/6pOUq9OpuKKFMZj
	 88VJN8twq2TLCKuxOSrAcLwyhSq7uCG9s8XizrHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 164/194] MIPS: Alchemy: Fix an out-of-bound access in db1200_dev_setup()
Date: Mon, 22 Jan 2024 15:58:14 -0800
Message-ID: <20240122235726.231716221@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 89c4b588d11e9acf01d604de4b0c715884f59213 ]

When calling spi_register_board_info(), we should pass the number of
elements in 'db1200_spi_devs', not 'db1200_i2c_devs'.

Fixes: 63323ec54a7e ("MIPS: Alchemy: Extended DB1200 board support.")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/alchemy/devboards/db1200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/alchemy/devboards/db1200.c b/arch/mips/alchemy/devboards/db1200.c
index 414f92eacb5e..9ad26215b004 100644
--- a/arch/mips/alchemy/devboards/db1200.c
+++ b/arch/mips/alchemy/devboards/db1200.c
@@ -847,7 +847,7 @@ int __init db1200_dev_setup(void)
 	i2c_register_board_info(0, db1200_i2c_devs,
 				ARRAY_SIZE(db1200_i2c_devs));
 	spi_register_board_info(db1200_spi_devs,
-				ARRAY_SIZE(db1200_i2c_devs));
+				ARRAY_SIZE(db1200_spi_devs));
 
 	/* SWITCHES:	S6.8 I2C/SPI selector  (OFF=I2C	 ON=SPI)
 	 *		S6.7 AC97/I2S selector (OFF=AC97 ON=I2S)
-- 
2.43.0



