Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866311078F;
	Mon, 27 May 2024 19:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836778; cv=none; b=ddN5ZjpsZdm55LERvYPZlMuHaJCZXu4Sya68XVpaCrtW+DnXYFUzVla7pgvfXJtKdz6Km7E9rjarloyHmfKXNqJZifXcPrDYWcRwZeqBh2wcI8POoN9ScpfyTKRtiWuVvvGFcUwEZGJziThDw9LPeF7LGH99c+Sp/jipAEpCwOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836778; c=relaxed/simple;
	bh=blmM30pR3u9mfqLt9UNV9/jv7IgMW0WV2r2WMgOvGxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFuLbvSbVvkPOJVRtGK2qXBeqE4RzJRMnKfWvkEJ6wRJOM70We1wIfj/o5c9NHDOFTWtXUyJD6j2NNkR/NMe3IAd41VVwyf6Uv43MeEBt+J6JY13Mqs0f+zmqJfkTd0i2/PU0GomM06PGV0n9pI02Szjez++GRKlDejZ0fsvmMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6xUNCpj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6xUNCpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1AFC2BBFC;
	Mon, 27 May 2024 19:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836778;
	bh=blmM30pR3u9mfqLt9UNV9/jv7IgMW0WV2r2WMgOvGxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p6xUNCpjfhlSke8GY8yp1iX5S01mI8ogszZq2gCtz0y3zFRi2rqcwX11GCcDCnLi2
	 DpmzEHgdD9Ht87qRO0d+S/BysHKcwYu5ATUOVU59byKnObAxbvA0010LYKazS747uI
	 92ect9/H0aYRU72GYrn8iyXqEB6j5RJYVl1a3XtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 142/427] arm64: Remove unnecessary irqflags alternative.h include
Date: Mon, 27 May 2024 20:53:09 +0200
Message-ID: <20240527185615.129545233@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 98631c4904bf6380834c8585ce50451f00eb5389 ]

Since commit 20af807d806d ("arm64: Avoid cpus_have_const_cap() for
ARM64_HAS_GIC_PRIO_MASKING"), the alternative.h include is not used,
so remove it.

Fixes: 20af807d806d ("arm64: Avoid cpus_have_const_cap() for ARM64_HAS_GIC_PRIO_MASKING")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/r/20240314063819.2636445-1-ruanjinjie@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/irqflags.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/include/asm/irqflags.h b/arch/arm64/include/asm/irqflags.h
index 0a7186a93882d..d4d7451c2c129 100644
--- a/arch/arm64/include/asm/irqflags.h
+++ b/arch/arm64/include/asm/irqflags.h
@@ -5,7 +5,6 @@
 #ifndef __ASM_IRQFLAGS_H
 #define __ASM_IRQFLAGS_H
 
-#include <asm/alternative.h>
 #include <asm/barrier.h>
 #include <asm/ptrace.h>
 #include <asm/sysreg.h>
-- 
2.43.0



