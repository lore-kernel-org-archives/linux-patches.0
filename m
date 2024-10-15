Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542961C7274;
	Tue, 15 Oct 2024 11:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992699; cv=none; b=GTJVCsHNkTFHu5b9O4z0yfS2ufnQxHQOVtGGXsKSaIG0dlpwyaBuuXQryoUGXAdA0cCPOqsU/zOLc/Adux7esVDUNg0Q2fMKY3YzshX/44reQJkDc29enwlOHCtxO3FQptTB5Rq1LakEvysY/vSmn+EKEvDcS6y50U31JImHdZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992699; c=relaxed/simple;
	bh=1djO59t6hQOgRkFlccvj8KCIA4nI26tptCXSeg9HK48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZvU+B5y2qX/F0embo4OXmtStP2cTdBlBT4QshVP4m5zCviQ5gUwI09NPIDaRk7uEl+Hwqn2+BlkH3n5J4k4LT9A1mXGDZUdDP0flv+7HQU/GI3jTLvM9Y+dtTFelpweQqJFEO82bt5CNP27Ty/Gtj3KfFY22xYw8xlXUFZKwK6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lRZrF9Wl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lRZrF9Wl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8101BC4CEC6;
	Tue, 15 Oct 2024 11:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992699;
	bh=1djO59t6hQOgRkFlccvj8KCIA4nI26tptCXSeg9HK48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lRZrF9Wljhte4XfVy44VtqAq4xb0hNsj7n9sXCCr7zvFm9cv//Gsy+yCgBOx/tyLi
	 PZg9R38SclPLeOSi9lrpd5MZccXt32hLwhu+B07N54+iAckQP0xjbWx1FPb5QV7Sh5
	 ZjsKR7LnLsSqcxd3Ed0kSS7MQHw3G+mvVbhy5FQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 193/691] selftests/bpf: Fix missing ARRAY_SIZE() definition in bench.c
Date: Tue, 15 Oct 2024 13:22:21 +0200
Message-ID: <20241015112448.019635092@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6ea15b93a2f8a..74dad15a74693 100644
--- a/tools/testing/selftests/bpf/bench.c
+++ b/tools/testing/selftests/bpf/bench.c
@@ -11,6 +11,7 @@
 #include <sys/resource.h>
 #include <signal.h>
 #include "bench.h"
+#include "bpf_util.h"
 #include "testing_helpers.h"
 
 struct env env = {
-- 
2.43.0



