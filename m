Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022090;
	b=ahI5GVcmOojRdFcnvheeyeKm1ed5bInB4/4qcqIaXVRPiMDJjSOB6eu92Of1icX9h73c
	 lHMRfTXc/WZlCipk1B3wPdZtfeqy5Yr1Z7lKYsCi0Ma4VF6JfG/fiO/qUCUaJIa52Vdw8
	 ACRjbMOKf94mBGL7AgXZusATsCcEAdBKDxZPmvwX80SwnEAy6JQLxxtiiWWCmgWzvmqnL
	 uHp/uPj/4CVRS28+MQulO+laxhWlsea7vmhLxUFIpl7znUNryUs9kCnZVjfX86sEQ+EI5
	 N+vtluCs0cKMdRt4CiPm2JE/7xsu7KtEEqkUY38ziI+EfPrxpa3mjZkdhS6l73+eugQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022090;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3O59MJNo9npyD2PftsXxwvOT/nQ9aF/9RVVOmgH9tiM=;
	b=WnFFBqMEzgdqtZH7O8nTKDqDgcCLdv60MfB/In6CAB45vsQUVI4a+oYogtdMUhXGFkfu
	 FXYyK/Ov+sFQ+yRbC3+zAigF4u4XR9iPpOSLd5aULrjDNs22Jf66VTRgceaq88xsO5TX5
	 V12Tmh4b1bqEfnlSjTDCGvpbmw6gDoFMu0UmqIQuGSqTizb13iBVm7Ghr1Yh4LVXMKPcO
	 7f3sZlwIjxf1b3WWb4SMGkv7cGTKNS9wh5Ci+FIyEE/gaazSKdTuuL0XkDhruYHByQT+X
	 zr5kkF5WXqgVQIwc7t3tUX2HXH6ct0H8imQzQFOcRhGEM/iiHk5vinEE+SIYslOIVOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aLhLjw6S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6878606A32A;
	Wed, 18 Nov 2026 17:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aLhLjw6S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D521F000C4;
	Wed, 18 Nov 2026 17:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022089;
	bh=3O59MJNo9npyD2PftsXxwvOT/nQ9aF/9RVVOmgH9tiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aLhLjw6SjUrEFsnGKftRr/IOOOaGoSztKVyEEbYPEXZUe5LyDZuxvdU4UFtZ/K9oL
	 vFH38LUMpxWnDjSVaw/tFVsOLZof6afMec4kaMT8xTCLieO5GpXyi3nJO4onGfmkM8
	 TXO2VriGErLv2LqRFd/pnMtUpppDJM6S0Aa9O2VY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Faisal Bukhari <faisalbukhari523@gmail.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Qinxin Xia <xiaqinxin@huawei.com>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2498/2651] perf parse-events: Include errno.h before kernel headers
Date: Wed, 18 Nov 2026 16:02:18 +0100
Message-ID: <20261118150414.744363552@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 022b0ac5d3e87f87cb7ba42d04d0bc3ddfdd6be4 ]

Building perf against uClibc fails in config_term_common():

  util/parse-events.c:954:30: error: 'ERANGE' undeclared

The kernel headers included before errno.h pull in asm/errno.h. uClibc's
bits/errno.h undefines EDOM, EILSEQ and ERANGE before including
linux/errno.h, but the kernel header include guards prevent these macros
from being defined again.

Include errno.h before the kernel headers so ERANGE remains defined.

Fixes: 6b9c0261b3fb298b ("perf record: Add ratio-to-prev term")
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Faisal Bukhari <faisalbukhari523@gmail.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qinxin Xia <xiaqinxin@huawei.com>
Cc: Thomas Falcon <thomas.falcon@intel.com>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/parse-events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 8302be207c1d6..5a84da4548e3e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1,10 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <errno.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/err.h>
 #include <linux/list_sort.h>
 #include <linux/zalloc.h>
 #include <dirent.h>
-#include <errno.h>
 #include <sys/ioctl.h>
 #include <sys/param.h>
 #include "cpumap.h"
-- 
2.53.0



