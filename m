Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6385E17A930;
	Tue, 16 Jul 2024 16:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146340; cv=none; b=ZZoJctJ/lg1aVXJl4yi4V2JoFnQ6PrhhSMtTnDb0tI7CMHLmGgRtZM4Ue9mvdkGW3liGiazBgG7ufNkQavryZR/Z+c3ZwVmpTwq6K35erUxdir7nR9Ihfyd9x2fF3bKLONpaeN3FdLgWxutfbNEipZQ2EzLDhy7Q2SFY52VFr14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146340; c=relaxed/simple;
	bh=6NZo6kL18o6MBmTNisLMyQ4LZM0K/+OORzCiHDASb7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXL7cBWkGVTGHg8Cv9z8mWiMOg4f7oVy1oazz5QHREJJiJmD6OcZMoip/AhDtrq5SJFeT7umXHOjyS/7VG/dF/4h6XF5nCCludlFEZuEMOuXf9qDTceEvSzEu8UPnZN+GRF0pAZy3fCbwklwpikDzE/HfjqWi285f1xZurir2nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHCNLCHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHCNLCHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D11C116B1;
	Tue, 16 Jul 2024 16:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146340;
	bh=6NZo6kL18o6MBmTNisLMyQ4LZM0K/+OORzCiHDASb7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gHCNLCHPFspq6KeZnDBKCwDjqwHiOAoqK3RC7Ln5Ce5kfi3ukDB0WtQrHLxodEZLt
	 ZTHdAQLxIDDUgnCJb/rt+FjZYk3FdIinUWkb7FTAGgai3jHJqGrrW3+2V+buCDbp4O
	 XeurujqPr3uVplzKq4tIoR/9Ktt/Kqtp+g8OmH0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 135/144] i2c: rcar: Add R-Car Gen4 support
Date: Tue, 16 Jul 2024 17:33:24 +0200
Message-ID: <20240716152757.703646849@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit ea01b71b07993d5c518496692f476a3c6b5d9786 ]

Add support for the I2C Bus Interface on R-Car Gen4 SoCs (e.g. R-Car
S4-8) by matching on a family-specific compatible value.

While I2C on R-Car Gen4 does support some extra features (Slave Clock
Stretch Select), for now it is treated the same as I2C on R-Car Gen3.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
[wsa: removed incorrect "FM+" from commit message]
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: ea5ea84c9d35 ("i2c: rcar: ensure Gen3+ reset does not disturb local targets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-rcar.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index 97900fe0c3bcf..b25a8e7ea2d20 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -1021,6 +1021,7 @@ static const struct of_device_id rcar_i2c_dt_ids[] = {
 	{ .compatible = "renesas,rcar-gen1-i2c", .data = (void *)I2C_RCAR_GEN1 },
 	{ .compatible = "renesas,rcar-gen2-i2c", .data = (void *)I2C_RCAR_GEN2 },
 	{ .compatible = "renesas,rcar-gen3-i2c", .data = (void *)I2C_RCAR_GEN3 },
+	{ .compatible = "renesas,rcar-gen4-i2c", .data = (void *)I2C_RCAR_GEN3 },
 	{},
 };
 MODULE_DEVICE_TABLE(of, rcar_i2c_dt_ids);
-- 
2.43.0



