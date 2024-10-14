Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117F41ABEB7;
	Mon, 14 Oct 2024 14:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917828; cv=none; b=n44DAuuEtIqIfMFWwUzRQgRBSoV0kTD7KPo/rvjjh6pmhWXmt9a7HcF7hj+b959fdDdcSHBuPJKsi3A+eK/jhpV2gzQ5+IvdVdyez7FKi4YzC4eQbZ7s/EB7RHzSb7YsO5oYZ3bOGaRNfumV4m/aV2Wxj81xlSz3uIeQlO94+cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917828; c=relaxed/simple;
	bh=3TYXP/sqF8hGD2aFuII5BGQRsTrM1oTSyXvP0y9dV2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmGN1Ppc2PUsx321fSq1ijDuRqPRkTEs9sTEEWgtXGcOb3RUBspaDk1ErwOOmw3j714EPpSOYw4V6MElqMS/Hd86b8TBx4No0SB3vTtnwNIM0K6rrH/KIfCSpi3nlpj4gZjmq9OSc+JLJvM9DuyT31EeeGCf/lniDMsdiaUXJnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNbrM71u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNbrM71u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C25C4CEC3;
	Mon, 14 Oct 2024 14:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917828;
	bh=3TYXP/sqF8hGD2aFuII5BGQRsTrM1oTSyXvP0y9dV2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNbrM71uWI4B9ucDV0GU0byE9g5s9Pa7YUQEZBVmP0BmGSltqBuvFKiNhNPa8G+To
	 nqEx13lb0AX2MsMj35anh+jPbLJVPgFG+otQpiqpeTP++C6ETCZuO1ZKDESKwSB/0l
	 3s0pul+F61SpxfoGe3Eu0J953fg173m35/YsAhQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 146/798] selftests/bpf: Fix missing BUILD_BUG_ON() declaration
Date: Mon, 14 Oct 2024 16:11:40 +0200
Message-ID: <20241014141223.653301577@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 02b18d018b36a..ca81d660eb96f 100644
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



