Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A6012F5A7;
	Tue, 23 Jan 2024 00:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969021; cv=none; b=BuvrcSpD9aYOu+mO4i0oN7K79loUxqFCI+IKFAFU7FcLAtJWEi7y1AzDsZyatCWsPZf1h3e68DV+xa2UDUrkkBIwsZ2O5QothdquM8gTdfOifK08jFmtDoVngpkVGUr1EfUNFucF7Sq5adU9ipEfxv/X0eI01hp0TMPAWhgMvKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969021; c=relaxed/simple;
	bh=RBBTIsfF+z1LKqaqb3U65u8rvMOVP4vS/ZcZamBwSX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZniS9xJTKSclpojceYZA7O5sckouXbYP60j2N6F4MUpGCY/bpIC+OwOatmjW00DEmWOdCnuYKp4zVJhYhBvz3BrglTmyDreI62P/ZRrYv2fJkukEnKS2euwtkPTCBTiBlOlV1hGedLQRn0UCtIPFx8xgb+5Ly6FqP7XUOpQiBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QD+pGm3U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QD+pGm3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A4FC433C7;
	Tue, 23 Jan 2024 00:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969020;
	bh=RBBTIsfF+z1LKqaqb3U65u8rvMOVP4vS/ZcZamBwSX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QD+pGm3UfchHyw9QMiD9X8HCfcUZrJ1nriWYpq0Wd5DhzLDZ5Cw6cMYzlPz/B+Wts
	 YEw6KGvfvCYbB9sHx4WhI7LGmGx9trgJhAGsXiWlhWKRzndeOaPBdv3zrnjQAKYoqW
	 dWlLOe9RoYX1x9QEbbu/CRA2fRLbIolDKu77uEpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 165/194] MIPS: Alchemy: Fix an out-of-bound access in db1550_dev_setup()
Date: Mon, 22 Jan 2024 15:58:15 -0800
Message-ID: <20240122235726.282165242@linuxfoundation.org>
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
index 3e0c75c0ece0..583b265d7407 100644
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



