Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCAC1974FA;
	Thu,  6 Jun 2024 14:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683101; cv=none; b=ou+vAZcmw3Ju7iV4MBPXIoyw0waCwnnuXvu0QQrFrnCR6BatshoJaBsjSl+TbOhh+4eVeDgh0sEy9rrZYVVEpT8tNYqpHG4u+0XQ7l5SK9/wTh8CnYBadjxQWPRG9pir9xFRQBBjiERKrpJ5WaRHLHL/Ua1K+9ZKq/jhnBetWm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683101; c=relaxed/simple;
	bh=k0LbirbYwDNMJXucrgzFOY0gtF6KOr0SYwvMFPIFZSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bd92/+p3bkXCQIRfeAuKQZ0DyJwdvE4x9JqynKbEqPBLBvC2jKtW0huJtrS3Y9/2sXzk3uGfOz+CypEXiM5FS5ja1R4baiYcrHz0N0RdqzpXOEjooMcPRFLxEydIcrodkSz4X+h3Fh0ywLdhtOrji4MfKb8KGajSZ5qab7aXjPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqD7qRFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqD7qRFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA56C2BD10;
	Thu,  6 Jun 2024 14:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683101;
	bh=k0LbirbYwDNMJXucrgzFOY0gtF6KOr0SYwvMFPIFZSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqD7qRFU78Kti82KYKSygjGRXGQhQeIqna9lEmKA7v7T8M2B4uXfHn000YGSY4s6l
	 SgaSjTUYFuBRyPX3J6sEW2KPUeSpfQq32Xq0ykxYZJsJ9CJ+V7eSQArQVmMWCK+2YU
	 FLTb/AOoZDnmCw9wmZXVE+lBOyboxd18umsP2Thw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.6 002/744] selftests/ftrace: Fix BTFARG testcase to check fprobe is enabled correctly
Date: Thu,  6 Jun 2024 15:54:34 +0200
Message-ID: <20240606131732.534997831@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 2fd3ef1b9265eda7f53b9506f1ebfb67eb6435a2 upstream.

Since the dynevent/add_remove_btfarg.tc test case forgets to ensure that
fprobe is enabled for some structure field access tests which uses the
fprobe, it fails if CONFIG_FPROBE=n or CONFIG_FPROBE_EVENTS=n.
Fixes it to ensure the fprobe events are supported.

Fixes: d892d3d3d885 ("selftests/ftrace: Add BTF fields access testcases")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../selftests/ftrace/test.d/dynevent/add_remove_btfarg.tc       | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_btfarg.tc b/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_btfarg.tc
index b9c21a81d248..c0cdad4c400e 100644
--- a/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_btfarg.tc
+++ b/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_btfarg.tc
@@ -53,7 +53,7 @@ fi
 
 echo > dynamic_events
 
-if [ "$FIELDS" ] ; then
+if [ "$FIELDS" -a "$FPROBES" ] ; then
 echo "t:tpevent ${TP2} obj_size=s->object_size" >> dynamic_events
 echo "f:fpevent ${TP3}%return path=\$retval->name:string" >> dynamic_events
 echo "t:tpevent2 ${TP4} p->se.group_node.next->prev" >> dynamic_events
-- 
2.45.1



