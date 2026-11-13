Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591539;
	b=FAUAILY3iWhmEm8EpSKA+cnrmEpc1KYD4SD5lbQz3RAhf1T1Z1M7FOLnWvF4r0gZl22H
	 4pWgHC+xn1gJL/Z32d3i2eazeYK5lx36MVtZdEoPpKs10nw0xfSbvW8KrUobVXbHDK57W
	 JF99OGMonEXJhod5F7vypWlMii9OKI8PqaEWy6373Buk5dK5eYzViuUHVm/blW9vAjq9M
	 0ePOEHW7HTeY9TOon5OWhEPcjqGs6cYuCqOpYZ/IhIyWDHp3+e7Y5+X+LaNz/lpiNJSo3
	 zfo+2d0ds4fjRXVxMJ9TQPjLR14fw+iYtPdHedBbKvBawuyDH6OOrQ7sfr7xTjXAOQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591539;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eP72VuXw7JynY6yPy0EOIG45tI/HpnuhIDttH6EZsqc=;
	b=g7sMYPVXjdGx3Xu1Aav2kHv+lDZNvO29IIRuxaM8jjljWV0QZkQjneo6HGQ4JqBGcjQR
	 y3u/WP4Sv9tSrBGFDDDfEJtLYH+rXj4bhbCRDzMQ2ywrSjd3vlbPUrpiD1KP0YyA++ND1
	 WBNuCh3N1J1A0aIAruvvJnaZeb02H9dKWBwTQlYqEl/yLqIzXoteHKxGg7U7yDY4BN+ay
	 3QiqskAKWLjyty2IhTQl/s72jlyXll3ltCYSxqxuZOvWVe8WxJ6insAC0pdT8MddQ6Atk
	 UgoVkrRBetF2ARjAMsG9bcF+mGnOEx5Q5duG25REvXW43mOJxtovV11G2MhqyMItMpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZbDijpsD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A78606D87A;
	Fri, 13 Nov 2026 17:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZbDijpsD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4ADC1F000C4;
	Fri, 13 Nov 2026 17:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591539;
	bh=eP72VuXw7JynY6yPy0EOIG45tI/HpnuhIDttH6EZsqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZbDijpsDF+RUN3Sku2+3gmZFr2e7hRUs2N7wmh+3Z1t+tUBqLxJEwkwGFO+htw3s3
	 p4B53man5/zIr9WzZpXLs7bk+eTxmeQUIDimnQBbGbWS3FazXKcwMj4Sdi44IOeKkH
	 bFLp5MVvKmQJ6ajG9sUkxhnPtjlAuJ91duyWukzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 593/670] nvmem: rockchip-otp: alloc clks with main struct
Date: Fri, 13 Nov 2026 10:52:37 -0500
Message-ID: <20261113153831.929843212@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 9f99bb979f930e52e6861114fe03535d4bc2f374 ]

Use a flexible array member to simplify allocation slightly. No need for
a separate calloc.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260530205333.117458-3-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 9fc6a1592d84 ("nvmem: rockchip-otp: Serialize reads")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/rockchip-otp.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/nvmem/rockchip-otp.c b/drivers/nvmem/rockchip-otp.c
index d88f12c532426..00921b9fe9aae 100644
--- a/drivers/nvmem/rockchip-otp.c
+++ b/drivers/nvmem/rockchip-otp.c
@@ -77,9 +77,9 @@ struct rockchip_data {
 struct rockchip_otp {
 	struct device *dev;
 	void __iomem *base;
-	struct clk_bulk_data *clks;
 	struct reset_control *rst;
 	const struct rockchip_data *data;
+	struct clk_bulk_data clks[];
 };
 
 static int rockchip_otp_reset(struct rockchip_otp *otp)
@@ -327,7 +327,7 @@ static int rockchip_otp_probe(struct platform_device *pdev)
 	if (!data)
 		return dev_err_probe(dev, -EINVAL, "failed to get match data\n");
 
-	otp = devm_kzalloc(&pdev->dev, sizeof(struct rockchip_otp),
+	otp = devm_kzalloc(&pdev->dev, struct_size(otp, clks, data->num_clks),
 			   GFP_KERNEL);
 	if (!otp)
 		return -ENOMEM;
@@ -339,11 +339,6 @@ static int rockchip_otp_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, PTR_ERR(otp->base),
 				     "failed to ioremap resource\n");
 
-	otp->clks = devm_kcalloc(dev, data->num_clks, sizeof(*otp->clks),
-				 GFP_KERNEL);
-	if (!otp->clks)
-		return -ENOMEM;
-
 	for (i = 0; i < data->num_clks; ++i)
 		otp->clks[i].id = data->clks[i];
 
-- 
2.53.0



