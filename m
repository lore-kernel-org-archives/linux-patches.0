Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BD11D12F0;
	Wed,  2 Oct 2024 14:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879656; cv=none; b=BChliYqw/nq4miNP35bZwzCQEKjqJzOmd4OZqWYa42W7F8HwkZq9bz2p7/MFaJNMSK8kwnAu9cyDQ3BueLUptVGHyNalAmUYnTKu7kijInl4PsmY3YklbDrZxNqvGrh/LxQD0wkOL9dZ9YJOdt70oom450K6AEXPMBnZJ+QX5kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879656; c=relaxed/simple;
	bh=+KFuDCn7F+kt1/DSPeobm0e9bgj15RD/K5W+XShCpzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSy42fXYi8P/KIHyN70p+cA0JPYLQalaHsr8mOdBB9mT+FrfqtZ4Z8EJixkDeUAA2fKfCMTsMr4e277DuMKeW0Yi8BKE1hC8oFfYoFGa7ZlKNbEgfUFkosi6TxIOr0/oDauZEnWbFzeQlB6mELim7ai0GicQGqB6KbDnRRuQjUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hwv8VP1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hwv8VP1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606A1C4CEC2;
	Wed,  2 Oct 2024 14:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879655;
	bh=+KFuDCn7F+kt1/DSPeobm0e9bgj15RD/K5W+XShCpzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hwv8VP1OIGay9eR4/FYzjxgkkgeoHR4XkN/CChDNGl9iYWmK9WF22uksPaG0FZaZd
	 L6BZv3Lgs56ioZXST11XDdtzkhHJin5qPdghssDepCCeD32grAVt/TODSzOOOLHtUZ
	 mpCSBkVQZdsjsLI6QGi6hVTOEAT47o8Olscxa9pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 192/538] selftests/bpf: Drop unneeded error.h includes
Date: Wed,  2 Oct 2024 14:57:11 +0200
Message-ID: <20241002125759.835768963@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit 69f409469c9b1515a5db40d5a36fda372376fa2d ]

The addition of general support for unprivileged tests in test_loader.c
breaks building test_verifier on non-glibc (e.g. musl) systems, due to the
inclusion of glibc extension '<error.h>' in 'unpriv_helpers.c'. However,
the header is actually not needed, so remove it to restore building.

Similarly for sk_lookup.c and flow_dissector.c, error.h is not necessary
and causes problems, so drop them.

Fixes: 1d56ade032a4 ("selftests/bpf: Unprivileged tests for test_loader.c")
Fixes: 0ab5539f8584 ("selftests/bpf: Tests for BPF_SK_LOOKUP attach point")
Fixes: 0905beec9f52 ("selftests/bpf: run flow dissector tests in skb-less mode")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/5664367edf5fea4f3f4b4aec3b182bcfc6edff9c.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/flow_dissector.c | 1 -
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c      | 1 -
 tools/testing/selftests/bpf/unpriv_helpers.c            | 1 -
 3 files changed, 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
index 9e5f38739104b..9625e6d217913 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <test_progs.h>
 #include <network_helpers.h>
-#include <error.h>
 #include <linux/if_tun.h>
 #include <sys/uio.h>
 
diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
index de2466547efe0..a1ab0af004549 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
@@ -18,7 +18,6 @@
 #include <arpa/inet.h>
 #include <assert.h>
 #include <errno.h>
-#include <error.h>
 #include <fcntl.h>
 #include <sched.h>
 #include <stdio.h>
diff --git a/tools/testing/selftests/bpf/unpriv_helpers.c b/tools/testing/selftests/bpf/unpriv_helpers.c
index 2a6efbd0401e5..762e4b5ec9557 100644
--- a/tools/testing/selftests/bpf/unpriv_helpers.c
+++ b/tools/testing/selftests/bpf/unpriv_helpers.c
@@ -2,7 +2,6 @@
 
 #include <stdbool.h>
 #include <stdlib.h>
-#include <error.h>
 #include <stdio.h>
 
 #include "unpriv_helpers.h"
-- 
2.43.0



