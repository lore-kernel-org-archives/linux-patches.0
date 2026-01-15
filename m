Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECFF39C624;
	Thu, 15 Jan 2026 16:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496369; cv=none; b=LH6OVXjG4COYHsvLw/FNBEMxiBNseGEloDMS069Twnkz4lj1y6V9qEY/KqbpVOyCLV8f5RtlBh5A8JOuZoBdNik6vFyT4GeiPnYin18LJOl5xTC3YwKTMGRFwyuRPoYbZhu2BaeJs8rntpuAlNVpwaGhI9+2f0POIVpmqHGMKJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496369; c=relaxed/simple;
	bh=6wHdK0vmyuh6h3u3uXzp6jA47kFD7NVQSS0qnrhTmfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WiRaPUqQWZH8xIcivgM0i2j8PlkwJ4TUZQtb4g3rjgJ/dIMpIh+e1cjPP68UOz/i3fJYuxH1KmyL1htRLbk8dMk0sqNlUFFGx7F1KvEf6bWa88decGjd4abQPqiywTU4giA00T7L6AeuXeO6NgdJuZETfV+os9b1nx9nKSLp3oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KHSylvmi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KHSylvmi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2974DC116D0;
	Thu, 15 Jan 2026 16:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496369;
	bh=6wHdK0vmyuh6h3u3uXzp6jA47kFD7NVQSS0qnrhTmfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KHSylvmisVCChGiwYInd2TFOK3UhtkTvA0UYp6J7rVAb8xmANsMvbqZx2wfF8v7HT
	 qgkyFYSb0PhRuSAMRlr5ppYj0D9sZO/ZCZ5bVi65/011lkDV80eBNm++rpPkHJLTAC
	 W9QmaNhuHi+cT9DKF3zaGYOb/xDnAIjtjSCSec/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 144/181] trace: ftrace_dump_on_oops[] is not exported, make it static
Date: Thu, 15 Jan 2026 17:48:01 +0100
Message-ID: <20260115164207.514330976@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit 1e2ed4bfd50ace3c4272cfab7e9aa90956fb7ae0 ]

The ftrace_dump_on_oops string is not used outside of trace.c so
make it static to avoid the export warning from sparse:

kernel/trace/trace.c:141:6: warning: symbol 'ftrace_dump_on_oops' was not declared. Should it be static?

Fixes: dd293df6395a2 ("tracing: Move trace sysctls into trace.c")
Link: https://patch.msgid.link/20260106231054.84270-1-ben.dooks@codethink.co.uk
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ddff2af3cd3f7..142e3b737f0bc 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -141,7 +141,7 @@ cpumask_var_t __read_mostly	tracing_buffer_mask;
  * by commas.
  */
 /* Set to string format zero to disable by default */
-char ftrace_dump_on_oops[MAX_TRACER_SIZE] = "0";
+static char ftrace_dump_on_oops[MAX_TRACER_SIZE] = "0";
 
 /* When set, tracing will stop when a WARN*() is hit */
 static int __disable_trace_on_warning;
-- 
2.51.0



