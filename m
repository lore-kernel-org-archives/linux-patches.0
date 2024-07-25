Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FD919CCF7;
	Thu, 25 Jul 2024 14:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919320; cv=none; b=kkZCmiwiohyk/Lw4gudo4QNTS8w0ODMTbTecTGZC+oZIs9BQIwm1jnx1DgmWoDa1r3qI5odJ5AAvBeBAX7t/K36brcNWcBange6go2/aESPkbC8rpkQ6j1OrIg7boGr8n1mI7G9+zgw4tWYniNP16tAFGws1qoRSwZowsiSDa2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919320; c=relaxed/simple;
	bh=Hk8V3hPLb2lTgN4T2fzKNhCxpYqx0I35kUnm3nZFUbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/zQKqFicRgJcTqNJ+Xe8hKMqtTtz6aa/sAh9GOonlnQ2c4Ns0oANQewVYM3nDiSU4ly9j53sC1omwj1fIIU0wHLY6pQCXBfqidBXIn8aFBYMPaTi2P08QqluVEzomOYoJ84Bm3pASGo/y+nQc0g41AnMRSTUvpWgZyO+42zLvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BnlkyHX4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BnlkyHX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD6EC116B1;
	Thu, 25 Jul 2024 14:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919320;
	bh=Hk8V3hPLb2lTgN4T2fzKNhCxpYqx0I35kUnm3nZFUbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BnlkyHX4qH18EUW7Bc4qNWEqGiuYegIcTDFhPtfpHuDqIpvUKeky9uso0eMMD+cAh
	 0Gc6gIS+hMc6WejjGiSIix7kSoNPzYakjyYi0dbmvMetjPOSLSpMxKSLEaR8m3Y+CD
	 SLRdh6aY1R92ivaCN6vUawzupBXAfdtNIYUaeYig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight@aculab.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH 5.15 69/87] minmax: allow comparisons of int against unsigned char/short
Date: Thu, 25 Jul 2024 16:37:42 +0200
Message-ID: <20240725142741.035963234@linuxfoundation.org>
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

From: David Laight <David.Laight@ACULAB.COM>

commit 4ead534fba42fc4fd41163297528d2aa731cd121 upstream.

Since 'unsigned char/short' get promoted to 'signed int' it is safe to
compare them against an 'int' value.

Link: https://lkml.kernel.org/r/8732ef5f809c47c28a7be47c938b28d4@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 4ead534fba42fc4fd41163297528d2aa731cd121)
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -25,8 +25,9 @@
 	__builtin_choose_expr(__is_constexpr(is_signed_type(typeof(x))),	\
 		is_signed_type(typeof(x)), 0)
 
-#define __types_ok(x, y) \
-	(__is_signed(x) == __is_signed(y))
+#define __types_ok(x, y) 			\
+	(__is_signed(x) == __is_signed(y) ||	\
+		__is_signed((x) + 0) == __is_signed((y) + 0))
 
 #define __cmp_op_min <
 #define __cmp_op_max >


