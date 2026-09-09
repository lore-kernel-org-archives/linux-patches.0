Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29AC5632B5;
	Wed,  9 Sep 2026 14:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964014; cv=none; b=tXeKNH8XLHIwTMYAy5EatQ75wUWuy5U5qSiFhmjN2uhTd2OebpScT78FXwv7oWx5mqUWGvweCtHv/QGVlQYKINyjHKDSMN5TG4wbfPqIRkYVNxhllhsW+rXvHIFag1cxwoGCcU+Kmd9y7/pJqg3vieZ9H8azXw6l8VzRUET1AOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964014; c=relaxed/simple;
	bh=alusUXw4KI2rtgfhb9mG8m0adCDUmBh+vygfCj591bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoW3SBAOdoL1CG6D5ZHJ//4EhUjWsH9oxlp8YVhGvRIGjsh0xyUl30W8fYJIpVQZRJbAjXY0IlIDtWpxnWPDDHbWS5OlwfEAYibM7YmjRQXtXfPr/IWjOwggllluf/aTRtyJXr+5wfK1wDbADBt/nN4zMqzRYIWxtkEXkBK3F+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=On/kALWI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="On/kALWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191461F00A3A;
	Wed,  9 Sep 2026 14:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964013;
	bh=ENqTRd3F1PG0AiBZMHSLx432mpi1SG8Q2/CDj+6k170=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=On/kALWIma/0Lcp3Ucb+7hQ1QTg1nglzdTxQWHnyuL7xdqFA39Z9i1Zt70l4g+Pqx
	 oQcM6rjEvwsXvDzG3eGUGYVszRTq+xBqliRfWZJcv0cQ06NgOAUl+iJ39PobQ+RMM+
	 wlrsae162ZLmC7DapUMFq3JUd+na/U6rJFYeJDwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 270/583] LoongArch: Do not select HAVE_RUST when KASAN is enabled
Date: Wed,  9 Sep 2026 15:39:15 +0200
Message-ID: <20260909134247.444357168@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit 63b6a48c951d63bf39d44603ada48a987ccf66eb upstream.

After commit 2625480a1bf7 ("hardening: Default randstruct off with rust
for better allmodconfig support"), which allows Rust to be enabled for
allmodconfig, ARCH=loongarch allmodconfig starts failing with:

  error: kernel-address sanitizer is not supported for this target

  error: aborting due to 1 previous error

  make[4]: *** [rust/Makefile:741: rust/core.o] Error 1

For the same reason as the commit 84a0f7caafc679f7 ("ARM: Do not select
HAVE_RUST when KASAN is enabled"), do not select HAVE_RUST when KASAN
is enabled until the loongarch64-unknown-none-softfloat target in rustc
supports KASAN.

Cc: stable@vger.kernel.org
Fixes: 90868ff9cade ("LoongArch: Enable initial Rust support")
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -173,7 +173,7 @@ config LOONGARCH
 	select HAVE_RELIABLE_STACKTRACE if UNWINDER_ORC
 	select HAVE_RETHOOK
 	select HAVE_RSEQ
-	select HAVE_RUST
+	select HAVE_RUST if !KASAN
 	select HAVE_SAMPLE_FTRACE_DIRECT
 	select HAVE_SAMPLE_FTRACE_DIRECT_MULTI
 	select HAVE_SETUP_PER_CPU_AREA if NUMA


