Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE90E230BF8;
	Mon, 10 Mar 2025 17:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627566; cv=none; b=qxtaAAnw+qVkHxfUcmZusjU10xufFvY9SeC16NxY03JpeWvmUKAKO/2FO6w130jhFBRy4VleNnmh6Hi4zmu1cxVSX85H1DaRR2EMFB6391H1PAEUYdCA0l3vqCnh9gZnGXB2a69prOP5bIRIQcsKCxLsYistAkF+ZzKMt/Dbtt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627566; c=relaxed/simple;
	bh=Aik8aZPAqMbArTRqBgbQCmWk8OyffNGPeQq/ZqVhobw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dm5Bo2thWD3kHk3/EAWdsDZFX1/plj5RJWRb0KtgvkgWREKnYuyrCLXScTqI9hwX4cVf8JOoA0pcssBkBV7mDo5dfJZv+u41oPwwEV+WCRDup4XhSQpYsAWaws2eybw4l0NtJmCYbcwI6+NifEYZF0UoPzk1V2GPdNEGVTBCClM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOI0Nz5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOI0Nz5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5248AC4CEE5;
	Mon, 10 Mar 2025 17:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627566;
	bh=Aik8aZPAqMbArTRqBgbQCmWk8OyffNGPeQq/ZqVhobw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOI0Nz5L4MLkf2v7JZzDeB8KVw3tFGNoJ4rIvEggOOTVaD6TrBdy47XiEOfejNEWJ
	 Rbh2mqn5XnsvtXGqHQ5au60c/HF3tfD8ktAYs/15DXc+vQgN4AJSHJHKsr/sxEiYW8
	 Lb7r/e/wrxydNyKOPOM+DVLLRgsIREST3QknNynk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 173/269] tracing: probe-events: Remove unused MAX_ARG_BUF_LEN macro
Date: Mon, 10 Mar 2025 18:05:26 +0100
Message-ID: <20250310170504.611287701@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fba3ede870541..8a6797c2278d9 100644
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



