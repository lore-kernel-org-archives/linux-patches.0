Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06885A78D;
	Tue, 23 Jan 2024 00:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969946; cv=none; b=AIx2hoqXPxqLUpC47zF6aJ7XPxOA0/NyJ0zAu95RyQZl8QlUhMMI+kyqoVMuGpz1Z7xXDHZUaPvt5RENgYqoty135gy1r01kBgm7hUyUunZRneL7+L/eyu7l2qcdE/bkCvKjBCkxiHnD4fsvB5FDc4BM2rrKNyBjor0nUZwJt8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969946; c=relaxed/simple;
	bh=8hf6LQiUNPzVAkwWIjcNAtITBITW2Tz7x7cL62mbUJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZQzobJuDOYvTgYFFQA6r2eOzVsuC79yKgbXeeRoHTyRzbvOjoC1uoBvRKKnO9IL+TMXH5uvamuTMofu1L1SuQrWBaSyUB8EkUtRrTEJZD3SMgM/V81VZnRpizdus7MBs+CPztPCpawasGHuQw11N1SffVEZV8MHlvDRNoVmCv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hQUFMycp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hQUFMycp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C72AC433C7;
	Tue, 23 Jan 2024 00:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969946;
	bh=8hf6LQiUNPzVAkwWIjcNAtITBITW2Tz7x7cL62mbUJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hQUFMycpX0NxJk2+6KMwXKUTXsMG9vHoZSPojdhLzDsAG/86AJmshKqlJcmcpHZmf
	 Kk09CxtWnFxlVp+Q3EhzPm0+j/xyqEfoflDVC/8pff9XHDaPVSTgOoUzyp/1/58pov
	 HjVt/2icbAiu/vBxXo0JvKuzNYgwGEkesmlm9PEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 500/641] MIPS: Alchemy: Fix an out-of-bound access in db1200_dev_setup()
Date: Mon, 22 Jan 2024 15:56:44 -0800
Message-ID: <20240122235833.711597560@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index f521874ebb07..67f067706af2 100644
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



