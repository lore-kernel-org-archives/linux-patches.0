Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210535;
	b=Nps+cs3Mcp1aDDEA1bxOGsfgManrS0MhfBPQ+ctR2JTUa7kgd12sgPPuPTwpzut3y3oa
	 MhOHuy6Dk8ncQhOJNZxa4pjdNgf+Cq1T96HlRjsEaMWr9SPb1d1xNtofujAu7PBknYM78
	 SRYlLF8XSnouCGB4vGn3izvV1gU571kMt90yADE7GjNvNkwoc18uWRP2K5D3QfC6VdfFp
	 zjY5kZ2s+7KZ+RMcevfaPSIQRvhlq7zKu6ouSlpHvbYV1RuRXgT/uEGI1khbvDwIZbDaE
	 D5Z7UOGh9pvMGyXu0ZE/EoNACBit6w7VEwo6zYRu1iKm2rpvxJ6yx+aFAADRgu14kUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n7pBxoAPO/of2XKB+EjO3A27LM4vfIfeNf9l//CoUmo=;
	b=HEBvoDz1CUOGOnVDAk5NIhzR7iXpfncAMzIbWiuX4VnfOuonueA0RngQM0+Uk5/O9NVc
	 mpkmkRE9leokbi+N9BRqjveLbzctlT6E13fiImmEDWfQyU8NEXN7B91V1BfaQNVRnPNIe
	 lRRDHYn1iSckOsQUrT0LBY3ws0U24zNFs6soH1a8zeksP1GUN62BhoBZKydsJkky0JQ/Y
	 2FfMKmijo+DDigkjV35bgUd1+ek79RcdLUhzLUqwcZoae4tfxlak/Vx1X1vZgEicCGzqA
	 a3cszBzo4uApE2jKiwV10HbZ6u+LRTxuggtXwq2VsHvN6UBoZ6QD2OP9MIChyPih57g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YWQQWRge;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB0C606A31D;
	Wed, 28 Oct 2026 18:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YWQQWRge
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5D91F01825;
	Wed, 28 Oct 2026 18:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210535;
	bh=n7pBxoAPO/of2XKB+EjO3A27LM4vfIfeNf9l//CoUmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YWQQWRge03ji6NWnUQN69Yi7LH2d1oufS3QJaI23J1bgI5+swNKmsl8UEKmwieO4w
	 tp+Ztx8Ef/DKMBbEFWvlHeGYxPwaqz8WFpkOdKKFQUDjLnl6w3SLkoe1dH2nfcDI2z
	 97+PxUPA/hoEtLIuj3GjKnS15I6HroQy/ssJoz/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/571] params: Sort headers
Date: Wed, 28 Oct 2026 17:53:27 +0100
Message-ID: <20261028170009.451418369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0139fe38d0b2a..dc714a1c67cc4 100644
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



