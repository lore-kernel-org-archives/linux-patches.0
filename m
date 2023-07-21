Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D78F200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:03:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FD0C433C8;
	Fri, 21 Jul 2023 19:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966219;
	bh=1gZFA9DdLZ3aZ2wq+M3Q8smd9iXKg2hPq0Mx9fP6+S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MD6hAljEeQxtKlCG4H/aEvtNmG0vL3pNrvLjRwHfX6arUPVJR+eEPIS3r4P/Pjx2+
	 vX+KtmAbUny4Ta4RQIQi+Y4iYsFkYbXUDpgIbJ9/Exb4eDRcjIYb/kbtV/RgoUqrV3
	 abn5H6lTTsb98FGBtVuBx8/5KeuxzrP8jOPKZwec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Minas Harutyunyan <hminas@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 267/532] usb: dwc2: platform: Improve error reporting for problems during .remove()
Date: Fri, 21 Jul 2023 18:02:51 +0200
Message-ID: <20230721160628.828821079@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 55f223b8b408cbfd85fb1c5b74ab85ccab319a69 ]

Returning an error value in a platform driver's remove callback results in
a generic error message being emitted by the driver core, but otherwise it
doesn't make a difference. The device goes away anyhow.

For each case where ret is non-zero the driver already emits an error
message, so suppress the generic error message by returning zero
unconditionally. (Side note: The return value handling was unreliable
anyhow as the value returned by dwc2_exit_hibernation() was overwritten
anyhow if hsotg->in_ppd was non-zero.)

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Minas Harutyunyan <hminas@synopsys.com>
Link: https://lore.kernel.org/r/20221017195914.1426297-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: ada050c69108 ("usb: dwc2: Fix some error handling paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index 7a09476e9f193..ad8c7de4bfb19 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -355,7 +355,7 @@ static int dwc2_driver_remove(struct platform_device *dev)
 	reset_control_assert(hsotg->reset);
 	reset_control_assert(hsotg->reset_ecc);
 
-	return ret;
+	return 0;
 }
 
 /**
-- 
2.39.2



