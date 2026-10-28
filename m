Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215807;
	b=XxQR+yqX4tY3bV6Ldnrtvt2klqxzRVJUKYngeTjArpBPQmDVW0jRs9pT26voK5RA4agr
	 nifBAFvqL4mDCea+pqMYRfNVggC5GGRNxmVdu37f0Qf3a83ftUgLTbugsl2QyqM+ZfE6R
	 uA9/4TtKY20MROUFW7gsnItbKj4AqhJwkpHzqW4UnPT56WZx8xxgiwYTSAGHGah3VwqZG
	 cxBPO+80QYIcrtGU10aqugDZBW8PmKBqIE0/McnWOXJik51JWhse5AHUr7osvz+24U6nN
	 8MtR0GK5x1iMNQs+mjVlpilLzRpSJZIiUoOqRR7i9nt4v83dtEd1O7UPnP5BEo//jxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N+4ChVjZoyo3KjLJobZJgVbkPDFVysWo1m70Uz1vW7k=;
	b=dDvziCXBxsed7SouxvA4khw7/tCkxi/DEVaX6GkuyzgYR+uiQlBgv8pGp9RyHwZ3J/O8
	 vFG5sfARJ2tVNvLPM18E+wOrwoxhzu237lR5za+jMTu9SvSzBzHr7K2h7YmPyZmsoIG0K
	 Lb+9isAydwuobIxn90Lerqg89QZ+aS/NYn0v/E4TXEcZOLXZVC/eFV8pAaX7Uty5Q8d+K
	 Mh55LknJQdoxm4o4w990/ZUWqT6Bq+gD39u6DhHLEK4wdUUBf3Sd/Uy2s1ajxavhHMqn7
	 4R6a75yXVulicJMExb3QgmDC3Dx1NhoPDr1haDBSgZvabFaul82KSj2yBJqyqlyJOgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PuVuttpI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EFB606A31E;
	Wed, 28 Oct 2026 19:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PuVuttpI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48E11F01825;
	Wed, 28 Oct 2026 19:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215806;
	bh=N+4ChVjZoyo3KjLJobZJgVbkPDFVysWo1m70Uz1vW7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PuVuttpI0VsyFmO3EpYApAU4gB8zL01JndjuRkVNNqy1GbLuDS+M+4L6h+7HpMRp7
	 UV4H7VruuhCfOxpAOHL2/frqntslmcnFo/ELwi3iEiuEiH93qrGZ0If9vu+WLdsRu9
	 LMeMvci+oIcsJfMc0zmLcS4tEc5OZDoPS+a7KITg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Baoquan He <bhe@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1339/1887] s390/mm: do not include <asm-generic/io.h> directly
Date: Wed, 28 Oct 2026 17:57:15 +0100
Message-ID: <20261028170529.907818423@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baoquan He <bhe@redhat.com>

[ Upstream commit 51f513fd9659faf00976071a9525474b08764ccb ]

We should always include <asm/io.h> in ARCH, but not <asm-generic/io.h>
directly. Otherwise, macro defined by ARCH won't be seen and could cause
building error.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306100105.8GHnoMCP-lkp@intel.com/
Link: https://lore.kernel.org/all/ZIWrtFMUnRfVP5h0@MiWiFi-R3L-srv/
Signed-off-by: Baoquan He <bhe@redhat.com>
[agordeev@linux.ibm.com changed patch description]
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Stable-dep-of: 7f40b346462f ("s390/dasd: Fix undersized format-check buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_cpum_sf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/perf_cpum_sf.c b/arch/s390/kernel/perf_cpum_sf.c
index 33550d9cecf50..54d2b175794e9 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -22,7 +22,7 @@
 #include <asm/irq.h>
 #include <asm/debug.h>
 #include <asm/timex.h>
-#include <asm-generic/io.h>
+#include <asm/io.h>
 
 /* Minimum number of sample-data-block-tables:
  * At least one table is required for the sampling buffer structure.
-- 
2.53.0



