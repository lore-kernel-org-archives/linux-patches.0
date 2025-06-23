Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303BA22173D;
	Mon, 23 Jun 2025 21:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713514; cv=none; b=L7wTjABbmiNixdNFU80GBx4kMGQzwLl9fjRKIdO0rh3AHdVUgcuTk6R0yUKijCXkyGnGt+snLEFtj7+Jk3tqKbYy8WG0LTJJKkKO7NwipjxNgYkTBi86E4B+opkQuneZq3UxhFIbR+g4+KIw4g+Fjy5huuxrV6KjuFT9rx008Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713514; c=relaxed/simple;
	bh=uildalYhA6I8yMkn3phzxAkSzo53SvK1dxLta/RidfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cur2KfDqWYSZAphrlkheDC6ASCCBZH2HUqIQALYUdJl27WFlJSuJBFyZklnc2Xdxr+znkhcVeianSQEUJFoOXpNE5m8QMpidh9DxM4D73G942ObGj53c/JsZtZKi0dFpTcXgZeTRW6x0BXRstXeZMP4r6s1xs0DHqapweTtNIYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbK+apAS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbK+apAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA6FC4CEEA;
	Mon, 23 Jun 2025 21:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713514;
	bh=uildalYhA6I8yMkn3phzxAkSzo53SvK1dxLta/RidfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbK+apAS65FWdJRtX8BWWfSXJHTD7eRXLBMcFnLyKz9TsRXereFtvTUjA5R1XQ1ZW
	 lMxgf+HUwqjugG5LXOpVnFupd/2W/oTPlrD5JCeIasJgyN3oD/kyO/r/sSNYSfo021
	 8UrXGNVALaldEuhAbgqn58mcqT9j8uy+1ViBmcEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 127/508] soc: aspeed: lpc: Fix impossible judgment condition
Date: Mon, 23 Jun 2025 15:02:52 +0200
Message-ID: <20250623130648.418463983@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index eceeaf8dfbeba..d9bdc2e084086 100644
--- a/drivers/soc/aspeed/aspeed-lpc-snoop.c
+++ b/drivers/soc/aspeed/aspeed-lpc-snoop.c
@@ -167,7 +167,7 @@ static int aspeed_lpc_snoop_config_irq(struct aspeed_lpc_snoop *lpc_snoop,
 	int rc;
 
 	lpc_snoop->irq = platform_get_irq(pdev, 0);
-	if (!lpc_snoop->irq)
+	if (lpc_snoop->irq < 0)
 		return -ENODEV;
 
 	rc = devm_request_irq(dev, lpc_snoop->irq,
-- 
2.39.5



