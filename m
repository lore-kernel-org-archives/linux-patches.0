Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619CF3612EE;
	Tue, 16 Dec 2025 12:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888529; cv=none; b=Zpsxei7ADUDBImzBNTViDwlJCpn4t4S3ZPZnHA5IRV3ZBliF4pmr8NcpppQWEx3Lzb18kGACXuSI/FV8hBPm1HA+Q6aqseSbOPe6jtZLON8nb+w0o8fHNSma2Qp4Vzed9TOMZVTZNBObuAnPXtARxVh/qJXj1eDNLxzGSk5EXZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888529; c=relaxed/simple;
	bh=D+XLK5oz1R+g1QpxJNobX9cYLe2t/0mD/8CncoJG2pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQhj1fGAz9z3OPGk/E5blNmc2WAckjEwol0outp0HF9vQ/l4pNc0jVfV6qv9oxdkNCPaOHzS8fzxcuetoDFIULrT9ikK/fsrZtEORlHlfFPq5oSA2lCJB+FNl35jR5VkCVMQgLbLWsMfVpDyWPVXfcn8q4iAzMVgTi+uOLSDb6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8urwqN2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8urwqN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32EBC4CEF1;
	Tue, 16 Dec 2025 12:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888529;
	bh=D+XLK5oz1R+g1QpxJNobX9cYLe2t/0mD/8CncoJG2pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8urwqN2IWpEInMSEUEhMc7yXsKJoBVVZL90UpvL/aYxeR1iK232TbCKWTZjoTXHm
	 EY7MjSTpvV2PyO0WGHSWrYz4O7KZsYVvXG9AoMdWAhgq5jLmTgks3iiS500Tzy6GyN
	 JA5bmq83ewM3yMdZX3RW0lWau5KLQOpl38swVgwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 528/614] perf kvm: Fix debug assertion
Date: Tue, 16 Dec 2025 12:14:55 +0100
Message-ID: <20251216111420.508202394@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 27e711257902475097dea3f79cbdf241fe37ec00 ]

There are 2 slots left for kvm_add_default_arch_event, fix the
assertion so that debug builds don't fail the assert and to agree with
the comment.

Fixes: 45ff39f6e70aa55d0 ("perf tools kvm: Fix the potential out of range memory access issue")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index f0f285763f190..c61369d54dd9d 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -2014,7 +2014,7 @@ static int __cmd_record(const char *file_name, int argc, const char **argv)
 	for (j = 1; j < argc; j++, i++)
 		rec_argv[i] = STRDUP_FAIL_EXIT(argv[j]);
 
-	BUG_ON(i != rec_argc);
+	BUG_ON(i + 2 != rec_argc);
 
 	ret = kvm_add_default_arch_event(&i, rec_argv);
 	if (ret)
-- 
2.51.0



