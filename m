Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700FE6AB9
	for <patches@lists.linux.dev>; Wed, 23 Mar 2022 23:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A593C340EE;
	Wed, 23 Mar 2022 23:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648076748;
	bh=ZCU7Of7v/lbpEDiuwt7YJBx0glvj//0sL5U6XPWuRm8=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=q8+CzY5cObzizqx7MSOf4N3KeqJyEUK7GemzmT7ZHELqvCkn7NluGAvzBCNTr6VDN
	 iOlL9cFZmLKVXVlrHbOCu7TeIpuhlCWS33eiYgpEeIwEfQPi3aw7t0gA/qL2bn7g+I
	 dgv+Xw3shw93ug06OL/4IaqV5uJGS9ChsAT6wZNM=
Date: Wed, 23 Mar 2022 16:05:47 -0700
To: peterz@infradead.org,jsd@semihalf.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 10/41] bitfield: add explicit inclusions to the example
Message-Id: <20220323230548.3A593C340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: bitfield: add explicit inclusions to the example

It's not obvious that bitfield.h doesn't guarantee the bits.h inclusion
and the example in the former is confusing.  Some developers think that
it's okay to just include bitfield.h to get it working.  Change example to
explicitly include necessary headers in order to avoid confusion.

Link: https://lkml.kernel.org/r/20220207123341.47533-1-andriy.shevchenko@linux.intel.com
Fixes: 3e9b3112ec74 ("add basic register-field manipulation macros")
Depends-on: 8bd9cb51daac ("locking/atomics, asm-generic: Move some macros from <linux/bitops.h> to a new <linux/bits.h> file")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reported-by: Jan Dąbroś <jsd@semihalf.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitfield.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/bitfield.h~bitfield-add-explicit-inclusions-to-the-example
+++ a/include/linux/bitfield.h
@@ -19,6 +19,9 @@
  *
  * Example:
  *
+ *  #include <linux/bitfield.h>
+ *  #include <linux/bits.h>
+ *
  *  #define REG_FIELD_A  GENMASK(6, 0)
  *  #define REG_FIELD_B  BIT(7)
  *  #define REG_FIELD_C  GENMASK(15, 8)
_
