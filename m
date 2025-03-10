Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89E8238148;
	Mon, 10 Mar 2025 17:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627417; cv=none; b=G2nX6ecmx/xfA4ottKQytSVdxUPaG7R8dxUZxqMEDBRZOMnppXlSYfBya++rzw/CPLgxH5JmTli/KqYE/ihOELFYy3kDS7yTBB54eImwGZfOlM+U3Bk2rzNV0ALRWyC9OIBbgGWxIc5HJp9Gks/eM0Q+LmA+oSeuum8j1UO+SRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627417; c=relaxed/simple;
	bh=LnNM9p7ZfauKYIaZn3hHmCVg0J4Us3EuX8f7ECn/NFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSIpkzOeAi43QNJee6fN755RC/pQOc8+2hk58+mpN55znYWmLB1vl8YwvJhJPWEVXySDcWKVk/MpCZfgqqYgGRvN3zMABrzuuqVsudGsM7oTOqS3fmOs8h/Zst9/mxX5armeAr8bHfjDPMkKUkY9AUgeZFYpI8gto8pTs286Twg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=df6A1nXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="df6A1nXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68AECC4CEEC;
	Mon, 10 Mar 2025 17:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627416;
	bh=LnNM9p7ZfauKYIaZn3hHmCVg0J4Us3EuX8f7ECn/NFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=df6A1nXW2ZlHUmtN0yyzGtX1vj1dlR03f5wugBkn/2pNXNyWgwU8Ii/MZlKxtR8Hc
	 RPzzjkf1oIynpBkv8yrMb4ZlY/HnLH96KpqSQ29TWoKiGXeac/P/yEimGLBAxzE8oM
	 fqveZOaRMiD2f9S58IsRcknSnn8ZMWniTfxMJYLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	kernel test robot <oliver.sang@intel.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 123/269] selftests/damon/damos_quota_goal: handle minimum quota that cannot be further reduced
Date: Mon, 10 Mar 2025 18:04:36 +0100
Message-ID: <20250310170502.625714111@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 349db086a66051bc6114b64b4446787c20ac3f00 upstream.

damos_quota_goal.py selftest see if DAMOS quota goals tuning feature
increases or reduces the effective size quota for given score as expected.
The tuning feature sets the minimum quota size as one byte, so if the
effective size quota is already one, we cannot expect it further be
reduced.  However the test is not aware of the edge case, and fails since
it shown no expected change of the effective quota.  Handle the case by
updating the failure logic for no change to see if it was the case, and
simply skips to next test input.

Link: https://lkml.kernel.org/r/20250217182304.45215-1-sj@kernel.org
Fixes: f1c07c0a1662 ("selftests/damon: add a test for DAMOS quota goal")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202502171423.b28a918d-lkp@intel.com
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>	[6.10.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/damon/damos_quota_goal.py |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/damon/damos_quota_goal.py
+++ b/tools/testing/selftests/damon/damos_quota_goal.py
@@ -63,6 +63,9 @@ def main():
             if last_effective_bytes != 0 else -1.0))
 
         if last_effective_bytes == goal.effective_bytes:
+            # effective quota was already minimum that cannot be more reduced
+            if expect_increase is False and last_effective_bytes == 1:
+                continue
             print('efective bytes not changed: %d' % goal.effective_bytes)
             exit(1)
 


