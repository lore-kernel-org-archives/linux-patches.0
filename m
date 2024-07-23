Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B92E157A4F;
	Tue, 23 Jul 2024 18:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759175; cv=none; b=C11YwtO2gTzrdTuPLEBb4192yUk7Yqs6tiCKCGDjl5gULrEQvSulnQMbb9VjDRbaZzrLzJJ9QaGrQtUCuzRZPtNsBcCGm1TgngJC/ncM/H+x7p2A07ekcVM3Ys9H/s+g8bxiW1r7PTK4BIzpheQldI5mvJIlBkniwWXbpcH7m7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759175; c=relaxed/simple;
	bh=xOUXOCQcWKdcJvhCy9DNymO0Uoz0+NahBFk30jQCBFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gpW4wRElakIaI/VGymvoznQ61AZnMbX8SSl1g8WsMi9jri0FwdF04Ydi0Y/xFUrQF7WEXTlbE8vVviXtI4HfupUYDA3iYN1DVBmV2016ACGfRRVaeURGsl+snCW7QWTFeNLV3z6cE26irxAyZ3CLFTlvKrQXwU9+E+B4rOVB6R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zl7aBcJ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zl7aBcJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6E7C4AF0A;
	Tue, 23 Jul 2024 18:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759175;
	bh=xOUXOCQcWKdcJvhCy9DNymO0Uoz0+NahBFk30jQCBFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zl7aBcJ/hD5w0tFUcLEstPF56lMPvPmdy00rwp5h5gRVPmfHCmkZFPdX5kIbzvDos
	 oy1VDUTDbwekWJgLEv1vfaB1zCsNIUqyoAikxn0SvXR1bYZDTu/da6OI1CWmHfiz4A
	 E017k4BnVngAY8297jg5apv0wslTUnGl18HcSSS8=
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
Subject: [PATCH 6.1 005/105] minmax: allow comparisons of int against unsigned char/short
Date: Tue, 23 Jul 2024 20:22:42 +0200
Message-ID: <20240723180402.823439361@linuxfoundation.org>
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


