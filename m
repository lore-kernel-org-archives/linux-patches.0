Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618804;
	b=DjxGvLzaEK84hPepPR56EKQy8VmvSIvNCVZxxb2yxe8tMEM4bYC2X3bPrVDivh9gYh9Y
	 ygfCiL+yfywvh98M7IEoiOYQoNszQPCPV2T9wirppIrDAhEVh+i7Q+s9IjcZbl20/3Eaw
	 uSHyTDpyJnrw1ZgTyjcvhz0uy3s044IcPTlcsllMPmjVjOYnaDjAJtlqHRiYeETErwUXa
	 IAxomBnsIKCa/fIe4l/qrZH4JAnTs5JpgiHwvHEsr7u0ZmGDsrrCTnFIiR8PTv47ffRzY
	 xD2epHaMJLnHzQ8n8ajtiAMazzNe0YQznnq2T4FfFmBUFoXKo0mCXNL/XlvSPymJGog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618804;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ly7sHevPuVdVZfxrOKdVfvoiXk6OdNaI9fBhGcaRtZs=;
	b=UiLcaPTGUkU0V58wnlzabQXa81Ry7oSbX+8ICk8rHD1X48it3qdQHMqWAcQ5O/+nf+oD
	 L6iy7R5uNlLIwJTXcpErJJ/D3fhFF9LkovpWby4VzzzK3igxehs5M3RqWYV+aLp1E6Hni
	 yXVHyTxavV210KNn8McQdNT1ayUQRtIrzeb+6CPDmotJLl/Z33DL8U+Nk8gST4VHbidHM
	 Wu9A+OUiBR/duJ6UQPS5i8BoUqN5YNdfVJmBY1ZdJVeXOHO+XG1iOgTt49nB7BKxwkpBV
	 mKx8Ndsq30NVc08zEU6RpoBW7VkEp1yo4E7K2IMWDP9GrFlHz5xXzzGUALd3gKRKqzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cl2pMdm7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4552606A323;
	Wed, 25 Nov 2026 15:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cl2pMdm7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449861F000D3;
	Wed, 25 Nov 2026 15:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618803;
	bh=ly7sHevPuVdVZfxrOKdVfvoiXk6OdNaI9fBhGcaRtZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cl2pMdm72OyltqkcecmI2AZBa/9mz/zS5d4wuG0mvXJZGDC9dnLZZG5lUKAIbS9Ki
	 iY6A8A1A2VisV9mmYeAGF6W6mKzCwWgLEBHLnuP10FUHPZTSrhZO6K1nRvlEEQ6wXL
	 w5W4PI+5Bg5r/ynLMdqO9z8WNOHGMaoARPzHxr7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Alan Previn <alan.previn.teres.alexis@intel.com>,
	Julia Filipchuk <julia.filipchuk@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0393/1005] drm/xe/gsc: Fix NVL-S GSC compatibility number
Date: Wed, 25 Nov 2026 15:28:51 +0100
Message-ID: <20261125143830.949157989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

[ Upstream commit f8795bced27bb00d74cef9de33e8a5e939c05e02 ]

The compatibility number for the published GSC number is 1.0. The binary
is correctly named nvl_gsc_1.bin (matching the major compatibility
version number), but the driver is instead looking for compatibility 0.0
(which maps to nvl_gsc_0.bin), leading to the binary not being found.

The driver supports running without GSC so this is not fatal, but all
content protection features will not work without the GSC FW.

Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Fixes: 8a90f0d1098f ("drm/xe/gsc: Define GSC for NVL-S")
Cc: Alan Previn <alan.previn.teres.alexis@intel.com>
Cc: Julia Filipchuk <julia.filipchuk@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: Alan Previn <alan.previn.teres.alexis@intel.com>
Link: https://patch.msgid.link/20261015204548.147348-1-daniele.ceraolospurio@intel.com
(cherry picked from commit 11f8678d6a702ab9d6abb2f50c45e82a56974068)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_uc_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_uc_fw.c b/drivers/gpu/drm/xe/xe_uc_fw.c
index f61910431cf25..78b8f104e5772 100644
--- a/drivers/gpu/drm/xe/xe_uc_fw.c
+++ b/drivers/gpu/drm/xe/xe_uc_fw.c
@@ -141,7 +141,7 @@ struct fw_blobs_by_type {
 
 /* for the GSC FW we match the compatibility version and not the release one */
 #define XE_GSC_FIRMWARE_DEFS(fw_def, major_ver)		\
-	fw_def(NOVALAKE_S,	GT_TYPE_ANY,	major_ver(xe,	gsc,	nvl,	108, 0, 0))	\
+	fw_def(NOVALAKE_S,	GT_TYPE_ANY,	major_ver(xe,	gsc,	nvl,	108, 1, 0))	\
 	fw_def(PANTHERLAKE,	GT_TYPE_ANY,	major_ver(xe,	gsc,	ptl,	105, 1, 0))	\
 	fw_def(LUNARLAKE,	GT_TYPE_ANY,	major_ver(xe,	gsc,	lnl,	104, 1, 0))	\
 	fw_def(METEORLAKE,	GT_TYPE_ANY,	major_ver(i915,	gsc,	mtl,	102, 1, 0))
-- 
2.53.0



