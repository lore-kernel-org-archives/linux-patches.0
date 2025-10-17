Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3578A335092;
	Fri, 17 Oct 2025 15:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713571; cv=none; b=IZGlRQ5JgSEEbt/r8gZfByvAUs/QuCHLAYhsdzyHDOt9Mi3GqT36PP0ADwtTY/U8Z6JdGPGLaoArWVg7F0AO6pS82GB1GWILACe9CeMedeiQknCes2N/4pQRlzkgJ61ANg8Ta8PZ28KWjX/f00aU/FkxbNc+sew6sEs5sIb1s54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713571; c=relaxed/simple;
	bh=nvbpSpt8ZF+xWjMZgItCQ8xbtdbAIJLN4W+3yiKc/Ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0ru8gN3ztE6OfTelBHGRyVq2zRYVcqoR/rB7p4Xv+wiWxh5Njd0YPTXcOxE2j685cMBUiwuyEkGAVaoAWwNVtCvHA/2kfcbK4vgVU+B1Fx2y3C9kDkC8wZWG0W6JCRv+CHUxKojy//mGulgwrAql5/CsMAY/i8vCQ89t51w6aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kFlMbPp7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kFlMbPp7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2987C4CEF9;
	Fri, 17 Oct 2025 15:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713571;
	bh=nvbpSpt8ZF+xWjMZgItCQ8xbtdbAIJLN4W+3yiKc/Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kFlMbPp7Bp9RQA8q8zVf7l/bUD3rgH/OV442tZ9cBDPfW8TgZTRliADg7RgaaUtHf
	 B676NWKXoxN3QzSzKcPUDhKn7s5ug2ZTj3Qn0rhFsRomUqq1Aa6xG6Fiw3aOfGezJB
	 r/ThKIMx0MU+j1KeuRAM/93A0PxZ5KEBKujEzwhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/201] rtc: x1205: Fix Xicor X1205 vendor prefix
Date: Fri, 17 Oct 2025 16:51:12 +0200
Message-ID: <20251017145135.147426877@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit 606d19ee37de3a72f1b6e95a4ea544f6f20dbb46 ]

The vendor for the X1205 RTC is not Xircom, but Xicor which was acquired
by Intersil. Since the I2C subsystem drops the vendor prefix for driver
matching, the vendor prefix hasn't mattered.

Fixes: 6875404fdb44 ("rtc: x1205: Add DT probing support")
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20250821215703.869628-2-robh@kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-x1205.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-x1205.c b/drivers/rtc/rtc-x1205.c
index 807f953ae0aed..b7a7ea036f7ad 100644
--- a/drivers/rtc/rtc-x1205.c
+++ b/drivers/rtc/rtc-x1205.c
@@ -669,7 +669,7 @@ static const struct i2c_device_id x1205_id[] = {
 MODULE_DEVICE_TABLE(i2c, x1205_id);
 
 static const struct of_device_id x1205_dt_ids[] = {
-	{ .compatible = "xircom,x1205", },
+	{ .compatible = "xicor,x1205", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, x1205_dt_ids);
-- 
2.51.0



