Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC54454F87;
	Tue, 14 May 2024 11:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687744; cv=none; b=DU1lc19aarf1AuyjRZG6SnkSPKgxZACrQUpI2xtUQ6lv17vtijq4x67mF0SYcbm0u4OUbKzKlhUp+Hw6ZPPDu8ilaTucS8kyi9X4051BfijNwIsn8NfF7/HT/ItseEiwnmXvSXaZ8emXxrgsaZEuzowIeqf1nPYfKjPzhoIt3c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687744; c=relaxed/simple;
	bh=4FJ6xh8pLrJEwuuNi2D4gEydxXKCjguO0fYXpyS0210=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuSOphcDu81Yagl5kTRwpwnzSl+4sGNpj1o511n8PtSWQMqwn86H3BOC64uqr/Gnjzm8QZQGcG1LR4beFgRbH0NVwFIenc8L/FCUTz0aghIkb1L7GIeeskMpn4lN+yZ4CSnnIjMYSDbpsPmdhzJ8Bzvl39jugOCwPFBfb6Kuges=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I7gBhmj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I7gBhmj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D18C2BD10;
	Tue, 14 May 2024 11:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687743;
	bh=4FJ6xh8pLrJEwuuNi2D4gEydxXKCjguO0fYXpyS0210=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I7gBhmj43S8CPAJYOQ3JGSaXYwUtBILrY6gPVd2t71bLfmuqF27lVayEKSySv/oU3
	 Z2mgoAWzcqGnd/iQ5ZPVnsnhxNWutXstXv7LSTpB4gUbRcai4TIxKa5lVqnsoVOTL8
	 EYoO7LGINk9Ii1nQaqe1UE9LxE+Ib7IgeehiEqKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/168] gpio: crystalcove: Use -ENOTSUPP consistently
Date: Tue, 14 May 2024 12:19:48 +0200
Message-ID: <20240514101010.090098686@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit ace0ebe5c98d66889f19e0f30e2518d0c58d0e04 ]

The GPIO library expects the drivers to return -ENOTSUPP in some
cases and not using analogue POSIX code. Make the driver to follow
this.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-crystalcove.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-crystalcove.c b/drivers/gpio/gpio-crystalcove.c
index 5a909f3c79e87..c48a82c240873 100644
--- a/drivers/gpio/gpio-crystalcove.c
+++ b/drivers/gpio/gpio-crystalcove.c
@@ -91,7 +91,7 @@ static inline int to_reg(int gpio, enum ctrl_register reg_type)
 		case 0x5e:
 			return GPIOPANELCTL;
 		default:
-			return -EOPNOTSUPP;
+			return -ENOTSUPP;
 		}
 	}
 
-- 
2.43.0



