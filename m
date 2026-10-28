Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208446;
	b=ab4UmguHr48byc9mphWHiSd6gCeng9AO2jxXKlX2DFRI5XA7fex/KvK7mxUujngVsFnJ
	 U7qffaluWy64SWiZi+BnjFuoAsR6cuAVP0Ko/NBBKTo8V0MGToJA34cbRiu947cSf3MK1
	 fQhg2l/Q/Xx3u8hnWELTAwRqI3hH4GJM+nhfoRz5DHWmLGJaV0I+FSxdkZRKBxzpeJUZU
	 OH2Zz4vpFzvksTm0EmUgK7LmJQL3h162mlOr8EIRi0drzMIB4chGQvwjbH9rv1/I0pLmQ
	 1Jr/ioKy/w1lW9ZwLF3Mil7lpf3Tv5hQ5GZERCnlq36JMzHpIrSWfwiXPj76FZ23dow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208446;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ms4aMTGJTONmDinv4GQ6hqMslscC8R+gtyGzOB803yU=;
	b=oaAqUb8tDn9x9wC24LojFGSrBWO7dRXxfdckLQluiJYoHNvb3j1u/bBv2Skj6/ltbkTy
	 c22flU9WrXNN+cKCY4VbtVCjIej4KSnbBUMA9iQxogure66fow7vfvivzth+VKN7wvPmq
	 gS8TEU3d5tWETNepWP5FfvlDS5hJxVqwRolQijrBCZigMIVQderB2FHbxW8ObUai9s2j+
	 6hWX7AqC2uIqGzUi4aRi/B9JKQo3c8vL8NMDCpoaF0VjHF2zvj5nkf3SQetbVVfCO8lvT
	 CeSC2BgXcKdQgr7rnIVB8benOgGRLh7fjczy6rSC3EU9NBh/of3hHFkf2FghlBAn8dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sEQ5Kyrk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF59606A31C;
	Wed, 28 Oct 2026 17:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sEQ5Kyrk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC831F01825;
	Wed, 28 Oct 2026 17:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208445;
	bh=Ms4aMTGJTONmDinv4GQ6hqMslscC8R+gtyGzOB803yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sEQ5KyrkipbIdf4aSzSeta8MMqYCYmUuajr+pojzUjx/ptMriDUvQ+5VgWYCFGnz/
	 8nXI70Da4t0tLr59UeQHwfW3Y4AqrSMtaH1hp9oRIi1a2zPybcXcBjxlckhJqx0TX4
	 q1YKCfXuYQwIknL3dbcNYrfJSAJdOLN9kihMR3X0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Jianzheng <wangjianzheng@vivo.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/516] pinctrl: sunxi: Use devm_clk_get_enabled() helpers
Date: Wed, 28 Oct 2026 17:54:34 +0100
Message-ID: <20261028170006.404724555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Jianzheng <wangjianzheng@vivo.com>

[ Upstream commit 7dc92ece32ed87a352e285e3d9f0d392b61443e2 ]

sunxi sunxi_pinctrl_init_with_variant get, enable clk and
deinit_device disable and unprepare it.

This simplifes the code and avoids the calls to
clk_disable_unprepare().

Signed-off-by: Wang Jianzheng <wangjianzheng@vivo.com>
Link: https://lore.kernel.org/20240829064737.16169-1-wangjianzheng@vivo.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: a13f7f5d14af ("pinctrl: sunxi: keep a shadow copy of the data register output latches")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunxi/pinctrl-sunxi.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index a39a97bd26884..1b419ebdc0110 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -1578,30 +1578,26 @@ int sunxi_pinctrl_init_with_variant(struct platform_device *pdev,
 	}
 
 	ret = of_clk_get_parent_count(node);
-	clk = devm_clk_get(&pdev->dev, ret == 1 ? NULL : "apb");
+	clk = devm_clk_get_enabled(&pdev->dev, ret == 1 ? NULL : "apb");
 	if (IS_ERR(clk)) {
 		ret = PTR_ERR(clk);
 		goto gpiochip_error;
 	}
 
-	ret = clk_prepare_enable(clk);
-	if (ret)
-		goto gpiochip_error;
-
 	pctl->irq = devm_kcalloc(&pdev->dev,
 				 pctl->desc->irq_banks,
 				 sizeof(*pctl->irq),
 				 GFP_KERNEL);
 	if (!pctl->irq) {
 		ret = -ENOMEM;
-		goto clk_error;
+		goto gpiochip_error;
 	}
 
 	for (i = 0; i < pctl->desc->irq_banks; i++) {
 		pctl->irq[i] = platform_get_irq(pdev, i);
 		if (pctl->irq[i] < 0) {
 			ret = pctl->irq[i];
-			goto clk_error;
+			goto gpiochip_error;
 		}
 	}
 
@@ -1612,7 +1608,7 @@ int sunxi_pinctrl_init_with_variant(struct platform_device *pdev,
 	if (!pctl->domain) {
 		dev_err(&pdev->dev, "Couldn't register IRQ domain\n");
 		ret = -ENOMEM;
-		goto clk_error;
+		goto gpiochip_error;
 	}
 
 	for (i = 0; i < (pctl->desc->irq_banks * IRQ_PER_BANK); i++) {
@@ -1644,8 +1640,6 @@ int sunxi_pinctrl_init_with_variant(struct platform_device *pdev,
 
 	return 0;
 
-clk_error:
-	clk_disable_unprepare(clk);
 gpiochip_error:
 	gpiochip_remove(pctl->chip);
 	return ret;
-- 
2.53.0



