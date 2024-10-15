Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564D21E766C;
	Tue, 15 Oct 2024 11:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992875; cv=none; b=ATGfY9lCA9gyoFcHyhEKjittrUVlYxqCy/jGTkOoBdnRAjrg9EInxGodh+/lvHJvISwIICqLNIqZq3miYJ0Wfu8ow9tUkK/ljntaJaZbEca79v9urnjc8RaAcA4MAHo0Km9VqSEl7Hf1iGTx8ocHQFscl1WmrwsHxF/TlBbGaQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992875; c=relaxed/simple;
	bh=LpvnGxP1OgKlRHWeMU47n6YIXdNOlVeGCet8676aegI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/gwF9pkLKiNEKUdxhBLzg8IGvZYznHlW4ea97wWgrCZRCIspeFDKTu5y4SXVIo39FidGcBoyWV7FO8aCGTYrFUNrfn0KnaoqELPDcDkrGgujXHXnKOnTPk9ond9nbnMr609QFViXDo4SUhmd7ZY3E8I0WlnyP0IJBMAo7hGtK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYJjuZbX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYJjuZbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ECC7C4CEC6;
	Tue, 15 Oct 2024 11:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992874;
	bh=LpvnGxP1OgKlRHWeMU47n6YIXdNOlVeGCet8676aegI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KYJjuZbXtLz54X8fhbM/FPeyxed8AcLXNgqPVbfr+vmwjUrHNVmQpOjTL9ODqyCtz
	 xzav0nxem6vQPmtpYmtCdETvAZLbMmX9hmYPCVIj7e5y7sG4VQy0UcXjtxfY8l2M7d
	 K0bYP4Pj3260XjtvNzDlxP+VKR+b6tN6SWKv8bHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 243/691] pinctrl: mvebu: Use devm_platform_get_and_ioremap_resource()
Date: Tue, 15 Oct 2024 13:23:11 +0200
Message-ID: <20241015112450.000618915@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit 2d357f25663ddfef47ffe26da21155302153d168 ]

Convert platform_get_resource(), devm_ioremap_resource() to a single
call to devm_platform_get_and_ioremap_resource(), as this is exactly
what this function does.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
Link: https://lore.kernel.org/r/20230704124742.9596-2-frank.li@vivo.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: c25478419f6f ("pinctrl: mvebu: Fix devinit_dove_pinctrl_probe function")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mvebu/pinctrl-dove.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index 545486d98532d..bd74daa9ed666 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -784,8 +784,7 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
 	}
 	clk_prepare_enable(clk);
 
-	mpp_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	base = devm_ioremap_resource(&pdev->dev, mpp_res);
+	base = devm_platform_get_and_ioremap_resource(pdev, 0, &mpp_res);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
-- 
2.43.0



