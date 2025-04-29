Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35222528ED;
	Tue, 29 Apr 2025 17:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949263; cv=none; b=i/PWVbzl9CcN34AYwREvfJkhVNuBuTdvo2hRqjHVaV5JcI9CcPwhlV36/pS1F/reE/yaBwq86GZa8tkqVSAawn9JsWw9CHAlriYU5snACMPennPiF9PiRZQ5q6VI/Rz2NbdxvDNdg/+KxF/D3mh037dD7boaVZbJo7mhGsMN/sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949263; c=relaxed/simple;
	bh=Sb6FUcSB6uMYVz+O1p94Zd1lceY/lJCl/3Dgw/p63Mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mja6bufRJ33V3o0BAKeye1WOkcmnWyRAMqsUeZCARtAzeBQbEn7xrxRw4hxwGkiTxXoOLmbuKCAhblbPppsdW6N84f2rnxkJVRB1iJQVPFpZx6hrJhCImAJIFR50DdZVStr5hEvprRuzRjM+qfRl8B97bLDKC/wZ+MkIeATC2TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1sNUj5W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1sNUj5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522F7C4CEE3;
	Tue, 29 Apr 2025 17:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949262;
	bh=Sb6FUcSB6uMYVz+O1p94Zd1lceY/lJCl/3Dgw/p63Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1sNUj5WQ0aivCT0tVZt4QYHH+ED9s5YFMiwB0+j7f+DW+mfavXVZw4EiQarvQKh8
	 v7xeli8Y6xM3XozMQLvDbagzKrWaj4u2SjeIX+Zlp9en8sTk5jvlJHYw+vm50XKt0p
	 Qjy4tPGI2IHLWZabY3FDZiWckvap3jSZPv47ViZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
	Sylwester Nawrocki <snawrocki@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 263/373] soc: samsung: exynos-chipid: avoid soc_device_to_device()
Date: Tue, 29 Apr 2025 18:42:20 +0200
Message-ID: <20250429161133.938560620@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit d1141886c8d72ad77920e6e4b617d366e6e3ee8a ]

soc_device_to_device() seems to be discouraged [1] so remove it in favor
of printing info message with platform device.  This will only change
the prefix in the info message from "soc soc0: " to "exynos-chipid
10000000.chipid:".

[1] https://lore.kernel.org/lkml/20191111052741.GB3176397@kroah.com/

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Sylwester Nawrocki <snawrocki@kernel.org>
Tested-by: Sylwester Nawrocki <snawrocki@kernel.org>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Tested-by: Alim Akhtar <alim.akhtar@samsung.com>
Link: https://lore.kernel.org/r/20210919093114.35987-2-krzysztof.kozlowski@canonical.com
Stable-dep-of: c8222ef6cf29 ("soc: samsung: exynos-chipid: Add NULL pointer check in exynos_chipid_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/samsung/exynos-chipid.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/soc/samsung/exynos-chipid.c b/drivers/soc/samsung/exynos-chipid.c
index 5c1d0f97f7664..dcd9a08ce7065 100644
--- a/drivers/soc/samsung/exynos-chipid.c
+++ b/drivers/soc/samsung/exynos-chipid.c
@@ -104,8 +104,7 @@ static int exynos_chipid_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, soc_dev);
 
-	dev_info(soc_device_to_device(soc_dev),
-		 "Exynos: CPU[%s] PRO_ID[0x%x] REV[0x%x] Detected\n",
+	dev_info(&pdev->dev, "Exynos: CPU[%s] PRO_ID[0x%x] REV[0x%x] Detected\n",
 		 soc_dev_attr->soc_id, product_id, revision);
 
 	return 0;
-- 
2.39.5



