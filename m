Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB17FC1B
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3B9C433EF;
	Mon, 15 May 2023 17:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172814;
	bh=OnWH8B1rD1iQcd7Q91S1eCwAM91Gv1y31hUg6xC8MAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BHN9YehDw8Ww1dWXtx0kPo/TFeafCiGpQQJm3uFvLbEEyd4Dg+gYpFT6EXlqkeLj0
	 sVTImL7mW6kSf3HDIZsuyA5vzJ30U5LnJN5B+mPtHts3Q934qvKA3wAcpq8tL+vsYx
	 6ce72/1fGG9CT7zibsbN49FaTAGWBQ5ZvZNtapow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Lee Jones <lee.jones@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 275/381] mfd: tqmx86: Add support for TQMx110EB and TQMxE40x
Date: Mon, 15 May 2023 18:28:46 +0200
Message-Id: <20230515161749.209755719@linuxfoundation.org>
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

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit 3da48ccb1d0f3b53b1e8c9022edbedc2a6e3f50a ]

Add the board IDs for the TQMx110EB and the TQMxE40x family. All use a
24MHz LPC clock.

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Stable-dep-of: 051c69ff4f60 ("mfd: tqmx86: Specify IO port register range more precisely")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/tqmx86.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/mfd/tqmx86.c b/drivers/mfd/tqmx86.c
index c5c5846dcf995..1db95aed5012e 100644
--- a/drivers/mfd/tqmx86.c
+++ b/drivers/mfd/tqmx86.c
@@ -35,6 +35,11 @@
 #define TQMX86_REG_BOARD_ID_E39x	7
 #define TQMX86_REG_BOARD_ID_70EB	8
 #define TQMX86_REG_BOARD_ID_80UC	9
+#define TQMX86_REG_BOARD_ID_110EB	11
+#define TQMX86_REG_BOARD_ID_E40M	12
+#define TQMX86_REG_BOARD_ID_E40S	13
+#define TQMX86_REG_BOARD_ID_E40C1	14
+#define TQMX86_REG_BOARD_ID_E40C2	15
 #define TQMX86_REG_BOARD_REV	0x21
 #define TQMX86_REG_IO_EXT_INT	0x26
 #define TQMX86_REG_IO_EXT_INT_NONE		0
@@ -126,6 +131,16 @@ static const char *tqmx86_board_id_to_name(u8 board_id)
 		return "TQMx70EB";
 	case TQMX86_REG_BOARD_ID_80UC:
 		return "TQMx80UC";
+	case TQMX86_REG_BOARD_ID_110EB:
+		return "TQMx110EB";
+	case TQMX86_REG_BOARD_ID_E40M:
+		return "TQMxE40M";
+	case TQMX86_REG_BOARD_ID_E40S:
+		return "TQMxE40S";
+	case TQMX86_REG_BOARD_ID_E40C1:
+		return "TQMxE40C1";
+	case TQMX86_REG_BOARD_ID_E40C2:
+		return "TQMxE40C2";
 	default:
 		return "Unknown";
 	}
@@ -138,6 +153,11 @@ static int tqmx86_board_id_to_clk_rate(u8 board_id)
 	case TQMX86_REG_BOARD_ID_60EB:
 	case TQMX86_REG_BOARD_ID_70EB:
 	case TQMX86_REG_BOARD_ID_80UC:
+	case TQMX86_REG_BOARD_ID_110EB:
+	case TQMX86_REG_BOARD_ID_E40M:
+	case TQMX86_REG_BOARD_ID_E40S:
+	case TQMX86_REG_BOARD_ID_E40C1:
+	case TQMX86_REG_BOARD_ID_E40C2:
 		return 24000;
 	case TQMX86_REG_BOARD_ID_E39M:
 	case TQMX86_REG_BOARD_ID_E39C:
-- 
2.39.2



