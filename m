Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E856281D;
	Tue, 23 Jan 2024 01:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974968; cv=none; b=fGGf2ZfqCgbZCTk7uVNq284Mw0KwG5Wl60ItCAAonT1IipBoGUh9ng/BB9cMy0GO5gyJLbDjHe/KhX3GOMwgOqYfEM451Ry/S0i7AdblfmVMmo+thmdj+ap7B4ilTNGwQyFWKwndORe60PsBR4kXnrz+x9dqF5ysHYG0H7Yx4e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974968; c=relaxed/simple;
	bh=HCW8sD8B+RSuPO5ROZ2DzUubebe/D9GGmDE8QZ5WmUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zs5C/WfaJGQYILfnhjREHVxN3pHp3oEEPx1I1CcAvOaPeLVh4ZXcjgoHq5S0K0jZ64daXFsEU5mRQZR2RlpwBPlbXP+DQyuKjSpXhKccZR6D98EiS53CqYWkPtt5TTN7C16g5ZvZ8Sf1VAnnj7a2HXCxMD2HANyJtF8X5XZrwyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hGeSLbZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hGeSLbZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED11CC433C7;
	Tue, 23 Jan 2024 01:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974968;
	bh=HCW8sD8B+RSuPO5ROZ2DzUubebe/D9GGmDE8QZ5WmUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hGeSLbZWkqvCpxGi58s53VEeNa3Mt/HPMxzf5QUPxFFqwhQ882bXLyw5hlxfmu3Ka
	 SWVaPOvOtx1vtTJY0A3iMyXbdEnSPrlx7m4uBqEWrDlIkIuR0CWfZtVmJe81mUozsU
	 hzHwlPed3T9n1YAg0XrRb/TLqYr8uJM+Vdlii0Wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 300/374] MIPS: Alchemy: Fix an out-of-bound access in db1550_dev_setup()
Date: Mon, 22 Jan 2024 15:59:16 -0800
Message-ID: <20240122235755.231859015@linuxfoundation.org>
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



