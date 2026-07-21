Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51893D3337;
	Tue, 21 Jul 2026 17:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653537; cv=none; b=PVP2LGEsUxmn7XsZk6d87OBrNw4yFruU3E/orgH964f9k/0y9ULBQMMR5G+TmOOhznb0Af92h3yXbjqP8Q2Qq2GLWPELC1xZ1U0tIn/VIImT/PFgoST+wXmIiaEamoCqORnAfpakYGCM2SG3BL29TZ+ww2zM0WwvoMn9YpIYrq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653537; c=relaxed/simple;
	bh=xtyB0WHerBgAzAe+R2ANTvw95Dr3j4hNvb7q1OtgeZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+jGp4xCbjmjK9RcRppQvzochsNScxQ/AwjGcuEmzW1QiikBxQ5weReO+xmg5LUg60lD5yIgLIT5T26TrKQl0W0RlH5rUw4bhoSDMawU3GBb2wZl1+gw+KQJRnDVx9U8MmCvmnKjSo1cBnfbUL7lvual/NDGmsrEUT+uJc7HZZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PzKZzrA8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PzKZzrA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050E91F000E9;
	Tue, 21 Jul 2026 17:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653536;
	bh=eVzw1Cneu+v0jYW2RDTcGmwUHI5fXjDRo9fvPI3yBfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PzKZzrA8Z3091QCDVbTFP3+5p9OG79MH9UaAKUi29K2vaPHWWEbde+1Fg7AqQh1vY
	 GbWC6u5dntaXsxz4u9c8dKZ0f+f4PMR9+LvM2c47CYYIl2vdvkll1RFj8Q95iIAGPx
	 DpvIU+3kIjo49BWjtBIhe4KWd2Enb+5mNBDLc3/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1364/2077] gpio: timberdale: Return -ENOMEM on dynamic memory allocation in probe
Date: Tue, 21 Jul 2026 17:17:17 +0200
Message-ID: <20260721152624.991695644@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vz@kernel.org>

[ Upstream commit 8d7e62d5e9b2d2ff146f472a9215d7e29c7e2307 ]

Out of memory situation on driver's probe is expected to be reported to
the driver's framework with a proper -ENOMEM error code.

Fixes: 35570ac6039e ("gpio: add GPIO driver for the Timberdale FPGA")
Signed-off-by: Vladimir Zapolskiy <vz@kernel.org>
Link: https://patch.msgid.link/20260630145148.4081967-1-vz@kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-timberdale.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-timberdale.c b/drivers/gpio/gpio-timberdale.c
index f488939dd00a8a..b77c9d16fd166a 100644
--- a/drivers/gpio/gpio-timberdale.c
+++ b/drivers/gpio/gpio-timberdale.c
@@ -235,7 +235,7 @@ static int timbgpio_probe(struct platform_device *pdev)
 
 	tgpio = devm_kzalloc(dev, sizeof(*tgpio), GFP_KERNEL);
 	if (!tgpio)
-		return -EINVAL;
+		return -ENOMEM;
 
 	tgpio->irq_base = pdata->irq_base;
 
-- 
2.53.0



