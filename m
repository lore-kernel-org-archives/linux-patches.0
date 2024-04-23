Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F7F143C5A;
	Tue, 23 Apr 2024 21:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908711; cv=none; b=qvovdllfVQl+Lk4oE54B32ybDG6nVJfi50MjMvHLLiUilB2wtA5pSNAlPLiR4ARyWZV6k8Uux65OIzyUWLZiyJEa4NO5Z8iA+2GpwjJaCdiknDLepdm6rwKNnRBm2HaW69Xaz55Yb9gPjN6nEtsaAPB0omPzN4GxjBrEDCHJaNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908711; c=relaxed/simple;
	bh=Wwcw0uS+dlLVjGAbYvDouZf+Bs/NwC4AyGIvf3bngvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQFb4zl764lyJ3yA3IooNpEXY/+Z0EuvJ7jDKdplYzr5/fZNCaIGQJ+umlMTqIyNroP7DQEH42CVbyd8I6IS7Jvv07Btphdn7NtZPx61Jzc0Xe8XhC7i/vrDQDDXqRD6TtmFce5krP4hnqMYHCg2SMa07MQwr2on2lK9mD1O2Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBvIduW7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBvIduW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77798C116B1;
	Tue, 23 Apr 2024 21:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908711;
	bh=Wwcw0uS+dlLVjGAbYvDouZf+Bs/NwC4AyGIvf3bngvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yBvIduW7k4YatJ+0K2e4I/ztbGa8IgTAlhQmwCKP67auOl4OU3Fu23ufZW3k5BqiK
	 EbCQ2SDYlv6l771GUxDtcyNB4lGtX9+QfrInly7ejS0W0qpXGz/dkWbcsBaXSiQOZP
	 651V09a4BsDX5pB+ppmRhkDu1kY8aq9o+m8eYCpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/141] ARM: davinci: Drop unused includes
Date: Tue, 23 Apr 2024 14:38:56 -0700
Message-ID: <20240423213855.436093838@linuxfoundation.org>
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

From: Rob Herring <robh@kernel.org>

[ Upstream commit 6e73bd23a1cdcf1416ebd57ff673b5f601963ed2 ]

of_platform.h include is not needed, so drop it. It implicitly includes
of.h (for now) which is needed.

Signed-off-by: Rob Herring <robh@kernel.org>
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/r/20230823165637.2466480-1-robh@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-davinci/pdata-quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-davinci/pdata-quirks.c b/arch/arm/mach-davinci/pdata-quirks.c
index b8b5f1a5e0929..b5b5c7bda61ef 100644
--- a/arch/arm/mach-davinci/pdata-quirks.c
+++ b/arch/arm/mach-davinci/pdata-quirks.c
@@ -5,7 +5,7 @@
  * Copyright (C) 2016 BayLibre, Inc
  */
 #include <linux/kernel.h>
-#include <linux/of_platform.h>
+#include <linux/of.h>
 
 #include <media/i2c/tvp514x.h>
 #include <media/i2c/adv7343.h>
-- 
2.43.0



