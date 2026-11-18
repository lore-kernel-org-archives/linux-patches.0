Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015105;
	b=DUt4RylHu/3HBdGwnZ5eBZBow+Ns8aD2Px05pw3nzVn/46YDbZq0M99t30cCnrdQLDSm
	 hkftEVP+XrUA7QEwHhXA89Oc2P890WwZWm4SmPFk1zVexNUCJyt9ZDttk3/W/WQe0HxTo
	 POxKfComH5OjkvfqLBsMs67uJE1JO0er2m3TMbMlqftCyDmpw23PwIRwwi/ZJ1qGS3/CM
	 1hSCYMxCQVmC5ub9WlkybVw9PT0R0ogS3TBL+lc96cSvRwn/5TKP2JcqBWfERRpiClQ8y
	 30323Yb3YuuYLCsCS82F9Sc71DKH5apQSIDxxcb16ETUx4GnN4jCcWE18g7IxPe51tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FwKRr1xitwnURM8oArG00wL5ffGCxTW5QlWUygyshQA=;
	b=kVhCNJYuHi0tX73nnMBRFdIkCtDtPzp4mcvK1O1P0fbtNge7zikyso+e22DpAKaCyOX3
	 JBHXoSBItzvxUmeXMDVBGnmo2JRfcTh6ge2ZDNFmfON64TlRjD3VDvBkxiPAUqud86y9E
	 T1SM4zA+OG0QWRVTz8q8RFs7OwTmZYdToLBp3bGwtDEQCndSeHHiPUKkwwyIeMbbnwbHr
	 nOXTqyCR0eaRPRFfXA9ncrwdBI8YxT1uvLBSVFskH/B2k5/+MNP+VIqWBUcQtTcgZ+Gui
	 ChkvIxmtXbe8+zej1sHi7UXSYqNc6alp895dzUTtkMPzhigfWxgC61r2EyP3OGSJ/rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ar6XZCSa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B0D606A32C;
	Wed, 18 Nov 2026 15:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ar6XZCSa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125571F000D0;
	Wed, 18 Nov 2026 15:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015104;
	bh=FwKRr1xitwnURM8oArG00wL5ffGCxTW5QlWUygyshQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ar6XZCSa89yQPh3B3cVMViUVVrSi0WQCouSTSAiShDwXHnKnrbr9wO5HHNv68OKh3
	 YCkw+Ml4xTKY0b+2GdPuIcJIONDWySvK6oHk6PrqYOPGpw878m8UfRb1M3XZWm7NNW
	 dNLLgYeRPqR+QdzWp+5ozLbrz6urhJE8xIndKWM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raveendra Talabattula <raveendra.talabattula@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0054/2651] drm/komeda: Fix bits parsing of GLB_CORE_ID
Date: Wed, 18 Nov 2026 15:21:34 +0100
Message-ID: <20261118150249.898289595@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 6f954bcdf40ea..f9a3ee7ba4b75 100644
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



