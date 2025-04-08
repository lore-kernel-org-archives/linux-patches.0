Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4CF21ADAE;
	Tue,  8 Apr 2025 11:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111061; cv=none; b=r/4jMw0Om/PyFawrJUoAhRoEw+8mGw63fpZRlgUzj3ewWhSIo2lSstpGQbghnQ7oLlFqayBw40YAZASs0Z7TqDhOUZFJWv9vohBrh2k1AOOGR2eO46hTIaal9h0P+O04r/O1p56mglINc2LJVm5bSkgCPDVn40M48xIUp/QJDMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111061; c=relaxed/simple;
	bh=th8qIRITIdb6Pr+oOoNBUVULtUPnnvXqGJH/QKdnP48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DycciwYPJIS0UnZmNndrytPcF14hlZbUf1W2JycaAIkgnQm6Ly6om9jpQpChgq8IoXU42uR1kOVnPb4+Af0XsCRvAXGT7bLoyklOkJhIRy4GhOsiHEX/CT04LZJTkB+FDOrkpdteqPX59gfLeN+RofZNJpU3PZ//dMGc2ZNiOco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xnAkTVNr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xnAkTVNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529A0C4CEE5;
	Tue,  8 Apr 2025 11:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111060;
	bh=th8qIRITIdb6Pr+oOoNBUVULtUPnnvXqGJH/QKdnP48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xnAkTVNr94j08ahzxpxbVNbdpgfGxCgDeazXweYZuKnuoFK9rqLYCG5Ixno39jmQy
	 zD/LvG8QHsYhYdo6W5pxvJLU6dic277xyPjYs78WlpvfEuW7ouLp5cyD2qwjkDM9mR
	 LAVHvnI6XNx+NMuJRFlA12ipnMQ8GF6/cTxIiD/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 293/731] drm/panel: ilitek-ili9882t: fix GPIO name in error message
Date: Tue,  8 Apr 2025 12:43:10 +0200
Message-ID: <20250408104921.093157061@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



