Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FE41FDD;
	Mon,  4 Aug 2025 00:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267967; cv=none; b=cCs5S8tmYO6ErRWiNzJE92ISnVqXGym+Bek+MkpjND625enYhbY1Rjib7HqfFvq0bn7ln46WcWjWmmmOtGgk2fZB+s5duu1fn3tJiVoy2smkhWDha9dcqueg6CPaQ4KSXnWw4U6uxgUd0thZm5zaZbG5kIDXNSOX7TYJBVXSgBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267967; c=relaxed/simple;
	bh=+pYwS4WTvi/EAOfs6kaV9zLl/d2GTGR+hcGJOV+TOvc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mZ0YhqpAN7RQ4mwdwVY9I0m9LXMq57mHdwmUKkuHj0vaq+CfRZf/NO4SpG8us4f0YwsKKbVV91cHH3MK+gr0FBmNqAo2aIgTRMzvaY2Vg6rzGaN+whDk+tWCvWO6KkGeH4nri63Lmx4yG1Pvh70V4eT7UDypoLFkbF6g3PSVYDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NuvQC3d0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NuvQC3d0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082A0C4CEFB;
	Mon,  4 Aug 2025 00:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267967;
	bh=+pYwS4WTvi/EAOfs6kaV9zLl/d2GTGR+hcGJOV+TOvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NuvQC3d0a7zKcUvO6YjPB15emR0y+vXGpO0J9iJFsi9AXvbtw/A+O7xlEaxs0WF86
	 E86h1Uu8VpKijJpbz9sP2pJ+D6HTA1ltrU+ByOIfg5JS3mtR5W8aoD0CiQFzlz8SFl
	 GqnWwq9tTJcPoSdGXFh7DD4n9EVlEQCxVa62V95n7nGmcSVrbuD/mwKZx7MdFb/iGa
	 v53QfB8c6wHSqxJRiK1Ff0rAIyGKYcHP0B7EfZn1G38xWjjRnJTmuaoQQl4hh24NQO
	 EyqEunfo4YYk97UrkbVi03735gIestvb3onN8Hr1gIP79oIuOTPOzAc+/s/nScelEP
	 TDqokT+nbLZ2Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.15 16/44] tools/nolibc: define time_t in terms of __kernel_old_time_t
Date: Sun,  3 Aug 2025 20:38:21 -0400
Message-Id: <20250804003849.3627024-16-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003849.3627024-1-sashal@kernel.org>
References: <20250804003849.3627024-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.189
Content-Transfer-Encoding: 8bit

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit d5094bcb5bfdfea2cf0de8aaf77cc65db56cbdb5 ]

Nolibc assumes that the kernel ABI is using a time values that are as
large as a long integer. For most ABIs this holds true.
But for x32 this is not correct, as it uses 32bit longs but 64bit times.

Also the 'struct stat' implementation of nolibc relies on timespec::tv_sec
and time_t being the same type. While timespec::tv_sec comes from the
kernel and is of type __kernel_old_time_t, time_t is defined within nolibc.

Switch to the __kernel_old_time_t to always get the correct type.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20250712-nolibc-x32-v1-1-6d81cb798710@weissschuh.net
Acked-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of this commit, here is my assessment:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Bug Fix**: This fixes a real ABI compatibility bug where nolibc
   incorrectly assumes `time_t` is always the same size as `long`. On
   x32 architecture (x86-64 with 32-bit pointers), `long` is 32-bit but
   kernel time values are 64-bit, causing type mismatches.

2. **Clear Impact**: The commit message clearly explains the issue - the
   `struct stat` implementation in nolibc relies on `timespec::tv_sec`
   and `time_t` being the same type. Looking at the code:
   - In `/include/uapi/linux/time.h:12`, `struct timespec` uses
     `__kernel_old_time_t tv_sec`
   - In the original nolibc code at `tools/include/nolibc/std.h:30`,
     `time_t` was defined as `signed long`
   - In `tools/include/nolibc/types.h:183-185`, the stat structure uses
     unions that expect `time_t` and `struct timespec` members to be
     compatible

3. **Small and Contained Fix**: The change is minimal - just changing
   one typedef from `signed long` to `__kernel_old_time_t` and adding
   the necessary include. This is exactly the kind of focused fix
   suitable for stable.

4. **No Feature Changes**: This doesn't add new functionality or change
   the API - it just corrects the type definition to match what the
   kernel actually uses.

5. **Low Risk**: The change uses the kernel's own type definition
   (`__kernel_old_time_t`) which is already defined as `__kernel_long_t`
   in the generic case, so for most architectures this is a no-op. It
   only changes behavior on architectures like x32 where it's actually
   needed.

6. **Prevents Runtime Failures**: Without this fix, nolibc programs on
   x32 would have incorrect stat structures where time fields don't
   align properly with kernel expectations, potentially causing data
   corruption or incorrect time values.

The commit follows stable kernel rules by fixing an important bug with
minimal changes and low regression risk. It's a clear correctness fix
for a specific architecture compatibility issue.

 tools/include/nolibc/std.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/include/nolibc/std.h b/tools/include/nolibc/std.h
index 1747ae125392..a0ea830e1ba1 100644
--- a/tools/include/nolibc/std.h
+++ b/tools/include/nolibc/std.h
@@ -33,6 +33,8 @@ typedef unsigned long     uintptr_t;
 typedef   signed long      intptr_t;
 typedef   signed long     ptrdiff_t;
 
+#include <linux/types.h>
+
 /* those are commonly provided by sys/types.h */
 typedef unsigned int          dev_t;
 typedef unsigned long         ino_t;
@@ -44,6 +46,6 @@ typedef unsigned long       nlink_t;
 typedef   signed long         off_t;
 typedef   signed long     blksize_t;
 typedef   signed long      blkcnt_t;
-typedef   signed long        time_t;
+typedef __kernel_old_time_t  time_t;
 
 #endif /* _NOLIBC_STD_H */
-- 
2.39.5

