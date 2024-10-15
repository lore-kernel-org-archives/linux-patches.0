Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434DA1C9B81;
	Tue, 15 Oct 2024 13:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997388; cv=none; b=tl2ln/X0eYIZGx+YfJoh2aVer90OqlfMYmlRfmHzdEArHuWE/ZRVOCQxnp2yZhITLB9yW7BCe+cfuHE5GT3XplJfAZjqvRx4k3RuK3D44E8jzTg/Oc8FwMopp2+AafvNDNvZJ5GnhqBf6UN7Nw3m3TAN05Q/jdZVCCOcS+KItec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997388; c=relaxed/simple;
	bh=EuUfL2wYf6laS0WOI+5EHqAEvv2bW1NT/bDU3MmCxe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwpHtUPLjBl05ScVyFtaK5/O31cnnjXf4O75w/OO95pOT2lLYnXRY9Nt5zok4UtjY6JfDOyj3kfsi90mqMbGMGEZ1EbgwhLPmSsNgQFvonnfUiWHLKpCuoIXY3FCxPDS85cbYW1kCp099PYqB32717UfZxlf0wvok/UrbTTK53A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADaS1m2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADaS1m2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DE5C4CED2;
	Tue, 15 Oct 2024 13:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997388;
	bh=EuUfL2wYf6laS0WOI+5EHqAEvv2bW1NT/bDU3MmCxe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ADaS1m2f/2SmwQer5GACYffcH5msovkjaKz1AdrVS5VU5JFacaUXRBOuogiYoqkPD
	 LhALhH5gKBuQFGxJ4T7487B+gabtlXgveyVwFVV01BZ6Z/BeNgtYHWcxNX6tEHBwim
	 ogACJkDnYN/3+3vIbtIz0k8zntb+xdcVt7hMuoYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 137/518] selftests/bpf: Fix missing ARRAY_SIZE() definition in bench.c
Date: Tue, 15 Oct 2024 14:40:41 +0200
Message-ID: <20241015123922.285263528@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 332ed2f7b4022..0a257dd3e027f 100644
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



