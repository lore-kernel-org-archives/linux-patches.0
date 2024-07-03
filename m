Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45037CF1F;
	Wed,  3 Jul 2024 10:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003538; cv=none; b=W8owOuXdlx5eIQnsf+Q4a84MO/cypz55Jg4mAOzEH1SL3c4fzE/Duh1iOs1zLS4mtFAMJKEwXxsDUldnOBjJPU0zZe6yNbjhRdBVrmosuS9AdxRutaIfgAeujy+BpQO1DKrjC9balnY8KktPuQroG0vaH1YPjw19cHV/lf6n07c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003538; c=relaxed/simple;
	bh=uGgHVPfM3dKtq0FsW7t3haBT24Z65YalC0mB/2sMYXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=to91aZjWstwd5HwT5uKzX1ynsewh/4yfPEMYCnk9YEeyTUykPaxUUSignXEt7DmWEwHI8OrUABv6HsKW0MZ3RXWqkxoBp5uO8hC7dG2znDKscLV/RE0O3Sd2J4iIAv+fanIGy4FAKM5uUsIq/XcoXF1cPcGbjZAqfVuHH90wSAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exiTi7t9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exiTi7t9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38843C2BD10;
	Wed,  3 Jul 2024 10:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003538;
	bh=uGgHVPfM3dKtq0FsW7t3haBT24Z65YalC0mB/2sMYXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=exiTi7t9CtecSN51I5w6Rm0u6hzzYR2Id4gP+OBhkCYTWh4zwlWBMNg+BQKq8oIso
	 S1/FFHXkG+OlJXy7TardPxeZ/CPZH1W2pYaQQZUEqGPvNWYtxEfFLfYXIFQ9zfVQxJ
	 uKaKUWhuGKNOAjONDd/BN7xGrOJfY/c2+NhkBtFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Chuck Lever III <chuck.lever@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.19 081/139] gcov: add support for GCC 14
Date: Wed,  3 Jul 2024 12:39:38 +0200
Message-ID: <20240703102833.500179771@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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


