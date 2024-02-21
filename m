Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7797C7BAF7;
	Wed, 21 Feb 2024 14:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525647; cv=none; b=HS5v3bjStkoHtY/wPp5lZ/UUcvz3GlKUEY6XsRP6FHVznWpDw/O93q/vM+SahVZUDmnJ943rb1nJg3rzR6PLhFDNMHYmvhg81YKSVAoMtYK45Ns4GGXjc3uuVt34LpnFBiODwsk0neE3ObUAED0Lug81pmoK3sskhhvMuqP3p3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525647; c=relaxed/simple;
	bh=UUiNulxrAfr9q/DApo4Ctj4YuWDrODNLok8RbHEF4Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQkP8gAZsKXov//segKGE4c/7NPNuwdK670XEwy8FO7BReGyLSg7FbrAewDUm5ODRzED/+ch8WL1uiI9Z9LFaDalAxqGNM4iGyBPDP0eNW/iCdmJCpgs1XADForx3N6OFwuMZGVb1G60BEYaMB+l4zV6imz7BgwL0beYfckETTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v36jFZ7R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v36jFZ7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4F3C433F1;
	Wed, 21 Feb 2024 14:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525647;
	bh=UUiNulxrAfr9q/DApo4Ctj4YuWDrODNLok8RbHEF4Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v36jFZ7RFI6oSSRwRdzo+lV1LQl2rDuGvPfNgXXbnIe/xdAFubquA0uwGkyPP9tlE
	 /QesHcai049LSYApipekorIocQXo2xbD15pViVcdeMdEgUr8aoBhzaZStkPiv4ZpjS
	 XjhWVwEftq65SI1Pth6rrqlhqaeNzl0m3YpnXwz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jean Delvare <jdelvare@suse.de>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 219/267] i2c: i801: Remove i801_set_block_buffer_mode
Date: Wed, 21 Feb 2024 14:09:20 +0100
Message-ID: <20240221125947.095345752@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 1e1d6582f483a4dba4ea03445e6f2f05d9de5bcf ]

If FEATURE_BLOCK_BUFFER is set then bit SMBAUXCTL_E32B is supported
and there's no benefit in reading it back. Origin of this check
seems to be 14 yrs ago when people were not completely sure which
chip versions support the block buffer mode.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Tested-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: c1c9d0f6f7f1 ("i2c: i801: Fix block process call transactions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-i801.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 50c972b3efe0..21ed6d98c048 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -528,9 +528,11 @@ static int i801_block_transaction_by_block(struct i801_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
+	/* Set block buffer mode */
+	outb_p(inb_p(SMBAUXCTL(priv)) | SMBAUXCTL_E32B, SMBAUXCTL(priv));
+
 	inb_p(SMBHSTCNT(priv)); /* reset the data buffer index */
 
-	/* Use 32-byte buffer to process this transaction */
 	if (read_write == I2C_SMBUS_WRITE) {
 		len = data->block[0];
 		outb_p(len, SMBHSTDAT0(priv));
@@ -768,14 +770,6 @@ static int i801_block_transaction_byte_by_byte(struct i801_priv *priv,
 	return i801_check_post(priv, status);
 }
 
-static int i801_set_block_buffer_mode(struct i801_priv *priv)
-{
-	outb_p(inb_p(SMBAUXCTL(priv)) | SMBAUXCTL_E32B, SMBAUXCTL(priv));
-	if ((inb_p(SMBAUXCTL(priv)) & SMBAUXCTL_E32B) == 0)
-		return -EIO;
-	return 0;
-}
-
 /* Block transaction function */
 static int i801_block_transaction(struct i801_priv *priv,
 				  union i2c_smbus_data *data, char read_write,
@@ -805,9 +799,8 @@ static int i801_block_transaction(struct i801_priv *priv,
 	/* Experience has shown that the block buffer can only be used for
 	   SMBus (not I2C) block transactions, even though the datasheet
 	   doesn't mention this limitation. */
-	if ((priv->features & FEATURE_BLOCK_BUFFER)
-	 && command != I2C_SMBUS_I2C_BLOCK_DATA
-	 && i801_set_block_buffer_mode(priv) == 0)
+	if ((priv->features & FEATURE_BLOCK_BUFFER) &&
+	    command != I2C_SMBUS_I2C_BLOCK_DATA)
 		result = i801_block_transaction_by_block(priv, data,
 							 read_write,
 							 command, hwpec);
-- 
2.43.0



