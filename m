Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8D52572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942C3C4339B;
	Tue, 18 Apr 2023 12:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822253;
	bh=JegotNx5fBXykk8QkNgylxdkaBH7T4nUuNR8kI4BsII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zaP6pX2pjp5W1fSLLaIzzEjGuZBe9P1iv9y1YRN7O9blB82jK1nddBLzf6zMysGPn
	 taEYcMN45KEjvjsiKFaHDwcHVqcdYX+BKaMUja19Thvlblj8A1Ww8W5Kt3ftiR3vhn
	 /g00YEjTkgvwS9Q/ao1yRQlfYh1dOcUr090PbOcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 081/139] selftests/bpf: Fix progs/find_vma_fail1.c build error.
Date: Tue, 18 Apr 2023 14:22:26 +0200
Message-Id: <20230418120316.874332838@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 32513d40d908b267508d37994753d9bd1600914b ]

The commit 11e456cae91e ("selftests/bpf: Fix compilation errors: Assign a value to a constant")
fixed the issue cleanly in bpf-next.
This is an alternative fix in bpf tree to avoid merge conflict between bpf and bpf-next.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/find_vma_fail1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/progs/find_vma_fail1.c b/tools/testing/selftests/bpf/progs/find_vma_fail1.c
index b3b326b8e2d1c..6dab9cffda132 100644
--- a/tools/testing/selftests/bpf/progs/find_vma_fail1.c
+++ b/tools/testing/selftests/bpf/progs/find_vma_fail1.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2021 Facebook */
 #include "vmlinux.h"
 #include <bpf/bpf_helpers.h>
+#define vm_flags vm_start
 
 char _license[] SEC("license") = "GPL";
 
-- 
2.39.2



