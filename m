Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A4646A5E7;
	Tue, 21 Jul 2026 17:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655062; cv=none; b=C/d1Lc9Xq06wJnMeI1+rNH0P92p1uhHVvjvumCKUuM5hj/1QlYF6G9S3nxhzit1QfaZnMskbVTNQwD+EXiRc5mnk/mckklSJUFhE76Sl/8xFVtZmN76Ci3fE7tMhoQguagCu1IzalXpW2vPwwpjSKUUnEAA1L7LrPJiLdHoIwOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655062; c=relaxed/simple;
	bh=D9Uv2uHyHcnPXBqu2snN2aWF0dWuz4M7Kh/M2JdMh9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTHjU/AiMvDADQ/7W8SuXGqhyLuOotxzqlToHJsm+j2DAuvEcIUNwlZnv50lc621nfu7kRpTfv/WzFC/wsXbNph55rBuJwiNSyvVl6mKqiN6Cw6bqp2Yv1NENTMzP1a4soaklOrUWeUo2TzYnXc5dhWJIyshPKjXAVjngcauA9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ipde+VuN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ipde+VuN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9287F1F000E9;
	Tue, 21 Jul 2026 17:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655060;
	bh=pDFaPcWFKJRdqRXWA8KCJZDAbGQBeDN9KMGBgSeZlMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ipde+VuNBKHI7VmLAgEPDv55hCEDCwVo5cj97VDhIAumxsMVeywzRfBgN62Kjs39x
	 BAV5bOtotyd6dBqe4q3S3dfxpeEApRyQcbe0YHrspn51n/qEpOT/PyKoYA7SlpW9y4
	 47gsc4c7Ilv2RPFbytFMsTn9qSqRp+e3b9eAjOYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cao Ruichuang <create0818@163.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 7.1 1898/2077] selftests/ftrace: Drop invalid top-level local in test_ownership
Date: Tue, 21 Jul 2026 17:26:11 +0200
Message-ID: <20260721152637.486818359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cao Ruichuang <create0818@163.com>

commit 808c447df2fe234eb7d9e08ecf53159d291c104c upstream.

test_ownership.tc is sourced by ftracetest under /bin/sh.

The script currently declares mount_point with local at file scope,
which makes /bin/sh abort with "local: not in a function" before the
test can reach the eventfs ownership checks.

Replace the top-level local declaration with a normal shell variable so
kernels that support the gid= tracefs mount option can run the test at
all.

Link: https://lore.kernel.org/r/20260407102613.81419-1-create0818@163.com
Fixes: 8b55572e51805 ("tracing/selftests: Add tracefs mount options test")
Signed-off-by: Cao Ruichuang <create0818@163.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/ftrace/test.d/00basic/test_ownership.tc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/ftrace/test.d/00basic/test_ownership.tc
+++ b/tools/testing/selftests/ftrace/test.d/00basic/test_ownership.tc
@@ -6,7 +6,7 @@
 original_group=`stat -c "%g" .`
 original_owner=`stat -c "%u" .`
 
-local mount_point=$(get_mount_point)
+mount_point=$(get_mount_point)
 
 mount_options=$(get_mnt_options "$mount_point")
 


