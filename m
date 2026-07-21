Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB71844AB71;
	Tue, 21 Jul 2026 21:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669733; cv=none; b=sa2qkjtQNPLuod9NRJz1dpRAOGqsI4lgbrXnH3w9kLM2JT65VNKpandz8s4IynHDMpeXfgGKsIWg8qyLCf8h/b+e5w7F2AbRw7ruJJllii1upfXI4Ro5PwDVQSNO1UbVlFQdLkHhLR/GzuoddcHbKAo0kh4W15PIFGdZ8qbQjjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669733; c=relaxed/simple;
	bh=0J5Du4PKoqScfPYL9L3t117YJEtapFlWTC1xPnHFATI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6RUz7Iyqn9soLRgz0jHYnsHnQHiUUBUJCbmqqppH/pVvQLOGzsWN+AnAb+UPGcqES3fs3F3BtmbHfRIW4+7Sn3V5R6BXfBH8oN45Og254EFifNVfLxan4BbbbvZHxRHwnk+0QSoe2Wfb83wGRwVmwgT/Mp5hYQDO4d34y9JEA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RTPp0Vgc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RTPp0Vgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2E11F000E9;
	Tue, 21 Jul 2026 21:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669732;
	bh=HUQ7fAdEy1YKf48uIXUT5rXSx8mL5U6rgjtZBkmMxPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RTPp0VgcHO3faALszQqeaBcpU674ZrLA0rc88nyjvj/vJgYvPq2uSCPQx8xyCVCao
	 sGiwn5a7M9QZeXIcurL6L0/wWiqyw2HfgR/rtaQk3+9HiYZUnLJil5XTMDkR7LL5ts
	 fXVMxpEy2wFq8N/+Gt7LXu/RjbhulvWUa5ID5YJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0667/1067] gpio: timberdale: Return -ENOMEM on dynamic memory allocation in probe
Date: Tue, 21 Jul 2026 17:21:08 +0200
Message-ID: <20260721152439.518117609@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 92c1f2baa4bff2..3a9cb305c13777 100644
--- a/drivers/gpio/gpio-timberdale.c
+++ b/drivers/gpio/gpio-timberdale.c
@@ -228,7 +228,7 @@ static int timbgpio_probe(struct platform_device *pdev)
 
 	tgpio = devm_kzalloc(dev, sizeof(*tgpio), GFP_KERNEL);
 	if (!tgpio)
-		return -EINVAL;
+		return -ENOMEM;
 
 	tgpio->irq_base = pdata->irq_base;
 
-- 
2.53.0



