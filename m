Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21C0171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E902C433EF;
	Mon, 22 May 2023 19:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783233;
	bh=diWu4AIC1ach/+U1Bf+5HLQYejSHjAGjK7EjL70df4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XG5anC+3idVAuZoF71ktM1/7asuhSJSS0oRA8Gt11Up+sH8EZ1DfoMBedygkQV/iG
	 F3DB2QlVo0rwXvjp8si+7PF7y976UskVGwKNrQ11W0OY2UhBNNzcZ7Xm9DaSU1HTML
	 J2B9D1UOlE3vv20V/dxkDPT17caXKMpESNhxW9xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Migliore <m.migliore@tiesse.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 155/203] net: dsa: mv88e6xxx: Fix mv88e6393x EPC write command offset
Date: Mon, 22 May 2023 20:09:39 +0100
Message-Id: <20230522190359.267227549@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marco Migliore <m.migliore@tiesse.com>

[ Upstream commit 1323e0c6e1d7e103d59384c3ac50f72b17a6936c ]

According to datasheet, the command opcode must be specified
into bits [14:12] of the Extended Port Control register (EPC).

Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x family")
Signed-off-by: Marco Migliore <m.migliore@tiesse.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/port.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 03382b66f8003..3e68d534eaca5 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -267,7 +267,7 @@
 /* Offset 0x10: Extended Port Control Command */
 #define MV88E6393X_PORT_EPC_CMD		0x10
 #define MV88E6393X_PORT_EPC_CMD_BUSY	0x8000
-#define MV88E6393X_PORT_EPC_CMD_WRITE	0x0300
+#define MV88E6393X_PORT_EPC_CMD_WRITE	0x3000
 #define MV88E6393X_PORT_EPC_INDEX_PORT_ETYPE	0x02
 
 /* Offset 0x11: Extended Port Control Data */
-- 
2.39.2



