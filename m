Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BA927456;
	Tue, 23 Jan 2024 00:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968701; cv=none; b=tQazX0+871KLOUgeBcH0jIZgTjgNvUDk5D95BhKJVqspLu7q2Zf311BbHtSnKI1zzVLqYedGB72C5JW0qRrrQNvlQDaoVF7ckhXTJaI6Apn6t3xAPDC+FOAmFcD1OZB/daBDVBEXcKGZeeT5qXK2cRAHaz0fxWUQ7HEgfNMe18I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968701; c=relaxed/simple;
	bh=ffvy+RPIt6ngLd4xxqzIdvJvN5GOU/AshztjWgGN4ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHE6iRqgAQHwAGJSqwAKZvmdbvadg2JMbBmYwnAA0ael5zyg0hIxvMI/j0vX+rnjftV3w/Cnl+RishVE9U/Ua8Shvlmpms4ijZMvXQOTM1rR6TJZaLgCKI93tYuN9FJ2CNPHZKPLq+UuSx1Z1ybitpSLNsszE+DYh+oOo0HEwi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FYAH3eAG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FYAH3eAG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB0BC433C7;
	Tue, 23 Jan 2024 00:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968701;
	bh=ffvy+RPIt6ngLd4xxqzIdvJvN5GOU/AshztjWgGN4ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FYAH3eAGl4YJsgW8SNYHGJLkR9Va5GZTZCNYCtRyH4jrTushY3Sgq86vhPoRSFfnf
	 oneMSH6ZwwOQpWcyh8v7GIfVAqOi9FTL63aS4wWegoa1qqgCW5+Uu21Y0Qf507GBSs
	 hrDZIeCxl/GDNdAHTGOrgIIHhIPm9WUiYCNXeGQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 133/148] MIPS: Alchemy: Fix an out-of-bound access in db1200_dev_setup()
Date: Mon, 22 Jan 2024 15:58:09 -0800
Message-ID: <20240122235717.942088164@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 48840e48e79a..e47bac04cf75 100644
--- a/arch/mips/alchemy/devboards/db1200.c
+++ b/arch/mips/alchemy/devboards/db1200.c
@@ -864,7 +864,7 @@ int __init db1200_dev_setup(void)
 	i2c_register_board_info(0, db1200_i2c_devs,
 				ARRAY_SIZE(db1200_i2c_devs));
 	spi_register_board_info(db1200_spi_devs,
-				ARRAY_SIZE(db1200_i2c_devs));
+				ARRAY_SIZE(db1200_spi_devs));
 
 	/* SWITCHES:	S6.8 I2C/SPI selector  (OFF=I2C	 ON=SPI)
 	 *		S6.7 AC97/I2S selector (OFF=AC97 ON=I2S)
-- 
2.43.0



