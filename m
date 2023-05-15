Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0BEFBF6
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:46:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD94C433D2;
	Mon, 15 May 2023 17:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172802;
	bh=L7JbHZYtEIk3eI+2jU5fBBEyPDFe1yx28TA0eVJ3giM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DbrDze1t1cyGFaG3L6J375Iq7ZwqbhIoktL4yKsr+gxAPOCS1nzjGiRWi/xVqnyed
	 auq5aLiMS4uhFrWgHAWnwu1fi0RUOPmKjswUWDByNc0aSnfuzh2/nAeIU7xi/DTo3o
	 tXceypIWT9QwIouna+VEZa3jlSWqn2xgIkku6wSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 254/381] input: raspberrypi-ts: Release firmware handle when not needed
Date: Mon, 15 May 2023 18:28:25 +0200
Message-Id: <20230515161748.190696500@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

[ Upstream commit 3b8ddff780b7d12e99ae39177f84b9003097777a ]

There is no use for the firmware interface after getting the touch
buffer address, so release it.

Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Stable-dep-of: 5bca3688bdbc ("Input: raspberrypi-ts - fix refcount leak in rpi_ts_probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/raspberrypi-ts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/raspberrypi-ts.c b/drivers/input/touchscreen/raspberrypi-ts.c
index ef6aaed217cfb..5000f5fd9ec38 100644
--- a/drivers/input/touchscreen/raspberrypi-ts.c
+++ b/drivers/input/touchscreen/raspberrypi-ts.c
@@ -160,7 +160,7 @@ static int rpi_ts_probe(struct platform_device *pdev)
 	touchbuf = (u32)ts->fw_regs_phys;
 	error = rpi_firmware_property(fw, RPI_FIRMWARE_FRAMEBUFFER_SET_TOUCHBUF,
 				      &touchbuf, sizeof(touchbuf));
-
+	rpi_firmware_put(fw);
 	if (error || touchbuf != 0) {
 		dev_warn(dev, "Failed to set touchbuf, %d\n", error);
 		return error;
-- 
2.39.2



