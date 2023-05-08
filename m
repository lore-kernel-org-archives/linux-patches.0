Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1685168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4F1C433D2;
	Mon,  8 May 2023 10:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540655;
	bh=9n4jKf10Y/FkCI3sXlyrVqlIyqulhjmDrYqmY0qXMnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lpg0xkRNYqSb20SeteN5I55l82RPI59+VoS3r1jKKUnQUdmbklyBR8oggt1zIse7n
	 wj22CrSNurIkn38R8C4f/whp3Rd17cJwIe7+//kAzWSnbqKj8252KVqwJYXDdRsQiE
	 nIzVZNrmxcL8pUn8+wPfAJ7aJFpD3XytZ8SUUaJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Peter Chen <peter.chen@kernel.org>,
	Yinhao Hu <dddddd@hust.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 446/611] usb: chipidea: fix missing goto in `ci_hdrc_probe`
Date: Mon,  8 May 2023 11:44:48 +0200
Message-Id: <20230508094436.648899062@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
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
index 5abdc2b0f506d..71f172ecfaabc 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -1101,7 +1101,7 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 	ret = ci_usb_phy_init(ci);
 	if (ret) {
 		dev_err(dev, "unable to init phy: %d\n", ret);
-		return ret;
+		goto ulpi_exit;
 	}
 
 	ci->hw_bank.phys = res->start;
-- 
2.39.2



