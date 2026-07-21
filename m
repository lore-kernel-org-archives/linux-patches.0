Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A63284662;
	Tue, 21 Jul 2026 19:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663177; cv=none; b=sn88gnoPmX5Ye22Eyfy942By3SmPFaeIF8KUbvD0cc8LBN+hVSWTN4W1Ky6ErPLZpLJJ7XFsr8f5+X6g0JMQbHYWRuAQ7J4BunArZC42kYny+MEWEzYLgIxV90EPbC+zQ1IdWSIPu5jS+IdzuZSAH9O3grqvFiOwiovnZbIBiJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663177; c=relaxed/simple;
	bh=3ECjmQpjo61s60ir/3QskqWg8oHOV/mVKXTEIqEYSOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h8rqzICXwXhiFxyMICK30bWtW3mzwnKGpsFttsrLdU1cADbxw8mEAXGLQSc/uKNOD12aoF5NgSoi87cdYf1L+dNelDLOpYLi4XjyMHFutxH0XRnlL6EupSc3ueeJl6YiK0T0gP6mlG2lK2CoAJtZjo76Dl6q6VOr8BNjjvFfwXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W1scjv9n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W1scjv9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94451F000E9;
	Tue, 21 Jul 2026 19:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663176;
	bh=CGvauo6h9uj9ZCfTGHkxaF012xQ4GWKrNnKVLesOOoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W1scjv9ndDpWll4Onha3JYlfGN+2aprlxalJFY8xqikw884rEQOA0X8HLW4UG14is
	 IB/T+ai6DQ5B2X76YX+ICvIltnRQhYykLVfPANtddIL14iQJ5cajj24MzYJswtHJM5
	 L8NAJmHmtJXxF6vr6D/aXsqVEJHGL98mE6jYvk+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0723/1276] gpio: timberdale: Return -ENOMEM on dynamic memory allocation in probe
Date: Tue, 21 Jul 2026 17:19:26 +0200
Message-ID: <20260721152502.269560182@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fad97979748653..c40fb5ec93e6bd 100644
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



