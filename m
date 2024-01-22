Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD02C27456;
	Tue, 23 Jan 2024 00:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968703; cv=none; b=WL1Wf6AJKFr+ncdznYV1W0HzcrlUYqXTOmhq1FXwJ5sFEdS8PpYBg0FmjU/kjk7b5Xn/L+8VpDg4jVVrKrhT0nsUkpdSWP8IbevmIR5i86XK+YFCdwoij2v9u/JUQQtW+ph3yljD8xi7xCpaho5ouZh8U7Hw8aj41VtDllPgvWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968703; c=relaxed/simple;
	bh=HW8TJfmgxC7Ef0frU9CXTMTMDRkmKmUrjEH17A9Yfig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfhGlHDHlZiVp2eneMQoW8iuF2h605SKGTzTeBsjFVlVYC2PYLVFluFS9B8R90Tetxi5DYA2zk1SUJF1yaUd+WAVFlTIGfAkvUx061kFvMJdwGlRkFzplZ/vfBi9ovRR/tp84Yz0v426tLifJyQHGhOprGrJxufRkTMsBXpAFIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7vYYNi8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7vYYNi8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D80DC433F1;
	Tue, 23 Jan 2024 00:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968703;
	bh=HW8TJfmgxC7Ef0frU9CXTMTMDRkmKmUrjEH17A9Yfig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s7vYYNi8OMd2wKSOllCwVr3pSRHdsyNnFcgyNWhpH5kmiFi6VSHUA0NH3gJtSMICb
	 ZSjrJ9jq7YW9yfPmWRbcEAWltvZljm0o5hTTnXQ7+CsqrtrEaZuGuv+BRXBn2C7RDC
	 hL06NVeqC4zt8RnTlB5BRU0xqHfkV+3R1V0hxusA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 134/148] MIPS: Alchemy: Fix an out-of-bound access in db1550_dev_setup()
Date: Mon, 22 Jan 2024 15:58:10 -0800
Message-ID: <20240122235717.983782443@linuxfoundation.org>
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
index 7d3dfaa10231..aaee46fe582f 100644
--- a/arch/mips/alchemy/devboards/db1550.c
+++ b/arch/mips/alchemy/devboards/db1550.c
@@ -581,7 +581,7 @@ int __init db1550_dev_setup(void)
 	i2c_register_board_info(0, db1550_i2c_devs,
 				ARRAY_SIZE(db1550_i2c_devs));
 	spi_register_board_info(db1550_spi_devs,
-				ARRAY_SIZE(db1550_i2c_devs));
+				ARRAY_SIZE(db1550_spi_devs));
 
 	c = clk_get(NULL, "psc0_intclk");
 	if (!IS_ERR(c)) {
-- 
2.43.0



