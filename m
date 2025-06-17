Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290712E8E05;
	Tue, 17 Jun 2025 16:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178125; cv=none; b=Csvnp7gXglSgPN8nJMuEU5hk2TNV+TqFMkufSYH/6jRkuae/SvhFhXJz3MXkokPv7/trbWoe8V37evP+v2Se3y/LRbpWtoyD03//JDjTSRc/JrMrVakhE/24XENdIj3x1h7WpYm3waqh1qwXccoQ73TboTZugIy3fGrkveY76G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178125; c=relaxed/simple;
	bh=3yQR18S9kCDi43+FeFUrdVziQ3bGQwBKPRBTjPleVXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cIcr+soDNMCeG1aRKbEqceTwtp97jBDNryUokTn3JGHXm/FtQVL943RZbEgN7iE4utf78xtm1vU4sd1bp60PKE6Fp3T2cbi6xhvR5IyBLNgXgG2xvFr944KJP1poeJkRpy4CNghDmD5AgnCDYFz7Jf2KMIAqi/Z0jgw6ezak92g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=whEsx+SR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="whEsx+SR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BAD7C4CEE3;
	Tue, 17 Jun 2025 16:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178125;
	bh=3yQR18S9kCDi43+FeFUrdVziQ3bGQwBKPRBTjPleVXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=whEsx+SRamhvt2O+v7znTooHtVrhvse9Qkh2N9zxoPGf5HAzk59rNkdM/5eiOz+hT
	 3+VduqRc7WnkKxwiRMaxdbyFR8oasC2/cjPFX8BMa2rTpofF+rBKEz1PFlKYbDKzKD
	 +FM4zGbRVWeYCFJpHZFZySDV3Ndd32jqQwMjDJLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 413/780] soc: aspeed: lpc: Fix impossible judgment condition
Date: Tue, 17 Jun 2025 17:22:01 +0200
Message-ID: <20250617152508.291174358@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit d9f0a97e859bdcef51f9c187b1eb712eb13fd3ff ]

smatch error：
drivers/soc/aspeed/aspeed-lpc-snoop.c:169
aspeed_lpc_snoop_config_irq() warn: platform_get_irq() does not return zero

platform_get_irq() return non-zero IRQ number or negative error code,
change '!lpc_snoop->irq' to 'lpc_snoop->irq < 0' to fix this.

Fixes: 9f4f9ae81d0a ("drivers/misc: add Aspeed LPC snoop driver")
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20231027020703.1231875-1-suhui@nfschina.com
Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/aspeed/aspeed-lpc-snoop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/aspeed/aspeed-lpc-snoop.c b/drivers/soc/aspeed/aspeed-lpc-snoop.c
index 9ab5ba9cf1d61..57ba855f375d9 100644
--- a/drivers/soc/aspeed/aspeed-lpc-snoop.c
+++ b/drivers/soc/aspeed/aspeed-lpc-snoop.c
@@ -166,7 +166,7 @@ static int aspeed_lpc_snoop_config_irq(struct aspeed_lpc_snoop *lpc_snoop,
 	int rc;
 
 	lpc_snoop->irq = platform_get_irq(pdev, 0);
-	if (!lpc_snoop->irq)
+	if (lpc_snoop->irq < 0)
 		return -ENODEV;
 
 	rc = devm_request_irq(dev, lpc_snoop->irq,
-- 
2.39.5



