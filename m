Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEAF76033;
	Tue, 14 May 2024 11:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686427; cv=none; b=i8jLYxeJcuG7lY9FoxBScVDLS2/7bmb0+kJf+LXBV5qNZpAjuSIQmnTbWSd9SxOWdX8NDHHh/VSflTDu800u44t/u7SQPhicSppa9RpbE/62fjl9OAM9Ay4Vz7gyAgRFj3JsrareGHhhlHrBlHBy5MX5aSv8r9/vKW0ucmiTzJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686427; c=relaxed/simple;
	bh=Jv9E4ybrUBDAKFjxDqWUlK8HmJzPpzIYDoMk6VMnZCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shAMjOMGdeQn8wZt6xPqNOWob09TDOT14dFtDYk7jY2h6WRebck2mouHAkyAWsdYg0bG9EGyrIQ9P4UX602TUXjo+dN9x5fhjy+MkMUEJapBs818pWDkJbbCW8QIMzO10I52i8Qjw3FmcSw57UsayWN1OXXEV6zhCh0TNpiLpKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bt6zGJ1/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bt6zGJ1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365CBC2BD10;
	Tue, 14 May 2024 11:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686427;
	bh=Jv9E4ybrUBDAKFjxDqWUlK8HmJzPpzIYDoMk6VMnZCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bt6zGJ1/GdzeLg1F1ILn9IieJhyicqpiU3h49bZgkv0yv47YFPLR2s2kEs7AtCJfZ
	 L8A+3uqux2u2Wh1tME17Lx57DIrjPyoc4SXeYXnP6fZP/zO3sY8L5NYSM/c4wIWI5G
	 iD5gMji0c+2LrQMAtOuEwwh0quXSSXG3Kxks44Wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 134/236] gpio: wcove: Use -ENOTSUPP consistently
Date: Tue, 14 May 2024 12:18:16 +0200
Message-ID: <20240514101025.456945213@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c18b6b47384f1..94ca9d03c0949 100644
--- a/drivers/gpio/gpio-wcove.c
+++ b/drivers/gpio/gpio-wcove.c
@@ -104,7 +104,7 @@ static inline int to_reg(int gpio, enum ctrl_register type)
 	unsigned int reg = type == CTRL_IN ? GPIO_IN_CTRL_BASE : GPIO_OUT_CTRL_BASE;
 
 	if (gpio >= WCOVE_GPIO_NUM)
-		return -EOPNOTSUPP;
+		return -ENOTSUPP;
 
 	return reg + gpio;
 }
-- 
2.43.0



