Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F4A16F8FA;
	Wed,  3 Jul 2024 11:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004807; cv=none; b=CRc1WGIGDtX96/yS3F9S/P03xqHMwVm3LAatrRkaJMyKkR20KIovc0viUU5yyYBFjoMcE1p+FGhWjFHNZsIKuaFmH1YoD5aDe+7zLZiqGTzqPmBOiTmtEHcToxImUDBW8NV0fnl0aof69jCMP/3daJJvZ1/6/vr/lf/kUBF5bmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004807; c=relaxed/simple;
	bh=HhipZ0arZ2j3eBD3H3PdgCy7x+1Hy2GT588SHOy7y6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMkhq3X584U7QAZnu+qj9+SYj51ZpVWHQSopcuM+W/LceIl7o4MYYTC+PIiB2kfbAQscBDu+/d3aJDVedzgH/1Z6DRt4N0zcpTKv7MPGPSe6o7VJlQu/+qKvabo3FHEqjEBb/cO6qkBQE5nzPpBaNMI3fMxhLhyystTRSi1XClY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RbsOt7u1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RbsOt7u1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830D8C2BD10;
	Wed,  3 Jul 2024 11:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004806;
	bh=HhipZ0arZ2j3eBD3H3PdgCy7x+1Hy2GT588SHOy7y6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RbsOt7u182U5O1nQ3OHeSyo2B9suhcyHHqlUHhXEqWvdOcPDZpPJ3Cln4+tuVKfdh
	 /azdTKPtQNZvpYysd6p5nUqK5uNW2r29s45lUM7QWMMgVxRiFrE5hHLmm251D1GqRh
	 WNDdY3m2G6s/R/W5MADRf0daIGwbGXJV6WyTA7fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Chuck Lever III <chuck.lever@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 166/290] gcov: add support for GCC 14
Date: Wed,  3 Jul 2024 12:39:07 +0200
Message-ID: <20240703102910.447155949@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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
@@ -19,7 +19,9 @@
 #include <linux/vmalloc.h>
 #include "gcov.h"
 
-#if (__GNUC__ >= 10)
+#if (__GNUC__ >= 14)
+#define GCOV_COUNTERS			9
+#elif (__GNUC__ >= 10)
 #define GCOV_COUNTERS			8
 #elif (__GNUC__ >= 7)
 #define GCOV_COUNTERS			9


