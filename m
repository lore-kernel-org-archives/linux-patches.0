Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED28D1D0436;
	Wed,  2 Oct 2024 13:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875932; cv=none; b=EQ1Xm8W9WiIcLfZcMHj6RbnWd1Tz1NggxroMpDocsQX2/mAaUkBT2mMp57hK55aTMXKxRcac5iqXISX7KWirr5zM0YAuDSugaK+seMumcLykNfc2DI1hYUJJ3h9WCwiRSMycKKrQyQgsJA3NaHpgRTK8HNlwF5q2TMLu0kqG+jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875932; c=relaxed/simple;
	bh=eF3C69mejIibvF8Om1huzs6AaUPqBXF2AMfwDBih9Og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rw73cGVWUu0mb912h0l84QW3AWoCS2oFN+FT4bws+FycFWDg88QrTy8X41jU6EAEhNiK1gLsOHQFnLgTEki5zHjDS032PspdMVmk9bI4wZX2xuiUHaukFb8+SD2tRMW7BIqELLmVcIwljZ5iPje2cotSjTQwKDzZiDKUP4hUTIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+I+oMUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+I+oMUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709DBC4CEC5;
	Wed,  2 Oct 2024 13:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875931;
	bh=eF3C69mejIibvF8Om1huzs6AaUPqBXF2AMfwDBih9Og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r+I+oMUkne6+46JW/RQsgA7GykAhZnd3P26A7SqjU7rWTuoTnvT1PamWIOx2nS1Cf
	 XBjf3Qr7sjSkUq6/COVPuEZDMPHqzj2rAdhK2Hg/lkbJfvsDukpStpbtPJR901C/zi
	 GYt2FLvCellZnG10KACsWHbe2eNWxmamdYbGd1jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 271/695] selftests/bpf: Fix include of <sys/fcntl.h>
Date: Wed,  2 Oct 2024 14:54:29 +0200
Message-ID: <20241002125833.264678997@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit 21f0b0af977203220ad58aff95e372151288ec47 ]

Update ns_current_pid_tgid.c to use '#include <fcntl.h>' and avoid compile
error against mips64el/musl libc:

  In file included from .../prog_tests/ns_current_pid_tgid.c:14:
  .../include/sys/fcntl.h:1:2: error: #warning redirecting incorrect #include <sys/fcntl.h> to <fcntl.h> [-Werror=cpp]
      1 | #warning redirecting incorrect #include <sys/fcntl.h> to <fcntl.h>
        |  ^~~~~~~
  cc1: all warnings being treated as errors

Fixes: 09c02d553c49 ("bpf, selftests: Fold test_current_pid_tgid_new_ns into test_progs.")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/8bdc869749177b575025bf69600a4ce591822609.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
index e72d75d6baa71..c29787e092d66 100644
--- a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
+++ b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
@@ -11,7 +11,7 @@
 #include <sched.h>
 #include <sys/wait.h>
 #include <sys/mount.h>
-#include <sys/fcntl.h>
+#include <fcntl.h>
 #include "network_helpers.h"
 
 #define STACK_SIZE (1024 * 1024)
-- 
2.43.0



