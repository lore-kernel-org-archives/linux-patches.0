Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680DB3E123F;
	Wed, 20 May 2026 17:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298723; cv=none; b=Rl8wI0WWDmif+caSla4mGa9tH2gwYncUEcB68xI/KIjE+0/ud069NsTxr0pz46OFNw5Oaoznkb/jHRF0e5X+ugS44ktveq2lymQ9ZzbJ/Av8CCATgUcNsozooNi1OzZtlMHiRZhifTCGNU3+hs3LlRdtKDtKBXBEKzxQF7VzweM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298723; c=relaxed/simple;
	bh=eoYs07JkXSwwm+qStZ+rLD9rImxpKEqLOOYPSeBkZ2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rn141mLE6lx1wPhQ8ztfoy7N4JMf6Bf8YhSNFI1RNW4gb1wZXudhht5vdYAB1xHKX/VFe4Her7IWC2OubWQWEH+mRAFc8Q55O926am9uqq2231WPo4N+T91X/g2ZkGtlmxsjm3+6hLIeUggFTlnsbZeQThgyki1RO6SdBHjCzms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GfMbzSL3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GfMbzSL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0021F000E9;
	Wed, 20 May 2026 17:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298722;
	bh=OG6ZNtWVk/3Ze1g5/6nRT3tTGNRRuJvwaDv77zzemzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GfMbzSL3DLTlkph6hHHV7oSEEu3Nsl2KLOP2zrJyPYYNVsvUbpJnGkjt5iIKkq9Pz
	 aj+gvOP+H2bRE5VGH+K5lU2+v4YbV1OKG2n0TPfGxNrNYRQPtnpv48FHKj/0oOf3YM
	 7kJ/vufYXY7GuJFnTqEp7n5m1AXkIGjo1HIItQxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inochi Amaoto <inochiama@gmail.com>,
	Chen Wang <unicorn_wang@outlook.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 518/957] pinctrl: sophgo: pinctrl-sg2042: Fix wrong module description
Date: Wed, 20 May 2026 18:16:41 +0200
Message-ID: <20260520162145.767304617@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Inochi Amaoto <inochiama@gmail.com>

[ Upstream commit ca1c2ddff00480c213903a1479b56203536e92de ]

Fix the SoC model in module description string, it should be
sg2042 instead of sg2002.

Fixes: 1e67465d3b74 ("pinctrl: sophgo: add support for SG2042 SoC")
Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
Reviewed-by: Chen Wang <unicorn_wang@outlook.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sophgo/pinctrl-sg2042.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sophgo/pinctrl-sg2042.c b/drivers/pinctrl/sophgo/pinctrl-sg2042.c
index 185305ac897d9..8dba12e122a45 100644
--- a/drivers/pinctrl/sophgo/pinctrl-sg2042.c
+++ b/drivers/pinctrl/sophgo/pinctrl-sg2042.c
@@ -651,5 +651,5 @@ static struct platform_driver sg2042_pinctrl_driver = {
 };
 module_platform_driver(sg2042_pinctrl_driver);
 
-MODULE_DESCRIPTION("Pinctrl driver for the SG2002 series SoC");
+MODULE_DESCRIPTION("Pinctrl driver for the SG2042 series SoC");
 MODULE_LICENSE("GPL");
-- 
2.53.0



