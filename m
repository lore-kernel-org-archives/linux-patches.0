Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585365;
	b=00Am1ToSUckRCi3ecuvxCqrNgTyPbyGmB78e06m/yghm/wHThEYEqESbo0+ldbk2zNae
	 FyJJQXuSmeYFCXYdO68YIG53MxQwmAcufFx+Qgya9Qp+bsvjnZd/4oLHQgBR/5UTC9CuJ
	 mnJDXjnR3xVEIPVlcqPbF4sGSzSiafVH1CBzjkFNmoezI3DuNgaTzCx0MHfJEBeqpSi5c
	 YilxAwMFK/vACooRBqBnUyuXlbjfiw1wEnjCavkFMxUsrJCbSXrrPRGgP9K5HuHo+MVeu
	 w/PyKNDXx/qu/6mVJ3qrJrY7KwIXs+MKHxA8ojVbwQwyEm296TW1VOvOmPeAgHhWy9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2ZhKnBSDsBGxsSkSRHHGAizsbzlmcqtiiJ6lkeldc58=;
	b=Oe24QHme9HfpDdMjiwkztz8dcd79lOre5Xn50Lixg1oPMOWeSsgxhJ4wCAF1/Bc0gLmJ
	 gurG/Xwg8mTgLOoc4KxoAZv5sArOV90esmmVB5oDI0XHMWpu5Bx762TlPsmw23qo7RwbF
	 11+JVci7oizmmjPdn7DuMiRp8jDX2CHj02Fm419OzdoGjeupGIif3jzTWtpZW96qDK9xy
	 hPwkEwlz2BqhG4qLf2CsWWK43uugUAQN0Ym+kAcV76giZ9rqRVsyIctdcxkhkBPUmtEc/
	 5wQSos4scgqGOWL6PEac3ER7f87cZgaNFMi9kVmoX67eytGCWaEDEBkPF07ngqvAc6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RTJFAo0r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F42606EBA3;
	Fri, 13 Nov 2026 15:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RTJFAo0r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354131F000D1;
	Fri, 13 Nov 2026 15:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585365;
	bh=2ZhKnBSDsBGxsSkSRHHGAizsbzlmcqtiiJ6lkeldc58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RTJFAo0rMWgK8GHPmpDr988hS7z2HHDjzrkUJaTyy+3qneXlsHqhVJ3f8AdAeNc4a
	 zhh1MY5Lw+q164MOfwMz0SX10alogoQlhRK5GmIHrifqsg+5udbSgzR0gsOXWpngBr
	 8F83f038Gm/UgxBy5+sXd9Suo1M+W49NEgswmQS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Usama Arif <usamaarif642@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 042/507] mm/damon/sysfs-schemes: read sysfs_filter->sz_range only once
Date: Fri, 13 Nov 2026 10:45:46 -0500
Message-ID: <20261113153754.977434588@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

[ Upstream commit af19aff38d6faea35b10f26cca32d0e54f8aea5e ]

DAMON sysfs interface reads the user-provided size range arguments for
hugepage_size type DAMOS filter twice.  Once for validation, and once
again for assignments to the variable that will be passed to the core
layer.  If the user updates the arguments in parallel, an invalid size
range could be passed to the core layer.  Avoid it by doing the
assignments first, and then validating the assigned variables before
passing those to the core layer.

User impact of the bug should be trivial.  From the core layer's
perspective, the invalid size range is not really invalid.  It just works
as having a weird size range.  No critical issues such as a crash or a
leak could happen.  And sane users ain't do such parallel arguments update
anyway.  If they do, such racy behavior is arguably somewhat expected and
deserved.  That said, there is no reason to keep such races.

Link: https://lore.kernel.org/20260914142327.92510-3-sj@kernel.org
Fixes: ea1f204ba29a ("mm/damon/sysfs-schemes: add files for setting damos_filter->sz_range")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/sysfs-schemes.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 974c456a9e099..4ffc13ab95e65 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2831,12 +2831,11 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 		} else if (filter->type == DAMOS_FILTER_TYPE_TARGET) {
 			filter->target_idx = sysfs_filter->target_idx;
 		} else if (filter->type == DAMOS_FILTER_TYPE_HUGEPAGE_SIZE) {
-			if (sysfs_filter->sz_range.min >
-					sysfs_filter->sz_range.max) {
+			filter->sz_range = sysfs_filter->sz_range;
+			if (filter->sz_range.min > filter->sz_range.max) {
 				damos_destroy_filter(filter);
 				return -EINVAL;
 			}
-			filter->sz_range = sysfs_filter->sz_range;
 		}
 
 		damos_add_filter(scheme, filter);
-- 
2.53.0



