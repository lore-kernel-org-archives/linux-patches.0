Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208380;
	b=N7XWCbZRkEOmnabQlZrzESXEUW00HTBpRrttPhPOWLy3DbTzC0sbFsqThCe9Ye1dn3mq
	 6yXRPljdqkJ9x/+5fodxjDLDu1TCS8FIUBpn0yms2I3PTdf6JvZSIKxT2ppC/j8A2xuiw
	 ksPbY/yX0jTPeJCB4ba/sc6D6SIjUWIdKv2iomQZcstrh71BPz9MrV/px3VZwxvDtYjr+
	 /Fgd0jnEiegOqWG5iacS2lydfZO4fki/54L07vhCdQvsL1OtyDIUjSwOmZfV8Z7Sb+wVk
	 E87daRhLXZf5kxFGTCpYjdRc5hk4VDx0+vmNi0yAwsZKMn23wFy45reHGaz3G0gzpaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oJkFOodxG63wb4KBfnFMTEkYStWVWJ6fFPBnnos15jc=;
	b=0ElbHpF7lI28smTOfuL9mDDmSN6lo1HexZEELs9/kL3yE4IkxqtWqsMRbRBCVb2E8XMs
	 +oVrj526nd96RkrXW/GA07Pyt913pEaZ4YhoQfBsOCasW8BpY9QfG3J8XsBimXdZNYPOF
	 0LTAKfWRGxTNQ5UguLyz2dt6OG2z0Gv1vQx8InNVvR9WELtnuVVb8oD4Rq9uc4R1qA2gd
	 wye5jf7Z4Cn7Cf72BWzHzkJJNbdxwVkf/VqdCYeFGzwjsbRLoKzGM4qTG2KmSItzxDJLr
	 l2eTP9IkEF/MPBHBn9vk64BJErLkuZtTCWhA2JXFHGkI26JYRhMTHbLXbDP7MuqW4Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZN5GTbmx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75976606A320;
	Wed, 28 Oct 2026 17:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZN5GTbmx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40051F01828;
	Wed, 28 Oct 2026 17:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208380;
	bh=oJkFOodxG63wb4KBfnFMTEkYStWVWJ6fFPBnnos15jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZN5GTbmxtLT3gFUlh86qrN2hWfTj464+7aCv7n13SQpAwB4IsLMdZDeY9SVl5qbEk
	 e8rEoJW9cu4GFqaVb6HREVN4QYDiMP/md65MSOLkzUtJPuSnO2O9H28sTvmFjO4Cdq
	 aLzUZd8OXkLt6U2q7wwseS/N805WtWWJwYS+lx+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/516] params: Sort headers
Date: Wed, 28 Oct 2026 17:53:28 +0100
Message-ID: <20261028170004.856222801@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b930d3a4677cc..94ee86e6f8fe1 100644
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



