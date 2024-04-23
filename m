Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45A7143C49;
	Tue, 23 Apr 2024 21:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908721; cv=none; b=gMui3ZJLWiBrFLbS9KI7RAs3znz3Z1T5ffSgyLrO09FzVUFqEQkIkVVOk5cmOGpP1tIZ5OSwdf7ZSRKHcp9IXlYtxLm5FArXtursYxZjQBynpWuQl9wUtXCmWz/B0Hsf+i6Da2pn6OzbqjgIwhcDvWQDjniObLx9+g/ebUu0yIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908721; c=relaxed/simple;
	bh=nvNwe2AZ5EplEbeIho2azQcGrz3Qw6/AHicc+XdF54Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKIw1dUdPN5HbRCEhTI1VhhtY8NsgWguNAieqH6zqLVUa9ObSD+QFdq5hSZaMC1JhQ43PP8eRmXvdVflfRtjYx7S1ft3XOOx3nTqpmUCf1TucGObg5tLQTuIP7NDMRVYnz3dcTgnGcKAJSKB+UeENGUH3IMrS8RSBM4wb5IUtfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bG0Glk6Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bG0Glk6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866BAC3277B;
	Tue, 23 Apr 2024 21:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908721;
	bh=nvNwe2AZ5EplEbeIho2azQcGrz3Qw6/AHicc+XdF54Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bG0Glk6QG8YFzHEq3//d4yCXBFIC44INYsVjCWbr2KI+hP9YHL+77iuV4JEPQeXPv
	 r7LplyxokbNTHFpYcGVsm/RXxu/5pLb3Y3soYC9W8QgDqB/C//QG+mRMZbM3I71Ju4
	 oSjihb6N+IglTFl75y9SvoNq9Z82FnmNpA/N3JDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Tony Lindgren <tony@atomide.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/141] ARM: OMAP2+: pdata-quirks: stop including wl12xx.h
Date: Tue, 23 Apr 2024 14:38:44 -0700
Message-ID: <20240423213855.075035569@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit e14e4c933e0047653f835e30d7d740ebb2a530cc ]

As of commit 2398c41d6432 ("omap: pdata-quirks: remove openpandora
quirks for mmc3 and wl1251") the code no longer creates an instance of
wl1251_platform_data, so there is no need for including this header.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221109224250.2885119-1-dmitry.torokhov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/pdata-quirks.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 9deba798cc919..baba73fd6f11e 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -10,7 +10,6 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/of_platform.h>
-#include <linux/wl12xx.h>
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
 #include <linux/power/smartreflex.h>
-- 
2.43.0



