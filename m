Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AADB15E8B;
	Mon, 30 Dec 2024 15:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573835; cv=none; b=rwMUbyKDS7VqntqbBTUbRjrp2BBK+6Ioy/7tVfJVkFJ7xYVrAW23yuszo+UdwrZODBh3aLlmvzPrcCZbJTeAVSanm6Q7JD0wJEo1VTr/growbSZbStO2sKXJOVfOu2PB4A+EhuGsztEGSmwVOhWzqn3iIUhMmPs7FxTA3TgEUFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573835; c=relaxed/simple;
	bh=qX5sBQjXGeX+EA/z7FXhCLcRm98zC9vWVhyvOolplw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCnZIpK3xRwAOSYRTvXXbvb4241P2QL5rrxCG2/2PFAVe1I3eY1UEQUoAQQn0YMZtM3GBP74LtaKu0zLKGUrosP8FhYigKNrPwqFuNzPecrSFkZg+fn/JYyM15YNyu6f0WVlae0YOHg2rXJasvIFzP3PY/2oYaLsyq7p4Ldar1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=myoeJ1gq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="myoeJ1gq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0B4C4CED0;
	Mon, 30 Dec 2024 15:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573835;
	bh=qX5sBQjXGeX+EA/z7FXhCLcRm98zC9vWVhyvOolplw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=myoeJ1gqMz4PuvDq627/8lZJgn1bQcgjOwh+zPZUOlgnoXFQUfAReQerrSQNXXxqd
	 c+w88pRF6wnrckWlbNF0+IUUDdclBqRUph3CHa7UUQYvbSXVQ3LaXU6buA0+HHJJp4
	 lX2sp/pF/ALu4+UOHLiE0Gd6wzYFy6Fm6XeGWFF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Purushothama Siddaiah <psiddaiah@mvista.com>,
	Corey Minyard <cminyard@mvista.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 47/86] spi: omap2-mcspi: Fix the IS_ERR() bug for devm_clk_get_optional_enabled()
Date: Mon, 30 Dec 2024 16:42:55 +0100
Message-ID: <20241230154213.501976595@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Purushothama Siddaiah <psiddaiah@mvista.com>

[ Upstream commit 4c6ac5446d060f0bf435ccc8bc3aa7b7b5f718ad ]

The devm_clk_get_optional_enabled() function returns error
pointers(PTR_ERR()). So use IS_ERR() to check it.

Verified on K3-J7200 EVM board, without clock node mentioned
in the device tree.

Signed-off-by: Purushothama Siddaiah <psiddaiah@mvista.com>
Reviewed-by: Corey Minyard <cminyard@mvista.com>
Link: https://patch.msgid.link/20241205070426.1861048-1-psiddaiah@mvista.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-omap2-mcspi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index ddf1c684bcc7..3cfd262c1abc 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1521,10 +1521,10 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
 	}
 
 	mcspi->ref_clk = devm_clk_get_optional_enabled(&pdev->dev, NULL);
-	if (mcspi->ref_clk)
-		mcspi->ref_clk_hz = clk_get_rate(mcspi->ref_clk);
-	else
+	if (IS_ERR(mcspi->ref_clk))
 		mcspi->ref_clk_hz = OMAP2_MCSPI_MAX_FREQ;
+	else
+		mcspi->ref_clk_hz = clk_get_rate(mcspi->ref_clk);
 	ctlr->max_speed_hz = mcspi->ref_clk_hz;
 	ctlr->min_speed_hz = mcspi->ref_clk_hz >> 15;
 
-- 
2.39.5



