Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADFC34D4DB;
	Wed,  3 Dec 2025 16:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778381; cv=none; b=GSh7WkaVsA1Avud+EHDeqrRBIwCiKtHUlRheS2eeNsx4uTKbZDFKt0njJqTgg3SIvArSBHPlXUIVSnQjOZneHhCqmazMaRzhjFedDo8j1QWv6ySOWuRJOfXFPRcaVjl3ZYPyRyIgSEGb9OWpHuSEpn/JWvsYI/rhhrnw+FNoMek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778381; c=relaxed/simple;
	bh=x5uDpfPXajp1udaDQoxaFCpkskOzq0zx5HVNwz5wKCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QN2qBFjYwEQ3IYYiy/cVmtC1Tu2PMnl8f/3jem+IlLFtdBLWVcEsA2TNsY0GY1lMzFCS19YMlstjviwjAmqo6WmDqUAgYIOtyzuAnhOEhKYW40naCuf81ZltujvANFAI2N6Teia2NAhPN4DS1KBGm5ag74YSgnu1mlos8ILMRtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IH4ZaLpP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IH4ZaLpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0F0C4CEF5;
	Wed,  3 Dec 2025 16:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778381;
	bh=x5uDpfPXajp1udaDQoxaFCpkskOzq0zx5HVNwz5wKCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IH4ZaLpPAHObV5vAuf3b6jRsjrH/bJ2ltGnPcMbU8x977VB21NIHR3XwkzwEcXkuI
	 07+5XP85N6GUaNIyzfTtVnwYYs6Be68cf8iXW976inUwB5IiAnvWwa0vknBuX3aCtp
	 HbHaiWRefLhVrPpFYMk7mOdLcyQT17uZ8j/9SDuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Chujun <zhangchujun@cmss.chinamobile.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 311/392] tracing/tools: Fix incorrcet short option in usage text for --threads
Date: Wed,  3 Dec 2025 16:27:41 +0100
Message-ID: <20251203152425.605608758@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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



