Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B984F5E9;
	Tue, 23 Jan 2024 00:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969891; cv=none; b=aTp5u0fnHwmuDIZ1AU51pQWF6oRNgcLtrum+GkdrelhTCRFrOUjkLtNbkXAOTNg8RcjE/S9TH1IOomqr91h9tOKIz/1o55ytBwHS3+pSfZh2kAOodLgun1TBcC2RaiLF7XJGD4/HMPViVsJVCnDeaYsqRr8zUqNK0m761BvyAks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969891; c=relaxed/simple;
	bh=jTxn9D4BO2w2pM7YHT7a9kRYOjJFqS2DMTP5Iuyzsd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkewkimD4GHslAXGlq6dfpJnAVveYXtsvQaqoA0mnJjopH9BKre6qtx+GjRNZY+RL0EAZx4kDyTzu8xEUziKlWBnDvSNhVN7AjzXiqxVfxXjzmD+OQr5LZ00vYBBuMQeMjGYrUF7G6EMhIL8X0gmsc7xby9yDeGUgdSJLLEPwbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o953yPq6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o953yPq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C69C433F1;
	Tue, 23 Jan 2024 00:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969890;
	bh=jTxn9D4BO2w2pM7YHT7a9kRYOjJFqS2DMTP5Iuyzsd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o953yPq6Xh1uONYKWsMHSXmTjGZwO/Bui88IZtxgf/TN491O3z755n2srsiJjLflA
	 YPZ7uOiagYnN9AZYuJ0wO4JkO07KEyQmd8Eap2f3cmtIva+wmZMCTGwt6laC5a7DAN
	 yk3qQwf3MB5llD513d54qlYYdzf8+qgXOVntDlc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 501/641] MIPS: Alchemy: Fix an out-of-bound access in db1550_dev_setup()
Date: Mon, 22 Jan 2024 15:56:45 -0800
Message-ID: <20240122235833.741985983@linuxfoundation.org>
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
index fd91d9c9a252..6c6837181f55 100644
--- a/arch/mips/alchemy/devboards/db1550.c
+++ b/arch/mips/alchemy/devboards/db1550.c
@@ -589,7 +589,7 @@ int __init db1550_dev_setup(void)
 	i2c_register_board_info(0, db1550_i2c_devs,
 				ARRAY_SIZE(db1550_i2c_devs));
 	spi_register_board_info(db1550_spi_devs,
-				ARRAY_SIZE(db1550_i2c_devs));
+				ARRAY_SIZE(db1550_spi_devs));
 
 	c = clk_get(NULL, "psc0_intclk");
 	if (!IS_ERR(c)) {
-- 
2.43.0



