Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CA33F4DC0;
	Wed, 20 May 2026 17:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299661; cv=none; b=tgqnOom4zfx2GhPMfRHm8oOistCYcAlMHFKXKsFGvKBIH0YctFq5a3JT0vHYCeMEClcoG9+ZncsyMzJCFQKd8VVy2uD5ulGco2yZSQylHCPBGJiDD5loooTUibGwbdSoCa9ywwuIOfe5LFNaA0QkGgoCNNhcgi4KqRzAy1738To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299661; c=relaxed/simple;
	bh=RgMCk+/2/Ue8o40PadZQYkSpk+mhj9Tg3EOo6YVYps0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yu0FLj87XKYnPzb6t9U8tXccEuCvNqBQ6ahqRotwFA83DV+3upOSwP999hNYbQ9V2bBvTtgcnCuHr51+Cw4JgPcFV3nJ/aBWU7RXpmFRmijUfYuBkfkaS2+7Zfl9OqkgiB0x333pp22QCgb/cqOig+HLoq8CIzeNs1cRI2WH+jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AgBi2Jwq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AgBi2Jwq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F471F000E9;
	Wed, 20 May 2026 17:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299658;
	bh=GtizY04h9R/BmUhRh8CELXRXgN/zhJczU29dSXdIRaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AgBi2JwqouEkxr0bDaiK5J/rzzOYk97WDbaYRVe8YP9Cav7vUutOfx7LJV42ZWMg1
	 /0sVKgd6Rfk1jIO4zRWDjbP8NQDTJZXg+Yf8BG1POYwHC1emRQ51WYoj5ss8Ww4OcK
	 qNlZ+TKqaPChzv8YgVFlX87jxktkxV1+PShgN1r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 857/957] kselftest/arm64: Include <asm/ptrace.h> for user_gcs definition
Date: Wed, 20 May 2026 18:22:20 +0200
Message-ID: <20260520162153.150721719@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit bb7235e226888607e6aac1288062fcb1ac105589 ]

kselftest includes kernel uAPI headers with option:

  -isystem $(top_srcdir)/usr/include

Include <asm/ptrace.h> in libc-gcs.c for the definition of struct
user_gcs from the uAPI headers, and remove the redundant definition in
gcs-util.h. This fixes a compilation error on systems where the
toolchain defines NT_ARM_GCS.

Fixes: a505a52b4e29 ("kselftest/arm64: Add a GCS test program built with the system libc")
Signed-off-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/gcs/gcs-util.h | 6 ------
 tools/testing/selftests/arm64/gcs/libc-gcs.c | 1 +
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/tools/testing/selftests/arm64/gcs/gcs-util.h b/tools/testing/selftests/arm64/gcs/gcs-util.h
index c99a6b39ac147..7a81bb07ed4b8 100644
--- a/tools/testing/selftests/arm64/gcs/gcs-util.h
+++ b/tools/testing/selftests/arm64/gcs/gcs-util.h
@@ -18,12 +18,6 @@
 
 #ifndef NT_ARM_GCS
 #define NT_ARM_GCS 0x410
-
-struct user_gcs {
-	__u64 features_enabled;
-	__u64 features_locked;
-	__u64 gcspr_el0;
-};
 #endif
 
 /* Shadow Stack/Guarded Control Stack interface */
diff --git a/tools/testing/selftests/arm64/gcs/libc-gcs.c b/tools/testing/selftests/arm64/gcs/libc-gcs.c
index 17b2fabfec386..72e82bfbecc99 100644
--- a/tools/testing/selftests/arm64/gcs/libc-gcs.c
+++ b/tools/testing/selftests/arm64/gcs/libc-gcs.c
@@ -16,6 +16,7 @@
 
 #include <asm/hwcap.h>
 #include <asm/mman.h>
+#include <asm/ptrace.h>
 
 #include <linux/compiler.h>
 
-- 
2.53.0



