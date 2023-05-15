Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229FB1772F
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFC7C433EF;
	Mon, 15 May 2023 18:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173780;
	bh=L9koS/fYt77aQLiza0XOujmtGRjjaFzM6wrqWol/Sgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7OaIClobTUGkgEgX+eFIKRbCTzQsREn4I4ZMVQRv+w6XVZG+hgtjgj4o6NtTnTC1
	 O2sKMXj7l9BEUg3lXmmsGlPV6fmCBKAcqOvfDWw3xxBbN6BwnU2jZ0WrJcyWtRJuqt
	 BFqGUSNPEjURwe06Qa/cpK23pOhKrXer+2RGDKVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 173/282] input: raspberrypi-ts: Release firmware handle when not needed
Date: Mon, 15 May 2023 18:29:11 +0200
Message-Id: <20230515161727.466780438@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
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
index 69881265d1218..4740a7c412364 100644
--- a/drivers/input/touchscreen/raspberrypi-ts.c
+++ b/drivers/input/touchscreen/raspberrypi-ts.c
@@ -164,7 +164,7 @@ static int rpi_ts_probe(struct platform_device *pdev)
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



