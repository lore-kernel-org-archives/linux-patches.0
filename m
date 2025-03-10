Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65524230D3D;
	Mon, 10 Mar 2025 17:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626645; cv=none; b=tIs2Xa6yr6+mPVuxFN1+768twAkwFkBmsPAQBg08twJS8o+3RUXqPuOyyH6HDhga+GyQQ6AmqbN8DfsvmtPDdsQX+aN/vAkH3fmUkebW9hWC9urFnUPB3RjLBpxug6tvIVAsCJhJwa7uCDez+e55ZcVfUMWRHjOAs78aU1UqWuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626645; c=relaxed/simple;
	bh=b5BfELRwBLkRzV6ctZeIt0LilPZ8GVTLUAE/9OfjhUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/5pXfqKAT+YlfiHAY+nBf8byhYhHUmHkvWbk5kxvPmxEqvAxInFJAXCmZd/IdhGN6gXU7dAomm9MEGlcroUjZL5Ixg3DiYSJps4b2JHlIwdoh7SeeYf3JyaxYnOWU5ckZWz6OlUKSsjQ83FEqC9yEUjg3VDwYhUNnDYwOjeAUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eh+B8KOU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eh+B8KOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F27C4CEE5;
	Mon, 10 Mar 2025 17:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626645;
	bh=b5BfELRwBLkRzV6ctZeIt0LilPZ8GVTLUAE/9OfjhUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eh+B8KOUgMj/2ir+D5kPRIxJbWcwdZGPQHDcp5tXrb1/Uh0tpDpIEI7v5zr9Jziiv
	 tHT23r4zKlupw7c1qJx4CaU4/hMzV3+v52I4vSoSyZWzAmsJVItUSX0bnfPkl2Cdr4
	 xzn/RY3z0GVQceFQBvEFKKfG8U/oXOsRTZyYQ7OU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.13 063/207] selftests/damon/damos_quota: make real expectation of quota exceeds
Date: Mon, 10 Mar 2025 18:04:16 +0100
Message-ID: <20250310170450.273677649@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 1c684d77dfbcf926e0dd28f6d260e8fdd8a58e85 upstream.

Patch series "selftests/damon: three fixes for false results".

Fix three DAMON selftest bugs that cause two and one false positive
failures and successes.


This patch (of 3):

damos_quota.py assumes the quota will always exceeded.  But whether quota
will be exceeded or not depend on the monitoring results.  Actually the
monitored workload has chaning access pattern and hence sometimes the
quota may not really be exceeded.  As a result, false positive test
failures happen.  Expect how much time the quota will be exceeded by
checking the monitoring results, and use it instead of the naive
assumption.

Link: https://lkml.kernel.org/r/20250225222333.505646-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250225222333.505646-2-sj@kernel.org
Fixes: 51f58c9da14b ("selftests/damon: add a test for DAMOS quota")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/damon/damos_quota.py |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/damon/damos_quota.py
+++ b/tools/testing/selftests/damon/damos_quota.py
@@ -51,16 +51,19 @@ def main():
         nr_quota_exceeds = scheme.stats.qt_exceeds
 
     wss_collected.sort()
+    nr_expected_quota_exceeds = 0
     for wss in wss_collected:
         if wss > sz_quota:
             print('quota is not kept: %s > %s' % (wss, sz_quota))
             print('collected samples are as below')
             print('\n'.join(['%d' % wss for wss in wss_collected]))
             exit(1)
+        if wss == sz_quota:
+            nr_expected_quota_exceeds += 1
 
-    if nr_quota_exceeds < len(wss_collected):
-        print('quota is not always exceeded: %d > %d' %
-              (len(wss_collected), nr_quota_exceeds))
+    if nr_quota_exceeds < nr_expected_quota_exceeds:
+        print('quota is exceeded less than expected: %d < %d' %
+              (nr_quota_exceeds, nr_expected_quota_exceeds))
         exit(1)
 
 if __name__ == '__main__':


