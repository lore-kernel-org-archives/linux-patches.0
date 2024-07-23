Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42C0156F37;
	Tue, 23 Jul 2024 18:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759169; cv=none; b=CblMsjsxkZJ4tcmbJUd8451qmx5N1WKyWp0JYQTBu/LjCZihUKuVKWAezdXlNfT0Ih5A4dS5Tdfafosecm3cTFN8kpbhgYxxH/Ofljx+rxZUy0geA22y8Ab7hWXPUjj9lyImPtuTFfYyXsDms6rvuYstfG4b+q4ArJNcNwkfN3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759169; c=relaxed/simple;
	bh=hp9vlDS3eAH8VPHBNBB4ATJb5pueU2+G9BdFw3oC2vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pjfk0J61ZA8KtQBvDB0WuPuqn06SeLYBTqp03IgULUg87XBZIFQSBiFw2apH0rohaqW9S9bGLoxYVk9CtNCZQpK5QbYWiOIjs5WDXlVG3EVlJ9QxsH1vgpXk4UoUUYklI/KAsbhc7LDCFRgNW3yBNw1elJh1mM+F6Xm+WhBK5L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U9ejZf4G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U9ejZf4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A031C4AF09;
	Tue, 23 Jul 2024 18:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759169;
	bh=hp9vlDS3eAH8VPHBNBB4ATJb5pueU2+G9BdFw3oC2vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U9ejZf4GOyRgRnMMl5QhdtzB+xKyyse9DCjkBAvNaZ4oSyXtZmBlAhGe4Phi18q8A
	 kJTUSZ7G+RlU35JD1+3gdBbM92Yfa4ms9cbVsr38Tlh0CdgqE8woNItqRla3vih0bE
	 sKS16eyGxsDrULDvq1nHT8tLRcHj7QlqCER/aW0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Herve Codina <herve.codina@bootlin.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH 6.1 003/105] minmax: fix header inclusions
Date: Tue, 23 Jul 2024 20:22:40 +0200
Message-ID: <20240723180402.697629523@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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


