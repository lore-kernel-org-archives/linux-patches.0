Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DE0325495;
	Mon, 27 Oct 2025 18:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591449; cv=none; b=gfaLyduQ5w5P8zjPSYrY3ksTdtEOdWtzA0HCCXipcKZBDCQnYbgwJ9y0PLxWmnEd1hpdRNJ/5Ig4tp8O/301/2a6tNJqlXYmKGrXX/TVCUMWc3UWMh8YIcUs7WpbJXoBtv2Bw5OQ0x1lsLGs1wWpfPaPL6k57RFqvPPNjZH/GvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591449; c=relaxed/simple;
	bh=XD9Wk3M/nd2NYZxq9blMecmlE5+YIJ3OlVlBVH6zki0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eL0jTYaJomA12sCidZaTGJS5qP36Q1OOoC0rYIk8AlgyJkwX/SKngHEv4SA/05Srmq90LZbgW2Pn1zPiEbfZauwjgtcuPjivAPM6Zrm9vj7EIuuLVs2hIPMuuulRubGcHV5F5AG0YzdN8mVvaVND4Gswe7R/Q3WkgmvTs1XrrUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U/Ex3hdH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/Ex3hdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114E3C4CEF1;
	Mon, 27 Oct 2025 18:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591448;
	bh=XD9Wk3M/nd2NYZxq9blMecmlE5+YIJ3OlVlBVH6zki0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U/Ex3hdHIiZuNqJrGJtEQdiHThJS41eCvFbD4KgjGoiDY2PCWwcYdlLtTF3elUPvu
	 9v8qC+xfazU4UrqkrlN7TuoHAybxXvy54UNUprnmDhMKOEIudlajNDwlfRDZRp4JSo
	 1OvOfEe84uOdtjSAYJMUc1jb+xTSuHuK9fVoa2/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Herve Codina <herve.codina@bootlin.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eliav Farber <farbere@amazon.com>
Subject: [PATCH 5.10 201/332] minmax: fix header inclusions
Date: Mon, 27 Oct 2025 19:34:14 +0100
Message-ID: <20251027183530.021732102@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit f6e9d38f8eb00ac8b52e6d15f6aa9bcecacb081b ]

BUILD_BUG_ON*() macros are defined in build_bug.h.  Include it.  Replace
compiler_types.h by compiler.h, which provides the former, to have a
definition of the __UNIQUE_ID().

Link: https://lkml.kernel.org/r/20230912092355.79280-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Herve Codina <herve.codina@bootlin.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
 


