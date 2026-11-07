Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063184;
	b=jBgocMRKhMzyFveGLqrLTIwVXPe5bMCWLuXJ0YK5fU80aPoKM3GtfU3Zn6BdQWuiUDvP
	 HByAC5idfJ7F+TWO6cJoP2hmDnI3ccEYVjeDe5BPVI1GkLZcpx9HVUj/nnLdUyLpZdcRD
	 Sb3Ypoz9YR99482izD2vxtKt1D/gEgOMWl5MAqBePAU5cZPJgitXa30jLvTj7qld2tcHG
	 /xL9cDNUN1wloQVyYgH4NTihC+J+l61pwM4hXhyGdiHClbi6Zldh75mV/4sNTyuBFmpvB
	 xbOiIqV8tdQ5KCaAS1WpPSOcN65KKPF87Bxw8xw7Q+4cSmYOsgN+5wo+G1VbSQTJ2GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063184;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z7Mh7rzP+NOv55u7C/VB4Kkwzg+aOznES8lkEly7hZk=;
	b=IhypxsRf2t1C3HiCgBmF96+pVNibyB16/3MGI/Es6DB0Y9HsBhPJ5pYTpOIM2EwY0cNp
	 LjXFVmmjU59D3VVzJ3xdpEtfGpPGl3L62hlGpqSpGVYP4/iIKChxAZBWMUOJvEtCKYHO1
	 QKFteWnB7meK8MAmG7x845JvfiUxvKS+RNV1V4Jam8Csrc+0Yl+R9kt3xJnwDJ4eDgQWd
	 +toTwhD9EnxclyQgDNHHSOIKPtGL8bAZWdyzf60MV1rocLa7NsqtZcH3nyPzzfuFBTT9Y
	 Wv5lCqLDlf6J9SA0axqZy9vMmruEAIW1PujnQHjBYneUB2pcRtb7sCGH4+wrYdXExKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=njDxWus5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A7E606A330;
	Sat,  7 Nov 2026 14:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=njDxWus5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89C81F0089F;
	Sat,  7 Nov 2026 14:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063183;
	bh=Z7Mh7rzP+NOv55u7C/VB4Kkwzg+aOznES8lkEly7hZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=njDxWus5btCtVtFBVeCKmtRt+WpOYuwttHAJLE64th/ud869q+ECIzN1XyHaLWHsV
	 CIZUmQ+86SBG2+78SJ5mISigRh8tNVHEVL51r2yjjDfcwCtKxjCaO5Dsxt2FrtKDpF
	 UkHluBVaAuDlpBDxGr0omiH8KV+xv84ddkt3Byv0=
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
Subject: [PATCH 6.18 393/869] selftests/core: fix unshare_test with large fs.nr_open
Date: Sat,  7 Nov 2026 08:51:15 -0500
Message-ID: <20261107134906.745613715@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



