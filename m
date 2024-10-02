Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C761D0796;
	Wed,  2 Oct 2024 13:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875923; cv=none; b=kXtae5bNQ/poD5VPSYgSgkhxT5iqqnpQA/wxpUOXh937vgmFVuIlO0o6O6KThVSNuDDB+PfMiMTmDbiqpDVHHCIKnIT4L2KdPE9a8yXo8rG48P9b/4M79PorqOpdcs3Om89C7Hn69zXahgJgpBRF0D1pxA81Bw6nwZPtZChiWQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875923; c=relaxed/simple;
	bh=/KhkLk92WaPw/wqbvhOoChGd5vnCXWL+de5LflvdLQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRdnCTJs1rJPf8lgQdZTlgNee+9l3TG/kswomNJ7uXQiuj/G6aX4tXHCZIyjEwlGpgUujWMOeZCB8d2JnqNYUuS0MOO0WhvBdv41KE8iFxB/eYZPEbKbSZCqnFgCSB8qahxh4pZk6BStxXED3jzF54nP0dcT8aK6P0aWkXI6bik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LP5t/SFd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LP5t/SFd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A27C4CEC5;
	Wed,  2 Oct 2024 13:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875923;
	bh=/KhkLk92WaPw/wqbvhOoChGd5vnCXWL+de5LflvdLQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LP5t/SFdJOCISb10YR2U10PHnQLvAfzTULd6OgMCVQCYUvXiNfjbnYXm6Ew8zcBMS
	 faYHKgLBa18jdMiZwGhf/CryQJSZ45FPm38MBCoDonDBaZiBtbrPRuuHbyBzRLS0BD
	 myy8skZWSQbU9l0WhA53lPDR7KI1sikHZ5C5d1kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 268/695] selftests/bpf: Fix missing ARRAY_SIZE() definition in bench.c
Date: Wed,  2 Oct 2024 14:54:26 +0200
Message-ID: <20241002125833.147061570@linuxfoundation.org>
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

[ Upstream commit d44c93fc2f5a0c47b23fa03d374e45259abd92d2 ]

Add a "bpf_util.h" include to avoid the following error seen compiling for
mips64el with musl libc:

  bench.c: In function 'find_benchmark':
  bench.c:590:25: error: implicit declaration of function 'ARRAY_SIZE' [-Werror=implicit-function-declaration]
    590 |         for (i = 0; i < ARRAY_SIZE(benchs); i++) {
        |                         ^~~~~~~~~~
  cc1: all warnings being treated as errors

Fixes: 8e7c2a023ac0 ("selftests/bpf: Add benchmark runner infrastructure")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/bc4dde77dfcd17a825d8f28f72f3292341966810.1721713597.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/bench.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftests/bpf/bench.c
index 627b74ae041b5..90dc3aca32bd8 100644
--- a/tools/testing/selftests/bpf/bench.c
+++ b/tools/testing/selftests/bpf/bench.c
@@ -10,6 +10,7 @@
 #include <sys/sysinfo.h>
 #include <signal.h>
 #include "bench.h"
+#include "bpf_util.h"
 #include "testing_helpers.h"
 
 struct env env = {
-- 
2.43.0



