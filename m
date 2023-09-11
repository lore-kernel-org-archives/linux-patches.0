Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F9E11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7FFC433C7;
	Mon, 11 Sep 2023 15:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444588;
	bh=jsicp2xLiIYNz1hjPyZh8kBuqGB8NWej4WAulKB8Yak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n3T3qqPOfxCQP0+D0MAxu/8co4eYzx0LHXsmva8Tz8qja3UyORK259X19h5SWvT2B
	 Uis6vfod/dtuE4QqATi93ObGzGcGPvuYg1I/K2rtKufvszuq7jXQ+C6U+bfvVB0g1R
	 2WRXPYFUXIK9cZxnH7jk/3yXMILbN7ymexznk9tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Gallais-Pou <rgallaispou@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/600] staging: fbtft: ili9341: use macro FBTFT_REGISTER_SPI_DRIVER
Date: Mon, 11 Sep 2023 15:41:18 +0200
Message-ID: <20230911134634.925989646@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raphael Gallais-Pou <rgallaispou@gmail.com>

[ Upstream commit 4912649e1cf0317bf563f91655e04a303cacaf8d ]

Using FBTFT_REGISTER_DRIVER resolves to a NULL struct spi_device_id. This
ultimately causes a warning when the module probes. Fixes it.

Signed-off-by: Raphael Gallais-Pou <rgallaispou@gmail.com>
Link: https://lore.kernel.org/r/20230718172024.67488-1-rgallaispou@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/fbtft/fb_ili9341.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/fbtft/fb_ili9341.c b/drivers/staging/fbtft/fb_ili9341.c
index 9ccd0823c3ab3..47e72b87d76d9 100644
--- a/drivers/staging/fbtft/fb_ili9341.c
+++ b/drivers/staging/fbtft/fb_ili9341.c
@@ -145,7 +145,7 @@ static struct fbtft_display display = {
 	},
 };
 
-FBTFT_REGISTER_DRIVER(DRVNAME, "ilitek,ili9341", &display);
+FBTFT_REGISTER_SPI_DRIVER(DRVNAME, "ilitek", "ili9341", &display);
 
 MODULE_ALIAS("spi:" DRVNAME);
 MODULE_ALIAS("platform:" DRVNAME);
-- 
2.40.1



