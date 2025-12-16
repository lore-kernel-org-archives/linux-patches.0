Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8DD3659E6;
	Tue, 16 Dec 2025 12:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887028; cv=none; b=mhQx5ocaGuLas5n4S4N4YmACwKUJarLnBhRu9T4T/EH9yabJBJy398jyUWIZYKWiC+HHUbodpYJGgYLYQvACnmhUCfIrZsiL2dXb0ETwTetPGWK0yrn9r5vU1rBuxAsy+28Cq4RUd6TPh8IbX/e+1DgXE7PvExND3Q3nElpwiX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887028; c=relaxed/simple;
	bh=DyX3Co6iJWqv7vWvGOPBaP6VgQ7LqmLTSfRwDRNi6Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adXRGHNhsxRNTT70ILTEGmn7vwQC0a31PhwvXOmH1xJ3RXXVma/qjEI8pa4lsRhCzMPveUyEyWf1eGps/j7JJG2x+8/fmbFgEYI2ko4FNolHtvFPB1dzkcnuKHilforCwLIBAO1B8FiutG3I5zScOgLzlaqBHMfR5MuOGGNXqjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0BuWZ98; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0BuWZ98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8D8C4CEF1;
	Tue, 16 Dec 2025 12:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887028;
	bh=DyX3Co6iJWqv7vWvGOPBaP6VgQ7LqmLTSfRwDRNi6Ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0BuWZ98RB5Cn/g93Jk+ZH0AQdBxY0Q0G7Vk3FZLIcP/BTo2zQlz9t4aozUhJmEDh
	 qvx3hFI7w/4nXJq1J2Mo7W0W1jXznH8iKhZQld1UCXDPhpmVMEdcigEjWhjiq8wR0P
	 buRiPUoLQHv2X+xj/CQ1qiMa02mVuyX1CdRad2Yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richard <thomas.richard@bootlin.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 106/614] leds: upboard: Fix module alias
Date: Tue, 16 Dec 2025 12:07:53 +0100
Message-ID: <20251216111405.177836336@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



