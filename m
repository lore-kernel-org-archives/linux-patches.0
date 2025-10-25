Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB3F305957;
	Sat, 25 Oct 2025 16:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408998; cv=none; b=lAOWPmWsp7xvSN6WmRx88TsqkIYXkzd67wDQsDZvpfvH1zXkLjVnnIwYRZQX1aRAC/ZEFv8DqKGFbT+tFpSJtxwAVvQSK3xF75FzMqG1XEVxhWpzLmyZilyRWGMgrkjx7VFeT0XBh9lotkg3ud1Ny87nPsg1qOeLtuSbmdP90Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408998; c=relaxed/simple;
	bh=D66r0THAaqiaUxNKszvcN3SewIVNQzg5lzzpO44zkuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l+3+yYZB5UDm9HgFtPzJC/sxm/Xc+Cg1QBR0ulTnnSypS8GyNHP+JX3dYxkjDTjXoXTnGiam8ZAFK+1yGV40aHIAqHwEUAALAZPOIB359lM54TScV/1CSYDrMaDLooFzWj7LiJJkI1TKu0CvVn0YzelEAWcd+7EChVKtGshuug0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AWGPpGUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AWGPpGUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D00C113D0;
	Sat, 25 Oct 2025 16:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408998;
	bh=D66r0THAaqiaUxNKszvcN3SewIVNQzg5lzzpO44zkuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AWGPpGUBYGywV680OOKUnH3cDSL8LLF8n1pvb1G2fwFE6Iz29OZiITbKvPASj2llS
	 aCblOlGA3/aaR64OONwQnhV52CmUejZbv8BeyVzbIJ1vjhpCkrkL7eLNGM5OoaIP4N
	 /ZHba4e49u4yMnwg/5ppl4tBq+sANfmlF1avipI9ITJE/yWTCK310CRUQ55hdYc/dl
	 ELp1nWHPA7U/yeW7yMllQ7l1u1aA/LlwN6LSZyvhjev2FI2LYS/vupH3f8JD3sfrzc
	 m7dmHonsksxviiSeuQKRGbUGR3GlBZsibhpJVIUBaX06/FkXz4Wjo8130N0zZlg23x
	 4NWQDfO/bPsQg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alessandro Zanni <alessandro.zanni87@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] selftest: net: Fix error message if empty variable
Date: Sat, 25 Oct 2025 11:56:39 -0400
Message-ID: <20251025160905.3857885-168-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alessandro Zanni <alessandro.zanni87@gmail.com>

[ Upstream commit 81dcfdd21dbd7067068c7c341ee448c3f0d6f115 ]

Fix to avoid cases where the `res` shell variable is
empty in script comparisons.
The comparison has been modified into string comparison to
handle other possible values the variable could assume.

The issue can be reproduced with the command:
make kselftest TARGETS=net

It solves the error:
./tfo_passive.sh: line 98: [: -eq: unary operator expected

Signed-off-by: Alessandro Zanni <alessandro.zanni87@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250925132832.9828-1-alessandro.zanni87@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- `tools/testing/selftests/net/tfo_passive.sh:95-101` now quotes `res`
  and switches to a string comparison, eliminating the `[: -eq: unary
  operator expected` error that surfaces when the output file is empty
  during `make kselftest TARGETS=net`; without the fix the harness stops
  before it can report the real problem.
- The test still fails only when the passive TFO socket actually returns
  an invalid NAPI ID, because the server helper continues to emit the
  decimal string produced in `tools/testing/selftests/net/tfo.c:80-85`,
  so legitimate `"0"` results are caught exactly as before while other
  values (including blanks) no longer crash the script.
- This is a one-line, self-contained shell fix with no kernel-side
  impact and no new feature work; once commit `137e7b5cceda2` (which
  introduced the test) exists in a stable tree, backporting is trivial
  and restores the test’s usefulness.
- Risk of regression is essentially nil: the change follows standard
  shell best practices (quoting and string equality) and only affects
  the selftest infrastructure, improving reliability without touching
  runtime behaviour.

 tools/testing/selftests/net/tfo_passive.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/tfo_passive.sh b/tools/testing/selftests/net/tfo_passive.sh
index 80bf11fdc0462..a4550511830a9 100755
--- a/tools/testing/selftests/net/tfo_passive.sh
+++ b/tools/testing/selftests/net/tfo_passive.sh
@@ -95,7 +95,7 @@ wait
 res=$(cat $out_file)
 rm $out_file
 
-if [ $res -eq 0 ]; then
+if [ "$res" = "0" ]; then
 	echo "got invalid NAPI ID from passive TFO socket"
 	cleanup_ns
 	exit 1
-- 
2.51.0

