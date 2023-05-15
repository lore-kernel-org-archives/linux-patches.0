Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840B7D512
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC04AC433D2;
	Mon, 15 May 2023 16:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168448;
	bh=GqFo9zUm+IkOg/d4nmQ/O8FqWR98C2a3H60WGiwVJ7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+/x6cy3xOFkEeYC2t0/1xKrY78JcHBDXJ9zG5JhOAoUuxe1zmeANHUwB12CvDe1Z
	 O0GeA6YiUxYBuk9J26hKWEbrWBqC0cDPonJXfVK0ddAxsGOEyhzMMkZkYMzMoNjuzg
	 vY9aO+B/Kg+uTb6c0YL0F48n0uPiHojfqRCw4El8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Peter Chen <peter.chen@kernel.org>,
	Yinhao Hu <dddddd@hust.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 052/116] usb: chipidea: fix missing goto in `ci_hdrc_probe`
Date: Mon, 15 May 2023 18:25:49 +0200
Message-Id: <20230515161659.993557103@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161658.228491273@linuxfoundation.org>
References: <20230515161658.228491273@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yinhao Hu <dddddd@hust.edu.cn>

[ Upstream commit d6f712f53b79f5017cdcefafb7a5aea9ec52da5d ]

>From the comment of ci_usb_phy_init, it returns an error code if
usb_phy_init has failed, and it should do some clean up, not just
return directly.

Fix this by goto the error handling.

Fixes: 74475ede784d ("usb: chipidea: move PHY operation to core")
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Acked-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Yinhao Hu <dddddd@hust.edu.cn>
Link: https://lore.kernel.org/r/20230412055852.971991-1-dddddd@hust.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index 48fbb6302e60e..4cacb91c47291 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -987,7 +987,7 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 	ret = ci_usb_phy_init(ci);
 	if (ret) {
 		dev_err(dev, "unable to init phy: %d\n", ret);
-		return ret;
+		goto ulpi_exit;
 	}
 
 	ci->hw_bank.phys = res->start;
-- 
2.39.2



