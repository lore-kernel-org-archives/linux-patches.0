Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A3A401490;
	Wed, 20 May 2026 18:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302969; cv=none; b=i3UsY0J97281d2rlnc8Fo9xlpc92WFjgjLSUjJkf0n5CyEYJ2Is4FbhlDk4/AH6j6V/diwsKfTNdMws1KqeRBg4+C8X3Dqe3b4majtI8tOoudiC+x0XKY33XEGpBnZpgby/11cHTprWzt9uXc/Cw7aonVc/fQWYA/xsPziAV+ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302969; c=relaxed/simple;
	bh=vuNmtZO6AVtkmQa07437UDms1lepKDE0kyrEs0X33s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mj6uOU4rXP58TrCEw3pFKnf1i37eyFRMipmoFCF5jwYi35/iTC0KpSgnJA5rJ3/gjLQRkQQD8+KUHFaPDZ2dO0Z8ELy7fqfkCQjZv1F2W4Fy0tKfyuVfCXMsKPdmuVNEqVSD+fuAcVikxmLFFDf4Vol21YpH0TBdhIY1wUVR0zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ufMt6Kjw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ufMt6Kjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677711F00894;
	Wed, 20 May 2026 18:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302966;
	bh=4a2AooJgODMT2QL75AYmzqt7DfjPaQqh2bxU9GJ9euU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ufMt6Kjwv/TiP7YxouuarKSyDRC9mSjTneutugCNo5BZpEYgJkj37FuYpboPbuOAH
	 TYFtQerhn6v9MKw1vNSFRaZWJJjsp2yESmSoqrcJx+Zs0vQtjlnzUIdvaS7vP4NB8P
	 zDnD2UsBQcspXmqec1gmqbbFpucsS54wd8+2weQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DeepChirp <DeepChirp@outlook.com>,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.6 467/508] drm/i915/dp: Fix VSC dynamic range signaling for RGB formats
Date: Wed, 20 May 2026 18:24:50 +0200
Message-ID: <20260520162108.716377693@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2029,8 +2029,13 @@ static void intel_dp_compute_vsc_colorim
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
 


