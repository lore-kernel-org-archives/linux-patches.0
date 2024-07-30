Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE353189514;
	Tue, 30 Jul 2024 16:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358338; cv=none; b=ZfZFBfmB3+BciBfdsPRIJIlPEu65Y4SVt8dyuJLWkCY80LZXXmdHXGRie5wdDAXXrGJdHcA0IPURQ34iSVhx2cAhUWE29x2EX5f/3sLJHCsik1bj+HsXYsYergXO7nZHBNskMlzyvWg/NtefW7mQg7j18gbZhOxRUXI5VrkQcSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358338; c=relaxed/simple;
	bh=Z32c/Cl92NMfBVH38XawzHBGIo5egG8KvidWbcl4M2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NbpLXyiM8dv3LF7iSpffvuQYbFF8l928cc8bFN8lyKsy2pwpupdwe1Fr28s8lv3yBIBjv1Xv8DYzjz8lH4UhTBgUg8ncDXux09si9h8D9Rd0lo9IzOdE39QCyWXIqSxaZPAugO+elkAtBaVVqIsWdsKLNaJrAlLih90So0TGp3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/Sv4fGw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/Sv4fGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4701DC32782;
	Tue, 30 Jul 2024 16:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358338;
	bh=Z32c/Cl92NMfBVH38XawzHBGIo5egG8KvidWbcl4M2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w/Sv4fGwYMBk6XlIXzQ5FnRdgRchg0qLNp09lDj4qzYKsPG3daBkIqmfqu5wfIcG8
	 io+3qVQbDVLygxQjFpDWPfRMcbiMVEAuvc5D1csto106PEO06cGS+o11U2T7L3idd1
	 pUptn8eXw+z8IcTUWsK7dNZWikzO026IUlrrVayA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 328/568] pinctrl: ti: ti-iodelay: Drop if block with always false condition
Date: Tue, 30 Jul 2024 17:47:15 +0200
Message-ID: <20240730151652.693362152@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 88b3f108502bc45e6ebd005702add46759f3f45a ]

ti_iodelay_remove() is only called after ti_iodelay_probe() completed
successfully. In this case platform_set_drvdata() was called with a
non-NULL argument and so platform_get_drvdata() won't return NULL.

Simplify by removing the if block with the always false condition.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20231009083856.222030-4-u.kleine-koenig@pengutronix.de
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: 9b401f4a7170 ("pinctrl: ti: ti-iodelay: fix possible memory leak when pinctrl_enable() fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/ti/pinctrl-ti-iodelay.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/pinctrl/ti/pinctrl-ti-iodelay.c b/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
index c1477f6578393..f3a2735620955 100644
--- a/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
+++ b/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
@@ -903,9 +903,6 @@ static int ti_iodelay_remove(struct platform_device *pdev)
 {
 	struct ti_iodelay_device *iod = platform_get_drvdata(pdev);
 
-	if (!iod)
-		return 0;
-
 	if (iod->pctl)
 		pinctrl_unregister(iod->pctl);
 
-- 
2.43.0



