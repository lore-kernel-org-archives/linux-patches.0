Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C956B26F462;
	Tue,  8 Apr 2025 12:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116227; cv=none; b=Y0Hqom1awswIb9OglJOp7KM4S/grd1+WOGYQZC0Am2gqVpJ+hk6p0UhBMJM4xw+jYcqAchSB+/zGJBIr6a3o/5p/tSLFinCSvPvRg6EM3wb3ENinPJwus3pbpPXSxud+C1jS0Da1CmnNKDWE1Lzx/kdkQaZXoTtKHSvqAVvcW0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116227; c=relaxed/simple;
	bh=l5KX72QXOT/ntM7MyHUw658x+uxj5tntgG6ERabWafU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0vrX/OXgf+2jQl5zem+7iv1emS0J2joTsMJFbNPyAfRRxEpcaZ1/qdU26uwoPknzfiCLStxg4WwuZ8bl4jRY0+0M4TbtIvn+bIyExCuiVZyHKd9gREUHpJbQheKL7xqG23P66TNbt27+HsrDjBa/43sAG99Tx29U+LlJbEHc78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mhaAgpb4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mhaAgpb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584DBC4CEE5;
	Tue,  8 Apr 2025 12:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116227;
	bh=l5KX72QXOT/ntM7MyHUw658x+uxj5tntgG6ERabWafU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mhaAgpb4ht4nDredd75E7H5/SFEPxA9niJAQUJjhupKNp33mlt5b2HEO+FEuxHXn8
	 JiZTjQL1/Y1PGggD6FDk3wauiw0TUSKeWA2PjIvO+x//1pEYJDHfQLO+DclrBt+xJe
	 m4+FqWLWY/cyoPYRUhR+2Rd6hZk61MC5zEJiOp7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 063/423] drm/panel: ilitek-ili9882t: fix GPIO name in error message
Date: Tue,  8 Apr 2025 12:46:29 +0200
Message-ID: <20250408104847.216364749@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Keeping <jkeeping@inmusicbrands.com>

[ Upstream commit 4ce2c7e201c265df1c62a9190a98a98803208b8f ]

This driver uses the enable-gpios property and it is confusing that the
error message refers to reset-gpios.  Use the correct name when the
enable GPIO is not found.

Fixes: e2450d32e5fb5 ("drm/panel: ili9882t: Break out as separate driver")
Signed-off-by: John Keeping <jkeeping@inmusicbrands.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250217120428.3779197-1-jkeeping@inmusicbrands.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-ilitek-ili9882t.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-ilitek-ili9882t.c b/drivers/gpu/drm/panel/panel-ilitek-ili9882t.c
index 266a087fe14c1..3c24a63b6be8c 100644
--- a/drivers/gpu/drm/panel/panel-ilitek-ili9882t.c
+++ b/drivers/gpu/drm/panel/panel-ilitek-ili9882t.c
@@ -607,7 +607,7 @@ static int ili9882t_add(struct ili9882t *ili)
 
 	ili->enable_gpio = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
 	if (IS_ERR(ili->enable_gpio)) {
-		dev_err(dev, "cannot get reset-gpios %ld\n",
+		dev_err(dev, "cannot get enable-gpios %ld\n",
 			PTR_ERR(ili->enable_gpio));
 		return PTR_ERR(ili->enable_gpio);
 	}
-- 
2.39.5



