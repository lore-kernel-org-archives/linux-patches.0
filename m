Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1E81D61BB;
	Fri,  8 Aug 2025 15:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754667078; cv=none; b=l9guhYvgULxf3GIdWoMBf8gjbSvCGcAIKrRjYte7k81lbEspi1CbSfXScpAx5yHGyPQtg0uIbcFLQY0QrEJErvMBK6ZaWgnkEewLYBBLavUKlB3OJcM71vvI6KFvsB27Fs7sO0Y94ZecmMfAtEqZQvxveroFABiYF+wnwRXaqeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754667078; c=relaxed/simple;
	bh=s7yEPYEJ4nywSUhC4VyVeBBQPUEYxS3k3UwaRBV14tA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hC3G9lysdV6orKOItPk4Ai/Epn2yrGXroFvDE4QiPsHuKWn2+Ag00SD+mR3u8HDucp29bXA+Vad4n4IObs6WsH1O60vDLnVy8S113Kq/UMSmTx2v+2ajp5+fwGiG48hk+0gTHxMQ4AM+aVf+7ijEXRxDxfxxBCzr3smBEUv8nug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R+u5IKPN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R+u5IKPN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FE0C4CEF6;
	Fri,  8 Aug 2025 15:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754667078;
	bh=s7yEPYEJ4nywSUhC4VyVeBBQPUEYxS3k3UwaRBV14tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+u5IKPNXIiSvvbD/hNseUwAy0jc2yIp0rtGeH2p1XlU13CEmVERVDYk9tZmA1ZW5
	 KDSVdcMOs+bFc6r8vsOkK941roFPE+fDw0k5vWZLVvZ3G4HgXMh1rAv2cvbwrNDjj1
	 0FlHkMzwwiGIHVkGjM4plkNfdLsTBx1fSWQqTDirvvDKGWdv6gijOdI+bcnkcyL6Hr
	 rSdLgNo0zI10d/bxwPanjBlAfdsit+rPLW8jJG7xRHYpbCGv/dxc3WB/Atgo+yrSJy
	 RLYdW5m1PvhLnH3mmHILYOvE2vGPvoZWIM5ezVjf+QrBWwHgP4hxq6LaLANzSN476/
	 j81oMNZ1eEMnA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mateusz Guzik <mjguzik@gmail.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>,
	rdunlap@infradead.org,
	ryan.lee@canonical.com,
	linux@treblig.org
Subject: [PATCH AUTOSEL 6.16-6.1] apparmor: use the condition in AA_BUG_FMT even with debug disabled
Date: Fri,  8 Aug 2025 11:30:50 -0400
Message-Id: <20250808153054.1250675-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250808153054.1250675-1-sashal@kernel.org>
References: <20250808153054.1250675-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Mateusz Guzik <mjguzik@gmail.com>

[ Upstream commit 67e370aa7f968f6a4f3573ed61a77b36d1b26475 ]

This follows the established practice and fixes a build failure for me:
security/apparmor/file.c: In function ‘__file_sock_perm’:
security/apparmor/file.c:544:24: error: unused variable ‘sock’ [-Werror=unused-variable]
  544 |         struct socket *sock = (struct socket *) file->private_data;
      |                        ^~~~

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **It fixes a real build failure**: The commit message clearly states
   it fixes a build failure with `-Werror=unused-variable`. When
   `CONFIG_SECURITY_APPARMOR_DEBUG_ASSERTS` is disabled, the
   `AA_BUG_FMT` macro becomes just `no_printk(fmt, ##args)`, which
   doesn't evaluate the condition `X`. This causes the `sock` variable
   in `__file_sock_perm()` to be unused, triggering a compiler warning
   that becomes an error with `-Werror`.

2. **The fix is minimal and contained**: The change only modifies the
   `AA_BUG_FMT` macro definition when debug is disabled, adding
   `BUILD_BUG_ON_INVALID(X)` which forces the compiler to evaluate the
   condition without generating any runtime code. This is a well-
   established pattern in the kernel (as seen in `VM_BUG_ON` and similar
   macros in `include/linux/mmdebug.h`).

3. **No functional changes or side effects**: The fix doesn't change any
   runtime behavior. `BUILD_BUG_ON_INVALID(e)` is defined as
   `((void)(sizeof((__force long)(e))))` which only evaluates the
   expression at compile time to ensure it's valid, without generating
   any code.

4. **Follows established kernel patterns**: The commit message states
   "This follows the established practice," and indeed, examining other
   kernel debug macros like `VM_BUG_ON` shows they use the exact same
   pattern - using `BUILD_BUG_ON_INVALID` when debug is disabled to
   ensure the condition is still evaluated by the compiler.

5. **Low risk**: This is a compile-time only change that prevents build
   failures. It cannot introduce runtime regressions since it generates
   no runtime code.

6. **Affects a security subsystem**: AppArmor is a security module, and
   build failures in security code can prevent users from building
   kernels with their desired security configuration.

The commit is a classic example of a safe, minimal fix that resolves a
real problem without introducing new risks, making it an ideal candidate
for stable backporting.

 security/apparmor/include/lib.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/security/apparmor/include/lib.h b/security/apparmor/include/lib.h
index f11a0db7f51d..e83f45e936a7 100644
--- a/security/apparmor/include/lib.h
+++ b/security/apparmor/include/lib.h
@@ -48,7 +48,11 @@ extern struct aa_dfa *stacksplitdfa;
 #define AA_BUG_FMT(X, fmt, args...)					\
 	WARN((X), "AppArmor WARN %s: (" #X "): " fmt, __func__, ##args)
 #else
-#define AA_BUG_FMT(X, fmt, args...) no_printk(fmt, ##args)
+#define AA_BUG_FMT(X, fmt, args...)					\
+	do {								\
+		BUILD_BUG_ON_INVALID(X);				\
+		no_printk(fmt, ##args);					\
+	} while (0)
 #endif
 
 #define AA_ERROR(fmt, args...)						\
-- 
2.39.5

