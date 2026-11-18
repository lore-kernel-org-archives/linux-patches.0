Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016754;
	b=vQPWyLbNEotqhQdbHZ43AuQvuuZ8QdmxjLpv1YmurkqU38luBd6lfmU5b7F4HH7J4gXG
	 Gt0+F4tofkpF67kLdLO0SJuxR2zGVQRRRMeMabODetOrGa5LQ9n6/INAWvkA4PmFH0vL5
	 GOCY4uExLI56VfO4kxotAmRP14IuXSj5+BunRuyURx5riO0o2ODF8fuErfRxpVsHTcMHp
	 Fk+8qunHj26CVuSHoZlfNtg834pIXzCA4z7aHnUs+eGtOFEOp8LivwnekPSsPuU66QcFb
	 o7/cRTyhKqE/I2+YNO3mp9CJeDe0SqGdnz42x54yfDKOQUeTCIlqG66vuV0APIkH6Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gPf7lVc+h/xv5Y+5ZnAf1saHUj8h7W6WJ3qYdwNQlVo=;
	b=oOTbljBVgtSQHdjgNelTB7cYgl23pDalN7JjWWURV8hcvl/Y3gKv/qI3KuB07DPf5qf/
	 /SNhQS9QC/7SBuXtxwBc4nGeQSbNNY0xBHsVnzWWYVtLvFNm6F3qgTU2Ch6dsXc7p+Nr0
	 CbErU60HHV/zMSAbkCXPkcD2NVjHbE9ty6C9LSDP2NIP+psCrz3jgSr7uPQuvOKhWJd6Y
	 vbk/rE5AFyOjQPLYuOZql471z1o8aqtjxyUC6E3raeNL68Fhla7wZHpMf7Ff8ldcoORUk
	 VEUM84tYiHOxUlXvXeKRIcpOqHMpxY5ykSPoMIgHpYG9/TV+XYhpvShfmIVRDY2Duaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d3L7Q5iv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889B2606A325;
	Wed, 18 Nov 2026 15:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d3L7Q5iv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BD71F000C5;
	Wed, 18 Nov 2026 15:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016754;
	bh=gPf7lVc+h/xv5Y+5ZnAf1saHUj8h7W6WJ3qYdwNQlVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d3L7Q5ivV/Z9cD/b2zLR1hK0rcUkilJsmjYrvLdIWNkJP0QIbcJxFH7zD04jQIgQd
	 wHLvXVIRXcxuVJz9gVfR2NQaLoFl7bDAe35pigta6bBjOmX4GAnsM6Tfz+5H4IDBdz
	 7oe3QVGHP0EBNsM64aKIAxN17fNlYXtWhocspr7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0640/2651] perf libbfd: Fix the clang -Wthread-safety build failure
Date: Wed, 18 Nov 2026 15:31:20 +0100
Message-ID: <20261118150310.723684877@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit c4c43343501bd9fc24ec501ecaf43b7ef2da44d2 ]

perf_bfd_lock() and perf_bfd_unlock() are the callbacks given to
bfd_thread_init(), so by design they acquire and release the lock on
libbfd's behalf and the lock state differs between entry and exit.
clang's thread safety analysis, which perf builds with as an error,
flags both:

  util/libbfd.c:56:1: error: mutex 'bfd_mutex' is still held at the end of function [-Werror,-Wthread-safety-analysis]
  util/libbfd.c:60:2: error: releasing mutex 'bfd_mutex' that was not held [-Werror,-Wthread-safety-analysis]

Mark both functions NO_THREAD_SAFETY_ANALYSIS so that libbfd.c compiles
with "make CC=clang BUILD_NONDISTRO=1".

Fixes: b72b8132d8fd2d6b ("perf libbfd: Ensure libbfd is initialized prior to use")
Signed-off-by: Ian Rogers <irogers@google.com>
Assisted-by: Antigravity:gemini-3.1-pro
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/libbfd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/libbfd.c b/tools/perf/util/libbfd.c
index 936555217e81a..d1d1c9b2ef223 100644
--- a/tools/perf/util/libbfd.c
+++ b/tools/perf/util/libbfd.c
@@ -39,13 +39,13 @@ struct a2l_data {
 	asymbol **syms;
 };
 
-static bool perf_bfd_lock(void *bfd_mutex)
+static bool perf_bfd_lock(void *bfd_mutex) NO_THREAD_SAFETY_ANALYSIS
 {
 	mutex_lock(bfd_mutex);
 	return true;
 }
 
-static bool perf_bfd_unlock(void *bfd_mutex)
+static bool perf_bfd_unlock(void *bfd_mutex) NO_THREAD_SAFETY_ANALYSIS
 {
 	mutex_unlock(bfd_mutex);
 	return true;
-- 
2.53.0



