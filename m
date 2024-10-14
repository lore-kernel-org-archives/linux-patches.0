Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991C11AC448;
	Mon, 14 Oct 2024 14:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917821; cv=none; b=roUeEEgVnO7Fsmi0MHYthlRv9yNIBR8SLhhbtI/l510/gjzsseunr8tWWKdI0QFauwSief48jX7G7C4449J7I5N87itQi1MuiQiEsy81d8bakuh4bAS0KBCxzwL+rhdCywgCT3fVUy724c4JkQO5obsvOH/RWYHzdova37ruI6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917821; c=relaxed/simple;
	bh=jLAo5cPxptxwsITLPjWXR61ZEfxcvMHxY8bE5IBPKhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvi0u1lj2LvVO88B6Lzn0DneVkhXJ+754NujyEr+jl0a3DXu5INxTg0TW5GDSdqP64qjipKgrXmdkGehbvdCybWdJ0Sh6sPI1WbtLUMHtJKB/aYPoKUP2wYyXBq8hJldKLt1Ev/pbafD8kW0XSVQLWXh8DeHfrZ37ViRH+0YNzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aao97VZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aao97VZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96611C4CEC3;
	Mon, 14 Oct 2024 14:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917821;
	bh=jLAo5cPxptxwsITLPjWXR61ZEfxcvMHxY8bE5IBPKhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aao97VZXeBpCPpoXjoOWSJ+J109pKEN814+Wn5cxmu7shqYvNKMzjUuWE8JSsC0W+
	 LgDdv4pBOKt1FXTkjwMqGVYpc421MT0qDrPJBD2jbN+WB3sFWID32HTqBQrDa7m/rW
	 9/uhREj04FOTHBXflcPTEjP3MRqmC9sYMiTi9Yxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 144/798] selftests/bpf: Fix missing ARRAY_SIZE() definition in bench.c
Date: Mon, 14 Oct 2024 16:11:38 +0200
Message-ID: <20241014141223.575559140@linuxfoundation.org>
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
index c1f20a1474624..dd39df9c2b0f4 100644
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



