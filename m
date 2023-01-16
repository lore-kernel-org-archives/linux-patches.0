Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DF56FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE73C433EF;
	Mon, 16 Jan 2023 16:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887008;
	bh=aRgzOab1q0uZC5w5aX+WGocSRGgAkOrzCYkdW2BFEy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w1dZHsILzAEcIkwDqaCtcX4gYJCEEEzRPp5i/7Ea/1BOKhhzbRbHxDv2Js8Ept2Fx
	 zLtE1YmxbH/BOIW+pNbXjH7PviNmyZNeqJ8+w5AcREsUqHQThw5mfKd9qSzX+1YTWR
	 H2RKyyN7V8LE1ASCh+diT1BNPdc7VQVPeaZatcY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <michael@walle.cc>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 615/658] wifi: wilc1000: sdio: fix module autoloading
Date: Mon, 16 Jan 2023 16:51:43 +0100
Message-Id: <20230116154937.639195062@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Walle <michael@walle.cc>

[ Upstream commit 57d545b5a3d6ce3a8fb6b093f02bfcbb908973f3 ]

There are no SDIO module aliases included in the driver, therefore,
module autoloading isn't working. Add the proper MODULE_DEVICE_TABLE().

Cc: stable@vger.kernel.org
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221027171221.491937-1-michael@walle.cc
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wilc1000/wilc_sdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index c787c5da8f2b..22a30da011e1 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -20,6 +20,7 @@ static const struct sdio_device_id wilc_sdio_ids[] = {
 	{ SDIO_DEVICE(SDIO_VENDOR_ID_WILC, SDIO_DEVICE_ID_WILC) },
 	{ },
 };
+MODULE_DEVICE_TABLE(sdio, wilc_sdio_ids);
 
 #define WILC_SDIO_BLOCK_SIZE 512
 
-- 
2.35.1



