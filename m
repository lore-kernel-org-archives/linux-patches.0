Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1F31FE44A;
	Thu, 30 Jul 2026 14:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422967; cv=none; b=mKjp8HMy2N8tnXW9+KrA6bg9aNtJmY7Ibin8sP7IexYLZJicqgubnJRW9KNjuYZnlrsWsawFm/lQsQW0OWlIZnNyJNTa8ej9OihciP6sCEJQiM3CN6KcvureEgQEE4oEYcAYYC+G2+acS5DUl6hNhZD00eS4FHkvhSz0vEoMDjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422967; c=relaxed/simple;
	bh=Po2wj0UYpboRlrCYNi+FTGHCXIIFDDWrZVTpv/4w+IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n30ZmQtJQIGvctmJiSbaWpXCVOk4914ZQfdJJpEYNhITKc3Qb/GFw7HGGwYuXr3LVHnhjqaYRGTkrFDvyqo9gSXYV7r80S9AlM0lI2SjCmvZlo1U48pZ4mMheCbzEr2s0Vuv/l8TahLbVLsoTEQ503s/StR9S8cUKcau8Kmbanc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lbRms1AC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lbRms1AC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D2A1F000E9;
	Thu, 30 Jul 2026 14:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422966;
	bh=VyCbdOCMvm4691mv1GKx/0AdZT5uDjU/7pVdcOp1o/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lbRms1ACdQ1rtiZwFjbFECrcW6MRGZLIiU2ozDGjXwuD5hBcBWOPpmi8GXJN4A8q+
	 sysP2jxCzhEvSOgytbVGHS1bs8LZOx3AmbBSivFqnpFasH85DLvFjMK376D2wEvJpq
	 0wk3hH3+GQF9IXsRC8UpuG5jUJN59Ud91RWZTqa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Yuanbin <xieyuanbin1@huawei.com>,
	Yi Lai <yi1.lai@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Borislav Petkov <bp@alien8.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 619/744] mm/memory-failure: trace: change memory_failure_event to ras subsystem
Date: Thu, 30 Jul 2026 16:14:52 +0200
Message-ID: <20260730141457.429850779@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xie Yuanbin <xieyuanbin1@huawei.com>

commit e57d6e9e20b551e4910d7a6331a81775c3ad6693 upstream.

Commit 97f0b1345219 ("tracing: add trace event for memory-failure")
introduced memory_failure_event in ras subsystem.  commit 31807483d395
("mm/memory-failure: remove the selection of RAS") changed
memory_failure_event to memory_failure subsystem.  This breaks the
backward compatibility, some user programs rely on it.

Change memory_failure_event to ras subsystem to keep backward
compatibility.

Link: https://lore.kernel.org/20260605081213.154660-1-xieyuanbin1@huawei.com
Fixes: 31807483d395 ("mm/memory-failure: remove the selection of RAS")
Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Reported-by: Yi Lai <yi1.lai@intel.com>
Reported-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Closes: https://lore.kernel.org/linux-mm/CY8PR11MB7134346A3E4BB28ECA28D6E989132@CY8PR11MB7134.namprd11.prod.outlook.com
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Tested-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/memory-failure.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/trace/events/memory-failure.h
+++ b/include/trace/events/memory-failure.h
@@ -1,6 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #undef TRACE_SYSTEM
-#define TRACE_SYSTEM memory_failure
+/*
+ * For historical versions, memory_failure_event is in ras subsystem,
+ * some user programs depend on it.
+ */
+#define TRACE_SYSTEM ras
 #define TRACE_INCLUDE_FILE memory-failure
 
 #if !defined(_TRACE_MEMORY_FAILURE_H) || defined(TRACE_HEADER_MULTI_READ)


