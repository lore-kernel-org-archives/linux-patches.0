Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE881210F59;
	Fri, 31 Oct 2025 14:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919480; cv=none; b=QTM8Z8BLV8z/mxpt6m5CbdC88pyrfXn+UfzhncpPxqEiTUzij6eTq+YJJ0gV8XzpagTia1mlH6okf9efEDBxBWfscbj4MzmweB2gNlRR0MDSFXQnpGnzZfNMWDKi0maEzc9P9HrbWB3HW8vHjKLrSfTHGgDCzr+nUZ9wgqyYot0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919480; c=relaxed/simple;
	bh=RkbUiZGquRUA2Wzra7OZRDG3gT/dBQWVjJoVEBzFi9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8OkRTi8xL8z0aRAqtBJJ9cNcMiXUGhPwdKK2Q1mG9DJrmtcAlInNOPZHoIjkmfTlXoHnwtcv3WrLR9+O0522f6yf8UGgfrdBtzZHevbSmdH4Cs5g6+iXlR6tRw2rcXJu2mdn/a/hTdhJY3EC4XqjOq0sAPRNZckwCmI4OG8jKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IPmyAJzZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IPmyAJzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765E9C4CEE7;
	Fri, 31 Oct 2025 14:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919479;
	bh=RkbUiZGquRUA2Wzra7OZRDG3gT/dBQWVjJoVEBzFi9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IPmyAJzZ8J0b01WInQyxKPyKlVLvuFY1/hgeLHkV5cLClKGE6kdo9ezMRcjG6Czq9
	 lPXsTefPKXkhzqzsTkVgNQs9/3LrW46beGxBf2TTGTnYimXMmtiW2jBdWs2hGTLsGz
	 EXVlNJ77dHloVCfgMESHmYa0/W4RWTdL2TyT/Cqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Yury Norov <yury.norov@gmail.com>,
	William Breathitt Gray <wbg@kernel.org>
Subject: [PATCH 6.12 32/40] bits: add comments and newlines to #if, #else and #endif directives
Date: Fri, 31 Oct 2025 15:01:25 +0100
Message-ID: <20251031140044.798677471@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit 31299a5e0211241171b2222c5633aad4763bf700 ]

This is a preparation for the upcoming GENMASK_U*() and BIT_U*()
changes. After introducing those new macros, there will be a lot of
scrolling between the #if, #else and #endif.

Add a comment to the #else and #endif preprocessor macros to help keep
track of which context we are in. Also, add new lines to better
visually separate the non-asm and asm sections.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Stable-dep-of: 2ba5772e530f ("gpio: idio-16: Define fixed direction of the GPIO lines")
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bits.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/include/linux/bits.h
+++ b/include/linux/bits.h
@@ -19,17 +19,21 @@
  * GENMASK_ULL(39, 21) gives us the 64bit vector 0x000000ffffe00000.
  */
 #if !defined(__ASSEMBLY__)
+
 #include <linux/build_bug.h>
 #define GENMASK_INPUT_CHECK(h, l) \
 	(BUILD_BUG_ON_ZERO(__builtin_choose_expr( \
 		__is_constexpr((l) > (h)), (l) > (h), 0)))
-#else
+
+#else /* defined(__ASSEMBLY__) */
+
 /*
  * BUILD_BUG_ON_ZERO is not available in h files included from asm files,
  * disable the input check if that is the case.
  */
 #define GENMASK_INPUT_CHECK(h, l) 0
-#endif
+
+#endif /* !defined(__ASSEMBLY__) */
 
 #define GENMASK(h, l) \
 	(GENMASK_INPUT_CHECK(h, l) + __GENMASK(h, l))


