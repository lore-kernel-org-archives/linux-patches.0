Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035AE146A67;
	Tue, 25 Jun 2024 10:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309795; cv=none; b=Xms8kwjjIFe69RctOA7lQsPhBvhT+S7i2cqjd6TQquGPmSGUGwYh0O9zWA5eAWkzKG9vMFBLcoJQP25ZMm3HI9zlofDDckdOSxNqPobMTRBAlVKaj+SgV9CTp95HhA05WyTbRsV6A0RTD9CkMGwj+HPwhave+9yVtmkKNq8K5DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309795; c=relaxed/simple;
	bh=z6z5TJo1pBitPYDJ1Vo5Sdr1bIZL4FAfuJTzpqlNuCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0NLJcA/6Q+DQu98pkYt4XJb1n4TS+tOce8B8Y+xdhGM4fqAhoV4W7rAM+u6kYSLganHjR2nTJwnn848gGhg3p+aUZuLswDo2COks6JmWWDuR1LKT1/ZANf59AKdM3ZqM/mAbKnXkOLvLe1362XfEdsxc+HTYJiXyDZQKRIblo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idfHJ9CB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idfHJ9CB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D474C4AF10;
	Tue, 25 Jun 2024 10:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309794;
	bh=z6z5TJo1pBitPYDJ1Vo5Sdr1bIZL4FAfuJTzpqlNuCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idfHJ9CBYdDoLDkDg9dfXBG1Tmg5RGzN/eTvjwC/lOMiJa0xn6WSwp13xr4Sbcthl
	 7Jc25dGE/i7kNcH0vMg8Vak0bw2A4hkWgQrngQQHcQyT4GPfBEVEzJdG7M8muQ0R63
	 90UWn9yBx3CWrIB12kTDmNYFfqMh/pSsIR1NASCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Chuck Lever III <chuck.lever@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 107/131] gcov: add support for GCC 14
Date: Tue, 25 Jun 2024 11:34:22 +0200
Message-ID: <20240625085530.004019578@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

From: Peter Oberparleiter <oberpar@linux.ibm.com>

commit c1558bc57b8e5b4da5d821537cd30e2e660861d8 upstream.

Using gcov on kernels compiled with GCC 14 results in truncated 16-byte
long .gcda files with no usable data.  To fix this, update GCOV_COUNTERS
to match the value defined by GCC 14.

Tested with GCC versions 14.1.0 and 13.2.0.

Link: https://lkml.kernel.org/r/20240610092743.1609845-1-oberpar@linux.ibm.com
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reported-by: Allison Henderson <allison.henderson@oracle.com>
Reported-by: Chuck Lever III <chuck.lever@oracle.com>
Tested-by: Chuck Lever <chuck.lever@oracle.com>
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
 
-#if (__GNUC__ >= 10)
+#if (__GNUC__ >= 14)
+#define GCOV_COUNTERS			9
+#elif (__GNUC__ >= 10)
 #define GCOV_COUNTERS			8
 #elif (__GNUC__ >= 7)
 #define GCOV_COUNTERS			9


