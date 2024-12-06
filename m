Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5EF53A7;
	Fri,  6 Dec 2024 15:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497587; cv=none; b=roXU7HZmAzttMLlqVEvcwI2PkwMQ5mIAs3nIR+AD3gX9HdDJ860lxFWaeQjCtI5IErkppy04yHAFF++yHk/EyrvdaGRvjjjONlUX+OG02XVqJJ3u1o6l9zFQiKacZUofW7v4azmTXr2MK1CZciVUo5Xb0X9MaiTL+uEVJyp+vUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497587; c=relaxed/simple;
	bh=uKGhvVvE1VRWgqya0upR6IQfa09FBRnxC9Y3BmdV1uM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwjrnl9SiI9nq/s+hLuCH5pyWGWRawXFcHCMipYCn5YuaURY1ngfWY2o7CFQXDrr/V8Fd86LuRbQpkpF6jff7NGShBmX2z8u0LbEKiZmqbusImmvOpZ9AjP3bUNfyYssODrKbksgS6yHL/gQDhKAImKz+FLWNo75Tb60AGpCJoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJZI8bFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJZI8bFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80C2C4CED1;
	Fri,  6 Dec 2024 15:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497587;
	bh=uKGhvVvE1VRWgqya0upR6IQfa09FBRnxC9Y3BmdV1uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJZI8bFVCHxd8drfwIMzWrw6UaeJ/1FzWpaN0LW3g5RNIlZ3xvixuZdadnmN7ogKg
	 r2Ef4LQUbUQEFedFeiXouGBBMPp4IqC9nGHGVnIbGSdcVdA4Fcd2iuRwZy/452cgNZ
	 ptY3brx3+I0RyEjYkl8mImaDKwSzdIV5AyyjOLh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhang jiao <zhangjiao2@cmss.chinamobile.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 332/676] pinctrl: k210: Undef K210_PC_DEFAULT
Date: Fri,  6 Dec 2024 15:32:31 +0100
Message-ID: <20241206143706.313734202@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: zhang jiao <zhangjiao2@cmss.chinamobile.com>

[ Upstream commit 7e86490c5dee5c41a55f32d0dc34269e200e6909 ]

When the temporary macro K210_PC_DEFAULT is not needed anymore,
use its name in the #undef statement instead of
the incorrect "DEFAULT" name.

Fixes: d4c34d09ab03 ("pinctrl: Add RISC-V Canaan Kendryte K210 FPIOA driver")
Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/20241113071201.5440-1-zhangjiao2@cmss.chinamobile.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-k210.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-k210.c b/drivers/pinctrl/pinctrl-k210.c
index b6d1ed9ec9a3c..7c05dbf533e7a 100644
--- a/drivers/pinctrl/pinctrl-k210.c
+++ b/drivers/pinctrl/pinctrl-k210.c
@@ -183,7 +183,7 @@ static const u32 k210_pinconf_mode_id_to_mode[] = {
 	[K210_PC_DEFAULT_INT13] = K210_PC_MODE_IN | K210_PC_PU,
 };
 
-#undef DEFAULT
+#undef K210_PC_DEFAULT
 
 /*
  * Pin functions configuration information.
-- 
2.43.0



