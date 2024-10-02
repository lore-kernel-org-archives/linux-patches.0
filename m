Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32CC3D994;
	Wed,  2 Oct 2024 14:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879764; cv=none; b=avn7MJOm6bjbzQ8ozXdbuy6qG7t+SroYriS1bWutOTaPiuBhs1Y5alZtimqmQSao9ZJWRjBqbx0bNWceQDYmvh3TZsSx3Bi8KV8lCU2/vWxlb3S6mLbY/fkyra5hDbDbj+8qecrw9iy+bAN/nKPBHpaMhr4uOCgqP+C0V0X0zuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879764; c=relaxed/simple;
	bh=3i+G2uUT8goRRFi10RweV8h9FwesjEpID2PswAWRGNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diM+M/SPuaH+rDU3QEVKKbkknkKJFWnzqNsRM5Fb8UWyfFQ1eZn7spCE4LAiJ62shE2gfYb9Eja5nvnlE+afayeVHtG+VNxiN/gcikCxKwxX/A4KNbQMjpiKGDKYpH0WIAKUMWddO1La1H7E+a3zMdEe5P6OMPfqgkazcYP3Ue8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=job2uSRY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="job2uSRY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784FDC4CECD;
	Wed,  2 Oct 2024 14:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879763;
	bh=3i+G2uUT8goRRFi10RweV8h9FwesjEpID2PswAWRGNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=job2uSRYSPYxiaxFNtpI1nVt2QsjTSSf2riDh2rTGcLR9l/rVw+N9MdCAaM/XnIqD
	 lIGwyiBg1cfmsZiXppnaXkf3MmvbyZGx6nKpjdr3fY7jbwX/HDbvH6CjHmrK3ImGQv
	 l6Gj6/FZn8TC40AbnGrpB4DMYJKQzEhg1ounQPY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 199/538] selftests/bpf: Fix include of <sys/fcntl.h>
Date: Wed,  2 Oct 2024 14:57:18 +0200
Message-ID: <20241002125800.110370634@linuxfoundation.org>
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
index fded38d24aae4..2c57ceede095e 100644
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



