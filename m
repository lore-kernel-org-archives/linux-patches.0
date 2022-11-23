Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B591C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F5BC433D6;
	Wed, 23 Nov 2022 09:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194845;
	bh=D12S1QJOCBDz/sO5Wa0HDRc7+ODBM7WKRmkzoARuMkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQNHHBrb7OrHNCD29P/RNwhGEwRB6fL3uMDvXFj5LhNHpcSuNq/KyzeMmLsMbnc7/
	 4COjSL6XWLGYFWH5V/jBaXkL+QLaaykO27kWMotT8nrCAlVnXwgD+5w8savG1hrXMb
	 MWc/pyL/yyEStLlJQBBOPPNyDkx70kF5H87sLe6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcaov@gmail.com>,
	Jean Delvare <jdelvare@suse.de>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 077/156] i2c: i801: add lis3lv02ds I2C address for Vostro 5568
Date: Wed, 23 Nov 2022 09:50:34 +0100
Message-Id: <20221123084600.791082188@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nam Cao <namcaov@gmail.com>

[ Upstream commit d6643d7207c572c1b0305ed505101f15502c6c87 ]

Dell Vostro 5568 laptop has lis3lv02d, but its i2c address is not known
to the kernel. Add this address.

Output of "cat /sys/devices/platform/lis3lv02d/position" on Dell Vostro
5568 laptop:
    - Horizontal: (-18,0,1044)
    - Front elevated: (522,-18,1080)
    - Left elevated: (-18,-360,1080)
    - Upside down: (36,108,-1134)

Signed-off-by: Nam Cao <namcaov@gmail.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Reviewed-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-i801.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 4e6d0b722ddc..2b84db59ab3c 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1253,6 +1253,7 @@ static const struct {
 	 * Additional individual entries were added after verification.
 	 */
 	{ "Vostro V131",        0x1d },
+	{ "Vostro 5568",        0x29 },
 };
 
 static void register_dell_lis3lv02d_i2c_device(struct i801_priv *priv)
-- 
2.35.1



