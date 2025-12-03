Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F3035E559;
	Wed,  3 Dec 2025 16:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780161; cv=none; b=B0P6buZpuSxK59iOIIVKX9kq0zNkVl9m50yeOL/SuEWVEH0lVNwcKYcqxPcvbn5xFo4wX4UAqiFTPGJIUk38HW51rshx3hxgnEYp21kDSwAX7wV2rHTRzq3BF8ERAN+Qn5OEvjfsxLF0S3BglDSskfY+X9ZDnY9jJ4XN8evCjQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780161; c=relaxed/simple;
	bh=fqgsLbOXjzwFc/m8OZ6AIeLAECniefmuB5G7AJilbgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+D/1pUakdWxUYOd7NUUifxltP738QET1Er3VI/iN+zcLJSmBDhB2BkmmaCAvADUM2DVW+LEnWalhBCmK5IV9GDY4vymZWANO6c9cb+RycSHY6E+7dLbCZFfGYL5mnACdQ1rwC2Ix5I6c1e6xIujzAv9Y7fJQAvvCEAOGWlNbI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0uem/4wH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uem/4wH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F16C4CEF5;
	Wed,  3 Dec 2025 16:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780161;
	bh=fqgsLbOXjzwFc/m8OZ6AIeLAECniefmuB5G7AJilbgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0uem/4wHREuVXyBTbaKEbgbiq3GE7CNzRNlJw9QqYbpTpKtGaN/gxq6A2XSMqrhUM
	 uqUFZUkr2s7acgHsQYlUtWNAcN4WUxvvXgqEzKENrZ/5VVsYbOKIfNbucr+75RkyM0
	 jgp54eqvfC7eIvvLwWgRTxONqfnAIAugv0oS7jiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Chujun <zhangchujun@cmss.chinamobile.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 475/568] tracing/tools: Fix incorrcet short option in usage text for --threads
Date: Wed,  3 Dec 2025 16:27:57 +0100
Message-ID: <20251203152458.096480761@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f7ed8084e16ad..ec95b94f80e1f 100644
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



