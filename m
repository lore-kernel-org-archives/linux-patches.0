Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E462534B693;
	Tue, 16 Dec 2025 11:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885269; cv=none; b=QxOeDp1vElzPV490W+QoOv5HSYX+OeCQ57HdBebCyqnWTtpWI6daBXiOtI4EtLvGk46wIvIFe83/jmJ9Jgw3GgoDsEj8482nF8iW4QiE6aP6uqlsrpKdzUBm+qth7iRIJ4xreA8GujDVPMh563wHZYFIc/uT6FsKAO+Acmwyllo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885269; c=relaxed/simple;
	bh=kVkZzxsRq051KTriUXEGI910qyD8I/YZJ4QnLjeIcAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOEsaFryREnBM3g15sWfZuqhmUT/qPoTrHVlGLA1MkHeI2iAG+kSWJ6o7Dnvtrknl8NV7FJfUnOxltpnRw3UoVMni9ygqtSn8/KiuDVz8iIpyis6zUwK7cOn8ybnj8W5J5kswhyZDUcJpXsm0vReBPUvBXxjMqicWpsd3o9EvqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XiRbSMNb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XiRbSMNb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643B4C4CEF1;
	Tue, 16 Dec 2025 11:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885268;
	bh=kVkZzxsRq051KTriUXEGI910qyD8I/YZJ4QnLjeIcAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XiRbSMNbgTxL9ZtMwf8AehyX0zOfvzDENjHp1M3PTQ1irLBBkSZEgAsLXT4/2vuk1
	 Bgm4/TcVgjl1eQteJWhOe3GFiRhuVrqrLm4ohV337UFkYJz6ZHx3P09nQrCz+pYFZ5
	 qh5KFocBRYI1pSLi/dGjIMGHcrpJpVoRZ2qgSmzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richard <thomas.richard@bootlin.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 088/507] leds: upboard: Fix module alias
Date: Tue, 16 Dec 2025 12:08:49 +0100
Message-ID: <20251216111348.726138432@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richard <thomas.richard@bootlin.com>

[ Upstream commit c06a017439110debd335b6864bc2d69835624235 ]

The module alias does not match the cell name defined in the MFD driver,
preventing automatic loading when the driver is built as a module. So fix
the module alias to ensure proper module auto-loading.

Fixes: 0ef2929a0181 ("leds: Add AAEON UP board LED driver")
Signed-off-by: Thomas Richard <thomas.richard@bootlin.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20251020-leds-upboard-fix-module-alias-v2-1-84ac5c3a1a81@bootlin.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-upboard.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/leds-upboard.c b/drivers/leds/leds-upboard.c
index b350eb294280f..12989b2f19530 100644
--- a/drivers/leds/leds-upboard.c
+++ b/drivers/leds/leds-upboard.c
@@ -123,4 +123,4 @@ MODULE_AUTHOR("Gary Wang <garywang@aaeon.com.tw>");
 MODULE_AUTHOR("Thomas Richard <thomas.richard@bootlin.com>");
 MODULE_DESCRIPTION("UP Board LED driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:upboard-led");
+MODULE_ALIAS("platform:upboard-leds");
-- 
2.51.0



