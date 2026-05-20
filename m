Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C54A36A37D;
	Wed, 20 May 2026 16:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294709; cv=none; b=dlGOzNMNxmkEiBz1wNSTlH7BXboTPuIv3NO2P8bC8QDr6pES+QdnzeO80WrnmZcNBM+g07/Dr9P9M3GKJfVDGCC7Mw2JPt7LbE2n0oUq+NAd9z0g92Y+R6rF10zSi8rQjMInegC2hIpmL2e+914THrKxjS/LxNeUiyo+nCnZH9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294709; c=relaxed/simple;
	bh=95fIhVYv/BPUiqWBZk4cQVv1/HnVWZsIyfy3z9Y43pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWjyIcjsrBDyk13upc/MJvn9nD/khEFPkUFDcsM/Mhni6K/hJIeVxF0KOI+dQQtVv+1n6HsrJlwQc7K+DDaNFHnls3RBf1rmazKMtW2XBpB0alemPtNC0fAsOMb4OBTR53kBVt23TLdK9tfEQ8o5lVDcAg2pSn07tdm22E8QYrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILW5ttPg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILW5ttPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA201F000E9;
	Wed, 20 May 2026 16:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294708;
	bh=x67jiimvOY6xJ+YOXSH0mG0N8umZbSX5yqxSaIdidCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ILW5ttPg5I6htSHonypUzAJAA9bwr1rFHYF4K/OarikvLSKqTadvn9GIykWTsDihT
	 GburHiyeiNOmyescoQMrQsXnMQQ8bEDpisjIRA/c4hBM/fQJPVJk/1pZYBCo0uWZ0D
	 8O+6976OLAD4BewrpO1YR3Fg0mwPz5pIk5OaHI+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0142/1146] selftests/tracing: Fix to check awk supports non POSIX strtonum()
Date: Wed, 20 May 2026 18:06:32 +0200
Message-ID: <20260520162151.525079932@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 3d0b8e45075d398369eb07e11f529c17a63cf5e1 ]

Check the awk command supports non POSIX strtonum() function in
the trace_marker_raw test case.

Fixes: 37f46601383a ("selftests/tracing: Add basic test for trace_marker_raw file")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Link: https://lore.kernel.org/r/177071726229.2369897.11506524546451139051.stgit@mhiramat.tok.corp.google.com
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/ftrace/test.d/00basic/trace_marker_raw.tc       | 2 ++
 tools/testing/selftests/ftrace/test.d/functions               | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/tools/testing/selftests/ftrace/test.d/00basic/trace_marker_raw.tc b/tools/testing/selftests/ftrace/test.d/00basic/trace_marker_raw.tc
index a2c42e13f614b..8e905d4fe6dd2 100644
--- a/tools/testing/selftests/ftrace/test.d/00basic/trace_marker_raw.tc
+++ b/tools/testing/selftests/ftrace/test.d/00basic/trace_marker_raw.tc
@@ -4,6 +4,8 @@
 # requires: trace_marker_raw
 # flags: instance
 
+check_awk_strtonum || exit_unresolved
+
 is_little_endian() {
 	if lscpu | grep -q 'Little Endian'; then
 		echo 1;
diff --git a/tools/testing/selftests/ftrace/test.d/functions b/tools/testing/selftests/ftrace/test.d/functions
index e8e718139294d..41325f387ee7a 100644
--- a/tools/testing/selftests/ftrace/test.d/functions
+++ b/tools/testing/selftests/ftrace/test.d/functions
@@ -173,6 +173,10 @@ check_requires() { # Check required files and tracers
     done
 }
 
+check_awk_strtonum() { # strtonum is GNU awk extension
+    awk 'BEGIN{strtonum("0x1")}'
+}
+
 LOCALHOST=127.0.0.1
 
 yield() {
-- 
2.53.0



