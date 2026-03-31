Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299BF2D1F40;
	Tue, 31 Mar 2026 16:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975650; cv=none; b=j3xUqZlKeHkWIjlLtf9fd9BvO00DtCm5VlPHLVaYd3wgIki9UXjIJ9bjMo4QR56Q+S6ydehB14VqxyFHblTIpj2RSlUvE7gANvevyLaM+ZspUScbgouGmfEx32MtgXQ4VaviIJO4q8js9xNa4GI9ZYjA/AIFwIFOS4EQUzhj4o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975650; c=relaxed/simple;
	bh=qnsZGE79IoX8Vj01NcZfJmiR0d/32h2ikCghqvh2fps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XjyXl1cJvHrCt8934ZbrH1eyL926eQJT1Kq78gW9CJc7sNcfwgXiZqIDueOguuRB6/00sUuvQnnX6HS5CcGcl03W06s8/bQam7UbIQdmVzZZHNtBPilNQ1620IwLM0Zlusnf8e6v9HFmSzUUr8MtIH5eYGMwV7S0C5NXVAH/Tyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYybcOSV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYybcOSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46E7C19423;
	Tue, 31 Mar 2026 16:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975650;
	bh=qnsZGE79IoX8Vj01NcZfJmiR0d/32h2ikCghqvh2fps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jYybcOSVrvMlpcnyJoBSUFghTIsI89XEcXiVKrUFuub/9eUfR9N0BDIoIuZWz/ZmR
	 aq6zTihGjsGk1EUELOKeHVoDiaFd9mYQkV+wkBWW6gbrecYcCKzCefd9wxlVF0r35m
	 ZXr6nuxOu3886cjpcBLwGCndIQiSS2fmXERex4+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/244] hwmon: axi-fan: dont use driver_override as IRQ name
Date: Tue, 31 Mar 2026 18:19:15 +0200
Message-ID: <20260331161741.903759468@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit 813bbc4d33d2ca5b0da63e70ae13b60874f20d37 ]

Do not use driver_override as IRQ name, as it is not guaranteed to point
to a valid string; use NULL instead (which makes the devm IRQ helpers
use dev_name()).

Fixes: 8412b410fa5e ("hwmon: Support ADI Fan Control IP")
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Acked-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260303115720.48783-4-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/axi-fan-control.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/axi-fan-control.c b/drivers/hwmon/axi-fan-control.c
index 35c862eb158b0..7beefbd7469f8 100644
--- a/drivers/hwmon/axi-fan-control.c
+++ b/drivers/hwmon/axi-fan-control.c
@@ -507,7 +507,7 @@ static int axi_fan_control_probe(struct platform_device *pdev)
 	ret = devm_request_threaded_irq(&pdev->dev, ctl->irq, NULL,
 					axi_fan_control_irq_handler,
 					IRQF_ONESHOT | IRQF_TRIGGER_HIGH,
-					pdev->driver_override, ctl);
+					NULL, ctl);
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret,
 				     "failed to request an irq\n");
-- 
2.51.0



