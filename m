Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B760F1D07AD;
	Wed,  2 Oct 2024 14:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877930; cv=none; b=X9Da/dUp9UdXKlCBumIsdZ3qQ4Zu1/p4ekjt+JOButnvP1EM228nXvu6yvYJL4UVui5V7jOUN+leoKyxAxtH2NIVfT9yS5MdjtmHnFy6oauL/iIp6uTA1VEc6wwjM09sUq4j8aBbBymilSvGhRU+Jw+cu/zjTUo4VgB66ChNdgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877930; c=relaxed/simple;
	bh=TpFGVXto75isKiCOTgDu+BolKifgNj7KJ/5aIvarQXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWlV0fXHVgPXtEZwHQu+3W+RZ/1qSPWU01aHjeGndLXa/QAE9WyvW+Y6LQm/bOO4WZEwYYPr5Z7utTGhhIwuaOEw8aX4foIBnUtFMYBXD82fBkyZAScjmdPxxYo/X7ayq4GIhZUcsxn5wEwgIACYS5sSMcENXodqBKQ5CFw8u38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cY3laI3d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cY3laI3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360C0C4CEC2;
	Wed,  2 Oct 2024 14:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877930;
	bh=TpFGVXto75isKiCOTgDu+BolKifgNj7KJ/5aIvarQXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cY3laI3dywodAMkA8c1cRI/00PQ7yzgH094TL4LuA23zx4OTRgcFCP4KfYQOqCiPS
	 Hu7shC5LBFDOiSot0sXfJrgsohy33Jf+3h8wNTVuuaB16VMVP2u0h3QXQ/7LYJhUdC
	 8ZMx/GKUpWeCjjrz8hs+bdVAnyeCihv8zRT2w9pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 244/634] selftests/bpf: Fix include of <sys/fcntl.h>
Date: Wed,  2 Oct 2024 14:55:44 +0200
Message-ID: <20241002125820.729815944@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



