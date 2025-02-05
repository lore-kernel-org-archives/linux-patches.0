Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960771519AA;
	Wed,  5 Feb 2025 14:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764589; cv=none; b=K6GV8Fpkz3UeAT2acdl6DmJcn/Vz4Ty0MDEpC4iGcZyghgDtfaSDf5VL3h0hi3fUgeFanr+uKMHPAkGSs5MQLUbp32SchYKxBNGWvwWOl2XD1a5lGsTpvFLcwo8eBwK/phNd1n2XpHfviSzeCXz1Mh1WWnCRrUusGY9+dNgsnpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764589; c=relaxed/simple;
	bh=TVR2RvAQpDacSLHBfOTIQtEsZROARLa7sNC1X7z8NK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BccLg6Ge5s3/Jg7ock1cUlV8jdEWmEZmZnz0v5ot5t8v+05OfFHyUR3/vfRDmmJQQ4HIYKnmO80o5tQMP3juKRSF3iH9XBLsPxod6+ZtOa2WA11mh6foRgc2kUFHTP5slVoOguzfGdYVZ5Jye81O4eJwP8wPnRSBfkX6MFD7LUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1KCEaz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1KCEaz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3C3C4CED1;
	Wed,  5 Feb 2025 14:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764589;
	bh=TVR2RvAQpDacSLHBfOTIQtEsZROARLa7sNC1X7z8NK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E1KCEaz8XKm7eEz5OfuGCpmMchtlhthPgaEUgF8e267COQMReReuJPtDTf1aOaKY/
	 HhOYpU/WYqWb6JxxEGQaXxLk5p1wImFWkfDGSakbkf2iPQViRwqMiPM24D4dkduXR2
	 Q0+nqRnXY/hWounJGhDGttAgfY+bdImzITjRLwQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Duje=20Mihanovi=C4=87?= <duje.mihanovic@skole.hr>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 093/623] clk: mmp: pxa1908-mpmu: Fix a NULL vs IS_ERR() check
Date: Wed,  5 Feb 2025 14:37:15 +0100
Message-ID: <20250205134459.783939589@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 7def56f841af22e07977e193eea002e085facbdb ]

The devm_kzalloc() function returns NULL on error, not error pointers.
Update the check to match.

Fixes: ebac87cdd230 ("clk: mmp: Add Marvell PXA1908 MPMU driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/5b3b963d-ecae-4819-be47-d82e8a58e64b@stanley.mountain
Acked-by: Duje Mihanović <duje.mihanovic@skole.hr>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mmp/clk-pxa1908-mpmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/mmp/clk-pxa1908-mpmu.c b/drivers/clk/mmp/clk-pxa1908-mpmu.c
index e3337bacaadd5..90b4b24885740 100644
--- a/drivers/clk/mmp/clk-pxa1908-mpmu.c
+++ b/drivers/clk/mmp/clk-pxa1908-mpmu.c
@@ -78,8 +78,8 @@ static int pxa1908_mpmu_probe(struct platform_device *pdev)
 	struct pxa1908_clk_unit *pxa_unit;
 
 	pxa_unit = devm_kzalloc(&pdev->dev, sizeof(*pxa_unit), GFP_KERNEL);
-	if (IS_ERR(pxa_unit))
-		return PTR_ERR(pxa_unit);
+	if (!pxa_unit)
+		return -ENOMEM;
 
 	pxa_unit->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(pxa_unit->base))
-- 
2.39.5



