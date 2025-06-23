Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E821F30E84D;
	Mon, 23 Jun 2025 13:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685701; cv=none; b=gGwkw+guuo2sjdF/y7J+dOZMt4aIRdMFU/upZiSCVBmVk4pUdNe32WAtl8Ac0Nc25Z7IkGe0TshhabDlMFdHfBhFbu75ugVPl+4g3TsgXKyd+4AQTWj36uwVDgSFjxx1NBZ8VgxO4b0LPeFyKSFVsyUK/1WXevkYmxHVteUPlVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685701; c=relaxed/simple;
	bh=8iIUhNqAAmb+WEZJ8VoG4R9R6U3JT3Yjozyk2UVBqek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s6EYYNfqk0CgpLiSZUd5f6rKWD2NYHjV0TxRi1o93d+vqjMAhTfsGxSdz7OGHIXVCgWKcqGNiLXZGNfSh5ziwijLnK0zFkUVa7Cgr0RabnD13MVK1/7Ae3nxwnXR6JcfqnU40ST/kJ3aoS9wpXgctUEcrZ7qM68nadH7BRZPjfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xwc2Eh6k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xwc2Eh6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC5BC4CEEA;
	Mon, 23 Jun 2025 13:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685700;
	bh=8iIUhNqAAmb+WEZJ8VoG4R9R6U3JT3Yjozyk2UVBqek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xwc2Eh6klOJyfMq1OomCDIs3blmUp8G2KbNXiD/HIJ/w2CEodKuDKXHTNDKVA7zjz
	 VK0yZ42x2/lMz/LGtEP5JnAfXBptIcz6gpUVzt8fqvzV8QzUzkH6QaT9tIrinYFQJ6
	 VXoAwNeqjjOPjLFIIzXSqKiDj6xTF2rBu/Ehz3mU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 069/355] soc: aspeed: lpc: Fix impossible judgment condition
Date: Mon, 23 Jun 2025 15:04:30 +0200
Message-ID: <20250623130628.906178453@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 538d7aab8db5c..8a2a22c40ef53 100644
--- a/drivers/soc/aspeed/aspeed-lpc-snoop.c
+++ b/drivers/soc/aspeed/aspeed-lpc-snoop.c
@@ -168,7 +168,7 @@ static int aspeed_lpc_snoop_config_irq(struct aspeed_lpc_snoop *lpc_snoop,
 	int rc;
 
 	lpc_snoop->irq = platform_get_irq(pdev, 0);
-	if (!lpc_snoop->irq)
+	if (lpc_snoop->irq < 0)
 		return -ENODEV;
 
 	rc = devm_request_irq(dev, lpc_snoop->irq,
-- 
2.39.5



