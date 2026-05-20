Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43DF3D7D7B;
	Wed, 20 May 2026 17:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298878; cv=none; b=PQLFczA3zP3b1qOpEccDHzcVbREKyniCvxxV64qazHD52JKLj4tZ9hRdgHnrXeWsLIpTLsUUI54g4vh2qOn2NEYhZHUeTUtLZbFpiSpq7DVO/X0FwHY1d5b5Vvu6GJ186z39hMPLe+hztwd8EB6mt397MOq5EfA6RdORnUsKOo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298878; c=relaxed/simple;
	bh=fDMnFu60RUjFa2kxblEgHyz5z89JkeBysHTiOCwo1RE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZD2X8V/J7BUMrQ6BgijiCifCPSY/pgHeXZatlkpCc83CHTasN3vM8zjv33PZ0NG5fhaj1/Ly/Hc1k5sd8sDWJ4GZ6VM6zauTgMU8V/1yGd7ZTnOW3lJFXpWMzhT4lG0GWozumU8Qgd+GYt6Q9Uvbe6RVPWVeJvQZTHRldsgyIIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sMjIxfdE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sMjIxfdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16AA31F000E9;
	Wed, 20 May 2026 17:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298877;
	bh=uhjC3ZfeS38Q/YlUH4jcsyK1bpAQX9RN3u6iZ5dIt9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sMjIxfdEsKuWtFRvr7CpphRhT3IeWRUGluRw862fhOv5MRMcJQ8ScCSL69v8I5F4N
	 EIWxM8K5ikDEn8NlmtRQzMM+OfdXI++d0IzWZbTv5/jDTZdjMDuREZX8Di8DgOly6p
	 WqgNOPVppwmkjt/C6FncaCRMjc8be3Bu4+8dsYUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 536/957] platform/x86: barco-p50-gpio: normalize return value of gpio_get
Date: Wed, 20 May 2026 18:16:59 +0200
Message-ID: <20260520162146.159711569@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 1c9d30d37aaffe3454d70b89a77f8aaecda257bf ]

The GPIO get callback is expected to return 0 or 1 (or a negative error
code). Ensure that the value returned by p50_gpio_get() is normalized
to the [0, 1] range.

Fixes: 86ef402d805d606a ("gpiolib: sanitize the return value of gpio_chip::get()")
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260318-barco-p50-gpio-set-v2-1-c0a4a6416163@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/barco-p50-gpio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/barco-p50-gpio.c b/drivers/platform/x86/barco-p50-gpio.c
index 6f13e81f98fbb..360ffd8505d6c 100644
--- a/drivers/platform/x86/barco-p50-gpio.c
+++ b/drivers/platform/x86/barco-p50-gpio.c
@@ -275,8 +275,11 @@ static int p50_gpio_get(struct gpio_chip *gc, unsigned int offset)
 	mutex_lock(&p50->lock);
 
 	ret = p50_send_mbox_cmd(p50, P50_MBOX_CMD_READ_GPIO, gpio_params[offset], 0);
-	if (ret == 0)
+	if (ret == 0) {
 		ret = p50_read_mbox_reg(p50, P50_MBOX_REG_DATA);
+		if (ret >= 0)
+			ret = !!ret;
+	}
 
 	mutex_unlock(&p50->lock);
 
-- 
2.53.0



