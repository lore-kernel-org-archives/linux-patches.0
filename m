Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9D8168D1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A01C433EF;
	Mon,  8 May 2023 11:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545206;
	bh=TYVftzPFH3d122fStT/BFsArYteAjmvF3SwKnaQBLn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RaCBGrMKbltp27+Ug7w4GnKtl0/DiT/Wj/0oZ0QNE6ApuFZV5sCYCqqLdJaBrVzY5
	 A0j9Wv99DMxEfd8ZesB3dpOTZh3QLp9I9vq5bJB3kAn/cDKT9J++Xp05q2ymdMzk0j
	 /E19QauMs3IHwNjIjuie3QZoywzw3ge9GCgQbY8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 660/694] mfd: tqmx86: Specify IO port register range more precisely
Date: Mon,  8 May 2023 11:48:15 +0200
Message-Id: <20230508094457.424680703@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit 051c69ff4f607aa114c7bbdd7c41ed881367aeee ]

Registers 0x160..0x17f are unassigned. Use 0x180 as base register and
update offets accordingly.

Also change the size of the range to include 0x19f. While 0x19f is
currently reserved for future extensions, so are several of the previous
registers up to 0x19e, and it is weird to leave out just the last one.

Fixes: 2f17dd34ffed ("mfd: tqmx86: IO controller with I2C, Wachdog and GPIO")
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/db4677ac318b1283c8956f637f409995a30a31c3.1676892223.git.matthias.schiffer@ew.tq-group.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/tqmx86.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/tqmx86.c b/drivers/mfd/tqmx86.c
index 31d0efb5aacf8..958334f14eb00 100644
--- a/drivers/mfd/tqmx86.c
+++ b/drivers/mfd/tqmx86.c
@@ -16,8 +16,8 @@
 #include <linux/platform_data/i2c-ocores.h>
 #include <linux/platform_device.h>
 
-#define TQMX86_IOBASE	0x160
-#define TQMX86_IOSIZE	0x3f
+#define TQMX86_IOBASE	0x180
+#define TQMX86_IOSIZE	0x20
 #define TQMX86_IOBASE_I2C	0x1a0
 #define TQMX86_IOSIZE_I2C	0xa
 #define TQMX86_IOBASE_WATCHDOG	0x18b
@@ -25,7 +25,7 @@
 #define TQMX86_IOBASE_GPIO	0x18d
 #define TQMX86_IOSIZE_GPIO	0x4
 
-#define TQMX86_REG_BOARD_ID	0x20
+#define TQMX86_REG_BOARD_ID	0x00
 #define TQMX86_REG_BOARD_ID_E38M	1
 #define TQMX86_REG_BOARD_ID_50UC	2
 #define TQMX86_REG_BOARD_ID_E38C	3
@@ -40,8 +40,8 @@
 #define TQMX86_REG_BOARD_ID_E40S	13
 #define TQMX86_REG_BOARD_ID_E40C1	14
 #define TQMX86_REG_BOARD_ID_E40C2	15
-#define TQMX86_REG_BOARD_REV	0x21
-#define TQMX86_REG_IO_EXT_INT	0x26
+#define TQMX86_REG_BOARD_REV	0x01
+#define TQMX86_REG_IO_EXT_INT	0x06
 #define TQMX86_REG_IO_EXT_INT_NONE		0
 #define TQMX86_REG_IO_EXT_INT_7			1
 #define TQMX86_REG_IO_EXT_INT_9			2
-- 
2.39.2



