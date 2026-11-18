Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030456;
	b=08H7f4vjPMbVX49mm19wImeZamLd5xZMqzDM1n9sTQlXBGTTo+O4nwIQdjljpghBLncp
	 mujBYib2QczqGbuoB8Zj18M/7ufAN8Yh7gu4ZH7D9kMbvntYodDG/1AB29tJsXEZfMAwu
	 35YgBZhk3efOoW2Yu30jnyXrqvEJQEKGcrOpmX0XqiY1HN6TrLGHZyKo0x89DW2/N2zhR
	 Y+hhmpaUvCfyYpdySrG8b5Yf5oKG0xsLUf0eOsF8N6diyGzZRGxOCIuF0JGpJKYvVzTUu
	 57MGpCH9weZPKTAF7l8OAu2Hsv/9GBemVeCnaJ0BtHjVEMcSOkYnil4JOiliSA4cL7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030456;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sTDQkFC1BDg+jFjQz4LLtAFTytMmYs8jdHyb3hkQJw0=;
	b=DrT4DkO1D7t5ZeP4gdVPxwl+yLS1Gc58EQ1xAxZtKP1tQ64MzK6LCxXkuDp9Cz6BDhbN
	 6r6/Om9svdB7G4Pk1AIQpK30AfwZPZHtdiA4EmJDMItSAcAWOKpMqPBjG+RUfM/vNzU7z
	 4xgGWf0be1IW5LWzu/5WQjvGOlfQCPoDukMALf0q8hqiLnR4jt5Egg08onSNavOt3sIeW
	 Ya4AzowZA56WhfnXV3RRD1FvE4CWNsrtAtnWgTwLAVV6UmWUzHWqERZNLLCjJqg2Gglda
	 PedKHEVFdUzR98lciwLh57AwRwSotW6FcrGkzY+xjd4SrZ3Z7zU20Yfqn+AoTtqOqxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jsGt4i/m";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8472606A7FA;
	Wed, 18 Nov 2026 19:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jsGt4i/m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299091F000C4;
	Wed, 18 Nov 2026 19:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030456;
	bh=sTDQkFC1BDg+jFjQz4LLtAFTytMmYs8jdHyb3hkQJw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jsGt4i/mBnyyLYtYZgoRvTljrzTnzsLC9qwZBOXVpXjmfX/RyvEI4hMHQkt5n2s0v
	 x36/VpsOUexfeH9cZQZRl00F7V01A2ZaEjBKJSYBwwdyjTJG4YpI4mg7daSdmflMgm
	 IysH9z07h+b3VREu2YNNtKbOSxUrb+4CwTJd+CVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0711/1756] pinctrl: stm32: Fix clock reference leak in stm32_pctl_probe()
Date: Wed, 18 Nov 2026 15:47:18 +0100
Message-ID: <20261118150037.685006071@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit dfd8259507c53a3c7eb0dd11c1152c88e12aa316 ]

stm32_pctl_probe() obtains one clock per bank with
of_clk_get_by_name(), but none of the error paths drop those
references: the loop returns directly when a later clock lookup fails,
and both the clk_bulk_prepare_enable() failure and the err_register
path return without calling clk_bulk_put().  clk_bulk_disable_unprepare()
only disables the clocks, it does not release them.

Release the references on these paths; the success path keeps them as
the driver needs them for suspend/resume.

Fixes: 451bc9aea9a1 ("pinctrl: stm32: Add check for clk_enable()")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index 2219f31d14935..9e8b8b82c232b 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1631,6 +1631,7 @@ int stm32_pctl_probe(struct platform_device *pdev)
 		pctl->clks[i].clk = of_clk_get_by_name(np, NULL);
 		if (IS_ERR(pctl->clks[i].clk)) {
 			fwnode_handle_put(child);
+			clk_bulk_put(i, pctl->clks);
 			return dev_err_probe(dev, PTR_ERR(pctl->clks[i].clk),
 					     "failed to get clk\n");
 		}
@@ -1641,6 +1642,7 @@ int stm32_pctl_probe(struct platform_device *pdev)
 	ret = clk_bulk_prepare_enable(banks, pctl->clks);
 	if (ret) {
 		dev_err(dev, "failed to prepare_enable clk (%d)\n", ret);
+		clk_bulk_put(banks, pctl->clks);
 		return ret;
 	}
 
@@ -1665,6 +1667,7 @@ int stm32_pctl_probe(struct platform_device *pdev)
 	}
 
 	clk_bulk_disable_unprepare(banks, pctl->clks);
+	clk_bulk_put(banks, pctl->clks);
 	return ret;
 }
 EXPORT_SYMBOL(stm32_pctl_probe);
-- 
2.53.0



