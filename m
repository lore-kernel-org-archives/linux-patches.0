Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0135018DF60;
	Wed,  2 Oct 2024 13:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875929; cv=none; b=pv4peBQzvkqHt+jNw2cmdiA+LCzaYhzbEpPmQQCAblFrGRaF7iXKo+qZ1IYcv9ZC+pVnNo0XKU9FpEoBRDSmwlN2k0jrJfr7bEjlh+OKySU+PWA/PGvAEEydOa6WbO7hp1Pe02NzDlb7XFjGAUth+vORldlPFtLrC2xttZAnW9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875929; c=relaxed/simple;
	bh=GXc+yTNVXHQWdGFVV97v0JXLAET1O+9LCVptQn3nQRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFEaGabfbCsB5l9d0U/K/o+geD683CWxMtpcOdyuu1fc8kJdFJDqIGyEz/xpUx8OaZ8FM7Mz+id8GdQNABgcip5sMeEaHJOU+mEM+eVcAl9JJw0v9cb2bs+tjVPsx54FeKNqCT5DiF/IbgLVQuIDV5Fs/vAFL2tznCHz1i3EuFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ag8BCtH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ag8BCtH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E498C4CEC5;
	Wed,  2 Oct 2024 13:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875928;
	bh=GXc+yTNVXHQWdGFVV97v0JXLAET1O+9LCVptQn3nQRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ag8BCtHeijuo/hGTmSXwapxlYjwyji20+AzMA223l3z7BAUiwunvq6KFnkdio4Lp
	 /7NlBf1FTAId2ib3VPXECV3Nzh2RiS/TMehBnuJaKpcQkV6AJfV6V7e1/kYT96m+QT
	 8PMDfnN9mInBbY0ls4jhIsi7bVDs6ytPCVO8GFg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 270/695] selftests/bpf: Fix missing BUILD_BUG_ON() declaration
Date: Wed,  2 Oct 2024 14:54:28 +0200
Message-ID: <20241002125833.225354489@linuxfoundation.org>
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

[ Upstream commit 6495eb79ca7d15bd87c38d77307e8f9b6b7bf4ef ]

Explicitly include '<linux/build_bug.h>' to fix errors seen compiling with
gcc targeting mips64el/musl-libc:

  user_ringbuf.c: In function 'test_user_ringbuf_loop':
  user_ringbuf.c:426:9: error: implicit declaration of function 'BUILD_BUG_ON' [-Werror=implicit-function-declaration]
    426 |         BUILD_BUG_ON(total_samples <= c_max_entries);
        |         ^~~~~~~~~~~~
  cc1: all warnings being treated as errors

Fixes: e5a9df51c746 ("selftests/bpf: Add selftests validating the user ringbuf")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/b28575f9221ec54871c46a2e87612bb4bbf46ccd.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/user_ringbuf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/user_ringbuf.c b/tools/testing/selftests/bpf/prog_tests/user_ringbuf.c
index e51721df14fc1..dfff6feac12c3 100644
--- a/tools/testing/selftests/bpf/prog_tests/user_ringbuf.c
+++ b/tools/testing/selftests/bpf/prog_tests/user_ringbuf.c
@@ -4,6 +4,7 @@
 #define _GNU_SOURCE
 #include <linux/compiler.h>
 #include <linux/ring_buffer.h>
+#include <linux/build_bug.h>
 #include <pthread.h>
 #include <stdio.h>
 #include <stdlib.h>
-- 
2.43.0



