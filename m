Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4573E254AF7;
	Mon, 12 May 2025 17:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071117; cv=none; b=hqpAwq5HAwC9J9L7/T/213ZzuovDmoyhf08ut/L33EMzZYyHMP6TBpwyFzNR1tU6uLGGyhjs54JDiQl9UfM62a5LxjwbWk7cUyLqTKNeNWI3O+5hc5e63cHGw21W32k2L7HiUixFEi8xhfDMZ5leouhtXI3P671wzsycKK7o4Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071117; c=relaxed/simple;
	bh=n2wfTeygIPXpMeR0X0QZQaGxB6+J0TkyP/GKA3lPF7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noekY+Ox1Z16vI4qm9J8+KI1r1ABdyg8aoUUOa4Cu2J5FWydj2iDC1eCuc6qMHFPlUc+lWBN1RWrWVXTPW4N1BQ9bTflPzrm4xqBjj3VTkrm3JInRPpBqoh48QFJ0SrT2Z09u+dKEBMLuLVrJPnUPvUuuHDZLKMf2KMXZWKjJcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3xHEPOf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3xHEPOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE90C4CEE7;
	Mon, 12 May 2025 17:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071117;
	bh=n2wfTeygIPXpMeR0X0QZQaGxB6+J0TkyP/GKA3lPF7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3xHEPOfsAlueM0gScGOzeVP4+oO+98/nr29268jfngr23CQyWqtI/wmENkQJCj2Y
	 6Ft/wLCJHn8Eub7RLLIrGxSWlsJrXUN9FC52eiAk4VR7o12kCS68DUaM2TsZyzM2W6
	 z65CYa43zU+dEQbm0uffIBOO9Trxsuh1QRZYz+4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 45/54] types: Complement the aligned types with signed 64-bit one
Date: Mon, 12 May 2025 19:29:57 +0200
Message-ID: <20250512172017.456854703@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit e4ca0e59c39442546866f3dd514a3a5956577daf ]

Some user may want to use aligned signed 64-bit type.
Provide it for them.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20240903180218.3640501-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 5097eaae98e5 ("iio: adc: dln2: Use aligned_s64 for timestamp")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/types.h      | 3 ++-
 include/uapi/linux/types.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/types.h b/include/linux/types.h
index ac825ad90e44a..be939d088638b 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -109,8 +109,9 @@ typedef u64			u_int64_t;
 typedef s64			int64_t;
 #endif
 
-/* this is a special 64bit data type that is 8-byte aligned */
+/* These are the special 64-bit data types that are 8-byte aligned */
 #define aligned_u64		__aligned_u64
+#define aligned_s64		__aligned_s64
 #define aligned_be64		__aligned_be64
 #define aligned_le64		__aligned_le64
 
diff --git a/include/uapi/linux/types.h b/include/uapi/linux/types.h
index f6d2f83cbe297..aa96c4589b71f 100644
--- a/include/uapi/linux/types.h
+++ b/include/uapi/linux/types.h
@@ -46,6 +46,7 @@ typedef __u32 __bitwise __wsum;
  * No conversions are necessary between 32-bit user-space and a 64-bit kernel.
  */
 #define __aligned_u64 __u64 __attribute__((aligned(8)))
+#define __aligned_s64 __s64 __attribute__((aligned(8)))
 #define __aligned_be64 __be64 __attribute__((aligned(8)))
 #define __aligned_le64 __le64 __attribute__((aligned(8)))
 
-- 
2.39.5



