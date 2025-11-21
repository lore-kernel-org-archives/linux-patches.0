Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D141F03D7;
	Fri, 21 Nov 2025 13:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731880; cv=none; b=rYCmYYX3mIamMXJvOaF6y3wnEXtTy3SgRxFp93RYY4JJkCpuVJYU0LOgAM88h8dyOAkLQ0jlQ17L/7LUu9Nc91V7tIPg5Caa7hMhTWYpCo1/KR8Ow8pCNDRsXh1TL/GER8pZFlGsEu/DzoVfGJevrWrOfeDcAyTU2sgSF7xjOFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731880; c=relaxed/simple;
	bh=mYwLMPmRDDHacXTr6je8bLGkjzJorNsy2gHy3jGPAH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4X2ueFGLW9koa/oSgSWSg4uYJpsrIqk22wGvhNMLsKboEdYNP0WPo8ZIDeLwDKDM0/ZfbnXZZvt5W1kvDFaF8NmVDDUhwmki7aCk2wWUd+QUebPzyZdZhzPmoqYaVgg26TedwFmlzN8kaf15fQ4Ly9Gegl1cg1lLynCHbI2tPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k279+Hq6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k279+Hq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33AD4C4CEF1;
	Fri, 21 Nov 2025 13:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731880;
	bh=mYwLMPmRDDHacXTr6je8bLGkjzJorNsy2gHy3jGPAH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k279+Hq6aIvLtVVtPnJEDCzXEYj09EQRMRAWDMcWuPi1n+YN3uec1ottaZFx6J7ae
	 GAHvDuKK9flH3TngtqgwkFRxytqf9LuAOkg336dP4+SvsEip0+EXSf9q69UuNj0QoS
	 p/LpxX3BRx2WJKTt0vzORWfexbDowhLfa3ia5uGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 113/185] gcov: add support for GCC 15
Date: Fri, 21 Nov 2025 14:12:20 +0100
Message-ID: <20251121130147.952004631@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Oberparleiter <oberpar@linux.ibm.com>

commit ec4d11fc4b2dd4a2fa8c9d801ee9753b74623554 upstream.

Using gcov on kernels compiled with GCC 15 results in truncated 16-byte
long .gcda files with no usable data.  To fix this, update GCOV_COUNTERS
to match the value defined by GCC 15.

Tested with GCC 14.3.0 and GCC 15.2.0.

Link: https://lkml.kernel.org/r/20251028115125.1319410-1-oberpar@linux.ibm.com
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reported-by: Matthieu Baerts <matttbe@kernel.org>
Closes: https://github.com/linux-test-project/lcov/issues/445
Tested-by: Matthieu Baerts <matttbe@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/gcov/gcc_4_7.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/gcov/gcc_4_7.c
+++ b/kernel/gcov/gcc_4_7.c
@@ -18,7 +18,9 @@
 #include <linux/mm.h>
 #include "gcov.h"
 
-#if (__GNUC__ >= 14)
+#if (__GNUC__ >= 15)
+#define GCOV_COUNTERS			10
+#elif (__GNUC__ >= 14)
 #define GCOV_COUNTERS			9
 #elif (__GNUC__ >= 10)
 #define GCOV_COUNTERS			8


