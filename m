Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290342572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FEFC433D2;
	Tue, 18 Apr 2023 12:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821897;
	bh=JegotNx5fBXykk8QkNgylxdkaBH7T4nUuNR8kI4BsII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nS3cObzAv+jnwZ31NfWc1I8ElX22pok1Q5L7M5/abHyGbevktl13ABl7s0b+0EwH7
	 De3qKiW3Iqo57NwCBohvuu0dhLqyBVsGRJcORtoR9CiApgf93m9EHg7Xv3Tya+c37M
	 o/mkqrR1JHVKtWsNcdyYmsQhvUHXUTvhoJMUup/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/134] selftests/bpf: Fix progs/find_vma_fail1.c build error.
Date: Tue, 18 Apr 2023 14:22:11 +0200
Message-Id: <20230418120315.647096892@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
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



