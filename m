Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A271DE89C;
	Mon, 10 Mar 2025 17:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628144; cv=none; b=N8Ts8UEh2d6cTvKMoICG5LXJo2FDajpmddVO+Kly+IICwUUt0qe1scuLQwb3Tf5vYh23OhMcWkr5zs3+5fhjOBSJ4YEKyC03exvNFOzZWDFAX3H6qETuggqJGJKq4lSsDK8u0lEBzSxlpIDIEv72XYYo7Yir7pYxbEbPzKoxDH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628144; c=relaxed/simple;
	bh=SASKm0GO97jwCTisT2EXuU53rjTnwAQ9oNzKBLHfqyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s28CzbMl111XxxO0VMRPq1+4hh5gjemPi1zfVPaWST2/40RFaujL0u0Um4jxZ6a9r59UMhyfrcyoyg81HfEbHr88YqRPRKz0g9N+FiD/qqdUErwzC0E3FzqdJhK64xJtLHrAcRNka+uCmTj0bDyUBp1gj8J9tzrSj+eZB7cnwKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y7UF0M4z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y7UF0M4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF361C4CEE5;
	Mon, 10 Mar 2025 17:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628144;
	bh=SASKm0GO97jwCTisT2EXuU53rjTnwAQ9oNzKBLHfqyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y7UF0M4zaPzWd/Eqqx8gfb1CzKsTWw3PaNhb9BgVAckA+42aDQC+Z1pnynNduzLmQ
	 BgwIqgXkj2svyQDIXZUQKGPZq7+tCjXw3V2aNCnRwFs5mJqsGtyy8mLz0zUQDLL+QZ
	 x9fZKK3A23s3UYXVxiRmT/dceXwU0uROuFRROb0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/145] tracing: probe-events: Remove unused MAX_ARG_BUF_LEN macro
Date: Mon, 10 Mar 2025 18:06:04 +0100
Message-ID: <20250310170437.575824143@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit fd5ba38390c59e1c147480ae49b6133c4ac24001 ]

Commit 18b1e870a496 ("tracing/probes: Add $arg* meta argument for all
function args") introduced MAX_ARG_BUF_LEN but it is not used.
Remove it.

Link: https://lore.kernel.org/all/174055075876.4079315.8805416872155957588.stgit@mhiramat.tok.corp.google.com/

Fixes: 18b1e870a496 ("tracing/probes: Add $arg* meta argument for all function args")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_probe.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index cef3a50628a3e..48afed3c3f88e 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -35,7 +35,6 @@
 #define MAX_ARG_NAME_LEN	32
 #define MAX_BTF_ARGS_LEN	128
 #define MAX_STRING_SIZE		PATH_MAX
-#define MAX_ARG_BUF_LEN		(MAX_TRACE_ARGS * MAX_ARG_NAME_LEN)
 
 /* Reserved field names */
 #define FIELD_STRING_IP		"__probe_ip"
-- 
2.39.5



