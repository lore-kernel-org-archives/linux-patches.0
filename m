Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5B433B6C4;
	Sat, 30 May 2026 17:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162087; cv=none; b=DOlIJFCW/b5wiSz1WM/OZokbNOqXZmPj55628AGRlys9obQ58tTFNqe98ysQTf+LxW/c6LAZkXe2L7IlAPD+5O1BfbQCI1BeNkuoPK1x22Vv2jKLD6TY+XfkQSTou7/ZlJrZKHXY4OaSmthHWM9iXAqPPfKoob3/8uqIckCKinU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162087; c=relaxed/simple;
	bh=aO5MiF+x6vyPj1RK/OFLJMMyZL0BpWIFqVv4OFXu4Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZPX6c+oL43EJbl8a3MReXfLUefSROl/T63FO04vsYCiIYniSJYftasqMWBbX0nmEhAy20pPrxv+jTMKEBHPrhsl0WFRs2JDLhiIw1gPp9UJ6l0EEgasf7cLRafI/h9KFH8w98as4VuI/UuRRf72sibSqgTTGxfXTEmr+ahuSUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lANKh+mT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lANKh+mT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5C01F00893;
	Sat, 30 May 2026 17:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162086;
	bh=+O0b/ioNCRVRVfqquOR91zpkWWnMCdQ6YlA0ua65uEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lANKh+mTxdKeXfjsg35JGIlwfkY7Lsh0k6Xas+53speI9UCckEOJbtm0W2w2KZ+iK
	 Wi8nQtEKhOKy1aM5D5wMcuB9qNhoZD1ZoAiQnZnDlJqJCyO/fU0nFqhrA42MvkBw4u
	 6rp+zYMOPiCEyTaC1qfYsdhPqxaG2SrLJXhzFQnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DeepChirp <DeepChirp@outlook.com>,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.1 816/969] drm/i915/dp: Fix VSC dynamic range signaling for RGB formats
Date: Sat, 30 May 2026 18:05:40 +0200
Message-ID: <20260530160323.171403071@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1810,8 +1810,13 @@ static void intel_dp_compute_vsc_colorim
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
 


