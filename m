Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F0739A7FE;
	Sat, 30 May 2026 18:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164875; cv=none; b=O5IJ8PaB+VqWER+jtUShvv7nBsGUmICxkXQsRIsuF4IlfWsEn41LllmqC5FwALYdLXQixTSkLdHOfUPsCc+ISLhjg2J5c4NslrKsgEk7VDsT/byLSV7W8MpPohSL1pn7M9knaDd/srarzf6ciRa0ga17T3DwTt6vHtplb0gqdfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164875; c=relaxed/simple;
	bh=NrDPHBLhhnATMa9i7/ya7YPwp0irFZGtgsVgBjidekQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iiznYaCdLzOtMkwlxjFRXHjVJPqunKOpqznMYiva48MEPDUo0AdUEiJniD8x3aFGflHlEq7pTXrdQnDXdBJmhFn3N4k13cXoKyPKqpyl043Oihzr0OLTWifV5lfCG2sELsd7HG6O3wJoo5Bnh/K9e/msyLm+e1P+M6LqP0skbbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGTQ4uVE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGTQ4uVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98FD1F00893;
	Sat, 30 May 2026 18:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164874;
	bh=OLg/12j21sdTCxb88/P3AqB82SBDe0diaKiCwARerhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QGTQ4uVEGR0ZmX17DR8wYyu4bF8SrlmR/OwUtDW1jBuGOZTMckbg+d2tICO9jB1dq
	 /dR6FFUQVDcR4bLwioUpwJo2ay+nTlbtja1r+qwRwZJv5HLWlUgEEgIYKZ/EvtP6Z1
	 ve0Oj+reN3jGzjyFksIAM/+IkYAzUqwRtRN9yiiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DeepChirp <DeepChirp@outlook.com>,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 5.15 655/776] drm/i915/dp: Fix VSC dynamic range signaling for RGB formats
Date: Sat, 30 May 2026 18:06:09 +0200
Message-ID: <20260530160256.839620773@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>

commit 1ae15b6c7965d137eef21f2cc7d367b29cb88369 upstream.

For RGB, set dynamic_range to CTA or VESA based on
crtc_state->limited_color_range so sinks apply correct
quantization. YCbCr remains limited (CTA) range.
(DP v1.4, Table 5-1)

v2:
- Added Reported-by and Tested-by tags

v3:
- Add back YCbCr comment(Suraj)

Cc: stable@vger.kernel.org #v5.8+
Reported-by: DeepChirp <DeepChirp@outlook.com>
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/work_items/15874
Tested-by: DeepChirp <DeepChirp@outlook.com>
Fixes: 9799c4c3b76e ("drm/i915/dp: Add compute routine for DP VSC SDP")
Assisted-by: GitHub-Copilot:GPT-5.4
Signed-off-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20260505090920.2479112-1-chaitanya.kumar.borah@intel.com
(cherry picked from commit 38e10ddae6f8d42a2e8437fcd25a1cac51106c64)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -1540,8 +1540,13 @@ static void intel_dp_compute_vsc_colorim
 	drm_WARN_ON(&dev_priv->drm,
 		    vsc->bpc == 6 && vsc->pixelformat != DP_PIXELFORMAT_RGB);
 
-	/* all YCbCr are always limited range */
-	vsc->dynamic_range = DP_DYNAMIC_RANGE_CTA;
+	/* All YCbCr formats are always limited range. */
+	if (vsc->pixelformat == DP_PIXELFORMAT_RGB)
+		vsc->dynamic_range = crtc_state->limited_color_range ?
+			DP_DYNAMIC_RANGE_CTA : DP_DYNAMIC_RANGE_VESA;
+	else
+		vsc->dynamic_range = DP_DYNAMIC_RANGE_CTA;
+
 	vsc->content_type = DP_CONTENT_TYPE_NOT_DEFINED;
 }
 


