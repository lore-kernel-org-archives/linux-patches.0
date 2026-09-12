Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EC737F313;
	Sat, 12 Sep 2026 11:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213713; cv=none; b=PBdYBpjK+ueyb4myuS3+wLLw9L9JwiwCwIOerWtsep4pPbc+e6/hbxlryQLck0O6MalLhTCBdflPPeQvEk4zamKXZhTzMcdly/wlMv33vXDlR9BSIuzJmli4fBXZKU1Uz+nMxa9rKq6X3Zkaqb39LYFAFC5JKs9pPm4vtektlUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213713; c=relaxed/simple;
	bh=H6z9D0CfvfejVmFQ2dri8wxTmgTPwgmmb5m5Y10LK5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hK+aII5XRi9gZIX4rMiJrXCUzWMAyhqeMbTBuqnWBSn+iAZKx5HLeq/heWVRgJNCbDN6ZYqhPsdeU+DQ+EEoxx+b+yTWj8JzELhSwI9O88g1zZ4Rckel62Hje8AVCxoTbkq3B+chgNaPk4aU3OLfuCdrQXzpnWYCcNuDOGkFFI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaoxpBCv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaoxpBCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396EE1F000FF;
	Sat, 12 Sep 2026 11:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213712;
	bh=jBvX5k8wjCeVI7SRByaedAFjbJmksZ9LX+K2aEviBT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WaoxpBCvQV9u6vsjUNrjSqveweEAQhAE7sFDM5QmOmRcbBFqE4WiizcqBbJFBpoHg
	 Wg3QALZih2FjvEbYZ5WTbXohtooTNO3pze8uAFfPhq4m9F7pP8cLC9kYa96Sp+B+l9
	 yctTPkkr8o7Z8WlmPu7w3gq7/8WlGLm8gTybXu5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 0176/1376] LoongArch: Do not select HAVE_RUST when KASAN is enabled
Date: Sat, 12 Sep 2026 08:43:22 +0200
Message-ID: <20260912065611.472752859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -161,7 +161,7 @@ config LOONGARCH
 	select HAVE_RELIABLE_STACKTRACE if UNWINDER_ORC
 	select HAVE_RETHOOK
 	select HAVE_RSEQ
-	select HAVE_RUST
+	select HAVE_RUST if !KASAN
 	select HAVE_SAMPLE_FTRACE_DIRECT
 	select HAVE_SAMPLE_FTRACE_DIRECT_MULTI
 	select HAVE_SETUP_PER_CPU_AREA if NUMA


