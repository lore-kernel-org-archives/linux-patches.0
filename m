Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AA8286416;
	Thu, 27 Nov 2025 14:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255032; cv=none; b=kDT2vI+ZFvVhxXyIvjpOIZVCYAZBWFHUMhGJhdj+52jrnERLKwRTryJ0huxzDG+t5xsjv2iSqJCQRdj/MC8V6kghUT3fvlhTai/qEzaH4eXi4S4RbQFBtKMNl7/ZM5kklySV9F3HDpmYImJ4z4g8m9+hU8iJ+E4u/lR8FNrl/Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255032; c=relaxed/simple;
	bh=F2uz2sFOpEWvmxWZJfkwVCuaHbogIKoEh8YAjxhRDS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jgEmhdHNcpFGMn0XYFasTQwxqweNtbPjf7mlX2Ly5XiP8psIccxw4nOPXk5Yf/Ei/jjcrWhVy4xPWXucnvlnsDz3dwTakjOGj4YiUgsj9kF8umpNm9C6QOyXFeO9zEuRuCzH2T4BbVcHJlLyRlgCT0U33SQyIgjNbDh5cSbbacM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jSNifKZF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jSNifKZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F1CC4CEF8;
	Thu, 27 Nov 2025 14:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255032;
	bh=F2uz2sFOpEWvmxWZJfkwVCuaHbogIKoEh8YAjxhRDS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSNifKZF0LSedAdO7TKl7R5sMhSCEUkh0mNMwVg1IAS9nALPqUTGzrpslFr9/98yV
	 AZk4ZYtdmdocT5s/FP2XQr62MllijvjvS7L89dMb4UVUE5JRjQUPNlAE++mO43UYLY
	 toe4F+1E3rmz2H47UlybnTrdqOLNRU1Rk39T00f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Chujun <zhangchujun@cmss.chinamobile.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 71/86] tracing/tools: Fix incorrcet short option in usage text for --threads
Date: Thu, 27 Nov 2025 15:46:27 +0100
Message-ID: <20251127144030.425773243@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Chujun <zhangchujun@cmss.chinamobile.com>

[ Upstream commit 53afec2c8fb2a562222948cb1c2aac48598578c9 ]

The help message incorrectly listed '-t' as the short option for
--threads, but the actual getopt_long configuration uses '-e'.
This mismatch can confuse users and lead to incorrect command-line
usage. This patch updates the usage string to correctly show:
	"-e, --threads NRTHR"
to match the implementation.

Note: checkpatch.pl reports a false-positive spelling warning on
'Run', which is intentional.

Link: https://patch.msgid.link/20251106031040.1869-1-zhangchujun@cmss.chinamobile.com
Signed-off-by: Zhang Chujun <zhangchujun@cmss.chinamobile.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/latency/latency-collector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/tracing/latency/latency-collector.c b/tools/tracing/latency/latency-collector.c
index cf263fe9deaf4..ef97916e3873a 100644
--- a/tools/tracing/latency/latency-collector.c
+++ b/tools/tracing/latency/latency-collector.c
@@ -1725,7 +1725,7 @@ static void show_usage(void)
 "-n, --notrace\t\tIf latency is detected, do not print out the content of\n"
 "\t\t\tthe trace file to standard output\n\n"
 
-"-t, --threads NRTHR\tRun NRTHR threads for printing. Default is %d.\n\n"
+"-e, --threads NRTHR\tRun NRTHR threads for printing. Default is %d.\n\n"
 
 "-r, --random\t\tArbitrarily sleep a certain amount of time, default\n"
 "\t\t\t%ld ms, before reading the trace file. The\n"
-- 
2.51.0



