Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857712BDC39;
	Mon, 12 May 2025 18:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073124; cv=none; b=XA5LYx4EiuIgGlOFhSTYJYEKZPQiMoVozmk4N4jj15MbmoIjoO/R1XBd8/+ufHALvZT8TUibEy+gt6Sr/DhXB/puj4pm/XzFNau5tC8B3vfrYrrDe3Tuf6QfbDo8qBBS+1bnbnfVReLJQBo/zSXerPSpMNbiTdxiy1z8pxkkdAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073124; c=relaxed/simple;
	bh=8l2IdlUqyWnCxeH7lAlgB2lQxQcOmC059AIDKD2W+Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ON9phy139I//UIBRHre1buWEBPDcIuQ7xafBBDFvbG6e9Y/1gt1hWGGyKS7gcbFlQQD/KFv1G87wZykKPjVfUJRADdlkmawutQCDrGJCYuaUE3CUbWNq2HL1NLurk3tdoGmJ4brl0H23kOTV4k409a0prlQRfWkZqWzIL0ojKtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJVtASV4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJVtASV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E57C4CEE9;
	Mon, 12 May 2025 18:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073124;
	bh=8l2IdlUqyWnCxeH7lAlgB2lQxQcOmC059AIDKD2W+Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJVtASV4dEOXTrGkK95DiorPNkkT38TNINjmgedR+z4aa8OhVCVQSKYcFjYXRu6AT
	 arS7/tiZVjy02n5zOgwHDd6Yx+gGzPpzgWuEy5o0nVxHHWocvbg+AhCY0KGkNhdgFV
	 GpL5MaycJk/8zk+yweP7V535P+qL0j8zwsOKxPXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 132/184] types: Complement the aligned types with signed 64-bit one
Date: Mon, 12 May 2025 19:45:33 +0200
Message-ID: <20250512172047.192383977@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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
index 2bc8766ba20ca..2d7b9ae8714ce 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -115,8 +115,9 @@ typedef u64			u_int64_t;
 typedef s64			int64_t;
 #endif
 
-/* this is a special 64bit data type that is 8-byte aligned */
+/* These are the special 64-bit data types that are 8-byte aligned */
 #define aligned_u64		__aligned_u64
+#define aligned_s64		__aligned_s64
 #define aligned_be64		__aligned_be64
 #define aligned_le64		__aligned_le64
 
diff --git a/include/uapi/linux/types.h b/include/uapi/linux/types.h
index 6375a06840520..48b933938877d 100644
--- a/include/uapi/linux/types.h
+++ b/include/uapi/linux/types.h
@@ -53,6 +53,7 @@ typedef __u32 __bitwise __wsum;
  * No conversions are necessary between 32-bit user-space and a 64-bit kernel.
  */
 #define __aligned_u64 __u64 __attribute__((aligned(8)))
+#define __aligned_s64 __s64 __attribute__((aligned(8)))
 #define __aligned_be64 __be64 __attribute__((aligned(8)))
 #define __aligned_le64 __le64 __attribute__((aligned(8)))
 
-- 
2.39.5



