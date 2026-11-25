Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618754;
	b=NuZ+ZqXuyLgbBAZICkf9AFRG8VT+F8AP96e2nhCTcMC5jxEqa2M7de2sQ47ZafHiQQ3K
	 xSA+VLLLVI5aJIf1UKau9UN/CSlT3TZ/wZhaNuMbvdRYmA/DO2x9+l91tVexQfBTaA3KR
	 pSdX/rshFvtHaIY8ZIDk0v2yy51MDJULSzZVEnLOG1y6tEhRArjNHDx7L1BEw8txK2MVx
	 ZWySbGOxMDISnpjqT85nyxRuH7Nesq8U57xNAi4f1k2T34uSaIx1UOLzCQorKqhJw55sL
	 phXoIlIaSYsjidReWcwDBJ4Mq/u6XawJHrQPDWvtebSsstAEaQLq+8k0GXMxUN0FHqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EOwpkPKzV1zqlSFG3DIT5c8aJg9mtaRSpUx4HXIgI/s=;
	b=VJuFXS3PlfbdOYer+SqErbPggXWVG6oSdXYBnazmPcI6HTDwBZvn0V5SjxvivLVdB3fj
	 Rw7w0+FQYtcPLuHidLUXPqQP/yD5s6WX14+LoCwfutsFbv4IZA7MVGek5cYS2C1ErJbM/
	 XHFziPSn89ci7MzLWz24lJJa0DUhogc89Ot0jXDweR7HbWqUpCLEH7ME7URYO+Ul34h2Y
	 eOnXosUz8I14wzms9UuGTAVrHzTsqmLV6mFVxhRhdJjpLH2mRaITncPhYe20l0yr4Syy4
	 zlx7SvRKvc9R2fybAQedZdWWoKGDvEcIWB7oR0jCjCdsayRDxA43tDdXXmQRavXTfeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tf9Wo+PF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FDB606A321;
	Wed, 25 Nov 2026 14:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tf9Wo+PF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94C21F000D0;
	Wed, 25 Nov 2026 14:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618754;
	bh=EOwpkPKzV1zqlSFG3DIT5c8aJg9mtaRSpUx4HXIgI/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tf9Wo+PFeNk/0J9zDYIc26Jy4/uiXIt28WFTdc5QCVrfP5OsoHqYl/PwzmRM+6558
	 ot2+RpBRwc0tWtEdGFD6PQPbDn4hlzTyOJy3GYlY9yw6RpFO22yo4KpvSIwDHPtl6N
	 WV6ml/E+rmfqqL+AE4PUEUUuHllyTJ1FiwHfsslI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Previn <alan.previn.teres.alexis@intel.com>,
	Julia Filipchuk <julia.filipchuk@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0379/1005] drm/xe/gsc: Define GSC for NVL-S
Date: Wed, 25 Nov 2026 15:28:37 +0100
Message-ID: <20261125143830.616173380@linuxfoundation.org>
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

From: Alan Previn <alan.previn.teres.alexis@intel.com>

[ Upstream commit 8a90f0d1098f9a9019f1a076bd1ee4b6c7da7dbd ]

NVL-S is identified by GSC major version 108.
The compatibility version is 0.0.

Signed-off-by: Alan Previn <alan.previn.teres.alexis@intel.com>
Reviewed-by: Julia Filipchuk <julia.filipchuk@intel.com>
Link: https://patch.msgid.link/20260923183600.1186943-5-alan.previn.teres.alexis@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Stable-dep-of: 7539edbca32d ("drm/xe/pat: Return error from xe_pat_init_early() on unknown platform")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_uc_fw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/xe/xe_uc_fw.c b/drivers/gpu/drm/xe/xe_uc_fw.c
index a8e6f18cc9b4a..f61910431cf25 100644
--- a/drivers/gpu/drm/xe/xe_uc_fw.c
+++ b/drivers/gpu/drm/xe/xe_uc_fw.c
@@ -141,6 +141,7 @@ struct fw_blobs_by_type {
 
 /* for the GSC FW we match the compatibility version and not the release one */
 #define XE_GSC_FIRMWARE_DEFS(fw_def, major_ver)		\
+	fw_def(NOVALAKE_S,	GT_TYPE_ANY,	major_ver(xe,	gsc,	nvl,	108, 0, 0))	\
 	fw_def(PANTHERLAKE,	GT_TYPE_ANY,	major_ver(xe,	gsc,	ptl,	105, 1, 0))	\
 	fw_def(LUNARLAKE,	GT_TYPE_ANY,	major_ver(xe,	gsc,	lnl,	104, 1, 0))	\
 	fw_def(METEORLAKE,	GT_TYPE_ANY,	major_ver(i915,	gsc,	mtl,	102, 1, 0))
-- 
2.53.0



