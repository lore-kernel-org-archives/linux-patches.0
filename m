Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F01253F1A;
	Mon, 23 Jun 2025 13:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684950; cv=none; b=Uk7/lwHsqxHZK6OVWNF2X4GptqA6InF2TP9oZHwGNSah1yaaz6lOyJytO/x1DLwoD9ueDn7qvno6nBCnJE4tTSCUWq28CARNwyLKEltHMD+r0aULmDPM4rGPsPD0ixiYcM+sgeu4Xos/0xKLlbpcmaWISFGTiV6dgam9XpqmbZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684950; c=relaxed/simple;
	bh=2ha+NeskSZuHC9ALlkFqH3/f9W7sVRWQDSeLDd4AEcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SZlpqdwa1ycg9yW8WGzwkP50fw8s0T+TW1ebs6rr6Bcczi38x7sjs2hqUoTLmk2YykxoiwGlmjkMqlmiJlBlXZCMoAWSiC/kfl4FyzTpk+rA0p5n3gmOs5oIZQmHy5jO7Qao225M+4+Ieir2lcIza50ZTRgGYtgDP57jnDYi7Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DoJbX/8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DoJbX/8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CC9C4CEEA;
	Mon, 23 Jun 2025 13:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684950;
	bh=2ha+NeskSZuHC9ALlkFqH3/f9W7sVRWQDSeLDd4AEcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DoJbX/8tPL+F7dReneJ5Mb1xFvHmhlgd3f4MXUh3WDN4t1ERlDznYSUWdEtrLyC+q
	 qgj2xQPvU3a83FC3i1jHivWLa+0Bb4uQ/DLeiNtYRYw/24Bc+aIkwhiVUyMxjeGsjs
	 cU7an8yw7iXWvMP9gC1p6r2iJ5wak9X/79uoB93U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 050/222] soc: aspeed: lpc: Fix impossible judgment condition
Date: Mon, 23 Jun 2025 15:06:25 +0200
Message-ID: <20250623130613.576521800@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



