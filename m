Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4CE2C026C;
	Sat, 17 Oct 2026 16:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254404; cv=none; b=MPTqtbImizAC0Kb3v/R2vhmuTBxX2IeehawxW3/TUpF7CQFJxJrWS/nXG7SruCqFJwOGfmGXb8efuThjGRvN9RWSYFCo6UkmhI0cJCVnhwbXMXZVwIKY0VpT411ac2TP4Rt69eE2TLeEDEJ8b/wVrVioeo18K80vCM9PmStrWCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254404; c=relaxed/simple;
	bh=jeeK2VkDpDaXG+D+5+R85bZceqqfFOtscoEhmym8cdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eIbgGKm7OAN9LDcRjC37G1fozWLQgkarnBAB5Uf/aPC9xwnktJ27E0tdUhTlgqdVzhQpiC7zMjuDEE8+2qavAKXILB8L6xDRrf8yDMfr69utpX5/Q0DPTNpm4UFg3P/SUVjsK6OYknYUS3gu//DRpP+0s94ysF44bywQJRuQ4Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fuVC7/Vm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fuVC7/Vm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69AD1F000C4;
	Sat, 17 Oct 2026 16:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254403;
	bh=N7Fb7j+MCp+vJ0BtmAFOIbo1fpFynWDuJdDPyOpBsqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fuVC7/VmjsafyplTixW3MnVkofgNS0WTfCwz10gBTfO/aOMNJZprCmLdhKzGCwzIf
	 b//nZGIdvk6aihgOTKhf4/WogKz+t2nr7jdQp0j1bOxzrRGfmHhpIJJJfnEeBw8u+5
	 LUNaYveILD7fHcBYAvavMgAiuFoXObmTt3f8/PmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 436/869] netfs: Clean up some whitespace in trace header
Date: Sat, 17 Oct 2026 17:54:37 +0200
Message-ID: <20261017160048.318705388@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit d3d3ec86568090cc5a4501b745274114de6881e0 ]

