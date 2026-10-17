Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED158392C27;
	Sat, 17 Oct 2026 16:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255930; cv=none; b=dcMIrvprMkNssakMqvp3PgDRBFjumahrIc4I64omoekJSpZAX6JupjSg6F5sFCEDTPKUWv/LK5ooubgb43FP+GWmbIBVRFWY9vhuhA2CsluiqAHUU32doECWzS4F7lhHzrMb9DvNy9z6f+8doFBdlYro6xEtK9r09Kvjia0GPA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255930; c=relaxed/simple;
	bh=pX+o3GW1HOCjzkTeuFaIlubwdKuxF8Ctc+0MfXCkZCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIW2/mu4APUPOnIebmTK0rDFvbMNJrAY8mvWDrP4GZ9l2LWwrfB7xp5D8brIj5w6qdQxcLIDlaqNod1RTMp5hh0/jWJMzhHbK9kizxBIUtCwq/ynzVuIY3vUebR+2RAtiZ1S9CvhhTcUUky1ILvHBrazC0lo+LBAI2u5CUM6QiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zLBXucrF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zLBXucrF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423301F000D1;
	Sat, 17 Oct 2026 16:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255929;
	bh=EpnFY7Nh8McuhiGqXjHNOVtNJoMiJv1wD/OJa0XDhjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zLBXucrFWnUFoWVipoS5JU21rJ+dJPDcXjqEXiJW4YN9ghMb0BZUZNmgDveGoYir6
	 8y2sObJ6pavB2Jr0VdU+JLLfni/OdLF/+M5AoB59hDa7gqYqNE0OM4lAbUKZKRuylT
	 LG11vSuRMKmis+EvHAhjfushyidHgmOAdDbGamY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0066/1674] params: Sort headers
Date: Sat, 17 Oct 2026 17:38:58 +0200
Message-ID: <20261017160432.831180934@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit a05f096c2c0ca52e8fd34740c7d4b53ab3e7123e ]

Sort the headers in alphabetic order in order to ease
the maintenance for this part.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20231120151419.1661807-5-andriy.shevchenko@linux.intel.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Stable-dep-of: 3dfaae04243c ("params: fix charp corruption on allocation failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/params.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index 1efc083b651c9..8e085de8551c3 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -3,18 +3,18 @@
    Copyright (C) 2001 Rusty Russell.
 
 */
+#include <linux/ctype.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/kstrtox.h>
-#include <linux/string.h>
-#include <linux/errno.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/device.h>
-#include <linux/err.h>
 #include <linux/overflow.h>
-#include <linux/slab.h>
-#include <linux/ctype.h>
 #include <linux/security.h>
+#include <linux/slab.h>
+#include <linux/string.h>
 
 #ifdef CONFIG_SYSFS
 /* Protects all built-in parameters, modules use their own param_lock */
-- 
2.53.0



