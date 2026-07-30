Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EE61FE44A;
	Thu, 30 Jul 2026 14:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422791; cv=none; b=lblPCiEGVVbze+T5Hf2TlKkULlNrM7db9TDMglW7Aa6ExOFKZ2t1x6xTO2EUyyd2ljhAWgWe4XODZGFvN0Wbpc1CtNv983s2I0g4vMPk5cDQ9OC+KkqbcJLkeMP4u2yJlSRji8eHuwFvaFCFgxReMNDPhIJCJbCVBFrqJZ4SjU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422791; c=relaxed/simple;
	bh=neX0IExWHmZEIcA94AkkiT44fZpAJzq45LWyeWm5myE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owNzYQvFgmBVkQUwalWHpxoqb86rVmb7xEl38BD7+kFwD8lOcARkxHkbeXTZeIneHEuU6IzkHKrD6e5+3PitH4Rl4E1QvtpxbL9YSlwM++jcyUB2pbrnTPhxDLWXs7oFRU6Mbo+zjSbEZPH91gq5o7cDnKK8Rl7Ol7I69IHtCEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p38gFah+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p38gFah+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C77E1F000E9;
	Thu, 30 Jul 2026 14:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422789;
	bh=Ed2zKzylUQyN+QDuV9oCkIC3BCGWsTSO5bpOFUzAVus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p38gFah+aVXiAqMp24AZoF+f+30o2se9yX72rGrSnowFDwXG+hdhXRo0aK3VVOEvB
	 Zsmqdtn/31085fVSqg0PAtaYUbWTy+PzrfwFpiknHCuA3OiWrtLyP4F6ao3aVrGaUT
	 ly1hDkp1pKTjkj9f31DtgrFBSd/8H+feVhrg9AqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 513/744] media: rzg2l-cru: Skip ICnMC configuration when ICnSVC is used
Date: Thu, 30 Jul 2026 16:13:06 +0200
Message-ID: <20260730141455.182679750@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>

commit cd4ce68875f406b0cf3f5a94c0fd22989689222f upstream.

When the CRU is configured to use ICnSVC for virtual channel mapping,
as on the RZ/{G3E, V2H/P} SoC, the ICnMC register must not be
programmed.

Return early after setting up ICnSVC to avoid overriding the ICnMC
register, which is not applicable in this mode.

This prevents unintended register programming when ICnSVC is enabled.

Cc: stable@vger.kernel.org
Fixes: 3c5ca0a48bb0 ("media: rzg2l-cru: Drop function pointer to configure CSI")
Signed-off-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
[Rework to not break image format programming]
Signed-off-by: Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/renesas/rzg2l-cru/rzg2l-cru-regs.h |    1 
 drivers/media/platform/renesas/rzg2l-cru/rzg2l-video.c    |   17 +++++++++-----
 2 files changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/media/platform/renesas/rzg2l-cru/rzg2l-cru-regs.h
+++ b/drivers/media/platform/renesas/rzg2l-cru/rzg2l-cru-regs.h
@@ -60,6 +60,7 @@
 #define ICnMC_CSCTHR			BIT(5)
 #define ICnMC_INF(x)			((x) << 16)
 #define ICnMC_VCSEL(x)			((x) << 22)
+#define ICnMC_VCSEL_MASK		GENMASK(23, 22)
 #define ICnMC_INF_MASK			GENMASK(21, 16)
 
 #define ICnMS_IA			BIT(2)
--- a/drivers/media/platform/renesas/rzg2l-cru/rzg2l-video.c
+++ b/drivers/media/platform/renesas/rzg2l-cru/rzg2l-video.c
@@ -262,19 +262,24 @@ static void rzg2l_cru_csi2_setup(struct
 				 u8 csi_vc)
 {
 	const struct rzg2l_cru_info *info = cru->info;
-	u32 icnmc = ICnMC_INF(ip_fmt->datatype);
+	u32 icnmc = rzg2l_cru_read(cru, info->image_conv) & ~(ICnMC_INF_MASK |
+							      ICnMC_VCSEL_MASK);
+	icnmc |= ICnMC_INF(ip_fmt->datatype);
 
+	/*
+	 * VC filtering goes through SVC register on G3E/V2H.
+	 *
+	 * FIXME: virtual channel filtering is likely broken and only VC=0
+	 * works.
+	 */
 	if (cru->info->regs[ICnSVC]) {
 		rzg2l_cru_write(cru, ICnSVCNUM, csi_vc);
 		rzg2l_cru_write(cru, ICnSVC, ICnSVC_SVC0(0) | ICnSVC_SVC1(1) |
 				ICnSVC_SVC2(2) | ICnSVC_SVC3(3));
+	} else {
+		icnmc |= ICnMC_VCSEL(csi_vc);
 	}
 
-	icnmc |= rzg2l_cru_read(cru, info->image_conv) & ~ICnMC_INF_MASK;
-
-	/* Set virtual channel CSI2 */
-	icnmc |= ICnMC_VCSEL(csi_vc);
-
 	rzg2l_cru_write(cru, info->image_conv, icnmc);
 }
 


