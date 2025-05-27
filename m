Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381903C01;
	Tue, 27 May 2025 17:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367262; cv=none; b=JeX01tKGuZAWUvARNKa4Cjfv0/LY2/GOQrlu+qNe/7SAYym3Dkv9p8MFhFLbJiTIhk1cJXr52QsQ8ONV7wO1/pE6HlfOZtBcLnuPPf2Vd66NrQMvVeSRE+6tRg9WvSTsFMh/jgRUfz/FJBEnyh0+8ncHiTnJal+rlIY1BOZI/nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367262; c=relaxed/simple;
	bh=PRxy5GIOcArI28fxoXlgYJ1ChwgxkZU7M+wN09+GJgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqzQFApSM6hdPJtlmN7zx8tqMNnhmReB5iQE/M0SV6LqF00HteMFRMht1n3uh0R6Jo9tdfVuOvpVbvqX1VRo9AIpmTfrG9SYiXksVJceXKc3JgBoo+hYFV83vd+ULlZZiF9D7v6VYXvThkDstAQnrfsEllNGlfvlw7UfcAP9PNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2AitipF/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2AitipF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC296C4CEE9;
	Tue, 27 May 2025 17:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367262;
	bh=PRxy5GIOcArI28fxoXlgYJ1ChwgxkZU7M+wN09+GJgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2AitipF/xR361l1e+K16BNTaqgKC0FpiuhJ1kOyo0rcut/x7bwvRfeZqo4k6GyQgE
	 y9EjeN+oGlHME+YJGyjveNVlfwdFBwS2gHYx6rlQwr7Wx7J+3YiMtwRPNCV89IpkUJ
	 nG57ubm31YyZBRhli0FhbBHnI10NOSZE2BUpEFJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Krakauer <krakauer@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 331/783] selftests/net: have `gro.sh -t` return a correct exit code
Date: Tue, 27 May 2025 18:22:08 +0200
Message-ID: <20250527162526.536979302@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Krakauer <krakauer@google.com>

[ Upstream commit 784e6abd99f24024a8998b5916795f0bec9d2fd9 ]

Modify gro.sh to return a useful exit code when the -t flag is used. It
formerly returned 0 no matter what.

Tested: Ran `gro.sh -t large` and verified that test failures return 1.
Signed-off-by: Kevin Krakauer <krakauer@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250226192725.621969-2-krakauer@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/gro.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/gro.sh b/tools/testing/selftests/net/gro.sh
index 02c21ff4ca81f..aabd6e5480b8e 100755
--- a/tools/testing/selftests/net/gro.sh
+++ b/tools/testing/selftests/net/gro.sh
@@ -100,5 +100,6 @@ trap cleanup EXIT
 if [[ "${test}" == "all" ]]; then
   run_all_tests
 else
-  run_test "${proto}" "${test}"
+  exit_code=$(run_test "${proto}" "${test}")
+  exit $exit_code
 fi;
-- 
2.39.5