Clean up some whitespace in the netfs trace header.

Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/20241216204124.3752367-2-dhowells@redhat.com
cc: Jeff Layton <jlayton@kernel.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: dbd6f56d975b ("netfs: Fix netfs_create_write_req() to handle async cache object creation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/netfs.h | 130 +++++++++++++++++------------------
 1 file changed, 65 insertions(+), 65 deletions(-)

diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index 1d9b068bb1758..59452f12dcbee 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -258,13 +258,13 @@ TRACE_EVENT(netfs_read,
 	    TP_ARGS(rreq, start, len, what),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		rreq		)
-		    __field(unsigned int,		cookie		)
-		    __field(loff_t,			i_size		)
-		    __field(loff_t,			start		)
-		    __field(size_t,			len		)
-		    __field(enum netfs_read_trace,	what		)
-		    __field(unsigned int,		netfs_inode	)
+		    __field(unsigned int,		rreq)
+		    __field(unsigned int,		cookie)
+		    __field(loff_t,			i_size)
+		    __field(loff_t,			start)
+		    __field(size_t,			len)
+		    __field(enum netfs_read_trace,	what)
+		    __field(unsigned int,		netfs_inode)
 			     ),
 
 	    TP_fast_assign(
@@ -292,10 +292,10 @@ TRACE_EVENT(netfs_rreq,
 	    TP_ARGS(rreq, what),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		rreq		)
-		    __field(unsigned int,		flags		)
-		    __field(enum netfs_io_origin,	origin		)
-		    __field(enum netfs_rreq_trace,	what		)
+		    __field(unsigned int,		rreq)
+		    __field(unsigned int,		flags)
+		    __field(enum netfs_io_origin,	origin)
+		    __field(enum netfs_rreq_trace,	what)
 			     ),
 
 	    TP_fast_assign(
@@ -319,15 +319,15 @@ TRACE_EVENT(netfs_sreq,
 	    TP_ARGS(sreq, what),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		rreq		)
-		    __field(unsigned short,		index		)
-		    __field(short,			error		)
-		    __field(unsigned short,		flags		)
-		    __field(enum netfs_io_source,	source		)
-		    __field(enum netfs_sreq_trace,	what		)
-		    __field(size_t,			len		)
-		    __field(size_t,			transferred	)
-		    __field(loff_t,			start		)
+		    __field(unsigned int,		rreq)
+		    __field(unsigned short,		index)
+		    __field(short,			error)
+		    __field(unsigned short,		flags)
+		    __field(enum netfs_io_source,	source)
+		    __field(enum netfs_sreq_trace,	what)
+		    __field(size_t,			len)
+		    __field(size_t,			transferred)
+		    __field(loff_t,			start)
 			     ),
 
 	    TP_fast_assign(
@@ -359,15 +359,15 @@ TRACE_EVENT(netfs_failure,
 	    TP_ARGS(rreq, sreq, error, what),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		rreq		)
-		    __field(short,			index		)
-		    __field(short,			error		)
-		    __field(unsigned short,		flags		)
-		    __field(enum netfs_io_source,	source		)
-		    __field(enum netfs_failure,		what		)
-		    __field(size_t,			len		)
-		    __field(size_t,			transferred	)
-		    __field(loff_t,			start		)
+		    __field(unsigned int,		rreq)
+		    __field(short,			index)
+		    __field(short,			error)
+		    __field(unsigned short,		flags)
+		    __field(enum netfs_io_source,	source)
+		    __field(enum netfs_failure,		what)
+		    __field(size_t,			len)
+		    __field(size_t,			transferred)
+		    __field(loff_t,			start)
 			     ),
 
 	    TP_fast_assign(
@@ -398,9 +398,9 @@ TRACE_EVENT(netfs_rreq_ref,
 	    TP_ARGS(rreq_debug_id, ref, what),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		rreq		)
-		    __field(int,			ref		)
-		    __field(enum netfs_rreq_ref_trace,	what		)
+		    __field(unsigned int,		rreq)
+		    __field(int,			ref)
+		    __field(enum netfs_rreq_ref_trace,	what)
 			     ),
 
 	    TP_fast_assign(
@@ -422,10 +422,10 @@ TRACE_EVENT(netfs_sreq_ref,
 	    TP_ARGS(rreq_debug_id, subreq_debug_index, ref, what),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		rreq		)
-		    __field(unsigned int,		subreq		)
-		    __field(int,			ref		)
-		    __field(enum netfs_sreq_ref_trace,	what		)
+		    __field(unsigned int,		rreq)
+		    __field(unsigned int,		subreq)
+		    __field(int,			ref)
+		    __field(enum netfs_sreq_ref_trace,	what)
 			     ),
 
 	    TP_fast_assign(
@@ -473,10 +473,10 @@ TRACE_EVENT(netfs_write_iter,
 	    TP_ARGS(iocb, from),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned long long,		start		)
-		    __field(size_t,			len		)
-		    __field(unsigned int,		flags		)
-		    __field(unsigned int,		ino		)
+		    __field(unsigned long long,		start)
+		    __field(size_t,			len)
+		    __field(unsigned int,		flags)
+		    __field(unsigned int,		ino)
 			     ),
 
 	    TP_fast_assign(
@@ -497,12 +497,12 @@ TRACE_EVENT(netfs_write,
 	    TP_ARGS(wreq, what),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		wreq		)
-		    __field(unsigned int,		cookie		)
-		    __field(unsigned int,		ino		)
-		    __field(enum netfs_write_trace,	what		)
-		    __field(unsigned long long,		start		)
-		    __field(unsigned long long,		len		)
+		    __field(unsigned int,		wreq)
+		    __field(unsigned int,		cookie)
+		    __field(unsigned int,		ino)
+		    __field(enum netfs_write_trace,	what)
+		    __field(unsigned long long,		start)
+		    __field(unsigned long long,		len)
 			     ),
 
 	    TP_fast_assign(
@@ -530,10 +530,10 @@ TRACE_EVENT(netfs_collect,
 	    TP_ARGS(wreq),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		wreq		)
-		    __field(unsigned int,		len		)
-		    __field(unsigned long long,		transferred	)
-		    __field(unsigned long long,		start		)
+		    __field(unsigned int,		wreq)
+		    __field(unsigned int,		len)
+		    __field(unsigned long long,		transferred)
+		    __field(unsigned long long,		start)
 			     ),
 
 	    TP_fast_assign(
@@ -556,12 +556,12 @@ TRACE_EVENT(netfs_collect_sreq,
 	    TP_ARGS(wreq, subreq),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		wreq		)
-		    __field(unsigned int,		subreq		)
-		    __field(unsigned int,		stream		)
-		    __field(unsigned int,		len		)
-		    __field(unsigned int,		transferred	)
-		    __field(unsigned long long,		start		)
+		    __field(unsigned int,		wreq)
+		    __field(unsigned int,		subreq)
+		    __field(unsigned int,		stream)
+		    __field(unsigned int,		len)
+		    __field(unsigned int,		transferred)
+		    __field(unsigned long long,		start)
 			     ),
 
 	    TP_fast_assign(
@@ -587,11 +587,11 @@ TRACE_EVENT(netfs_collect_folio,
 	    TP_ARGS(wreq, folio, fend, collected_to),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,	wreq		)
-		    __field(unsigned long,	index		)
-		    __field(unsigned long long,	fend		)
-		    __field(unsigned long long,	cleaned_to	)
-		    __field(unsigned long long,	collected_to	)
+		    __field(unsigned int,	wreq)
+		    __field(unsigned long,	index)
+		    __field(unsigned long long,	fend)
+		    __field(unsigned long long,	cleaned_to)
+		    __field(unsigned long long,	collected_to)
 			     ),
 
 	    TP_fast_assign(
@@ -616,10 +616,10 @@ TRACE_EVENT(netfs_collect_state,
 	    TP_ARGS(wreq, collected_to, notes),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,	wreq		)
-		    __field(unsigned int,	notes		)
-		    __field(unsigned long long,	collected_to	)
-		    __field(unsigned long long,	cleaned_to	)
+		    __field(unsigned int,	wreq)
+		    __field(unsigned int,	notes)
+		    __field(unsigned long long,	collected_to)
+		    __field(unsigned long long,	cleaned_to)
 			     ),
 
 	    TP_fast_assign(
-- 
2.53.0



