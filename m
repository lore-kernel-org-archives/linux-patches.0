Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C90522060;
	Tue, 23 Jan 2024 01:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974965; cv=none; b=B/jUQig6+uavKXA8EyBnFxCI2QMTkqAm/ObWutiNd2WNMVouhvCveVW3KLJ44C/aPTXcPNllInDGEuVW6wG2g6UxP8ORUZGPn7sBGKHIh6Ygyvf+JQipZ71LMxN7kovUN5TJGDNw+kQihQdSf/H9W/MFjIJAd6rSAmiMyjd6Sgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974965; c=relaxed/simple;
	bh=OKA44jgN0UnmuAlrnSf9HtxEHlNukVU/wEu73vl3hh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmclwqjXTFdZgdxjwBGUuAtAUQx6V1wA/oRpqEyRaIRzsRb4L5VgvNknn4nTQ+vt9JH8mOYYF7jLo1QQ+VVQP25Wyaisyl1EPsdmSAtLHSwofVfJ1HCKFsUNeGUu4AFQSzsEgIWo1zk+yiuegqGXhDRp1RNvhEB6pR0K2gnsnxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=auQWZq1A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="auQWZq1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FA2C43399;
	Tue, 23 Jan 2024 01:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974965;
	bh=OKA44jgN0UnmuAlrnSf9HtxEHlNukVU/wEu73vl3hh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=auQWZq1AmAw1yjcg660qFREGtBkjLjL6KYlwUEscD4K3STtU/6KrrzOEfceu/H3fy
	 W6vaDQ6fRjv0opYCbJi6N3hB/Hs6tZyol1vbUzDXbU+0XWTvBgBUzazveOy2ZELGly
	 UZpthPBIKC7NqRae2K3yjZBDAB6jBTRBE1JWtFOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 299/374] MIPS: Alchemy: Fix an out-of-bound access in db1200_dev_setup()
Date: Mon, 22 Jan 2024 15:59:15 -0800
Message-ID: <20240122235755.191869971@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



