Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278A115C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F202C433C1;
	Mon,  5 Dec 2022 19:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268481;
	bh=KI//VNrvY18blvo63HE7FRgt4waLWxECGwe22pKqrSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m1RoqEhAxDThbjYJ4MVsNwlmf5UBn1kRsF1kegcaH489OUl9t5qyZRahT06ioIzdU
	 RTDhQVhHPa+u5OzYntRJh7UzSJji5KpJ8KRDz6jZ9cRk3YwG3QyQee7VIVUeVxmKHD
	 9Iyu+U7+8TFxtXqY8gZBn+ntY9CFpRgotBLjYHSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yufen <wangyufen@huawei.com>,
	Tommaso Merciai <tommaso.merciai@amarulasoluitons.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 117/124] i2c: qcom-geni: fix error return code in geni_i2c_gpi_xfer
Date: Mon,  5 Dec 2022 20:10:23 +0100
Message-Id: <20221205190811.771676048@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit 7d8ccf4f117d082156e842d959f634efcf203cef ]

Fix to return a negative error code from the gi2c->err instead of
0.

Fixes: d8703554f4de ("i2c: qcom-geni: Add support for GPI DMA")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Reviewed-by: Tommaso Merciai <tommaso.merciai@amarulasoluitons.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-qcom-geni.c b/drivers/i2c/busses/i2c-qcom-geni.c
index 84a77512614d..8fce98bb77ff 100644
--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -626,7 +626,6 @@ static int geni_i2c_gpi_xfer(struct geni_i2c_dev *gi2c, struct i2c_msg msgs[], i
 			dev_err(gi2c->se.dev, "I2C timeout gpi flags:%d addr:0x%x\n",
 				gi2c->cur->flags, gi2c->cur->addr);
 			gi2c->err = -ETIMEDOUT;
-			goto err;
 		}
 
 		if (gi2c->err) {
-- 
2.35.1



