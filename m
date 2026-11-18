Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017377;
	b=0CkCwwLOC49FuavoihtYYw3v+eSFoVZkCFn03RgjIH8akhsiVpD/rQ2zO1it+u84bARB
	 v9V9Vxmjvq7/nar2Ngy+5n0vtv1XkjnOsj3arl+zZkmcs9jPwqT4d7wtUA3A09rwXwk57
	 AjVaim/yjpbom5abTAaMKfE477fM7qx8gKSZfFgi/4tIC2w1PdDm7IW36CCEM43uNoP7J
	 5iK0nkrVjTAbYJSk1jvo10EMe4kxolbavUUqnSkdoq118tnYl+vZbINwnV3g2V3jGmjRy
	 dgAX38Fa7gWBqPlsODgJb/u1wf/CKIftzfDcXeMS6fvsio7d6zmRUizdyyORaKe6S4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sGinErszF67zhqay5Pxdczo6kGHT4udhBR6ok3Fj/9M=;
	b=fAWuK4JSQ8KhPnnC9sdHYtgTEgQn16Hw9bR2Ez1YYZSxIEnfLTgDFXeecAQAhIaRALNw
	 S6Dzudom+nwmbiNXE+BGpsPLWdJi4kjbhTLRtmKrXr8OzL9SUXXtEkpnfkEDc/ktZ+3Ie
	 u/gOIZDINX4aNKscMxA8J8zg1gymxXcr7lWShIhBHGVG18weqhoTAIVPoxzPXgySOA44S
	 +CwTot4bAvcTJPAEjGVHjT/QLmFypRdoCR/+vHMv1YQjrfJ2lWN4C4ka2lqhTd54/QIU4
	 fE5MkTGxK42OhZBPtzPyYSwesBlG2rERIkgzPB7+nOl4CnO8dg35eTI/RMB8zhcJgTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2UG3BW/B";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92A8606A31C;
	Wed, 18 Nov 2026 15:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2UG3BW/B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3971F000D0;
	Wed, 18 Nov 2026 15:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017377;
	bh=sGinErszF67zhqay5Pxdczo6kGHT4udhBR6ok3Fj/9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2UG3BW/B5Mkye9xSzpP9VqiRacwnnAaD2ZdMlejIma5PK70VBaVjReTlMwmU8mpNS
	 5CsyOuO3Z6K5CpysJHTyAPj3RIWhY/DT3wPFuvKnvefDJ4qhxrhiwF2R5OInDQhYjn
	 orfSWNV8pxxhpNlKaNZ29AJAVIc9EggcTrTOzYKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Dmitrii Dolgov <9erthalion6@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0862/2651] perf test workload: Use unsigned int in code_with_type instead of uint
Date: Wed, 18 Nov 2026 15:35:02 +0100
Message-ID: <20261118150318.895739406@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 66fcf1357a26d9cf8c7e34e2a70d12ebd7bd538f ]

The declaration of the Rust helper test_rs() uses "uint", a BSD-ism
that lives in <sys/types.h>, so on glibc it is only visible by
accident: glibc's <stdlib.h> includes <sys/types.h>, where uint is
exposed under __USE_MISC, which is on by default.

musl does none of that: its <stdlib.h> doesn't include <sys/types.h>
and it typedefs uint there only when _GNU_SOURCE/_BSD_SOURCE is
defined, while nothing else in this translation unit includes
<sys/types.h>. Building it on Alpine therefore fails with:

  tests/workloads/code_with_type.c:9:21: error: unknown type name 'uint'; did you mean 'int'?
  tests/workloads/code_with_type.c:39:17: error: implicit declaration of function 'test_rs' [-Wimplicit-function-declaration]

The second error is a consequence of the first one: with the
declaration at line 9 rejected, the call at line 39 has no prototype,
which is an error since gcc 14.

The breakage is only visible when rustc is present, because
tests/workloads/Build adds code_with_type.o when CONFIG_RUST_SUPPORT
is detected, and tools/build/feature only checks for "rustc
--version". That is why alpine:3.23 and alpine:3.24 fail while
alpine:3.22 and alpine:edge, lacking rustc, build fine and hide it.

Use unsigned int, which needs no header at all.

Fixes: 2e05bb52a12d3 ("perf test workload: Add code_with_type test workload")
Reviewed-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Dmitrii Dolgov <9erthalion6@gmail.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/workloads/code_with_type.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/workloads/code_with_type.c b/tools/perf/tests/workloads/code_with_type.c
index 65d7be7dac24d..d2d437b86e0c6 100644
--- a/tools/perf/tests/workloads/code_with_type.c
+++ b/tools/perf/tests/workloads/code_with_type.c
@@ -6,7 +6,7 @@
 #include <linux/compiler.h>
 #include "../tests.h"
 
-extern void test_rs(uint count);
+extern void test_rs(unsigned int count);
 
 static volatile sig_atomic_t done;
 
-- 
2.53.0



