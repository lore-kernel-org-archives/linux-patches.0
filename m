Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028157;
	b=FOP9JS/4n5nqTPDJFsJEoSmW7H0xysAjinPL3TuY03H94E1hAcq9dmERsf6hWBy8T1Xv
	 f2TwNRYVXWoZmnkk/IiGb53ZjzviesUWfC2fdUWuCYmHK5pUCA+jLOyh/ul0v/WJeMJFH
	 Po/y0LehrVwR787MAbGOwBytGTFyhLKATwVx+zfGpKX3Ss6O1U41wY630aHPE8DTbNc5F
	 ElfNA7mlzaXeqdsp0a3hepoZ4ls2oaY3SWsUui83NEIjh/iP2sIoqDO+bu5erKDWYHLST
	 p4kpFnDNUDffphz7qTR7fHT2oBDQZqDZYP7g18odaoGJfdv3O7dHPojQOFtWPTUzi1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HAbOxVpe6CN5VE9nYZiJNk1CeG4Q2XDndbaOuBYLbeI=;
	b=Il/IEjH/Dl28y0WRtm4feztJ7NE0zGe9xUXST/+1ct6/rKjJIMrNgGd/wqqgKXb+fffP
	 d9SYakDy/7kXHWOg/a34yxW1E685qotSBaJlfZwuHDtdhq9VwLoIPFi99zFbYpzT8ERAv
	 gwq1KIp2PkWJhHYk08bP8IS1np6sg66J5Tgm/xOY7Bs+mREO3fb9nuoGX4oI76krJcnIe
	 HtfmlJEUjbV+K70kCUyCHRHKcQfInhhmCzCnLHBcdQUTB8CPuIGpWHoiiaWDjtYvd8u1N
	 jasdRG8TEszsRr+qFCvJKmRs1XQTDfQ+IpTcmbFgeaVymHS+XVFzsNzZuVpD7uQ8rog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=epBfCBQi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0296606A31C;
	Wed, 18 Nov 2026 18:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=epBfCBQi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783061F000C4;
	Wed, 18 Nov 2026 18:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028156;
	bh=HAbOxVpe6CN5VE9nYZiJNk1CeG4Q2XDndbaOuBYLbeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=epBfCBQifxPvtf0EUW1qRDMmjublVe+SWEzPPDUOR+GOjoeRcTMjiCr3zDowh6q4p
	 iO3y0gDd90Xf7L6JfhtnTKbKc+FZmxD2EGYRCrKb1vgGeF9XU9HOWhwMC55kIpKbjS
	 7j4a9Pgum2LGmMQ2XlBZJdSj7LfdZjxDNIQb7Pa0=
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
Subject: [PATCH 6.18 2004/2151] perf parse-events: Include errno.h before kernel headers
Date: Wed, 18 Nov 2026 16:02:19 +0100
Message-ID: <20261118150234.726143944@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3d05d691e8c52..3bbe1356387ba 100644
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



