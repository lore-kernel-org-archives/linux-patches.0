Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E98B76033;
	Tue, 14 May 2024 11:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686430; cv=none; b=ho7vbERGGOl4IGrE+iCA91GQBVQ8vwlQys24L0f+YEy3j63yzptvsdysJDNo4IVM7Gg0/z0aIfEAxGTxRhicd/dA8ZMsj4my5vqYRIyDfuwRurv/JDthHZJRUm8350x5MdtCGJgWFI2SCSaHD/3tl9ISGnoZ3JE61Kh+wLaP4qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686430; c=relaxed/simple;
	bh=Yrnaai+J8cpNH6IvOXwcQvHPCFOincuLnPtsDHI5Iuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNRvRfF0mzVfVzpJ1kXqfY19cN4bQTd57bR66sMvo4Gy9JmWUaUfpZtTJ6yY6ZQT9t5UUcdiMoXTzpQ1xWkswmH1/UxMzsvQ+6AP4GU0NTl81LTLwG6q/pORGqab3oViYqvUEMEguwD/n4GZnRQfEWl4jAupR7m4jEeQNf/kOLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6nY9Ut/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6nY9Ut/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15350C2BD10;
	Tue, 14 May 2024 11:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686430;
	bh=Yrnaai+J8cpNH6IvOXwcQvHPCFOincuLnPtsDHI5Iuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I6nY9Ut/XKnyxxEbkDYZE9XLI89H75LQtAwBngdHB3mU1Tk1HPq2CxG+mgTa6X/MI
	 8jV+gyaNo+G8G6P6CEkgBoM2UXFS2w/ILS5DDZ9C/LxJl49FIQAYp6twZgqlMxjPRv
	 MqBbkOXItr/0NzcgXeVBL2oRr/f/h8xxpm53RoTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/236] gpio: crystalcove: Use -ENOTSUPP consistently
Date: Tue, 14 May 2024 12:18:17 +0200
Message-ID: <20240514101025.494464993@linuxfoundation.org>
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
index 1ee62cd58582b..25db014494a4d 100644
--- a/drivers/gpio/gpio-crystalcove.c
+++ b/drivers/gpio/gpio-crystalcove.c
@@ -92,7 +92,7 @@ static inline int to_reg(int gpio, enum ctrl_register reg_type)
 		case 0x5e:
 			return GPIOPANELCTL;
 		default:
-			return -EOPNOTSUPP;
+			return -ENOTSUPP;
 		}
 	}
 
-- 
2.43.0



