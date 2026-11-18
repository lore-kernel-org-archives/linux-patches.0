Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047486;
	b=fExNzrYsI36UQVV4GumL4ZOJK9R09fd7d2mlLX8xYKCkCUovorTrZNxYzMZ3cXohpiYn
	 QLsgGhZ6a4kP0+6mnsYWXo04NrWrvpsVVc41HYhEADySJhMrKwYvfq0MfnBJbas3sGfag
	 mP64/DcnEihOzASUnS1Cw+zvSHNW9ikyJSi+i/ixWwMWD4S7wWNPiBbYaYnDjoDYKoUTb
	 KlYtbymTfYghWRv70AIChahmEKBHuqAYsjmqUbufZmd13k+1OQjukdtazGJxF1pwymklV
	 uOQ/ZVafHB3/Pm2WmVmC1hd8m496Nu0c9vk0aXIjnsDaxyp55XUW6cHtxq6Esn0MRlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047486;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C7ZD7fcHsva/zU68YRCotIx3KhfuFNX54ks8uKi8Hxs=;
	b=x9cAhGLIh7RbAg3TUMnvCuJo1RGnKkNQJHgok+AZVMNgwwT713zMKgpYCMEGs3VIwmmg
	 +9O6H3u1WVbPC8fiJKaukNyqlsEptNXOebGO4+D6diE+iVWYH/2oszc1pnggm+X2gjFo8
	 c1FXS3jB0/v6rKPOqxUTdFCj+R1Wdvg/67m+QU1WqAJoH30/i2k8CPuZ6r/khZf874VNg
	 PdeZnw79m7huajglZmlDnpEkO9EkhZiD++LEB7uASpYleRxZ7qTGmivykCGEehMbEzgkz
	 I3AkReH2r30WqV2zC++8yhBcorIOu0MBJiiwsEtQH4bWEmwOV8uDmh998VzUZloLdbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xje7BwNE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E24606A32A;
	Thu, 19 Nov 2026 00:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xje7BwNE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0EC1F000C4;
	Thu, 19 Nov 2026 00:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047486;
	bh=C7ZD7fcHsva/zU68YRCotIx3KhfuFNX54ks8uKi8Hxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xje7BwNEDFOE4Q3HuXsLsbUWgMo8GIlJ7UJVYaS7QqvhDCGmT6JxVFis6Zx54uYxY
	 HvLs6ZlXdu5VZ4YQd1QaOpn4LAGisOH1U0kK0ykKxXt2u/F5Gv3HE1CGTciL4X2YU3
	 EWKIjeBDybpSiUVhXE7jsEvj4Ie4Zai1akzRIO/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Khorenko <khorenko@virtuozzo.com>,
	Eva Kurchatova <eva.kurchatova@virtuozzo.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1639/2857] selftests/core: fix unshare_test with large fs.nr_open
Date: Wed, 18 Nov 2026 15:44:33 +0100
Message-ID: <20261118150300.350186899@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Khorenko <khorenko@virtuozzo.com>

[ Upstream commit df0b7e0ea59c43708cff8c7e34da5e2f8d430e5e ]

The test assumes fs.nr_open is close to the default 1048576, but some
systems set it much higher (e.g.  1073741816).  This is systemd's doing:
since systemd v240 (2018), PID 1 bumps fs.nr_open and fs.file-max to their
largest possible values on boot, as file descriptors are already accounted
for by memcg [1].

In that case, dup2() to nr_open + 64 requires the kernel to allocate a
file descriptor table with ~1 billion entries, which fails with ENOMEM.

On a kernel that already carries 04a2c4b4511d1, dup2() no longer fails
with ENOMEM.  The allocation is now rejected up front and the caller
gets EMFILE instead, without the WARNING, but the test still fails.

Cap the nr_open value used for the test's own arithmetic to a known
reasonable base value (1048576) and restore the true original value once
the test has completed.

Link: https://lore.kernel.org/20260814165709.513263-1-khorenko@virtuozzo.com
Link: https://github.com/systemd/systemd/commit/a8b627aaed409a15260c25988970c795bf963812 [1]
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
Signed-off-by: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/core/unshare_test.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/core/unshare_test.c b/tools/testing/selftests/core/unshare_test.c
index 7fec9dfb1b0e3..6716e0f74d7da 100644
--- a/tools/testing/selftests/core/unshare_test.c
+++ b/tools/testing/selftests/core/unshare_test.c
@@ -40,6 +40,14 @@ TEST(unshare_EMFILE)
 
 	ASSERT_EQ(sscanf(buf, "%d", &nr_open), 1);
 
+	/*
+	 * Cap nr_open for the duration of the test to avoid ENOMEM from a
+	 * huge fd table allocation; buf/n keep the real original value so
+	 * fs.nr_open can be restored to it once the test is done.
+	 */
+	if (nr_open > 1024 * 1024)
+		nr_open = 1024 * 1024;
+
 	ASSERT_EQ(0, getrlimit(RLIMIT_NOFILE, &rlimit));
 
 	/* bump fs.nr_open */
@@ -73,10 +81,13 @@ TEST(unshare_EMFILE)
 
 	if (pid == 0) {
 		int err;
+		char buf3[32];
+		ssize_t n3;
 
-		/* restore fs.nr_open */
+		/* restore fs.nr_open to the (possibly capped) test baseline */
+		n3 = sprintf(buf3, "%d\n", nr_open);
 		lseek(fd, 0, SEEK_SET);
-		write(fd, buf, n);
+		write(fd, buf3, n3);
 		/* ... and now unshare(CLONE_FILES) must fail with EMFILE */
 		err = unshare(CLONE_FILES);
 		EXPECT_EQ(err, -1)
@@ -89,6 +100,10 @@ TEST(unshare_EMFILE)
 	EXPECT_EQ(waitpid(pid, &status, 0), pid);
 	EXPECT_EQ(true, WIFEXITED(status));
 	EXPECT_EQ(0, WEXITSTATUS(status));
+
+	/* restore the real fs.nr_open value */
+	lseek(fd, 0, SEEK_SET);
+	write(fd, buf, n);
 }
 
 TEST_HARNESS_MAIN
-- 
2.53.0



