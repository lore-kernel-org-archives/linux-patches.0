Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09334078CE;
	Sat, 12 Sep 2026 10:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209679; cv=none; b=oRFLEJ9jPm0VpNYPaOBF1WyEFUC57bV5bXJzZyFhbRIynQItQ14DplzapIgWcXQIkjBsnIkeS0xLnQSu4c/Uz28jQzOrOSsN19YdA8EDpTMhGfkKTmF6TiyzmYiB/fI64K/NatR7vS+NJ1yfJFIATHCs70maIlhIER1tLFuewWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209679; c=relaxed/simple;
	bh=JeOcYisFhUL7w1OOP1qMS6UNkAUBfGtUNjw02Ihilu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MkHOV8Qub5YFX6b+WO7oirKXcQ2YpuXNUiclyro0rDQFgg8xXYJOEOIp2Cj7frIu1Djc5d366wwGa+C/PRE5xxXfS+L4nUQ/ER2FBoCbucGkYqMtmFToYKtCWRV3juQfqrWFGc9h4chtGOSJF3jYGcwbj+I1GO9EbcWvHQU1Q5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wBYqYZ4f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wBYqYZ4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A601F000FF;
	Sat, 12 Sep 2026 10:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209677;
	bh=0IPS4wywvKRwayxprYHPJa9eY1Y+ImyzyR6VafOOGCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wBYqYZ4f8o/9Y9BoNDva/u/r3ph+za2NS8GDxJxxfsis9fXwKd//dCG+hrurXdieG
	 cSY5mp6J3nnKEoxl/5J2rm5SF+S3hgkWOnnF7+ALkRUCTuR3kYpaOwP02Kl/io6yXt
	 BYZowDqDNOXEq4Cl+dM/B56ZxtALvvU9UxMHSR50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Akinbou Mita <akinobu.mita@gmail.com>,
	Andy Shevchenko <andy@kernel.org>,
	Christoph Lameer <cl@linux-foundation.org>,
	Joern Engel <joern@logfs.org>,
	Kees Cook <kees@kernel.org>,
	Pekka Enberg <penberg@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0868/1518] lib/string: fix memchr_inv() for large ranges
Date: Sat, 12 Sep 2026 08:50:37 +0200
Message-ID: <20260912065643.085392937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bradley Morgan <include@grrlz.net>

[ Upstream commit c04cffb8c51618538f0c05c478a931eb6e1a806b ]

memchr_inv() takes a size_t length but counts 8 byte words in an unsigned
int.  At 32GiB that count wraps, so the scan can quietly miss most of the
range.

Use size_t for the word count.

Link: https://lore.kernel.org/20260621121133.16460-1-include@grrlz.net
Fixes: 798248206b59 ("lib/string.c: introduce memchr_inv()")
Signed-off-by: Bradley Morgan <include@grrlz.net>
Cc: Akinbou Mita <akinobu.mita@gmail.com>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: Christoph Lameer <cl@linux-foundation.org>
Cc: Joern Engel <joern@logfs.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/string.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/string.c b/lib/string.c
index b632c71df1a50..01c9845024b85 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -839,7 +839,8 @@ void *memchr_inv(const void *start, int c, size_t bytes)
 {
 	u8 value = c;
 	u64 value64;
-	unsigned int words, prefix;
+	size_t words;
+	unsigned int prefix;
 
 	if (bytes <= 16)
 		return check_bytes8(start, value, bytes);
-- 
2.53.0



