Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3D0134AC;
	Mon, 12 Aug 2024 16:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479953; cv=none; b=gZuQqkZ69Pfk2UXPDliSKUtOCYO0SEGh72HmyqnB1hv0+RfQbk+UKsCTffZISoE3WHtm+2kVRABkIcN2y3h6rHeHa2fpC9tyRDYvwZx5Jt9prwow77bZl9iU2sksDIGZQEOTSq1piIE1am1+1RsM0ryA1xJAoLpzQWD8OlqsRMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479953; c=relaxed/simple;
	bh=wRgCno8U63cEZ0Bhr/NpYjCUXeZl26lHdDb0DTNDC+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KV4EZXGagPF16pqEi9NYQmvuKWqFsWJUYoDO3VkRZxPjRIysSlNZ/mt8o2CK2m6NCVPMeJjZpiZZj6gsvY01IWNMz5OMo296kvkO7GsQtWChMnoyKxjvbcQORD/hhJt9Pj3ePQxadxBdUkfLRXTYai661GKzFEzjNdCY9Z+hDJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebY9e98V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebY9e98V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD28AC32782;
	Mon, 12 Aug 2024 16:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479953;
	bh=wRgCno8U63cEZ0Bhr/NpYjCUXeZl26lHdDb0DTNDC+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebY9e98V+EB2IClb3jctNZX9grZ3qTmnuhPIqZGD2RWojMhTGZ3ES/teoBG5+aIca
	 1jc5ZGrmhaUN2gqTwQxEKcLP0kxTD3owrIFZRY/YdTOkiaksz75d1USTR61drnheJX
	 M2tL1C5MC77/TxCVsceOfV2ZcmVYXjjzCcuy/qVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Swenson <kyle.swenson@est.tech>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 020/263] net: pse-pd: tps23881: Fix the device ID check
Date: Mon, 12 Aug 2024 18:00:21 +0200
Message-ID: <20240812160147.315602249@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Swenson <kyle.swenson@est.tech>

[ Upstream commit 89108cb5c28527c1882df2987394e5c261a1f4aa ]

The DEVID register contains two pieces of information: the device ID in
the upper nibble, and the silicon revision number in the lower nibble.
The driver should work fine with any silicon revision, so let's mask
that out in the device ID check.

Fixes: 20e6d190ffe1 ("net: pse-pd: Add TI TPS23881 PSE controller driver")
Signed-off-by: Kyle Swenson <kyle.swenson@est.tech>
Reviewed-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20240731154152.4020668-1-kyle.swenson@est.tech
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pse-pd/tps23881.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/pse-pd/tps23881.c b/drivers/net/pse-pd/tps23881.c
index 98ffbb1bbf13c..e95109c1130dc 100644
--- a/drivers/net/pse-pd/tps23881.c
+++ b/drivers/net/pse-pd/tps23881.c
@@ -29,6 +29,8 @@
 #define TPS23881_REG_TPON	BIT(0)
 #define TPS23881_REG_FWREV	0x41
 #define TPS23881_REG_DEVID	0x43
+#define TPS23881_REG_DEVID_MASK	0xF0
+#define TPS23881_DEVICE_ID	0x02
 #define TPS23881_REG_SRAM_CTRL	0x60
 #define TPS23881_REG_SRAM_DATA	0x61
 
@@ -750,7 +752,7 @@ static int tps23881_i2c_probe(struct i2c_client *client)
 	if (ret < 0)
 		return ret;
 
-	if (ret != 0x22) {
+	if (FIELD_GET(TPS23881_REG_DEVID_MASK, ret) != TPS23881_DEVICE_ID) {
 		dev_err(dev, "Wrong device ID\n");
 		return -ENXIO;
 	}
-- 
2.43.0



