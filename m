Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4AF4582D0;
	Tue, 21 Jul 2026 22:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672122; cv=none; b=SswhIIjgG0w43FXY9V8GH8CKCbCO4nPHUb0fgbwTdrSuq3s/IxpAKErx8/CBzQdjgB88JQdd1yEnvP8f8atVJUG/jCcLqV3E4ZlQxiIVq7ZnHNyk7wGF3/cWWUm/XWZGrr3YxD+lu6apEuvYM/GYGEDBQfcqm+dq9IyTlGizPI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672122; c=relaxed/simple;
	bh=kWjNJroGrEc11uYgcCtPqh+rIjRAWXFR0+I91itYHhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txxurdru8v5uodOuf8wQVKuIj1DfyonwhKcWWh6L/8cSUO8RdG2/ngSx+rO5edHemW61jgy8jSwZ0OlP/6jPjdAso9wg6+X/IK6RZ8Kz7OWl805Ey7aDXUplYtsBNfi4utvGEhl5IhKKK7El1OXdxjSpq4STq5k3RgKBTqCQlS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=butIQ4Oy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="butIQ4Oy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57A61F000E9;
	Tue, 21 Jul 2026 22:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672121;
	bh=oOtxJhHIsF4DsDNKk/3I8gmzgw1YzZS+dzu7veWDBBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=butIQ4OyiXiCin7r+pKLN0i//TE7rcSrybbjVw1z6fV4BbrtJDyNAxPYZ8zOl331I
	 8E9+GuZpkmjvYebfJ9dNu12u8qkOo/lQRJwgpRTkKUvgJsQVZDTqfgj0p0KYnEsQZz
	 5r5Wdq6SHj+SDXK3EyQCjtPTRyHnVikEuhD6Rbf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 506/843] gpio: timberdale: Return -ENOMEM on dynamic memory allocation in probe
Date: Tue, 21 Jul 2026 17:22:21 +0200
Message-ID: <20260721152417.414007207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



