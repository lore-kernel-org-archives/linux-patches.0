Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844BD2192F2;
	Tue,  8 Apr 2025 11:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112356; cv=none; b=Ua8IswmPOlO+ukCiTmDVF08QV+TBdkZJbLZQ9kXaIKQ2US/FvgXGy9mRJ1SYdgr09CbzZkMS/GanM/cSnFiwD/Lh/ZdLUNmAnQ5H/WmlZd85U3+O27U1YYC9vgjhP2KPuHxC1UsHK62yxPsoFeYKi1UIuTPs0J8KPQctLIZytHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112356; c=relaxed/simple;
	bh=ipNUeesJA8wYhuR3i8ErCZ5g6Ayd67kRAdrguBVZwzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YW3iSDq4vNAcaHsjChvLXm+49pi/UKJCpyYmsVz8fE8rFvK5AaXVfCq9xJd+WguWyeq9jwlvqF5V1pUL/PO0m+SfZ9IMqyknYd5lAqyS/i6dwmjK5SVZzDFjvs/V0VO1StODkmXO1jQ/krA643PCxOzWMSq+xssD/oPipYaw3eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tMz1V2xj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tMz1V2xj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1508BC4CEE5;
	Tue,  8 Apr 2025 11:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112356;
	bh=ipNUeesJA8wYhuR3i8ErCZ5g6Ayd67kRAdrguBVZwzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tMz1V2xjsL+lwINGreCf0vPqpmfYLvTGnzlh5DarG6Md7xHMJFYD0BrHFVvQjwHBI
	 HveI630PpSdUawTNsgopx2zJZ/wJBhzWjL5UvKdTJW6vpwE/5MIe3UGHbt3Dac52iN
	 F6d5Z/I42Iu+mmO+dt+sBp8RXM5Oxrwkz9uD5+BQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artur Weber <aweber.kernel@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/279] pinctrl: bcm281xx: Fix incorrect regmap max_registers value
Date: Tue,  8 Apr 2025 12:46:29 +0200
Message-ID: <20250408104826.527434675@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Artur Weber <aweber.kernel@gmail.com>

[ Upstream commit 68283c1cb573143c0b7515e93206f3503616bc10 ]

The max_registers value does not take into consideration the stride;
currently, it's set to the number of the last pin, but this does not
accurately represent the final register.

Fix this by multiplying the current value by 4.

Fixes: 54b1aa5a5b16 ("ARM: pinctrl: Add Broadcom Capri pinctrl driver")
Signed-off-by: Artur Weber <aweber.kernel@gmail.com>
Link: https://lore.kernel.org/20250207-bcm21664-pinctrl-v1-2-e7cfac9b2d3b@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/bcm/pinctrl-bcm281xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/bcm/pinctrl-bcm281xx.c b/drivers/pinctrl/bcm/pinctrl-bcm281xx.c
index 9ab1f427286a7..fbfddcc39d5cc 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm281xx.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm281xx.c
@@ -981,7 +981,7 @@ static const struct regmap_config bcm281xx_pinctrl_regmap_config = {
 	.reg_bits = 32,
 	.reg_stride = 4,
 	.val_bits = 32,
-	.max_register = BCM281XX_PIN_VC_CAM3_SDA,
+	.max_register = BCM281XX_PIN_VC_CAM3_SDA * 4,
 };
 
 static int bcm281xx_pinctrl_get_groups_count(struct pinctrl_dev *pctldev)
-- 
2.39.5



