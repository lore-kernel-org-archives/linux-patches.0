Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8C229AAE9;
	Mon, 12 May 2025 18:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073481; cv=none; b=huQPbpZNy0HPNE74uC5JSIo8XHErVlmKTk7ErGKJeBHHrWp0i0NUremf2QCKMy73Q1blYplZw/vfxLxCerNBZ7pMt70vDCbWUTMKl16TDINJarmJ80BfZoYYSa/aAVW0WVLOpq1w0kXTGD2DBESej7zFVsarlNlDlXwh/dLyQUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073481; c=relaxed/simple;
	bh=8Mo0q1nwoXNm3Ld1fp22jtg4ax+3RYM+UFYgJA2vlwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdGBwQuuQPXEZ5M591GWWMuOYqSHceeU4Ei+fn8x09e/b2/kP0inFT0RUSHsi12TWh7FF1TDz50hh/Vqlh8arGRLnzb8KU7N3W0dzzylPdSBZzMu6x7sryQdL7y55IFiun3vBzV2CefKfsm2s1q8SOZ9KSCrgOzJA8XtCZaJYP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0BDjy17z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0BDjy17z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC669C4CEE7;
	Mon, 12 May 2025 18:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073479;
	bh=8Mo0q1nwoXNm3Ld1fp22jtg4ax+3RYM+UFYgJA2vlwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0BDjy17z3CSNvUqKU9TSmVmgxQEFRQSehgnaxewwzNIzgqYyuMwGi6BXFf1pDYRuU
	 gnq1HweWGHFI9TMVzgr3+QP3WRqLwjhR6e3uDbv4BkZaXUa2211XuGIDVmclDbDrBO
	 Ez43hmxrtEeIy0NrT/dVMVU8CcNKBqqWTcTuy7fE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/113] types: Complement the aligned types with signed 64-bit one
Date: Mon, 12 May 2025 19:46:10 +0200
Message-ID: <20250512172030.982938097@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 253168bb3fe15..78d87c751ff58 100644
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



