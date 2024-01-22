Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92337691F;
	Tue, 23 Jan 2024 02:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975503; cv=none; b=Ao9ujPmTpPbTYWtVaBtv8dAKxSfljeFrbsMSgVslruu9s198gAIzltBDM77LgUCP283zp0Crp02c0gTrja4YNdT/GwzqASmi0Z51fKy7iTEuwzTWtPEqAiOAletD4NxPR8tMY+0t5atAVT+ai0QjZ0BLWS3MvSodvbm/t4lF3YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975503; c=relaxed/simple;
	bh=Jgcwjcx9U7XMCqDgSVIuAXqetSkKpzLir2uglplWXds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugQ4qOv0p2XzuuwSh5QAQfkVzyGdjurPNW3hR23q5nunk7iGwY64bvsWkjFlGN4kpDY1fy8K1PBXANYsCB10Z9k3hEML8mNPe2w03oXUY5dtfJbZhq9xa0MIuafijTrlCx/Kjt9ROWHMDOw+6wpD3nTpHx87/Qh7auo2ypv1Bcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXfLNJqQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXfLNJqQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DA5C43390;
	Tue, 23 Jan 2024 02:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975502;
	bh=Jgcwjcx9U7XMCqDgSVIuAXqetSkKpzLir2uglplWXds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXfLNJqQCJqGn3l9LtNyjLf4pSR86AuL7n2vgIt80T2RT7E8JyDuUNTdxbbXE3L6I
	 IQu8FfTHq/a/ycTkaNdkNFVTCegVEp6ccfAeR9SNtxEk93cX0UbhgT/ilc74cdmRri
	 RnekKAr3EGaSmyBoZWPBhF51HKQwAq6dpgQlM7mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 455/583] MIPS: Alchemy: Fix an out-of-bound access in db1550_dev_setup()
Date: Mon, 22 Jan 2024 15:58:26 -0800
Message-ID: <20240122235825.894185432@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



