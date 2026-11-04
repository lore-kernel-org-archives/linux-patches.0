Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831240;
	b=rSgGHqVh6BDSvj/eXLbQ+vOr3bABkHnM0PahK56OJKRgNZPIaQWo5KKQEfwTcADB8KA4
	 6WWL9Kgw/Q4Mc0XX6WuKDgS/Y2hCzCpIO0i7xF9rM+GXYLnf4Q0KDqv2JmGdH40JsBVsg
	 GTvwMXf52TtUaT6h6kVMdMpJZdXnk3KVKNoySUQTjqzPl9QTaFog+YqCVqQ1L0S32vW4e
	 XZEhKa8itkAzoSwDMP7Ig38vE0JZcZ24vxkaHYAj4/NVE6wS7eJZeg42IJY0EMr2d9BUI
	 L87c4Jeo1YXsgbdeHqR+txOEgFF2Pc1+FbT/2YRXDz+u2V4yGv9kfGuz1pZi7MWfnQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831240;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7mDApX3A+tdoAoQZg+qJPwgiJS5RjR/JBYJLk5fnlQk=;
	b=RQVAFwABgLZZRmuR6iL3AcJrh2PfQGREpj3IaAvH9/KPV3Tlb4myOBSw2JdYPoUBRWaC
	 PlATfL5tm5bamSXxeaxZ85WDLfNvqSXyi6XzQQUwh5qlmK+refMDimoKsmdTMO9lmD2Nw
	 E6tzP12SCXzJq4Qe8l62Euqim3hv+lz4OQeaueO0mnqq5lF2inPgsXZabK1oztmA4wiZs
	 DKGr5ytf4qiv7Xm5zRFWOWhsZdplhWhcdHDf2nOHyiDI+hjTsF+Avk3mxZXnSNaXQJraQ
	 j6N5J3CiIAsWTvzcjvNj4GOFwT4AVk8nwzH/6oC6R0sNojHWCPSdMuz3WT8/nNsmQag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MpLw3t+2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB9A606A842;
	Wed,  4 Nov 2026 22:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MpLw3t+2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5E81F000C1;
	Wed,  4 Nov 2026 22:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831240;
	bh=7mDApX3A+tdoAoQZg+qJPwgiJS5RjR/JBYJLk5fnlQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MpLw3t+22+fGMmlWUKFcI14N+4yZqgXFJ9q1XvDblCz5eCLsnz3rWzXB2keVhSpnD
	 5yrFbVx5EAMDZQ2JfPQJFgSI1LyHQwPJ+t3XBLTAVli5KhBtTcUYzjhHH1/mJWo00Z
	 9ZRrOWs6VQdsTFhNLR0tuTQ2h7xYwm/Gt1rbX9jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0583/1005] selftests/ublk: fix Makefile to rebuild on header changes
Date: Wed,  4 Nov 2026 16:05:16 -0500
Message-ID: <20261104211100.176632550@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit a2ce133969175d36d708b7c76536b375d0522e53 ]

Add header dependencies to kublk build rule so that changes to
kublk.h, ublk_dep.h, or utils.h trigger a rebuild.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: c4fa55f85c47 ("selftests: ublk: install test_common.sh and trace/ scripts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ublk/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/ublk/Makefile b/tools/testing/selftests/ublk/Makefile
index 770269efe42ab..4bf7a686e21d2 100644
--- a/tools/testing/selftests/ublk/Makefile
+++ b/tools/testing/selftests/ublk/Makefile
@@ -42,10 +42,10 @@ TEST_PROGS += test_stress_05.sh
 
 TEST_GEN_PROGS_EXTENDED = kublk
 
+LOCAL_HDRS += $(wildcard *.h)
 include ../lib.mk
 
-$(TEST_GEN_PROGS_EXTENDED): kublk.c null.c file_backed.c common.c stripe.c \
-	fault_inject.c
+$(TEST_GEN_PROGS_EXTENDED): $(wildcard *.c)
 
 check:
 	shellcheck -x -f gcc *.sh
-- 
2.53.0



