Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212215;
	b=W2IEs4C3MfFGWzf4NQvzWhohDLsQGM9isdNbb7PQ+sumG5t54TCOro4KGOTIMo+2h9Vx
	 9jJykv+LXdHhWFdfRiyzPCpggPU8YCConnSUOx4qbn8d/BaIv5OYHnWwq/kUmTXSd8xYg
	 b3JAT5MGPggJZBS6wUxktKzM0AGaecMQUaffDLtqYBExN41wHI1R0dB69rHaZdZlPlHro
	 c27PmyTprz+44o0rg3JwGBvFNVTDQq77fx5o0DQoyswq9lHHTMd5t6NyVtSqRzz/ima+z
	 uHDHu44yMz9OLCkywCAemYjz//lZBvTsl8bcece7hMCP37F0ywdc8PFsW2n/DRb5gbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212215;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8WjRHjpLQ1UN4mpmBosyC6QrEIRiUMTrNBJEj4sB6+I=;
	b=pw5umPsyUuDWiG1RBPRSyaRoNQwAGnWNAUHn+9t/9UTWAix/qgcalU1SfJkNFh5iS5rm
	 HaPm2kxBojNFlShDYWRRGPGazNyKHkxrBgIZzVADX16HBVxkd58jc+tmX96qrvATW5QHP
	 Z8wnqM9TcMDyOO8F6Nu44KOI4fzPaQ4k1O1nPoDxDNRO/C6T8t+xJeo/5IWD99YFnhEWY
	 O0iPJ19pq4nBEn1OmxW4HDCuL/PoG7RuSVvRdqkM5LqLdsGNfhv7yW7ogeHvaLGmyihx9
	 Fw7bARpTfVzsSdEaTVKZqHVQRfM0xK+owc3px02VpFt8fO8unyUh/VLqRywoT54lumg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=awU7eC8R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B71606A31C;
	Wed, 28 Oct 2026 18:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=awU7eC8R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B7F1F01825;
	Wed, 28 Oct 2026 18:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212214;
	bh=8WjRHjpLQ1UN4mpmBosyC6QrEIRiUMTrNBJEj4sB6+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=awU7eC8RKENgnYHIBlh1LMtPBGsRaBfvaLaB+8++zjRJVdgE3O2OpN/Iz6PDU19ht
	 FYL1Wo48bfDUCPm45EAsmmbrqn23bLaYUb9JA3W2yW8Hi2hPIJfd4HY49KYr1Y9tVF
	 /QRChAwcXbCRhMCtX1gR9XRRqaR2ZUGUo6/UipZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0079/1887] params: Sort headers
Date: Wed, 28 Oct 2026 17:36:15 +0100
Message-ID: <20261028170501.032658953@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4d021ba9c677a..8c51ce17862ca 100644
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



