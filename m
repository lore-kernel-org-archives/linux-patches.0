Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509FE175A6B;
	Mon, 17 Aug 2026 14:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977595; cv=none; b=JmhAGAeAXBHKhS4cMQuHd8DMpIpxw9tS8h2yE9395HypXs1yJl57afPElMZC6ZFcTob/p5e6lKtdsrmtbDq36y84Hwp2hAjTNhcpFyMBnlI5G5DFo7/yZvRnJBGWLxWMBXIhmD4sdY3ni+bau3I8tVXDO4hdv6hF572Zf4Bz4oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977595; c=relaxed/simple;
	bh=rWGHwyEyFSSxdgnPBeS2N/Zj2FkdMtJSYSsMltNKPX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTihgObfap2lxXeBZ4Pi+eTgCaJACw6gaBYTvrh7GaipSRHFUF49qFKf5zRpon6RQJP9QriIsOQlWz0NK2frvsXQxTB3wSMurKB6JlEcctE4jxuJWMnrtVUxCUVYHglGbWtZGrkaFhFMlq7eEzGntFM5bNQB7CAlJaYvJdjTUKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqz7I52r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqz7I52r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F101F000E9;
	Mon, 17 Aug 2026 14:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977593;
	bh=KiUeQCshx1EBhk7YDFpzlMSyJUC8U1HExLmDp2nprjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gqz7I52raTz8442IXhtyArpusA9arp2KTT2TMH7UTG7O4NaWBGPp9vQhrbxBeNerr
	 CpK2cO813bajceETGtCK12z2VLr78c83PQ7ZLER0a9eCKf4tSgDM4nw8HsrvLmMBAt
	 wSmkCasUsgPG5Y429ILzLRD+mQ/67Wpw5gFAA+y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Tom Zanussi <zanussi@kernel.org>,
	Linyu Yuan <quic_linyyuan@quicinc.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 382/456] selftests/ftrace: Add test case for GRP/ only input
Date: Mon, 17 Aug 2026 15:32:52 +0200
Message-ID: <20260817132554.404897048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linyu Yuan <quic_linyyuan@quicinc.com>

[ Upstream commit 5db19792f0660ad1ece247829bddd24bb2f8db25 ]

Add kprobe and eprobe event test for new GRP/ only format.

Link: https://lore.kernel.org/all/1656296348-16111-5-git-send-email-quic_linyyuan@quicinc.com/

Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Linyu Yuan <quic_linyyuan@quicinc.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: 6e3abef2a27e ("selftests/ftrace: refactor eprobes test to fix argument checks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ftrace/test.d/dynevent/add_remove_eprobe.tc          | 9 ++++++++-
 .../ftrace/test.d/dynevent/add_remove_kprobe.tc          | 7 +++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_eprobe.tc b/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_eprobe.tc
index 60c02b482be83..c300eb0202620 100644
--- a/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_eprobe.tc
+++ b/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_eprobe.tc
@@ -1,7 +1,7 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 # description: Generic dynamic event - add/remove eprobe events
-# requires: dynamic_events events/syscalls/sys_enter_openat "e[:[<group>/]<event>] <attached-group>.<attached-event> [<args>]":README
+# requires: dynamic_events events/syscalls/sys_enter_openat "<attached-group>.<attached-event> [<args>]":README
 
 echo 0 > events/enable
 
@@ -87,4 +87,11 @@ echo "-:eprobes/$EPROBE $SYSTEM/$EVENT $OPTIONS" >> dynamic_events
 ! grep -q "$EPROBE" dynamic_events
 ! test -d events/eprobes/$EPROBE
 
+if grep -q "e\[:\[<group>/]\[<event>]]" README; then
+	echo "e:mygroup/ $SYSTEM/$EVENT $OPTIONS" >> dynamic_events
+	test -d events/mygroup
+	echo "-:mygroup/" >> dynamic_events
+	! test -d events/mygroup
+fi
+
 clear_trace
diff --git a/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_kprobe.tc b/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_kprobe.tc
index b4da41d126d58..13d43f40a6fc6 100644
--- a/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_kprobe.tc
+++ b/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_kprobe.tc
@@ -23,4 +23,11 @@ grep -q myevent1 dynamic_events
 
 echo > dynamic_events
 
+if grep -q "p\[:\[<group>/]\[<event>]]" README; then
+	echo "p:mygroup/ $PLACE" >> dynamic_events
+	test -d events/mygroup
+	echo "-:mygroup/" >> dynamic_events
+	! test -d events/mygroup
+fi
+
 clear_trace
-- 
2.53.0



