Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BC1330B2D;
	Thu, 28 May 2026 19:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998136; cv=none; b=UAAm3ilhXFxmV//3wXRR/ZNZKBBOfymxGWNgqjGBJTFTQQ8ueQCRyOT1EZeSc78hsUV4kl9K150FtwgeaNexJaSOc6SYtK+9DbqVuminSQXUtjQ1v5rRLi4cg1tTj4S8HxcAgTrVJSkAAvQbfTOUcZSZ4ONCP/pIIy5YR8ZCZsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998136; c=relaxed/simple;
	bh=+wUaEtR6IF9/wX7f0ARCTjQOI2/mo+Yj112pydTXUAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5aZpJ+CNm6yo9CcIQ5kf8O9knTi4WdRq1yylHxWC0i7Qp3HdZJnmG7gnBVGjKj3w+Lo4VfKDznVMqV3R3ybdbQyT/qzAWDoXnrVo0CMjqnUjyN7/ttX/Gbwg+S2iJ7VbUpQFQrFuAGTfAZHAWib3xrWsvYWV8YECsRVPDc+GEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kj7zVUF3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kj7zVUF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C80A1F000E9;
	Thu, 28 May 2026 19:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998135;
	bh=lFRqGSverpPqzzhutw9TU0GJ0FuDAWIjVC1LC8DeHAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kj7zVUF3bWwqzb/HKLciB80Tk4NPjqyOpgE8s8kO8TrUdXF/dEJRx3Mv/DgJB69Gb
	 iIEJCPp93r74xxxef6VMfmcQVQ+HcaEamq64Kxvk0Qkw2iOxqCBmtamwRLouCaHAtO
	 dWjdRC2MbuSFZdBIJkDK/4KmJtKhEhpEJno1JgiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 039/461] mm/damon: fix damos_stat tracepoint format for sz_applied
Date: Thu, 28 May 2026 21:42:48 +0200
Message-ID: <20260528194648.028751438@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 620072fd783290ad92c2d445a47b0a61b161f352 upstream.

The print format is wrongly marking sz_applied as sz_tried.  Fix it.

Link: https://lore.kernel.org/20260426193119.88095-1-sj@kernel.org
Fixes: 804c26b961da ("mm/damon/core: add trace point for damos stat per apply interval")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: <stable@vger.kernel.org> # 7.0.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/damon.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/trace/events/damon.h
+++ b/include/trace/events/damon.h
@@ -41,7 +41,7 @@ TRACE_EVENT(damos_stat_after_apply_inter
 	),
 
 	TP_printk("ctx_idx=%u scheme_idx=%u nr_tried=%lu sz_tried=%lu "
-			"nr_applied=%lu sz_tried=%lu sz_ops_filter_passed=%lu "
+			"nr_applied=%lu sz_applied=%lu sz_ops_filter_passed=%lu "
 			"qt_exceeds=%lu nr_snapshots=%lu",
 			__entry->context_idx, __entry->scheme_idx,
 			__entry->nr_tried, __entry->sz_tried,


