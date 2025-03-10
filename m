Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A62232367;
	Mon, 10 Mar 2025 17:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626804; cv=none; b=r/Qyo8MCycWkJ82Way3sM2B7pInn2idvjRXzOeJMA7VaYXaacxEe9h7xQiGlT5SDaXzrmKKCMm24l9zL02B3MI9H14JXUKPQ6p2lKYLkpbRdc0q7A2WFaJn9rsYQr0DMEypcdclXGMgbiFdX1Fwblk7VMb67u2Jos07g2r27bG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626804; c=relaxed/simple;
	bh=JnwZ6TYHGF5K48LO9ZzZBqW7oVBOMJvf4d7n9lu3v9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iua+W2Son5Ep/cq+Mv+Wpd2ZhS5Vs54/4211OGWrsf4/eolSCTDFFYFw+cX7I5tMMv3AQVEsMKUZiq+bis50jmnfc4yDO9ITjACiODoJAr3bq3waXZQTBO07y6pgpJOrhGg6NXeoIaFMqvH6zp1qb5qeRgDUpMjO+SMJr88IhB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bhzYBGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bhzYBGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6DAC4CEE5;
	Mon, 10 Mar 2025 17:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626804;
	bh=JnwZ6TYHGF5K48LO9ZzZBqW7oVBOMJvf4d7n9lu3v9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bhzYBGnw0HvMcyj7v3zR6W2SvkGl38rNCZPXJxTVWUUQX2LexIpjSq152XCex2B0
	 QhzXReoWms+dMJNSLIA8Bu82rdKddPYSwVdRcx7tx6p6XtMwXYBM8m++Kri8a+2Gsy
	 ymp0bnehEQU4EaMrc0tNr2QofSXM3oZOVlznSsmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 119/207] tracing: probe-events: Remove unused MAX_ARG_BUF_LEN macro
Date: Mon, 10 Mar 2025 18:05:12 +0100
Message-ID: <20250310170452.540299713@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index c47ca002347a7..96792bc4b0924 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -36,7 +36,6 @@
 #define MAX_BTF_ARGS_LEN	128
 #define MAX_DENTRY_ARGS_LEN	256
 #define MAX_STRING_SIZE		PATH_MAX
-#define MAX_ARG_BUF_LEN		(MAX_TRACE_ARGS * MAX_ARG_NAME_LEN)
 
 /* Reserved field names */
 #define FIELD_STRING_IP		"__probe_ip"
-- 
2.39.5



