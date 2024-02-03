Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CBA1B59F;
	Sat,  3 Feb 2024 04:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933734; cv=none; b=bR093JVDzf/0+pvaRZ9PjZPjVnMeqR5sNd9B8O13K2cn5p6GHFAGg0R16NDuMRRLq1tqA1ZklpAP+WkZuxy7WriRlIkBQ2CPCXSdCalLrKW+WxX4+6sVUKUlOf9DyrtFgnLKvUqNSt3P/M+UMWeag8cxMqgN5REyri6sy+GsqeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933734; c=relaxed/simple;
	bh=nr3VqHHjLGbZ7hRZveypMj71sZu8vs5Vg9J/2VDtUuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T+dEZWOOZQDDPhXIwbI0zvEpb9DtE44L+qXxP0yTvK/K+ZzEMjcHsXGzToaSftxSqBgFuTdfDeoRcmOjQvCyQlApGlFc+HIxC2wnaRlA8z1eejsvVW3/S2DEkbj7dyXgFoqQ5mkw57kAnOUq5MgDGVNPfgtwjCkq8YERhAnYrEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EiZ1kien; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EiZ1kien"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E82EC433C7;
	Sat,  3 Feb 2024 04:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933734;
	bh=nr3VqHHjLGbZ7hRZveypMj71sZu8vs5Vg9J/2VDtUuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EiZ1kien6NfEvYuP/cbUnZ/HF1Z23eGB2UDDQ6zmZ01+alcs3EWI7fAvala7ZuDJF
	 6FexOgKC9Bx5+4H4kXtv1GpuddtrwHqqe60ERJ2ke8URotj9Hj0BGPcvsE2jPubRPQ
	 BAj+D3KpVoe7dQFXJwDofcJPIHRI13DyNZSvkjlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 022/353] selftests/nolibc: fix testcase status alignment
Date: Fri,  2 Feb 2024 20:02:20 -0800
Message-ID: <20240203035404.455820809@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 07f679b50252dc9e3d0c19aca5801f82c230c527 ]

Center-align all possible status reports.
Before OK and FAIL were center-aligned in relation to each other but
SKIPPED and FAILED would be left-aligned.

Before:

7 environ_addr = <0x7fffef3e7c50>                                [OK]
8 environ_envp = <0x7fffef3e7c58>                               [FAIL]
9 environ_auxv                                                  [SKIPPED]
10 environ_total                                                [SKIPPED]
11 environ_HOME = <0x7fffef3e99bd>                               [OK]
12 auxv_addr                                                    [SKIPPED]
13 auxv_AT_UID = 1000                                            [OK]

After:

7 environ_addr = <0x7ffff13b00a0>                                 [OK]
8 environ_envp = <0x7ffff13b00a8>                                [FAIL]
9 environ_auxv                                                  [SKIPPED]
10 environ_total                                                [SKIPPED]
11 environ_HOME = <0x7ffff13b19bd>                                [OK]
12 auxv_addr                                                    [SKIPPED]
13 auxv_AT_UID = 1000                                             [OK]

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/nolibc/nolibc-test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/nolibc/nolibc-test.c b/tools/testing/selftests/nolibc/nolibc-test.c
index 2f10541e6f38..e173014f6b66 100644
--- a/tools/testing/selftests/nolibc/nolibc-test.c
+++ b/tools/testing/selftests/nolibc/nolibc-test.c
@@ -150,11 +150,11 @@ static void result(int llen, enum RESULT r)
 	const char *msg;
 
 	if (r == OK)
-		msg = " [OK]";
+		msg = "  [OK]";
 	else if (r == SKIPPED)
 		msg = "[SKIPPED]";
 	else
-		msg = "[FAIL]";
+		msg = " [FAIL]";
 
 	if (llen < 64)
 		putcharn(' ', 64 - llen);
-- 
2.43.0



