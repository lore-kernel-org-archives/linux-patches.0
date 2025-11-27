Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1E229BD89;
	Thu, 27 Nov 2025 14:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255465; cv=none; b=ORViVmSs2VVMaxC3Yjr39xSRd6BJ1W36MsAzbSubbeuqPGEzKhs1KDE3JdxiePTPHlVyvIO/Uyk2fqipoxj4LWqwfwBGy/S9EDgVc1LhmxJTQDQsHE0cOZHUcnYOCYS3VLZ25NOjgX/5Ikm3fZ+x9sYHNr5H2JEZWW4UBNlElFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255465; c=relaxed/simple;
	bh=Eb8cj0U9NkTTY+Em3iwz3fJbyyGfiT6IFW5xPnmNDzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4MBpks86SVEkFFEq1A2MNiN5xD0qGAXQXBuIufaxHoSPQBAhlT4dfSXMQ+lAQu9gy4sKUyTjriUIWcy2B6mw7wLUaqiZpeafJHto9LxaF96gnCfyqUMB+7uH4ssNh+dkOZWDc1AvbQ9U2uLZs3waMlVXfAjZZSCcRGgTFBGJ00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KSIlZtL/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KSIlZtL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D0AC4CEF8;
	Thu, 27 Nov 2025 14:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255465;
	bh=Eb8cj0U9NkTTY+Em3iwz3fJbyyGfiT6IFW5xPnmNDzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KSIlZtL/SDfbyO9kEdllRpHqkO7jKQhFUaz7QqjwoxBSZuuHAcpyqNn3VzcaQ6xMa
	 1QvPgbqV4bv7ItioTkW6b8aHnUghGkd0zyHArJRZg9X0t9NcOynFCvqkXB9pXyIL/e
	 c+rwKAP97V3ByUqIWF2dAlyZR4u8pH5XpnG0TmL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Chujun <zhangchujun@cmss.chinamobile.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/112] tracing/tools: Fix incorrcet short option in usage text for --threads
Date: Thu, 27 Nov 2025 15:46:42 +0100
Message-ID: <20251127144036.501926839@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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



