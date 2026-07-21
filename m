Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E04344AB91;
	Tue, 21 Jul 2026 21:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670154; cv=none; b=T1lIm7zjapTyA6VpCQbhDG0/UWvrIpE07B9AesvY4BcDcJop+jz+Bj2zTnldk4vkzzKg6XoBFuuwhJ+FgK4QVGwIIflVSGFfV7yKsj4xF7DKkkBdlA64hsmV7K7WeRf7JTUhBh4zGnye7lJSaQS1qZ8r74UMfIB/dreftDpxvsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670154; c=relaxed/simple;
	bh=NL49VM7HuPu7IuEzrXXxWcgUeVr4b1CIxlAmiSVJ9A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbjlfxU7cGTH4xyKfAuD26uJjvSAUeONEUEynJkCghbs8odShr2BezX4fEHLKxJE5Z4IukwdwN0v3A3KYEwx8+0rFN0nQzdrmsNZ6jN55n/g0BntcVEM4ytXwmv5311huW6chrohELocrr8HnbBbDGEiUjkpvIUUQIqrv8qp2bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQyytoqS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQyytoqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E071F000E9;
	Tue, 21 Jul 2026 21:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670153;
	bh=zXeUV79qVJYiAV9ptb6i0Vmk7ygkhF8sLnGPOjG2AS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aQyytoqSZKbQcTx0o37ZxR3E4r72sYec9lKGgA/tMc3e6rF9DDPmZXtTfbimOXanB
	 F1vGakTKj3oz8IqphoJq4w3Kb8Fc6VPgeCx8VnKdhH4by6pGTSoivbX79J5otEDtnT
	 Fkqa1tXk3K0vxhLPm7+EN7G2Xtp9nuUtEf/fsDUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Vivchar <rva333@protonmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.1 0824/1067] i2c: mediatek: fix WRRD for SoCs without auto_restart option
Date: Tue, 21 Jul 2026 17:23:45 +0200
Message-ID: <20260721152442.983737119@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Vivchar <rva333@protonmail.com>

commit deb35336b5bfed5db9231b5348bc1514db930797 upstream.

MediaTek mt65xx family SoCs have no auto restart, however, they still
support the WRRD mode in the hardware. Because auto_restart is set to 0,
the WRRD mode will be never enabled, leading to read errors.

Fix this by removing auto_restart check from the WRRD enable path.

Fixes: b49218365280 ("i2c: mediatek: fix potential incorrect use of I2C_MASTER_WRRD")
Signed-off-by: Roman Vivchar <rva333@protonmail.com>
Cc: <stable@vger.kernel.org> # v6.18+
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260709-6572-6595-i2c-v2-1-b2fb8510d1d3@protonmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-mt65xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -1228,7 +1228,7 @@ static int mtk_i2c_transfer(struct i2c_a
 	i2c->auto_restart = i2c->dev_comp->auto_restart;
 
 	/* checking if we can skip restart and optimize using WRRD mode */
-	if (i2c->auto_restart && num == 2) {
+	if (num == 2) {
 		if (!(msgs[0].flags & I2C_M_RD) && (msgs[1].flags & I2C_M_RD) &&
 		    msgs[0].addr == msgs[1].addr) {
 			i2c->auto_restart = 0;


