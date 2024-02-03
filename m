Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FDC1759C;
	Sat,  3 Feb 2024 04:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933575; cv=none; b=ZIri2OqdZ15xHPEAp12i466iedslnA8u8QdDKQIb1dTEabW2YnlQTDwdSpT7vkkkn+yzqxHtDGG8AiUTWnjhsTw1TzsgwMokqqQmPwIGj6lTzO9DOP6EFIsa5pE3VZyROSlbmgvRo8YIAbo61yw0hnVsYBiR2I5AN26NI2oBOu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933575; c=relaxed/simple;
	bh=wwRYeqNHJY8fNBNkD7rnEczt1YiYTBoxWYQebK0rjLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPaVVUp+tzkV9a5+3R1SfEQgfvdGOO94Oc/Q6hIhHYL8tYtKRE8AlE921Wr5NFC67NyDNJS5Y/qC7jF2Tej7TcMsbetps0bNxj7xN6haLK19teUr9jzu7qcafzMTHykXQH2f55p/74voTOIpwkvqQVuAJVu1Z3uy7UqHHqBouyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CD6fOVRV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CD6fOVRV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933AFC43390;
	Sat,  3 Feb 2024 04:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933575;
	bh=wwRYeqNHJY8fNBNkD7rnEczt1YiYTBoxWYQebK0rjLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CD6fOVRV98StszYqwjV7qqGnE/kQJGSvwC/t3n5nNdB+H6b8LJHCsXeQPXO7i6y13
	 tormxsmuWOaDepKfPyME1YoukAbfW90uF8p+frAZTaHooCW5yHxyyGWlIB3B7KxjS8
	 OKT5VvWIl0xhuaIORf9oMoa4+XfC/Kw93gOGipP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Herve Codina <herve.codina@bootlin.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 095/322] minmax: fix header inclusions
Date: Fri,  2 Feb 2024 20:03:12 -0800
Message-ID: <20240203035402.213856207@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit f6e9d38f8eb00ac8b52e6d15f6aa9bcecacb081b upstream.

BUILD_BUG_ON*() macros are defined in build_bug.h.  Include it.  Replace
compiler_types.h by compiler.h, which provides the former, to have a
definition of the __UNIQUE_ID().

Link: https://lkml.kernel.org/r/20230912092355.79280-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Herve Codina <herve.codina@bootlin.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/minmax.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -2,7 +2,8 @@
 #ifndef _LINUX_MINMAX_H
 #define _LINUX_MINMAX_H
 
-#include <linux/compiler_types.h>
+#include <linux/build_bug.h>
+#include <linux/compiler.h>
 #include <linux/const.h>
 #include <linux/types.h>
 


