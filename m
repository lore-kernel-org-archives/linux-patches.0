Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673103115A6;
	Thu, 27 Nov 2025 15:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255915; cv=none; b=qhYIMWOWCy5NFyYKAmjw23DghKx0yDczOWEWKl2KvIyik2VMTgjcv2zblXuk957OEqBqq9ZjYdlCxjAMpmWKT7QauchaPGiNpAKm3A7UqcT19G2D9B0nP9q1Qo1N3IqcJQYmKgp2UoUG8fdTqH+JtQ15x31NFjCNfIPKPkwVNG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255915; c=relaxed/simple;
	bh=FyC62cwJ1NTyANeGP55JieKJYLJ13tB62v7G0vAQSjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDRNEN+BBEQpqWzTrlf9UTj5BiK3Y4ki7FckQiMo6Y7PMWe1iPjY/QWY3plzTUfdc2JACtTKkACJqAsiYo6EUgZDOuxEf6cy3vZls6ie5jiyCkobvk5xMxlJGrT0T8v4G39tJ4495DQVR6VqQ3j2slMhngt0570wLaE/2r9MG54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GoTAWQUS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GoTAWQUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943D6C4CEF8;
	Thu, 27 Nov 2025 15:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255914;
	bh=FyC62cwJ1NTyANeGP55JieKJYLJ13tB62v7G0vAQSjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GoTAWQUScnyqNERgCtjklAeYrcjsGVnEDMkfVuAZRwemDfdJ2XHQ1OVaDAxUy4lBN
	 /sAYsdwe+x8QRNerwYOEm7xH9B6phQ6cqijcLFSqJ7Zs2eQkdeUk4QcnGPUr/AKJJd
	 kFU9KUqCTtgLcQ7c0uhSIG3ksVLjNnZM/BOFBUjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Chujun <zhangchujun@cmss.chinamobile.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 158/175] tracing/tools: Fix incorrcet short option in usage text for --threads
Date: Thu, 27 Nov 2025 15:46:51 +0100
Message-ID: <20251127144048.723711971@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



