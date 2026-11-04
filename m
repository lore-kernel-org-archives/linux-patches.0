Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829673;
	b=XZtsUZy1bwWnRhxmd7D1AV2qN/cxQlgsIGHEDQj4moDwF9tAXQOFC0eKjircHq6vnkJW
	 SV6FNGnBmjEJoi/CnpgQC8D8dfV/Pct+5NRaQx67QUVZf42BsXzjHhPiYssQUXb4KcSrs
	 lfyCSs/ybxfeFWqMH7+q/Bh1RiUdBaBTkqM7LPDQCdim4Id3mTm63oRnzbqjcvaRsHw9H
	 RyCj1+CQMf7wgyryhdfUIBE6W+Ew31VwotpxvLDE4G887YhdTv2MBmz+c/j2GZULdRYxE
	 od7ucvoymqCPnhf9fuutkkp4oEU7WQqDKVYHc5PzsOK6GEKn64bLsmt9xg1++ORU2MA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829673;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yK0iwFQgUz94Dx46t8PQS3Z0AtrLzr4SOD7B2M+Om1I=;
	b=h9Bv7L5kQo2NUzPFnlTBMfqLzHATNvbh89nNeJSghdcajw+WlHQbE4Bgb5qZykzMsXuM
	 9bkARYiNdWia9hbLtsizEGlwqJ3fDZlMwgB3aBt+AM/X1BKGKEOMmW+HPFgha7+fE9zPt
	 Ho4MM8+wJNM9T9Nms/mg8KzrqGOAqNXL8I8NnrY4cp98KoJ+HSssGsGRH5CpC0G21YtnB
	 80hnvTacJSevjc1cN16UeDxZ0VvMlg+cHAcYTKull9JAdU0+so0t4I1gBaWNWwD+9aN2s
	 G20uvfiT+7LkMPpM1wgVuYR2DqeTnvTgH+MNzeJv956Lb82mp5tdOx+oUV/XIJL7F0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z+00vA9f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BFA606BA3F;
	Wed,  4 Nov 2026 22:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z+00vA9f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A941F00A02;
	Wed,  4 Nov 2026 22:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829673;
	bh=yK0iwFQgUz94Dx46t8PQS3Z0AtrLzr4SOD7B2M+Om1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z+00vA9fW4IzZ+uSakbBy2/lsegTjaQP7MeD5R7djWt9alLNq6OMzT9sDYbKZiggv
	 pUR+0PNpppXfjbynaJiLOZhh/Gsd5BVKm8JT3ZPby+R1UTWMFgJnRxoMPR9KL723Qp
	 YzvuA/L5doLKBMnfJERnxtg3dNMO32QkMZmPOQik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Matthew Stewart <Matthew.Stewart2@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0272/1005] drm/amd/display: Fix rounding errors in CalculatePrefetchSchedule
Date: Wed,  4 Nov 2026 16:00:05 -0500
Message-ID: <20261104211051.502336213@linuxfoundation.org>
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

From: Matthew Stewart <Matthew.Stewart2@amd.com>

[ Upstream commit fa0300333db07ca4ad56c9879f155faafd3f7079 ]

[why]

Rounding errors were causing mode validation to fail in some cases when
it should not. (IE. Increasing fclk from a lower value could lead to
validation failure, which should not happen.)

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Matthew Stewart <Matthew.Stewart2@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c   | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
index da865bd466c9a..c32b704627085 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
@@ -5554,7 +5554,8 @@ static bool CalculatePrefetchSchedule(struct dml2_core_internal_scratch *scratch
 				+ 2 * (p->PixelPTEBytesPerRow * p->HostVMInefficiencyFactor + p->meta_row_bytes + tdlut_row_bytes)
 				+ *p->prefetch_sw_bytes)
 				/ (*p->Tpre_rounded - *p->Tno_bw);
-			s->Tsw_est1 = *p->prefetch_sw_bytes / s->prefetch_bw1;
+			/* due to rounding, VM can clamp to +1/4, Row can clamp to +2/4, giving SW less time */
+			s->Tsw_est1 = *p->prefetch_sw_bytes / s->prefetch_bw1 - 3.0 * s->LineTime / 4.0;
 		} else
 			s->prefetch_bw1 = 0;
 
@@ -5578,7 +5579,8 @@ static bool CalculatePrefetchSchedule(struct dml2_core_internal_scratch *scratch
 		if (*p->Tpre_rounded - *p->Tno_bw - 2.0 * s->Tr0_trips_rounded > 0) {
 			s->prefetch_bw2 = (vm_bytes * p->HostVMInefficiencyFactor + *p->prefetch_sw_bytes) /
 			(*p->Tpre_rounded - *p->Tno_bw - 2.0 * s->Tr0_trips_rounded);
-			s->Tsw_est2 = *p->prefetch_sw_bytes / s->prefetch_bw2;
+			/* due to rounding, VM can clamp to +1/4  */
+			s->Tsw_est2 = *p->prefetch_sw_bytes / s->prefetch_bw2 - 1.0 * s->LineTime / 4.0;
 		} else
 			s->prefetch_bw2 = 0;
 
@@ -5592,7 +5594,8 @@ static bool CalculatePrefetchSchedule(struct dml2_core_internal_scratch *scratch
 		if (*p->Tpre_rounded - s->Tvm_trips_rounded > 0) {
 			s->prefetch_bw3 = (2 * (p->PixelPTEBytesPerRow * p->HostVMInefficiencyFactor + p->meta_row_bytes + tdlut_row_bytes) + *p->prefetch_sw_bytes) /
 				(*p->Tpre_rounded - s->Tvm_trips_rounded);
-			s->Tsw_est3 = *p->prefetch_sw_bytes / s->prefetch_bw3;
+			/* due to rounding, Row can clamp to +2/4  */
+			s->Tsw_est3 = *p->prefetch_sw_bytes / s->prefetch_bw3 - 2.0 * s->LineTime / 4.0;
 		} else
 			s->prefetch_bw3 = 0;
 
-- 
2.53.0



