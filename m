Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A077930BF60;
	Mon, 27 Oct 2025 18:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591195; cv=none; b=JLzUksOy46ShOkBHtcKYqiAcJjk/mP9m/Hjuc+EEYepvbT30AqeeSzn7tDMCo+sBX/idI6elNa/JcpfttkB7+AbIflOPSxF2+65PsPt4tfqDkiOjaJtDg9fOo6nTSyrv6In/kg0vMPsCoY0X8SfypmzPNr9QhwC0jdvlsstzHsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591195; c=relaxed/simple;
	bh=Hb5t7BfiktPpfsR28Z8h1ao+HxK1MWmarSYRqdkZbWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdqPUt1wBsABndbBwXY3hSjAC7NHjjK+h+TW5OZpL/UVzVrlLgcmDNHft2SujLS23i5FyISkq4hHAOuXOnsXc+MQVQ2fc209MNHqRE27AWJWP9GcprFtAqjkmu6T6ao96Zk5YO/v12rD7CpFnlFQ3a1E1FsaWHrBtzSGbbPxhOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n72iPQol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n72iPQol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA212C4CEF1;
	Mon, 27 Oct 2025 18:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591195;
	bh=Hb5t7BfiktPpfsR28Z8h1ao+HxK1MWmarSYRqdkZbWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n72iPQolM9JmLx+WkFDK2VPohh62f4rBT2+nl7ekVACDogtNqEQMEu71YQMP2lbEw
	 fWkGtRdTIx6K/06/yjsAtSo5PB95wglWgCFfkV/3/i3EPkf4aRjRu0sYatKGiXedaY
	 BDjvejiTeRJCrugiNH4ju51oQbunLiZlR/tC12Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/332] rtc: x1205: Fix Xicor X1205 vendor prefix
Date: Mon, 27 Oct 2025 19:32:35 +0100
Message-ID: <20251027183527.311269924@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d1d5a44d9122a..3b3aaa7d8283c 100644
--- a/drivers/rtc/rtc-x1205.c
+++ b/drivers/rtc/rtc-x1205.c
@@ -671,7 +671,7 @@ static const struct i2c_device_id x1205_id[] = {
 MODULE_DEVICE_TABLE(i2c, x1205_id);
 
 static const struct of_device_id x1205_dt_ids[] = {
-	{ .compatible = "xircom,x1205", },
+	{ .compatible = "xicor,x1205", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, x1205_dt_ids);
-- 
2.51.0



