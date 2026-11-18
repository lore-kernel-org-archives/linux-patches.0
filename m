Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028821;
	b=4BqVnXKVW48gv74X12+l64X90BaRCG6/WAo/WVHBEQtUrnL5albr/VHUXuGvmlL5mNej
	 da9THg4pt+pfJnPIKFpxNFpKq3AGeyLZviNDVzpwwC2pwXfQHIQza3N9H/fG4bwR1/LxE
	 gAwUJNOw1aYa691ba7k8XtggppnWOE08jyAm1ogmH5k1b+nJdRg1GcJBHY4GSEXMp2ibZ
	 307DSYP+oxBI4wRYsHj/up9Tj7F6DTjkqM5rMH62DQ/RT2x1xonddKFJV6/KekI+RuCdM
	 pKjsbSd9IzV+YAielQtzGAV/8GluycrJHSPtE9693TKO5RpBdt9NqYBDzKSrayVSKbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=62MVLqXCPHeei+o7kNYZNLZrkd3n3Vna//2JB+ewzs4=;
	b=ERBRAkHFbNb7uVmipxXk5PQGNaCImtgqxZQV2Ixyf0B2YVIMpPBVJljnpfp9XF1v29cy
	 cR3/NHsxrMfK8YBh8m42dlzghKTgx0tNZbYGdLIwtg/QBVs/05C388yZJKg+UgKC7wz8A
	 q4b5ecwHXjoFcF4YdVds1aGgiMX2NV8MI5a4v0waYjAxtG/V6mvlaDecShorPUMN+pQV2
	 T6/hJG+kxmqbNNiueao2pnVJPsjB8uto0vUSr1okGN5zD0l1SvfF8e5sJ1gaPMAphQNdU
	 UT6Z5E/k9iae8k5LwvfLWRG+Ned6mA4oAaKKDM7lPTBrrlhJjBeynumdGGUjALb8AeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RMp6yyaP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13C0606A332;
	Wed, 18 Nov 2026 19:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RMp6yyaP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9691F000CA;
	Wed, 18 Nov 2026 19:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028821;
	bh=62MVLqXCPHeei+o7kNYZNLZrkd3n3Vna//2JB+ewzs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RMp6yyaPwFuxh3zkKBs3Gp3t3sTfHvOkv8zx57de+Ri4PICXo417AmsQzI7XQz0tL
	 7oVxojKG94zGCPVhVwrnppJS2Cq6d+3DG4au1O5VFg9n5IyVZjYRqj4nrNAHZi/3fn
	 KZBEa8y2D5muFSvqF+aQAL86Nt7kx9OLCUiSDXVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raveendra Talabattula <raveendra.talabattula@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0131/1756] drm/komeda: Fix bits parsing of GLB_CORE_ID
Date: Wed, 18 Nov 2026 15:37:38 +0100
Message-ID: <20261118150013.406993436@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



