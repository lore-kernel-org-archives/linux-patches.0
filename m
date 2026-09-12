Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898D747277C;
	Sat, 12 Sep 2026 16:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230736; cv=none; b=Am8g1ggFW9fVy9mFHAytHQmj2wO0/cD0ugSL1yuXp/1LuW89TP5hKG830Y+CqUE/d1YG5o2wM8t341som/fyjrSX5zIH0NV+Kg7OQ4qkA0jy3l3V1WAnA1aJfJJepDkk+EMZXnrmzrNNxVVXJknaSPaYtrZQMRlWuUnTvWWNYQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230736; c=relaxed/simple;
	bh=+NqXi5eniUdo4deh83GpAdFuz62TxQBuBNetp+rgcIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLkMldSmwU/SYuhJDtQ131NllYKjqeuLSUTpk1zzQ+Y8EVtFwq53V2cKC4A90P6zW9WQqITQK1vhWMexh347A+lr1BdJfxPfVq3Jo62u4SWa3C5RnHKK46o7mM61hZdslKG9vFsuYcsSAHWqWrNL6eZRftgYJ5OHv/yQIcP9qIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LlPHzDL9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LlPHzDL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCAB1F000FF;
	Sat, 12 Sep 2026 16:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230734;
	bh=KJPceKrEHmCDezb63uEfqjz3vT5OfENNLSdFwZLTcnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LlPHzDL9iR112Npj1EP006mRyAB6eD1G7T2mICCYNy1LnPzPoJYfY7ATv9D/hVX6K
	 9cBcCGdRyp83rpD91TKt3A7OW/U6QqvzvtRN7foB5jjBt9BKap1OJeGMGPmQAxMbHs
	 LIZfbBVbC7+wI20dOR2Y8ZxtNIMda+XojcfLp1Kw=
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
Subject: [PATCH 6.1 0855/1191] lib/string: fix memchr_inv() for large ranges
Date: Sat, 12 Sep 2026 08:59:43 +0200
Message-ID: <20260912065607.456132330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c4b8349ff0582..95b4e69b8d3cd 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -928,7 +928,8 @@ void *memchr_inv(const void *start, int c, size_t bytes)
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



