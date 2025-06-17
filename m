Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1FA2EB5CE;
	Tue, 17 Jun 2025 16:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176784; cv=none; b=RZLSXQZAp0xq2lsy+ScjThh2Jlmft8EIdnwLOBpIkOj/FUGpc1zsW1cUHB55ZYDKslTRq+6owA9JY9DkZisn/ZRNkyilKSuNdYCvfDxPpXgWI+xdX+7wqkLHU9+w+ahP/7SEWWP7vLfXpIVNqwdT6stvIree7bNNwWgi0zUEStg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176784; c=relaxed/simple;
	bh=P09Iy4mx32j+h7mlFAPcW9HmchYXP2M4ozqDtB9MkoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lqofM7rSqO9clZDUqgNOx155VJrBlfSZ9aCON5s2S+jcVMmsk0GCmvQ7MXh3RgKrJViV+IY+wptaPPSgTrH2AVoROzV4cimwB5qe5uCedWeeEzaIAjjAFJ9cydoS0rn52FCqBEdf9FtAvVHfgGD+4ry72HwqHWiGYJ9fKbTCzlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ewOdoMTs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ewOdoMTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CCAC4CEE3;
	Tue, 17 Jun 2025 16:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176784;
	bh=P09Iy4mx32j+h7mlFAPcW9HmchYXP2M4ozqDtB9MkoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ewOdoMTshGeSXoOeoy6mHXTL/HAoSftOwXO2RkXxRCuQfwuGEadXOQQ2wuGNDQhDE
	 VLuDYKEBzKPmEMoJamGwd+G7MaaDdgaauGEFgphIIcfCaCYL1W1zPaUYBNmiShuPUb
	 /qOjsz/Fav2kRyamWmOgQJQ1rW2k7wfRAwtEuUts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 266/512] soc: aspeed: lpc: Fix impossible judgment condition
Date: Tue, 17 Jun 2025 17:23:52 +0200
Message-ID: <20250617152430.368082932@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 888b5840c0150..f06edc4cc5ea4 100644
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



