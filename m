Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96E83F12CE;
	Tue, 21 Jul 2026 17:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655840; cv=none; b=pcVBLHYm8y8+jR9tqMyfd0pBv+7xyIAi/jmjjydJfur7ovtMihyCqsE44V6pqbf4T3byFlu4nxLLXoFBYq6eKXAO9iuRW3W327fveyzMfLnbjs7LU1dCCFN+A8CVCx2LbQayc0c/xY/+ckj0trpzeF4UUts2dbMq3/slftKFseQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655840; c=relaxed/simple;
	bh=/uqRrKoaJemCyhhP57Zq+xe9mfqSAFqzG9x9/o4+GkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ktplr17yHuo8ArCZlo8pydecXh7ijfpZCF8KDvfZpUjue3AKkLLLJp3mKn6V8OVuTdVMKfUuMbeDviauLCUr7vwZp84OMBkpZpLe5rjf1m5m+DIdxhRuElPLaNh/PXCXN7hZ7rTegCkMm1zCmPH7IQObNCrohiliCHVxVOlryU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DzV3uUP1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DzV3uUP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB0F1F000E9;
	Tue, 21 Jul 2026 17:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655839;
	bh=g3So3MonPtA39W5N4JVseiIUeRuAUjrMlTn4Fbkjy2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DzV3uUP1zp/+aJP4GdXoo7FEr85K5CuWSFTWd+qqRae3ANMQYySfkWtc/Orddh0zG
	 6xB6+v91lJo99/nWfoQ0wapSudHCOyWPKsDL1LHbRMqlcB68Quzrv0kodZUGjGsRpi
	 WBy7xCrMIULbuodRFF5t/xIZhrpbTtLwzLg+ISsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Kvasnytskyi <roman@kvasnytskyi.net>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0161/1611] selftests/bpf: Reject unsupported -k option in vmtest.sh
Date: Tue, 21 Jul 2026 17:04:37 +0200
Message-ID: <20260721152518.506409812@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Roman Kvasnytskyi <roman@kvasnytskyi.net>

[ Upstream commit 6df582112aa9ac9d190169abdb0e42e496659ec9 ]

vmtest.sh does not document a -k option and does not handle it in the
getopts case statement. However, the getopts optstring includes k, which
causes the script to accept -k silently instead of reporting it as an
invalid option.

Remove k from the optstring so unsupported options are rejected through
the existing invalid-option path.

Fixes: c9709f52386d ("bpf: Helper script for running BPF presubmit tests")
Signed-off-by: Roman Kvasnytskyi <roman@kvasnytskyi.net>
Acked-by: Paul Chaignon <paul.chaignon@gmail.com>
Link: https://lore.kernel.org/r/20260516120625.80839-1-roman@kvasnytskyi.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/vmtest.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/vmtest.sh b/tools/testing/selftests/bpf/vmtest.sh
index 2f869daf8a06b7..9ca8022853933a 100755
--- a/tools/testing/selftests/bpf/vmtest.sh
+++ b/tools/testing/selftests/bpf/vmtest.sh
@@ -382,7 +382,7 @@ main()
 	local exit_command="poweroff -f"
 	local debug_shell="no"
 
-	while getopts ':hskl:id:j:' opt; do
+	while getopts ':hsl:id:j:' opt; do
 		case ${opt} in
 		l)
 			LOCAL_ROOTFS_IMAGE="$OPTARG"
-- 
2.53.0



