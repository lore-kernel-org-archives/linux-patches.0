Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D05277CB8;
	Mon, 13 Oct 2025 15:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368902; cv=none; b=eRgUVLKS7WWfnPnhXABpJXTuRcUFVOat3eQb4OziwZHeh0/e+DzsYPW9uMwwPvx+0KlWA6DXMmrEjeWvDxbMZmFnS/CFpmUfQijcIw16xHjNCOjFpoobJoYhf2se8olL4/w95Pwrp7c4dXQIxcQX/XCWQqJda9+qfTgSvgzULHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368902; c=relaxed/simple;
	bh=w98oeeMkDEuXw17CJVzT+4PDqY6Ww3MssXmdZtHsGS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OmBfrNxR4CWGzTJ21Zdr/Uy8Krgq5OCKkLUooMn6AY9EYFX3khTbarhD485BH8a+twryJopdH17h3T2FFRo3OKvmp7KFnCYrndclvzgCgcZDtof6QX218qAzAH27yKEb/kW5FTxM4YQpNqbXB6ClBq9xKdkPUJh0iPv1OEI/tpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hm5/HKPT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hm5/HKPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BB4C4CEE7;
	Mon, 13 Oct 2025 15:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368901;
	bh=w98oeeMkDEuXw17CJVzT+4PDqY6Ww3MssXmdZtHsGS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hm5/HKPTvkflXHMwtj+ltf2sa+mUXBbjiWqmMGsV7SndZyHvvVXdV/SwFXpOeRHzs
	 QKgrbvah+HB2tfqA+Eue8zB5qLy34387Vr/MmNNruA9ZvAX0EDwNfStxilD8f1uPh6
	 pF9chiXg0T+BzSDeG7qC/f4cKenOlqDRE3ErHsLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
	Nutty Liu <liujingqi@lanxincomputing.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 025/563] raid6: riscv: Clean up unused header file inclusion
Date: Mon, 13 Oct 2025 16:38:06 +0200
Message-ID: <20251013144412.200035346@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>

[ Upstream commit f8a03516a530cc36bc9015c84ba7540ee3e8d7bd ]

These two C files don't reference things defined in simd.h or types.h
so remove these redundant #inclusions.

Fixes: 6093faaf9593 ("raid6: Add RISC-V SIMD syndrome and recovery calculations")
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Reviewed-by: Nutty Liu <liujingqi@lanxincomputing.com>
Link: https://lore.kernel.org/r/20250718072711.3865118-2-zhangchunyan@iscas.ac.cn
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/raid6/recov_rvv.c | 2 --
 lib/raid6/rvv.c       | 3 ---
 2 files changed, 5 deletions(-)

diff --git a/lib/raid6/recov_rvv.c b/lib/raid6/recov_rvv.c
index 5d54c4b437df7..5f779719c3d34 100644
--- a/lib/raid6/recov_rvv.c
+++ b/lib/raid6/recov_rvv.c
@@ -4,9 +4,7 @@
  * Author: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
  */
 
-#include <asm/simd.h>
 #include <asm/vector.h>
-#include <crypto/internal/simd.h>
 #include <linux/raid/pq.h>
 
 static int rvv_has_vector(void)
diff --git a/lib/raid6/rvv.c b/lib/raid6/rvv.c
index 7d82efa5b14f9..b193ea176d5d3 100644
--- a/lib/raid6/rvv.c
+++ b/lib/raid6/rvv.c
@@ -9,11 +9,8 @@
  *	Copyright 2002-2004 H. Peter Anvin
  */
 
-#include <asm/simd.h>
 #include <asm/vector.h>
-#include <crypto/internal/simd.h>
 #include <linux/raid/pq.h>
-#include <linux/types.h>
 #include "rvv.h"
 
 #define NSIZE	(riscv_v_vsize / 32) /* NSIZE = vlenb */
-- 
2.51.0



