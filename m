Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0485A168C4;
	Mon, 27 May 2024 19:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837963; cv=none; b=HOIw6SFQFZpCcnIQAbr1IvW3Ic9VPa4wvBgHZeIitry6u7QG/GitGBjIpgDBHqsx/QGJRoRh17ft7zCTHqXpK7VyBpg0Mr/gOHsP2qv/l8NwpHFPiLSL2i4LuSR3boRiZli7c1JYhCTkrXSZqnzouHo+X2EK0FnGmvrZNljgHP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837963; c=relaxed/simple;
	bh=PSPlWaCYJIwwWOPqy57GIEpiiTWxpceUww3ZGjKyOQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQoCF7L2kUG4PenOZNgtW9EcnIKyr1BhfwYRkp3sVNH3Y9gTzbHnEl2BOWvv3VBXrSMqguLYuesK36QmZ2UqQlfuWzlf/KSQogVx9vkuLEdlhVyxHry9h86KVXw3uKUxOoh6pyHYh3bLaSbc12Km3xcDONX9ZZKmK8cYba6wP0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qz3mBDXB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qz3mBDXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF2EC2BBFC;
	Mon, 27 May 2024 19:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837962;
	bh=PSPlWaCYJIwwWOPqy57GIEpiiTWxpceUww3ZGjKyOQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qz3mBDXBFPzNU+pjVlinQBGR6yr5Y6VxKa+PiSfHbyHJehxxYsW6iiwDNT3FB2Crt
	 Sdgb44+L/gHpWKCwLn+ZC21nuN0EuqmMgb1oXHo9VTDvcfW+s13XDp/06wFgmN+3AM
	 QAQX4YtlImmAvWWjIMTYq30qODsyXv9LLc5pLRqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 211/493] arm64: Remove unnecessary irqflags alternative.h include
Date: Mon, 27 May 2024 20:53:33 +0200
Message-ID: <20240527185637.215927704@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



