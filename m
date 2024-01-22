Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BCB13340E;
	Tue, 23 Jan 2024 01:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971829; cv=none; b=bydaKTRI+4AsOTb+vO/RJo+vg0jUuXJmkdBESlECuoT+2n+SOZVY9lPreHOMC4P936ad/t6UE3jQG2k/Aw9XWfZwBOhLTed+6t3GrUgAIxkOZmgZaueYS5CAdPj7QgFfsuXJ141stUkf31e3gSLToUene/vcFJCCZOc+z6KQG0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971829; c=relaxed/simple;
	bh=cVCBAv0EZocQ+AOrLTW2UGmXZY+K98S/AiWcTL1JnW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oADBR7D6uTwq103u2l8wWiwCMrzLxqdV6meIZ8mbpagPm0E4Ms6kB/f9n7xbnmK506qmjsrIJdyr1i6rEwPeYTPkUAFPYBKK0gAqgJ9MHiT7tXFeBpES8pHcME8vUPA/7ZZ0NCVm2HFyWQp1fE8P1I65sv+4wXBcO2oUsY9PpVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjezm5pf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjezm5pf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D7CC433F1;
	Tue, 23 Jan 2024 01:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971829;
	bh=cVCBAv0EZocQ+AOrLTW2UGmXZY+K98S/AiWcTL1JnW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zjezm5pfK+HDCfs6MVjVgks8VseQ5aGM6GxtBUg1cmAfpaL52YddQ2RLMHQ61A/rA
	 2MSW0nwHmGOfDXdy0TnpCgN9+bScVFhTY6RjFRO/sAoVdYFwujV4c3iG6KYnh82GX5
	 HZzFuGyXNeL1IJFlconIN+PXbOdBuOUGQXj7YTVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 240/286] MIPS: Alchemy: Fix an out-of-bound access in db1200_dev_setup()
Date: Mon, 22 Jan 2024 15:59:06 -0800
Message-ID: <20240122235741.304998703@linuxfoundation.org>
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



