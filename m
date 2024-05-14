Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917547E77B;
	Tue, 14 May 2024 11:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687351; cv=none; b=YwyoAg4kVd9hFQBruHdH6MLl+GhzLqGOeG94BM8fNUFcz6J571pDHJuEJ4fonm2Hk7B2H7e7dTFsot0hj9bysretc8Y6KTX2kzehYRZ1JqQmEqM5WS9GeGK01fyoCqq5NTTNaPbWoVx1tVjKQi9vuJi6aqL7otJ34dQ1whhxS5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687351; c=relaxed/simple;
	bh=daT7KLZvW1BKEWw6U8+woIkwCoh8+8N+T98xWMUjNbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQM/XULMLpqvNo5W9ckd5/liBzPwlWkisqSxa6M5+RTnPWwmLWPnVcktlGtBwY7lhwVUqZ/P1qFn6nSAsUZ3c6aJSarDhUgroqqiMwq/IZW8cQEky293h3Tx3WH/uN6pPmyVgYRyuoiEotWKg6MJefBJziMmVmtdNrBjciFOwXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1tT7JPs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1tT7JPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196D8C2BD10;
	Tue, 14 May 2024 11:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687351;
	bh=daT7KLZvW1BKEWw6U8+woIkwCoh8+8N+T98xWMUjNbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1tT7JPsjQzCG9i1tohso25GYcrrimjSXE0uXS7FX3oMr1ThiXJ4/l7JBln7itYD3
	 6p6zFKOB9B3p4S5ZnU8dd0I4W1+DSEa3lWC5JE7c8BddTHjVgmQ0c4Nz8aEPP5ofp6
	 0Zc+zX3BwjM/Vc2AdbSQZcy6JKNJk6uwg2QYnaSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/111] gpio: wcove: Use -ENOTSUPP consistently
Date: Tue, 14 May 2024 12:20:05 +0200
Message-ID: <20240514100959.679325209@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 0c3b532ad3fbf82884a2e7e83e37c7dcdd4d1d99 ]

The GPIO library expects the drivers to return -ENOTSUPP in some
cases and not using analogue POSIX code. Make the driver to follow
this.

Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-wcove.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-wcove.c b/drivers/gpio/gpio-wcove.c
index b5fbba5a783af..e3755bc636267 100644
--- a/drivers/gpio/gpio-wcove.c
+++ b/drivers/gpio/gpio-wcove.c
@@ -102,7 +102,7 @@ static inline int to_reg(int gpio, enum ctrl_register reg_type)
 	unsigned int reg;
 
 	if (gpio >= WCOVE_GPIO_NUM)
-		return -EOPNOTSUPP;
+		return -ENOTSUPP;
 
 	if (reg_type == CTRL_IN)
 		reg = GPIO_IN_CTRL_BASE + gpio;
-- 
2.43.0



