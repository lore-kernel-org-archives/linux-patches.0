Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2AC3D393
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nSgMcR6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B0AC433C7;
	Wed, 15 Nov 2023 20:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081078;
	bh=uhRcVbE6/Kbvf0t0/6P9HME4JYAEw4OQJkgYF+q59yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nSgMcR6AFu8WL2IucOwjUR8VoHyONbbzvHqZpdudS4IYL/r0PLq4Ko1d9CcNZCUs1
	 T5vdweGqg5boezICQiVK7ziNkpSxFdwqfezcp6LSrxbBhKalyRMKvxT6pKQvPzN6mX
	 LqePQPoNRsE7G937J5hahcvyvOEYBIfZJm+GcnR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/88] can: dev: move driver related infrastructure into separate subdir
Date: Wed, 15 Nov 2023 15:35:20 -0500
Message-ID: <20231115191426.694692619@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191426.221330369@linuxfoundation.org>
References: <20231115191426.221330369@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 3e77f70e734584e0ad1038e459ed3fd2400f873a ]

This patch moves the CAN driver related infrastructure into a separate subdir.
It will be split into more files in the coming patches.

Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/r/20210111141930.693847-3-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: fe5c9940dfd8 ("can: dev: can_restart(): don't crash kernel if carrier is OK")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/Makefile               | 7 +------
 drivers/net/can/dev/Makefile           | 7 +++++++
 drivers/net/can/{ => dev}/dev.c        | 0
 drivers/net/can/{ => dev}/rx-offload.c | 0
 4 files changed, 8 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/can/dev/Makefile
 rename drivers/net/can/{ => dev}/dev.c (100%)
 rename drivers/net/can/{ => dev}/rx-offload.c (100%)

diff --git a/drivers/net/can/Makefile b/drivers/net/can/Makefile
index 44922bf29b6a0..93e11f1fee5c6 100644
--- a/drivers/net/can/Makefile
+++ b/drivers/net/can/Makefile
@@ -7,12 +7,7 @@ obj-$(CONFIG_CAN_VCAN)		+= vcan.o
 obj-$(CONFIG_CAN_VXCAN)		+= vxcan.o
 obj-$(CONFIG_CAN_SLCAN)		+= slcan.o
 
-obj-$(CONFIG_CAN_DEV)		+= can-dev.o
-can-dev-y			+= dev.o
-can-dev-y			+= rx-offload.o
-
-can-dev-$(CONFIG_CAN_LEDS)	+= led.o
-
+obj-y				+= dev/
 obj-y				+= rcar/
 obj-y				+= spi/
 obj-y				+= usb/
diff --git a/drivers/net/can/dev/Makefile b/drivers/net/can/dev/Makefile
new file mode 100644
index 0000000000000..cba92e6bcf6f5
--- /dev/null
+++ b/drivers/net/can/dev/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_CAN_DEV)		+= can-dev.o
+can-dev-y			+= dev.o
+can-dev-y			+= rx-offload.o
+
+can-dev-$(CONFIG_CAN_LEDS)	+= led.o
diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev/dev.c
similarity index 100%
rename from drivers/net/can/dev.c
rename to drivers/net/can/dev/dev.c
diff --git a/drivers/net/can/rx-offload.c b/drivers/net/can/dev/rx-offload.c
similarity index 100%
rename from drivers/net/can/rx-offload.c
rename to drivers/net/can/dev/rx-offload.c
-- 
2.42.0



