Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BBF22FF4E;
	Mon, 10 Mar 2025 18:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630918; cv=none; b=J0uSsKkMxJIYFdjMZrLW3ayXeP7XvwyBZAZzBHmOFHNYiBwhqyPJh25rhg7ulECClHEKZrL743SyfeQkrjmkUQuoKEwM/NK044Uh2iB5ippELjK0cYzNsIC5Ec28Q6V/BVuq9xQDUqTHGQqWtfWY4Or97fWgiwVCap5s53TBFUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630918; c=relaxed/simple;
	bh=oqiqWduC2as5eC4UUQ7yyJaaYiL+lE/vgIRDiYthqQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjrcARdxVCCIc8ueMKPKuLlAlBP9bKJWKjuBxd1ctfLqvY+QPBq2/pQC/pHP9USVrufxyTYwuuEfVlmjM4VgjsZ2uCeG4bL5KwlGwDN2ywALNO8MkuELgse5Gv6+WRAOTNUPcBGgHNOD8VPAgaCPBLJ31e9Ce698XkdESEC4be8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vEyjN/++; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vEyjN/++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E228C4CEE5;
	Mon, 10 Mar 2025 18:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630918;
	bh=oqiqWduC2as5eC4UUQ7yyJaaYiL+lE/vgIRDiYthqQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vEyjN/++nGQD9vqB9QPM8R+O/wLOwEgHr58UixrCiA/gTK0uq/9+1zBEx+jicXYDe
	 T5wKXrQ+Jz7DSqIXoxrHq9t77s2gp6sMET5NLVHNtpHXh06N19uyx3KYan+b4eq6BA
	 IDYjFN6uqW8h0Tre5EL8uU/+msHw0WrxKAWq0JXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 579/620] gpio: rcar: Fix missing of_node_put() call
Date: Mon, 10 Mar 2025 18:07:05 +0100
Message-ID: <20250310170608.392896405@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabrizio Castro <fabrizio.castro.jz@renesas.com>

[ Upstream commit 391b41f983bf7ff853de44704d8e14e7cc648a9b ]

of_parse_phandle_with_fixed_args() requires its caller to
call into of_node_put() on the node pointer from the output
structure, but such a call is currently missing.

Call into of_node_put() to rectify that.

Fixes: 159f8a0209af ("gpio-rcar: Add DT support")
Signed-off-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20250305163753.34913-2-fabrizio.castro.jz@renesas.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-rcar.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-rcar.c b/drivers/gpio/gpio-rcar.c
index f4612a62fd96a..8e2acf3b022f7 100644
--- a/drivers/gpio/gpio-rcar.c
+++ b/drivers/gpio/gpio-rcar.c
@@ -452,7 +452,12 @@ static int gpio_rcar_parse_dt(struct gpio_rcar_priv *p, unsigned int *npins)
 	p->info = *info;
 
 	ret = of_parse_phandle_with_fixed_args(np, "gpio-ranges", 3, 0, &args);
-	*npins = ret == 0 ? args.args[2] : RCAR_MAX_GPIO_PER_BANK;
+	if (ret) {
+		*npins = RCAR_MAX_GPIO_PER_BANK;
+	} else {
+		*npins = args.args[2];
+		of_node_put(args.np);
+	}
 
 	if (*npins == 0 || *npins > RCAR_MAX_GPIO_PER_BANK) {
 		dev_warn(p->dev, "Invalid number of gpio lines %u, using %u\n",
-- 
2.39.5



