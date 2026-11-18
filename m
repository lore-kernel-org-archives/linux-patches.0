Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028510;
	b=ksm0KeF8ELTc11Dt+C1S5QfKPZSWZ0tapwaCTkLPyt6h29Ih03UwGnjQwh9BJ6xl4E5M
	 D3GZR+od9pWWk7z2DRy9U1wQ0gjaKmaiPdjfKek0bVqC3A42Ota1tUhfkoCVLVnl4sKUy
	 cXxDKDgfuDwV5xgly3OLfdysYky5CFQpQw/XJ0p1oDT16VNoM/yzNXWCtnf9P5Jz8rlMX
	 10zXRpRbkyzQ4bacX4ROQI17VcrmxOO+gRXLmwpzEFgZxaTMA4RHWhPRRkxTgkVdqFJAP
	 vue3H2jLDJRAHFKxxtifiARbGG8JOamuiYnYLtY13v3Rk9m/ySXr7tUh7Mwf9Wpwajw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=lLnyEdHu6XOZ3G5L8uwZeWaS3CJeLiW1TBZVajnpZhE=;
	b=xzRNtXMehkrBbIjEdsaykA1jQjNqeIjEzrCwKAJU2kBPtjFeEJcH+7yu+2tGyTmJAJGi
	 X32AuSqzQDlhZ3pCu4dSn1l00FhUiCQLZqJDlyNg51QDLwenlZcQh3u4ykjwIEPXqdvv9
	 T48CCwIYsHfAxUfRU+DKDeHRnOdvWK+jtxCnJ/RTMh6y0YK8WlHQ8HXwjgKn0z1tnR0bY
	 rwASW/nhw8B3vEq+KkOSdidJMzQPeSqrR7OuTxXL9hDhuMVo03540vFLHZMvqxTxZHrqD
	 MhOZJEO3wQWPKri4TFNTWkPWr3vZMWJ0x1JLpxokLcXu8X+vbo6iDrAwGUG7zdMHoPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yZInKL7K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517E1606A33F;
	Wed, 18 Nov 2026 19:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yZInKL7K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F561F000C4;
	Wed, 18 Nov 2026 19:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028510;
	bh=lLnyEdHu6XOZ3G5L8uwZeWaS3CJeLiW1TBZVajnpZhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yZInKL7K/sLOjbfglVLt74YroFgJQvKOyasHm8zC807j4B97CqobyU82eRhjxO+HV
	 vXTvqpBaGcEj0Cbi+1hRcJAdwM83n9Pp3R0RGBqo5DDqCVKd3PHHlwJngFlQeaTE/3
	 1JiaJTWEZTg3vKwY8Cv4OeW0yLKNb6tcMi8Ex5Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vernon Yang <yanglincheng@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0008/1756] selftests/mm: include kselftest.h in vm_util.h
Date: Wed, 18 Nov 2026 15:35:35 +0100
Message-ID: <20261118150008.303866659@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vernon Yang <yanglincheng@kylinos.cn>

commit d8a866c766ebe34b4371d42f4a3edca200f5e645 upstream.

The 6.12.y backport of commit fdc3bc349794 ("ksm_tests: skip hugepage
test when Transparent Hugepages are disabled"), added a KSFT_SKIP return
to khugepaged.c, but the prerequisite include from upstream commit
d8a866c766eb ("selftests/mm: add commentary about 9pfs bugs") was not
backported.

As a result, the selftests/mm build fails:

  khugepaged.c:1195:24: error: ‘KSFT_SKIP’ undeclared (first use in this function)

Add the missing include, only the vm_util.h hunk of commit d8a866c766eb
("selftests/mm: add commentary about 9pfs bugs") is needed here.

The remaining hunks depend on commit 32b42970e861 ("selftests/mm: skip
gup_longterm tests on weird filesystems") and commit 571a4b62ed63
("selftests/mm: skip map_populate on weird filesystems"), which are not
present in this tree, so we don't need to backport the remaining hunks.

Fixes: 6cd1e92981f8 ("ksm_tests: skip hugepage test when Transparent Hugepages are disabled")
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/vm_util.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 823d07d84ad01..b3d1d17a09e4b 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -5,6 +5,7 @@
 #include <err.h>
 #include <strings.h> /* ffsl() */
 #include <unistd.h> /* _SC_PAGESIZE */
+#include "../kselftest.h"
 
 #define BIT_ULL(nr)                   (1ULL << (nr))
 #define PM_SOFT_DIRTY                 BIT_ULL(55)
-- 
2.53.0



