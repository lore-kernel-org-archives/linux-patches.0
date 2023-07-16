Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7541E8F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3A6C433C7;
	Sun, 16 Jul 2023 19:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537431;
	bh=k3iiOrVJXgITNWlYC+SOUmYv/rV+nyO1C7AzGsqw/qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IsefDlY2HYmXRjbzCAkUifypewDt9CsRjmYDCRdzSZvv3pBGEa7grSeyMO+FQrpHN
	 4LWZTKVxcMrF9lEEjqcjp+7DwLT1MXIF/TmMcpHCbGt0i10d9zg0oadS/3CMxmEQ+e
	 QutUn902CZZnm7iAxa6yQQGGgrC44XApYKeMtDGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 094/800] selftests/ftace: Fix KTAP output ordering
Date: Sun, 16 Jul 2023 21:39:07 +0200
Message-ID: <20230716194951.296718367@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 8cd0d8633e2de4e6dd9ddae7980432e726220fdb ]

The KTAP parser I used to test the KTAP output for ftracetest was overly
robust and did not notice that the test number and pass/fail result were
reversed. Fix this.

Fixes: dbcf76390eb9 ("selftests/ftrace: Improve integration with kselftest runner")
Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ftrace/ftracetest | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
index 2506621e75dfb..cb5f18c06593d 100755
--- a/tools/testing/selftests/ftrace/ftracetest
+++ b/tools/testing/selftests/ftrace/ftracetest
@@ -301,7 +301,7 @@ ktaptest() { # result comment
     comment="# $comment"
   fi
 
-  echo $CASENO $result $INSTANCE$CASENAME $comment
+  echo $result $CASENO $INSTANCE$CASENAME $comment
 }
 
 eval_result() { # sigval
-- 
2.39.2



