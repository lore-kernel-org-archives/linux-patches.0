Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054586;
	b=dCEM3XxE4RvUHXXU1q5O4jfSJLUdXp1zp8ZcXp40443kWPnjuxnqwUOGQD8U6d81ob0T
	 E/jQoLa8qNkvk0mrjv3NU61V3a/yVT2ebBG3TbdQCXYzmBchm67CA930b7Dkj7dO01PFq
	 pct3suJ4n+/YkBPc41I1eYDPypSZRiOLweNqo5RRyIndCFYfW/8K1WjkDbv5Ux2wo3h+N
	 B+oNwYPIQdFjgHROt7QOLEdKeeDdETdcFvykShiB8rxTM29evJqrF3xi+COt0H6k4AWFd
	 wyGZ3P8UkNW61SvCfWU5xDC3pfgYUoIA/cSDOCC9sRcLfBoA1J0ItzBPPTVQRcRcJ/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NZk5fcNFAu0R4NgdQphDE1LRU6Co4P3pP5z28WbrIJ4=;
	b=aopksqfPzBhWWhJrbhh89VPGf2xgUdVjf8SBrnrtpIOpdqdnGtNa5qYxAJ7EmXbXZQU4
	 8Mp0yryN9bLGAFvhBPuPloPAel+3Z40vkYd56NDgeNJ1DvYVWtVBfSxN+tQpf6vTav8oD
	 QlvGsMydTgUiz2ic6f77HItxQk8KEHz0xlIDhkLKuBTbqyw75VBZK45FexrjS2VilPtpM
	 721rRgyPUwh4UOXCK5S36CaZ2NotRELx4EZIM/PRNlAV9OX5iUH8rk+n6h8NHOcjJpJdH
	 Rj0U2SJ5uZ7UZOk52oOdTAa8AcCrLBxK7021II/M70ZfPGDxTozO8jBh7f8xbXAJAwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T3hLlPfK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0648606A32C;
	Thu, 19 Nov 2026 02:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T3hLlPfK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA541F000C4;
	Thu, 19 Nov 2026 02:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054585;
	bh=NZk5fcNFAu0R4NgdQphDE1LRU6Co4P3pP5z28WbrIJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T3hLlPfKSjbGLkJlbXjV7KHvGcag8M5stItLkb798S1rPiKvccgJV8+Kog6dn08ds
	 gNRrnpoTEy9v+43VSnD9Islb0TzkCKK6r5J1vyc91BKFUHG2Z0oSSGvonL/D4p8xHp
	 vf3YesoXGne98brpreMuAZMLQWl9RPSqx6oQvmrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raveendra Talabattula <raveendra.talabattula@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1326/2214] drm/komeda: Fix bits parsing of GLB_CORE_ID
Date: Wed, 18 Nov 2026 15:50:02 +0100
Message-ID: <20261118150104.479930243@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raveendra Talabattula <raveendra.talabattula@arm.com>

[ Upstream commit ec902de0221747094f9ccbb61454e9633fbf282f ]

GLB_CORE_ID contains the product and version information returned by the
hardware. The current macros parses VERSION_MINOR as a 4-bit field and
VERSION_STATUS as an 8-bit field, which does not match the register
layout. As a result, the driver reports an incorrect version number.

Fix the parsing macros to match the hardware specification:
- VERSION_MINOR is 8 bits at [11:4]
- VERSION_STATUS is 4 bits at [3:0]

Fixes: bd628c1bed79 ("drm/komeda: komeda_dev/pipeline/component definition and initialzation")
Signed-off-by: Raveendra Talabattula <raveendra.talabattula@arm.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260803142122.4127851-2-raveendra.talabattula@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/display/include/malidp_product.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/arm/display/include/malidp_product.h b/drivers/gpu/drm/arm/display/include/malidp_product.h
index 16a8a2c22c423..f0c34eff523f1 100644
--- a/drivers/gpu/drm/arm/display/include/malidp_product.h
+++ b/drivers/gpu/drm/arm/display/include/malidp_product.h
@@ -8,14 +8,18 @@
 #define _MALIDP_PRODUCT_H_
 
 /* Product identification */
+/* GLB_CORE_ID fields as per HW specification:
+ * MINOR is 8 bits ([11:4]) and STATUS is 4 bits ([3:0]).
+ * Update masks/shifts accordingly.
+ */
 #define MALIDP_CORE_ID(__product, __major, __minor, __status) \
 	((((__product) & 0xFFFF) << 16) | (((__major) & 0xF) << 12) | \
-	(((__minor) & 0xF) << 8) | ((__status) & 0xFF))
+	(((__minor) & 0xFF) << 4) | ((__status) & 0xF))
 
 #define MALIDP_CORE_ID_PRODUCT_ID(__core_id) ((__u32)(__core_id) >> 16)
 #define MALIDP_CORE_ID_MAJOR(__core_id)      (((__u32)(__core_id) >> 12) & 0xF)
-#define MALIDP_CORE_ID_MINOR(__core_id)      (((__u32)(__core_id) >> 8) & 0xF)
-#define MALIDP_CORE_ID_STATUS(__core_id)     (((__u32)(__core_id)) & 0xFF)
+#define MALIDP_CORE_ID_MINOR(__core_id)      (((__u32)(__core_id) >>  4) & 0xFF)
+#define MALIDP_CORE_ID_STATUS(__core_id)     ((__u32)(__core_id) & 0xF)
 
 /* Mali-display product IDs */
 #define MALIDP_D71_PRODUCT_ID	0x0071
-- 
2.53.0



