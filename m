Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831210;
	b=CRX72Ccnk/miyYM9y9haNvWRcNSNJyHxUojxHfIOfmF4g2UXzScooPdoJFlcHZ4Atiqt
	 EGuaMama+J46JdJzrDcHArYiGBwM+BBH7J1pvT70klXP6pShcX8Vq3X4fQWW/hLn7chOI
	 vZ6v8UJytm4bYgIg4Csvz/L+Cm0WEW9cMwh1r1GMPqJVY/OLl5XkyiPcxUwtSN1yGh6SX
	 WMFXDedvcw33JvAIQiCY0UZUGIoymMkhShqA++X63HLCKE2cePu+HaQFLw83zNEYOdVnL
	 AYPKkMVeLowfaMf3o6A7pW19qM29q77OO2Uwh2cX+uYld90q/Ugw7wpCTVuqIQEng5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VqvcafrYBxz9856dxFwBXUYY9h/OBz6pZ/mLk13uZHs=;
	b=WmyhvI7nGLbgCPJ858vbhljtzlBSDPU5t3LOK/7PtDgKhAz8eaGgJh8UhY3IwlY/PqPv
	 ytVkJjAn4CFCI7vjAQIt91KKuZhW974uPjuwP1QOA0fjeD6GTBd7QNc1J+ezgG2V3heE0
	 to4ZyFnyZbEfjdzUJpwWGGg5BHxft2biQo4vRS01z3BduBD7uzcRNEJuX/fgG4KVuTH9J
	 VFqbQgOCCFe1xg7Ruf4d/jBb5ac/cYKIlLwm6gZESYL5PoHwRwMFcTkl4LWk5BMm5kfJg
	 2aTuIKASEYQe8LqmFu1aCSUSE17R1IMjiFy2YZDlmfOucLn4B+Tb/X0J/qwi3zb+WYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QFqFJU2r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D30A606A870;
	Wed,  4 Nov 2026 22:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QFqFJU2r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10FF1F000C1;
	Wed,  4 Nov 2026 22:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831210;
	bh=VqvcafrYBxz9856dxFwBXUYY9h/OBz6pZ/mLk13uZHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFqFJU2rjZAk2wQNFZoS7d7yXH/QiD/+ZujcpEEL3TcDTSAiKmbEfS6zJYedc/y/g
	 yqL3CAtWo0UZP46Io7KZ3l1AjQh4MeNwWQxwIFCXTB5DWLL4c2tQHdHkc2R93k78m3
	 PYlEHsar0GJI25cB8wSX8dBmuAOiFxDPvLDy9+w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0566/1005] drm/amd/display: add const qualifiers to watermark params struct
Date: Wed,  4 Nov 2026 16:04:59 -0500
Message-ID: <20261104211059.734408662@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenjing Liu <wenjing.liu@amd.com>

[ Upstream commit dd2308c1d007d7a3416c02e542abdc6acc23966d ]

[why]
There are few non const input pointer fields. Setting them to const to
prevent future modification of read-only data.

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 93a77d353cb2 ("drm/amd/display: Remove const Qualifier From Non-Pointer Fields")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../src/dml2_core/dml2_core_shared_types.h    | 34 +++++++++----------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_shared_types.h b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_shared_types.h
index c09be5652f46f..bc64e3fd5f209 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_shared_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_shared_types.h
@@ -1718,30 +1718,30 @@ struct dml2_core_calcs_CalculateWatermarksMALLUseAndDRAMSpeedChangeSupport_param
 	double ReturnBW;
 	bool SynchronizeTimings;
 	bool SynchronizeDRRDisplaysForUCLKPStateChange;
-	unsigned int *dpte_group_bytes;
+	const unsigned int *dpte_group_bytes;
 	struct dml2_core_internal_SOCParametersList mmSOCParameters;
 	unsigned int WritebackChunkSize;
 	double SOCCLK;
 	double DCFClkDeepSleep;
-	unsigned int *DETBufferSizeY;
-	unsigned int *DETBufferSizeC;
-	unsigned int *SwathHeightY;
-	unsigned int *SwathHeightC;
-	unsigned int *SwathWidthY;
-	unsigned int *SwathWidthC;
-	unsigned int *DPPPerSurface;
-	double *BytePerPixelDETY;
-	double *BytePerPixelDETC;
-	unsigned int *DSTXAfterScaler;
-	unsigned int *DSTYAfterScaler;
+	const unsigned int *DETBufferSizeY;
+	const unsigned int *DETBufferSizeC;
+	const unsigned int *SwathHeightY;
+	const unsigned int *SwathHeightC;
+	const unsigned int *SwathWidthY;
+	const unsigned int *SwathWidthC;
+	const unsigned int *DPPPerSurface;
+	const double *BytePerPixelDETY;
+	const double *BytePerPixelDETC;
+	const unsigned int *DSTXAfterScaler;
+	const unsigned int *DSTYAfterScaler;
 	bool UnboundedRequestEnabled;
 	unsigned int CompressedBufferSizeInkByte;
 	bool max_outstanding_when_urgent_expected;
-	unsigned int max_outstanding_requests;
-	unsigned int max_request_size_bytes;
-	unsigned int *meta_row_height_l;
-	unsigned int *meta_row_height_c;
-	enum dml2_pstate_method *uclk_pstate_switch_modes;
+	const unsigned int max_outstanding_requests;
+	const unsigned int max_request_size_bytes;
+	const unsigned int *meta_row_height_l;
+	const unsigned int *meta_row_height_c;
+	const enum dml2_pstate_method *uclk_pstate_switch_modes;
 
 	// Output
 	struct dml2_core_internal_watermarks *Watermark;
-- 
2.53.0



