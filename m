Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497F113C816;
	Thu, 25 Jul 2024 14:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919314; cv=none; b=JT/FXAad1p/ln+5+gzBNDhtWXdnQKbLB5eSDsNNP4UcN7LWnYoH1AMlvC5Wl6KgL8HqXSHWujQrNYiBVvGBpMwXbzQtxHgL/Q/DNZfR9sWKJTenF+A2kLxEuhoiKCZkAAOCcaiIcjHwS1QMzlgGNitjh2fy95F9QHFF3BrJDm4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919314; c=relaxed/simple;
	bh=G6nmWHDB3/hi2c2fku5ZHyyqVACAoiZvw9NCoxA+dJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQYa94aMZg4SidhpbO2pTJDarGCsdtII6r7QaiaRMKUsT/q2kKQKiA5C0wYIgK9C66BBD1OcgZofEBmraVFHAgs/mUP9C3fc+bPGnxinA4fXoSrmxdHjKQCMfXssIfdcactBYwHJzIF5MLzFaI65eoCB/1gojea+uFgWhPXFfA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTQ5ffeC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTQ5ffeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC580C116B1;
	Thu, 25 Jul 2024 14:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919314;
	bh=G6nmWHDB3/hi2c2fku5ZHyyqVACAoiZvw9NCoxA+dJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTQ5ffeC3D59vaxY7eACpk/lq04TcEfpqxuPwtIWlCG1Eqv/VxJ1OEXm63AiFtgzC
	 DvNbqYbKFMHkcN9GVFBI5U1Yv5JqkYE/x1g/31KPa0UHWz92sptvgZidJlqNSVJ7dH
	 j0Y2d4wQUNn56/bCxGBIf0FRiSFmsSmg+L+u2WNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Herve Codina <herve.codina@bootlin.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH 5.15 67/87] minmax: fix header inclusions
Date: Thu, 25 Jul 2024 16:37:40 +0200
Message-ID: <20240725142740.960306698@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

commit f6e9d38f8eb00ac8b52e6d15f6aa9bcecacb081b upstream.

BUILD_BUG_ON*() macros are defined in build_bug.h.  Include it.  Replace
compiler_types.h by compiler.h, which provides the former, to have a
definition of the __UNIQUE_ID().

Link: https://lkml.kernel.org/r/20230912092355.79280-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Herve Codina <herve.codina@bootlin.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit f6e9d38f8eb00ac8b52e6d15f6aa9bcecacb081b)
Signed-off-by: SeongJae Park <sj@kernel.org>
[Fix a conflict due to absence of compiler_types.h include]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -2,6 +2,8 @@
 #ifndef _LINUX_MINMAX_H
 #define _LINUX_MINMAX_H
 
+#include <linux/build_bug.h>
+#include <linux/compiler.h>
 #include <linux/const.h>
 
 /*


