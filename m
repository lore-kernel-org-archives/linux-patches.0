Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033EE36EAB8;
	Wed, 20 May 2026 16:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296101; cv=none; b=RrqpefFIpi9hVS0fohTThjZzWtHQvSpTXm6WS1S/PlJsPjp9WvX93Eh6swTz3L7sJ0yg6RwRlhXxDxzXjfJIkA5yPtXGrph0m1JNwOxJPZ4+HuL4ONC+aW/i2MN++ajjVEIQNrrIoFyK93r161DT2/ACmbzUhmScMM0OddT8yV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296101; c=relaxed/simple;
	bh=6JWb5/ShN4kqOuuO5QcgOWC7sau5/y4siZxi1GQRwYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fxp9Pc7Ly+CkJ0wR0IByEIvhwNwG4BPWZQa0QYdjM6g/R//1BUesDZMKzOUib5fvbWvwzphNviARlxPcdCm1fqnEgxfWcjEHTujEZe5P0+m2QhpU1wPsii+OcypOIqDnGGoYJl3zISDvSFRfd5rbIiqtwM2FIfgN7cmFciDgQZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2e/LMP/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2e/LMP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED401F000E9;
	Wed, 20 May 2026 16:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296099;
	bh=6L08o+UDx3kIrQsWLLlukYgp/6fuu4nhGnWuuv5DvE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U2e/LMP/hKa6LMSmixv/RzsiCAFUK8axgOstRKpYAJ1iRUljviKEbt91O1gslyPhl
	 ig8KKmWJnq8QQQefDxGnRXWZzgdVhnbTvKPf+/nVjtDT7FFtgyyAxndA01qiN5Zohb
	 iTyCiz8QQkfw85uaosDlKPYZNz1Dh97cYqiYjCH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0671/1146] platform/x86: barco-p50-gpio: normalize return value of gpio_get
Date: Wed, 20 May 2026 18:15:21 +0200
Message-ID: <20260520162203.371408013@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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



