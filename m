Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9204EB38;
	Mon,  1 Apr 2024 16:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990340; cv=none; b=g0DCXxD5C+iVNFMKpvRA+eDBLd/1Gzd5hLsEedrAFKCXP8sfJsjdHyw2zxncflDVx9FfGGSmjrCdQrqH02RnZU2oUxcAimd/hyUOLCulDQmEX14I4Lrw2dCWT4Oyf9NFoYf9rjp48WFq1ff3/VVNhHdpNojfmahLt322X+W1+KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990340; c=relaxed/simple;
	bh=xllGLTVNE+r9wYGRJVcF7Jug70InlXnI/j0pQAuQ/jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sxz6rC+RfmplCZECmTwtR6+qr7uJY5ltj1gFH3XGyMgNqW9sD+lfB4ZdlYyUfZE6sDCLBTveJ01Ge71+K1GZuB34y66k+KTfR9RPAB59eIebzoVQ4lLbjyoObSMYwuRocI0U3ASWWWQ1hcie5mZX0lLU9YuxyPrVh1GI8DNHnV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/Bo9v4d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/Bo9v4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E364C433C7;
	Mon,  1 Apr 2024 16:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990340;
	bh=xllGLTVNE+r9wYGRJVcF7Jug70InlXnI/j0pQAuQ/jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/Bo9v4diXW4AAcmINvoYA+Hek3tLglH2hSZoTYNudsH7jHOeq+Nk1XCgCVrsOUkR
	 DkYB51yNwxN3PHCWEhsqjknTtjNoNMtomF36x3IZcW0nRYRPjPldZkeM7J6sSDUQ6i
	 B9f24Cqr1fjyBzI1WQcWHsj3UfR750WpAHflQwYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zoltan HERPAI <wigyori@uid0.hu>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 304/396] pwm: img: fix pwm clock lookup
Date: Mon,  1 Apr 2024 17:45:53 +0200
Message-ID: <20240401152556.979725447@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Zoltan HERPAI <wigyori@uid0.hu>

[ Upstream commit 9eb05877dbee03064d3d3483cd6702f610d5a358 ]

22e8e19 has introduced a regression in the imgchip->pwm_clk lookup, whereas
the clock name has also been renamed to "imgchip". This causes the driver
failing to load:

[    0.546905] img-pwm 18101300.pwm: failed to get imgchip clock
[    0.553418] img-pwm: probe of 18101300.pwm failed with error -2

Fix this lookup by reverting the clock name back to "pwm".

Signed-off-by: Zoltan HERPAI <wigyori@uid0.hu>
Link: https://lore.kernel.org/r/20240320083602.81592-1-wigyori@uid0.hu
Fixes: 22e8e19a46f7 ("pwm: img: Rename variable pointing to driver private data")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-img.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-img.c b/drivers/pwm/pwm-img.c
index 326af85888e7b..fd1535c47b6db 100644
--- a/drivers/pwm/pwm-img.c
+++ b/drivers/pwm/pwm-img.c
@@ -289,9 +289,9 @@ static int img_pwm_probe(struct platform_device *pdev)
 		return PTR_ERR(imgchip->sys_clk);
 	}
 
-	imgchip->pwm_clk = devm_clk_get(&pdev->dev, "imgchip");
+	imgchip->pwm_clk = devm_clk_get(&pdev->dev, "pwm");
 	if (IS_ERR(imgchip->pwm_clk)) {
-		dev_err(&pdev->dev, "failed to get imgchip clock\n");
+		dev_err(&pdev->dev, "failed to get pwm clock\n");
 		return PTR_ERR(imgchip->pwm_clk);
 	}
 
-- 
2.43.0



