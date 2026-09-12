Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5876135B12B;
	Sat, 12 Sep 2026 12:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217236; cv=none; b=bnVXsztMosIeLiY68kgVrsknqWMNkX0gF1yBVTtJVvreV2Gr3PbQPJIvQb//VU3XLjfHrqWxtngtMjqa5prgjRlZroW10c4Aa+xwB2jgmCUyra+WF3cMDAV5aLvH6cRIzy/HHa2RGgUvLp/9ygrn+qXlg8ob2zpWt4UzaWWXKAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217236; c=relaxed/simple;
	bh=jWmD/maGH/moIVWETjAgiaBafG2OOONd4c8IkfT1ooo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqYHBCp10pmD4aR9pCGOklBDFs833+ptmhf/NOwK1FP0Pq8doM1Y2pg/EKTvycFkeA+0A168jG7+bbC8cMQBpN6zhfSR0OoTQOCxaW+lb4xdtdWsJRFaQKx/O1vMFcp8gr3CzTNF2r3JBngxjjJ8Fe1ZwBGWueQbW2HIHi/rZdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cxot5ffs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cxot5ffs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56E41F000FF;
	Sat, 12 Sep 2026 12:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217232;
	bh=79I/Tz92y1FbeExQV/O/zr76yMrhWH9QcnhMcDwvoPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cxot5ffsr8d6+psiyZDYsb2xUbEs6z2oW3W+mMAGcNUczDtulwwLRSpgq+Yq1Fj6n
	 lMxTbyUij1zqDF2A9QsGCulYbbgne6cJVYSATD2eSvTGAt3ttaBQ0hsxegi5mJgTmc
	 lLjAcNc083Z7w+GaJhZqqe3jmbi7HN9vPi5QyXuk=
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
Subject: [PATCH 6.12 0882/1376] lib/string: fix memchr_inv() for large ranges
Date: Sat, 12 Sep 2026 08:55:08 +0200
Message-ID: <20260912065627.221161725@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index e657809fa7189..8d117fed31264 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -828,7 +828,8 @@ void *memchr_inv(const void *start, int c, size_t bytes)
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



