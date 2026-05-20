Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463AB2BE02A;
	Wed, 20 May 2026 16:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294704; cv=none; b=lRvxiMPQPonexmACBhUA1ACSZFChKY9LExLF7ZkuXeJMVEN0bgWutaqhwIZXiUPIHx6UVXzuhvlOD/ukNehKPDyy6Q3K9/xCBblwLOpQRnriJMXrFnRzSbha57BAqqCKpTzaKRraVppgNU3Ynv1ajwBUhOF2gvLtwpddv+JUa1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294704; c=relaxed/simple;
	bh=BO6veDwrDQhQKxRo6h8LYRJVXJScWrLcZSvyw6tTqOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lmw5+9e8gVSLCvC6wzxGgIkPCZ25DG29FXlepVMq4PgBc9+0r4L/t+p3jykFnhvqqi2mRdlQzdHSplpZDA41DSt4Kzx3L5Pq0NWxbhzL8j3+E9kPp84v4NTO+CFRnUP4DRukxp8H2r9iykJCyA2glv5jOaVhOWsMThRBoRWK0us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kTgv0OlT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kTgv0OlT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5171F00894;
	Wed, 20 May 2026 16:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294703;
	bh=giBLbnEekUR2hmNCWyprFXQ0qtihOKAQ43QjHurAK7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kTgv0OlTvXBLadBTZg3J1+uAAWUtF63Sp+Mt8fn2nrA2PjYvmAjw149uZ77fVEbSw
	 YD8kC7a+5zKq5vkW6PYsQrdfuc0jpDK+8SMp49LQbER23hKl3tiiqw5/t2qvcbL1Tu
	 Ax7dFjg8tMv7YdjJYjYAELDpvyFj0gXmZGrEqvko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0141/1146] selftests/tracing: Fix to make --logdir option work again
Date: Wed, 20 May 2026 18:06:31 +0200
Message-ID: <20260520162151.504339201@linuxfoundation.org>
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

[ Upstream commit e011853dd78f97898ae8e0b0b949603987e24c4b ]

Since commit a0aa283c53a7 ("selftest/ftrace: Generalise ftracetest to
use with RV") moved the default LOG_DIR setting after --logdir option
parser, it overwrites the user given LOG_DIR.
This fixes it to check the --logdir option parameter when setting new
default LOG_DIR with a new TOP_DIR.

Fixes: a0aa283c53a7 ("selftest/ftrace: Generalise ftracetest to use with RV")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Tested-by: Gabriele Monaco <gmonaco@redhat.com>
Link: https://lore.kernel.org/r/177071725191.2369897.14781037901532893911.stgit@mhiramat.tok.corp.google.com
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ftrace/ftracetest | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
index 3230bd54dba84..0a56bf209f6c0 100755
--- a/tools/testing/selftests/ftrace/ftracetest
+++ b/tools/testing/selftests/ftrace/ftracetest
@@ -130,8 +130,7 @@ parse_opts() { # opts
       shift 1
     ;;
     --logdir|-l)
-      LOG_DIR=$2
-      LINK_PTR=
+      USER_LOG_DIR=$2
       shift 2
     ;;
     --rv)
@@ -199,6 +198,7 @@ fi
 TOP_DIR=`absdir $0`
 TEST_DIR=$TOP_DIR/test.d
 TEST_CASES=`find_testcases $TEST_DIR`
+USER_LOG_DIR=
 KEEP_LOG=0
 KTAP=0
 DEBUG=0
@@ -210,12 +210,18 @@ RV_TEST=0
 # Parse command-line options
 parse_opts $*
 
+[ $DEBUG -ne 0 ] && set -x
+
+# TOP_DIR can be changed for rv. Setting log directory.
 LOG_TOP_DIR=$TOP_DIR/logs
 LOG_DATE=`date +%Y%m%d-%H%M%S`
-LOG_DIR=$LOG_TOP_DIR/$LOG_DATE/
-LINK_PTR=$LOG_TOP_DIR/latest
-
-[ $DEBUG -ne 0 ] && set -x
+if [ -n "$USER_LOG_DIR" ]; then
+  LOG_DIR=$USER_LOG_DIR
+  LINK_PTR=
+else
+  LOG_DIR=$LOG_TOP_DIR/$LOG_DATE/
+  LINK_PTR=$LOG_TOP_DIR/latest
+fi
 
 if [ $RV_TEST -ne 0 ]; then
 	TRACING_DIR=$TRACING_DIR/rv
-- 
2.53.0



