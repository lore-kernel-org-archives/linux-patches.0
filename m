Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928B0231842;
	Wed, 20 May 2026 17:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297060; cv=none; b=KfIcNY0EOrPOlKxuGUecqhlWTG67ka5TL8NirBbim3GnMaRDNA5wwJ9LNJOB4WVM2zMFFKLXgvav3dv5iwet0wNEEPz56iTUfcoKPNAiBfVy0ixXMygGB2F07wJLCXNYKiPp+xrkMiCjWCD2RjoWK2S7tYWCZdwrXqWeh95Rpzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297060; c=relaxed/simple;
	bh=ngMxNOuTHiQn5g/tBU4sFpe/Y5C36BJc/B/JcRVIqw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDFrP1Dyzj/aqI1lMud2z2vGHH6A2e5s6AYOlD44PX9xMB2Me75b6UBjAYHmCU3LGiSVfybeqbm1EogdLvktV3C2q/osByOVehVrKlvSCEuGIdfpxcYmx/ZVPqAVRACG6CJBIocnPQhAw3vG3y/+jm7QJJtWOk7Qn4I5odQ3wo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VuPX0j4n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VuPX0j4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0313D1F000E9;
	Wed, 20 May 2026 17:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297059;
	bh=4wwJY4X7qACYBTb+SYAQgspSvulU1Z9yXAs/iHZLWw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VuPX0j4n6JGxz0iOkt1Mo2sKd/uLIuUEwaVkwCtM/DddeW60/Rg5slzkrGRkIbEee
	 KC1WufUYOkLl31aTqzrTKY/EHz8Od4ipC7fEfxEC/j49Mgjr6SwWtu9I51zopRXiUc
	 63n/7yO0c8cDY3TDjQygE3ABTxANzh8nFqjFuJqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1034/1146] kselftest/arm64: Include <asm/ptrace.h> for user_gcs definition
Date: Wed, 20 May 2026 18:21:24 +0200
Message-ID: <20260520162211.630707711@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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



