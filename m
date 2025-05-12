Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23975255222;
	Mon, 12 May 2025 17:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072601; cv=none; b=ZKqwPXgTrkShei/2ZZUiEqrO/UqIKK3SCi0rtJPkZPQfSmhh0YElTRlCt9FK50aHvE/Wi+fm4/biD77ues122zsFitlhOWeyeUazylhLjTn02eh4NWut9dPBXNJxQ5gNg43Xsm6U9IA+jbuF87whUIRkd1AKwsvkoFiqTUM+9jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072601; c=relaxed/simple;
	bh=6aUqz2WbSb4zJACAGb7aT8C/PXn3b2NW3bi7djDcTxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gzwEdXd13B5n+JjFopYACRvCOSUicwCwGcwto5UsGphn8dubBWGGCur7MkQgqNyNT5oEilZn1c07Zhxwo6sL9NsYZ0RSRZHf5PpAFfg6zSdFOT9Andn/oleHRV6CoWxSWOdS21W1K96YZvQcuml/rAfRNzw/DudtU63lmi9rnkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fblN0CjL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fblN0CjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F60BC4CEE7;
	Mon, 12 May 2025 17:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072601;
	bh=6aUqz2WbSb4zJACAGb7aT8C/PXn3b2NW3bi7djDcTxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fblN0CjLjjMbltkdK2nvPudDTZHEemfb875hFajJJVi1lCzIiVoBJ0BKPyKc2xwQp
	 T8Iu6tu+b9KH1tMUC5EKhtsQw3kV9QMN4KGSLW/4BnEqOGJ+A5ojdF4GpaIFFxkwf1
	 M4IWI54dc7+kyRZCCRipf6kSoa3ybY8/2C0vTLFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 62/92] types: Complement the aligned types with signed 64-bit one
Date: Mon, 12 May 2025 19:45:37 +0200
Message-ID: <20250512172025.638566416@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit e4ca0e59c39442546866f3dd514a3a5956577daf ]

Some user may want to use aligned signed 64-bit type.
Provide it for them.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20240903180218.3640501-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 1bb942287e05 ("iio: accel: adxl355: Make timestamp 64-bit aligned using aligned_s64")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/types.h      | 3 ++-
 include/uapi/linux/types.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/types.h b/include/linux/types.h
index ea8cf60a8a795..f1df5d8df2ef9 100644
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
index 308433be33c26..c39147653094f 100644
--- a/include/uapi/linux/types.h
+++ b/include/uapi/linux/types.h
@@ -49,6 +49,7 @@ typedef __u32 __bitwise __wsum;
  * No conversions are necessary between 32-bit user-space and a 64-bit kernel.
  */
 #define __aligned_u64 __u64 __attribute__((aligned(8)))
+#define __aligned_s64 __s64 __attribute__((aligned(8)))
 #define __aligned_be64 __be64 __attribute__((aligned(8)))
 #define __aligned_le64 __le64 __attribute__((aligned(8)))
 
-- 
2.39.5



