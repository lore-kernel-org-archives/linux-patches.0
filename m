Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367F222F767;
	Mon,  2 Jun 2025 14:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874540; cv=none; b=L44NBIt9ytiNlpmR4zP5W50kI8Gc2XUNMeNmhTiPU2Id9LXeQwrBF4YQgfM1VgLAlspkLqqXvVEh+uNiN2nPNjyyOY51askFkzrTtatPnlwBiDBhMf+rhjDDzCPkiDClcGPjRmMeipw5Dh4m+7nqXcv/PZf+ZGsCZcCpnNl5z08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874540; c=relaxed/simple;
	bh=An3GFcre/sozyfmKmPToZsyGrZR3UXlErXXXgH76Wug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OiWPVWOciFhh0SW/1AChwJH6piXah4pCCPgPAg/01spOCJUcEip9qu68/nTyqjT4a4KDFBiQIye5oUU+Bc3+3g1UJO+3Wyc/xj+K+ZLGPrf4bsMzRujsTlZ5uMmIguGdjdjRr9ySZKP+YQ6HMBVzHn1O16H2WDBrUV2DNeTUhss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lzva60Bq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lzva60Bq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99164C4CEFB;
	Mon,  2 Jun 2025 14:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874540;
	bh=An3GFcre/sozyfmKmPToZsyGrZR3UXlErXXXgH76Wug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lzva60Bq7rHfSeEYhWISvUC7j76jfrX9/2Dz2YPvYubQU1i9BSbjOJzTDOFDZJUB0
	 byaxv5ppyhdpR2TDYAbrpVglV+Jcw4NejtAd2XV1Rd4jgEPq4wrKgB6L9rzx+9dUM6
	 m+vtyBO23KHuI5g6iTJ0BFa+6OBB5yWSTIw7OmcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/204] types: Complement the aligned types with signed 64-bit one
Date: Mon,  2 Jun 2025 15:46:30 +0200
Message-ID: <20250602134257.922458764@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 05030f608be32..71e55c06c9639 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -114,8 +114,9 @@ typedef u64			u_int64_t;
 typedef s64			int64_t;
 #endif
 
-/* this is a special 64bit data type that is 8-byte aligned */
+/* These are the special 64-bit data types that are 8-byte aligned */
 #define aligned_u64		__aligned_u64
+#define aligned_s64		__aligned_s64
 #define aligned_be64		__aligned_be64
 #define aligned_le64		__aligned_le64
 
diff --git a/include/uapi/linux/types.h b/include/uapi/linux/types.h
index 2fce8b6876e90..cf5f4617ba5aa 100644
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



