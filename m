Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027870;
	b=UFgyxV6IcteS/Bb07zoVVq1CsBiyPHP0bN0G6tp3bEBR0YBspxeD5uvkTZ1cjOKwFf3v
	 hRjYcLbuUB0SnYKbTqvV12+xW7kVa/FjmReDFzzH2I/t/sunv84ME8Lm+kC6seCjTCeBm
	 LqoHkRfrwQdKxt+1yszj96LKUrnTBi8DdccMiazyQj3EkGFZCZhHfrLW3v2qV03QhFZmr
	 pDi6V8v58lPirfW0CNKjWdvvgZFTj8mGdfPrxzuisyQr077uyHzD9T5nt8r9VvOKIXObV
	 646KBlGZF0n4HMkaHjkjx8Y0Dz5dpDgODZJb+cAat6XCcCqB5BBGOJTNW3P7nu3fTPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027870;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X6/4ftLvAmVfWVSZx1yFQy50SmE2DQfr2w08Ga8R4Bw=;
	b=A/4At4WA+LFeu/XbLGLs9jmkCkpy7/L7upe6lRl7uhoEZ7clICW/nhW60NHRdb0aFe0w
	 8vL25DZBf29PvlxsT+CePDYrFG8naafJB3AIj+NJKd1+ZQouY+kKY1wWmvQO7H/+lXtBs
	 DbLVd6Rg6+UggZEUkaaj7fBWsniR447iYDmskcaavfXxX4gnBWZNgjVwOYYhrTjFux4q/
	 KaTlXGaK5MKcE1SKNOX4on24tA/RrF0hESKms1eEFKCJkblyHYmc9EUoWdyp/wsZvBqaD
	 ePq29Y9E0eM2yPtMb/Y2sO9zKF7Qy6yru5bkgExKJI3n6xq6kSwwfg4DDKnkQGU5JFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iWibCrCx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B96B606A31C;
	Wed, 18 Nov 2026 18:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iWibCrCx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F901F000C4;
	Wed, 18 Nov 2026 18:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027869;
	bh=X6/4ftLvAmVfWVSZx1yFQy50SmE2DQfr2w08Ga8R4Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iWibCrCxBvKZrKwnkRLKi5FzXM0NFSx0KmG4PsCBQc56C7QBHCd1puMTxV2pwGrFF
	 l3kIf6VLS6Sxk8Nc41SfQgez5jNE6uBsOlQ7v7SHnI720Ma/bLSAWjWpwXA/AXVNgf
	 JNS6OOvriL99zvlQmPXwY9Mg+JUEfhlE3wGxiDOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ting-Han Hou <ue081723@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Kuan-Ying Lee <kuan-ying.lee@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1941/2151] scripts/gdb: fix stack depot out-of-bounds diagnostic
Date: Wed, 18 Nov 2026 16:01:16 +0100
Message-ID: <20261118150232.476601441@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ting-Han Hou <ue081723@gmail.com>

[ Upstream commit b6232ca8d194c60ee603586e42b5ea584d4b7be9 ]

The pool_index field was renamed to pool_index_plus_1, but the
out-of-bounds diagnostic in stack_depot_fetch() still accesses the old
field.  Looking up a handle whose pool index is outside stack_pools
therefore raises "There is no member named pool_index" instead of printing
the diagnostic and returning an empty result.

Use the already decoded pool_index variable in the diagnostic.

Link: https://lore.kernel.org/20261011023044.1722-3-ue081723@gmail.com
Fixes: 9d938f40b228 ("scripts/gdb: rename pool_index to pool_index_plus_1")
Signed-off-by: Ting-Han Hou <ue081723@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gdb/linux/stackdepot.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gdb/linux/stackdepot.py b/scripts/gdb/linux/stackdepot.py
index 37313a5a51a0d..aaa18af25cd12 100644
--- a/scripts/gdb/linux/stackdepot.py
+++ b/scripts/gdb/linux/stackdepot.py
@@ -39,7 +39,7 @@ def stack_depot_fetch(handle):
 
     pool_index = parts['pool_index_plus_1'] - 1
     if pool_index >= pools_num:
-        gdb.write("pool index %d out of bounds (%d) for stack id 0x%08x\n" % (parts['pool_index'], pools_num, handle))
+        gdb.write("pool index %d out of bounds (%d) for stack id 0x%08x\n" % (pool_index, pools_num, handle))
         return gdb.Value(0), 0
 
     stack_pools = gdb.parse_and_eval('stack_pools')
-- 
2.53.0



