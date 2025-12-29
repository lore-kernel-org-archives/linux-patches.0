Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC55A23D2B2;
	Mon, 29 Dec 2025 16:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025355; cv=none; b=IQlTLeLxd4Irzf932RCktEWVOMUyKAh7kBiZKE6KNPbq4QOTYded1pvh37w2GQx3B6MaWCIILmLnhfbE9WxZjqAS1xNunLB/PJt+naja8C30Cew4kTeHCFQajGr8q1twdNUAV0eGdL3q26OT+iIoiT6I4xG5SxAN+HFs7/j6Jfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025355; c=relaxed/simple;
	bh=AC+3CpA4V/C1qrarpPIpXnIl2WDrVqDI1uIQGFf0nkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0kbRa3gsV6OgiCk41Vh1GXlKS+pN5FCKE3Fr3E03IlV0Tr+sHnd3JiMxg3jX5JqSNwCzCUeyBf9GNJhsRLJG+F2vytpm9ophWBx96ipDqzZj/gPo7CxXa4SJQspw9UmhnPkci3hLnATuqjJoIeFAxzjPkRjqAoqeiMgtQjSfvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xnEmD/br; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xnEmD/br"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1859C4CEF7;
	Mon, 29 Dec 2025 16:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025355;
	bh=AC+3CpA4V/C1qrarpPIpXnIl2WDrVqDI1uIQGFf0nkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xnEmD/br5hmbK2EHqzrm8ZicVx6oHKNgMiCjoJd1MOB5HAKwH5ghWpS8B2I//Fecy
	 7Swhoc0+C8Ir/3yAseddi8adpXhxOusiNH9XBKNK56AgQSnc1yYpMn0uQ2hb+j20ay
	 wZ83IZY4Tk9w0I7DPVfuiyQ1sGmsB4jPIbqGo3Dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tal Zussman <tz2294@columbia.edu>,
	Ingo Molnar <mingo@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	David Hildenbrand <david@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 167/430] x86/mm/tlb/trace: Export the TLB_REMOTE_WRONG_CPU enum in <trace/events/tlb.h>
Date: Mon, 29 Dec 2025 17:09:29 +0100
Message-ID: <20251229160730.509076154@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Tal Zussman <tz2294@columbia.edu>

[ Upstream commit 8b62e64e6d30fa047b3aefb1a36e1f80c8acb3d2 ]

When the TLB_REMOTE_WRONG_CPU enum was introduced for the tlb_flush
tracepoint, the enum was not exported to user-space. Add it to the
appropriate macro definition to enable parsing by userspace tools, as
per:

  Link: https://lore.kernel.org/all/20150403013802.220157513@goodmis.org

[ mingo: Capitalize IPI, etc. ]

Fixes: 2815a56e4b72 ("x86/mm/tlb: Add tracepoint for TLB flush IPI to stale CPU")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Link: https://patch.msgid.link/20251212-tlb-trace-fix-v2-1-d322e0ad9b69@columbia.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/tlb.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/tlb.h b/include/trace/events/tlb.h
index b4d8e7dc38f8..fb8369511685 100644
--- a/include/trace/events/tlb.h
+++ b/include/trace/events/tlb.h
@@ -12,8 +12,9 @@
 	EM(  TLB_FLUSH_ON_TASK_SWITCH,	"flush on task switch" )	\
 	EM(  TLB_REMOTE_SHOOTDOWN,	"remote shootdown" )		\
 	EM(  TLB_LOCAL_SHOOTDOWN,	"local shootdown" )		\
-	EM(  TLB_LOCAL_MM_SHOOTDOWN,	"local mm shootdown" )		\
-	EMe( TLB_REMOTE_SEND_IPI,	"remote ipi send" )
+	EM(  TLB_LOCAL_MM_SHOOTDOWN,	"local MM shootdown" )		\
+	EM(  TLB_REMOTE_SEND_IPI,	"remote IPI send" )		\
+	EMe( TLB_REMOTE_WRONG_CPU,	"remote wrong CPU" )
 
 /*
  * First define the enums in TLB_FLUSH_REASON to be exported to userspace
-- 
2.51.0



