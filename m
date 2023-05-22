Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6821D171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6684C4339B;
	Mon, 22 May 2023 19:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783954;
	bh=10Mr85HkH3deh8J3bwd3WajESRNlzHJt9b+GJAw1GSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BV/6kmlTCMiHw3buwN0/dWD7Z4HUnb18V1jHSiAeLaNWLo8EK7ldWpgFBDzgGCOCk
	 HnuN0XmbSXV5LUV1SfQaRXg2zRhddSFIWerrPqf5V1Qh72ROCrIya9xoGUlYM7X9eL
	 0yR6QoXl00TZ3TkCJ27/vLLdSN6Eau6o9q7js22w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Migliore <m.migliore@tiesse.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 217/292] net: dsa: mv88e6xxx: Fix mv88e6393x EPC write command offset
Date: Mon, 22 May 2023 20:09:34 +0100
Message-Id: <20230522190411.381897843@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
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
index cb04243f37c1e..a91e22d9a6cb3 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -276,7 +276,7 @@
 /* Offset 0x10: Extended Port Control Command */
 #define MV88E6393X_PORT_EPC_CMD		0x10
 #define MV88E6393X_PORT_EPC_CMD_BUSY	0x8000
-#define MV88E6393X_PORT_EPC_CMD_WRITE	0x0300
+#define MV88E6393X_PORT_EPC_CMD_WRITE	0x3000
 #define MV88E6393X_PORT_EPC_INDEX_PORT_ETYPE	0x02
 
 /* Offset 0x11: Extended Port Control Data */
-- 
2.39.2



