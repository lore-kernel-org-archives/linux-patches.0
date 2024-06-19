Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A97A1459F2;
	Wed, 19 Jun 2024 13:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803648; cv=none; b=adfItWqOCRX/wEwGiCzVgnPv+8JBTUKIyEDP4i4EgRCs+dJiKK1SuFT8kgzcBKxXNjSIs1Ww5YXDpDnI6nI9QB25ksOjvmlO9mQZTJ64fR9Q1WC/K6nD3zT7uBNKxrv+rFP8IbpD3hBTkckop7Cwts+JeSkM20+O1jIL/Hc/7cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803648; c=relaxed/simple;
	bh=/MMWP9qCNXvDCGQpNqsk5eokysqXk1MLgII2qkEp0Ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QSLpJVGSmOMo/gwFXNByrI9l9yE61km9PcOEky+grxx14Q4gZp+dPKhzdYaAY0PsxOqbV7n6WECUN53l48KepUDajHDWK6REvs8KUscIA9acEKQH6pf7N1FHhp9aHwDxtqlkXX1eXIXu9P21wEVhqZVGxYCkA9Wwuxz0oXnlKow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z41bV5Go; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z41bV5Go"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C20C2BBFC;
	Wed, 19 Jun 2024 13:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803648;
	bh=/MMWP9qCNXvDCGQpNqsk5eokysqXk1MLgII2qkEp0Ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z41bV5Gob5muxZmOeep0UHcTqDutRfDQgj5yAGUy8a2JctO/QURdUs6K0OljFies4
	 a5uIjjJztYasVvI8BS3za5G+mEuO2mZimjCrH4HiXcR4kvXfPGwckvWLcvk/FfbUG5
	 bBOXItRonSk2FFYK89MHBb2IjJjIURfSQaiabDgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/217] xtensa: stacktrace: include <asm/ftrace.h> for prototype
Date: Wed, 19 Jun 2024 14:54:59 +0200
Message-ID: <20240619125558.842077738@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 1b6ceeb99ee05eb2c62a9e5512623e63cf8490ba ]

Use <asm/ftrace.h> to prevent a build warning:

arch/xtensa/kernel/stacktrace.c:263:15: warning: no previous prototype for 'return_address' [-Wmissing-prototypes]
  263 | unsigned long return_address(unsigned level)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Message-Id: <20230920052139.10570-8-rdunlap@infradead.org>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Stable-dep-of: 0e60f0b75884 ("xtensa: fix MAKE_PC_FROM_RA second argument")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/xtensa/kernel/stacktrace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/xtensa/kernel/stacktrace.c b/arch/xtensa/kernel/stacktrace.c
index 7f7755cd28f07..dcba743305efe 100644
--- a/arch/xtensa/kernel/stacktrace.c
+++ b/arch/xtensa/kernel/stacktrace.c
@@ -12,6 +12,7 @@
 #include <linux/sched.h>
 #include <linux/stacktrace.h>
 
+#include <asm/ftrace.h>
 #include <asm/stacktrace.h>
 #include <asm/traps.h>
 #include <linux/uaccess.h>
-- 
2.43.0



