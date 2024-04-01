Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBCF63E;
	Mon,  1 Apr 2024 16:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989016; cv=none; b=fUxMrEGRNVBDOyWfNiVcfm8TnK0L0TQPSXC2u7efXIzwnYebfI3viv+Zhd6RUXpiNz0dhKTR8J35LFyFvtXL5upfx8ds75tjxW7ERdz8C6TBim7ReCcJs9EmzxvSX93v6Y33qlpo/27LjM+ZHdXhue49KkdnjeVXjavNDHrc2LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989016; c=relaxed/simple;
	bh=FbmaVD/vBaCq/+hvGlcMXfXA6fGMtF0pRktdI4p/e3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jIabYPfHqsI+iJOa7FCKqea0/tFvx81Fygw6rKfepzemChfVPZDXpQ243/+9MZJiEP3p5goe6DmZMVs8ZEHqnqLam8G4J/cezzajDpisahpvTmVe8R5rhv85aW6CpSyuO9AyayjWzyPdk4oA+5mV16hIkAe6BOKZrCHEbYDY2iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iukzWAWW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iukzWAWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF358C433C7;
	Mon,  1 Apr 2024 16:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989016;
	bh=FbmaVD/vBaCq/+hvGlcMXfXA6fGMtF0pRktdI4p/e3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iukzWAWWc9JE1MZqauTczApW4iJnonjMZWKdEfCUNguwEETyKYNK4lCVoQRysQcwz
	 Y4pSK0eUI7Vb6nhh5QH7qJ7ceCISH6ZYg35czklFh0Bc1r9l3bBaWkfSDjNXjQIy9w
	 vUsAw+zM25rrxw16wR53aX+/pBiLvMkqk5q7ZbdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zoltan HERPAI <wigyori@uid0.hu>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 318/432] pwm: img: fix pwm clock lookup
Date: Mon,  1 Apr 2024 17:45:05 +0200
Message-ID: <20240401152602.676733595@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 116fa060e3029..29dcf38f3b521 100644
--- a/drivers/pwm/pwm-img.c
+++ b/drivers/pwm/pwm-img.c
@@ -288,9 +288,9 @@ static int img_pwm_probe(struct platform_device *pdev)
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



