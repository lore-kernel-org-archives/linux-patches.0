Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A428D3346BE;
	Thu, 28 May 2026 20:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000996; cv=none; b=MxUCVt1p03b59KDd3aYWOJ/MPd0O0zSmC/+aZPi2AE8EXmIr4wTvkK8S4JUOC6a/8NdxHjFq+5EVUmDZZ9ZkMa/dPCL72Emk04A/CTjVfeHzmstt2HMTvJdVBLoqb6bhYo7MvWdbdCnVqTQB5XjzyvbYOMLWkP9RN4sqJ+yT2lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000996; c=relaxed/simple;
	bh=ol7LO/S78ndhnAwoHDTS+OZHkYk32fUViWwsFRqpSlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hnGoxJ8mVtUO74BQTnTA7hDoYdQpqptUMmioj9JCAO1I01EvAK2C7ciRFCvZAGpIgfLDlk1YzKWN8NlVz9Kq4Gmeb8zPIcV2DPIo5pzCdLfdcBtRuxkRQOsp6lXHZmi6Fjk4nAJ9PqnZ9fufT1RAZUVGKccN7zbnHxbdYgaC/8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfhHoxqH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfhHoxqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4781F00A3A;
	Thu, 28 May 2026 20:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000995;
	bh=jHQ/aCxPVsFbtuxSb4jql2mDTxKHlRPPaPEQRbG12BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qfhHoxqHUMslQNClFSSjVtXtUc6wJ92IyCsDqqkS4ue9HB9ggm+TY46wHFoErnNRc
	 Mff7klBjT7npwKYYdpZiR2WORackA0krgjju6ucYYOZT62Z5N7nTZ/jcK9wenmBNql
	 LVHJQBLaYDNY8PsRokT70AP2hE8tfeUENVIP5ME8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 242/272] drm/i915/dp: Fix readback for target_rr in Adaptive Sync SDP
Date: Thu, 28 May 2026 21:50:16 +0200
Message-ID: <20260528194635.918477903@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ankit Nautiyal <ankit.k.nautiyal@intel.com>

[ Upstream commit f87abd0c6604fb6cc31cc86fc7ccc6a576924352 ]

Correct the bit-shift logic to properly readback the 10 bit target_rr from
DB3 and DB4.

v2: Align the style with readback for vtotal. (Ville)

Fixes: 12ea89291603 ("drm/i915/dp: Add Read/Write support for Adaptive Sync SDP")
Cc: Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patch.msgid.link/20260511123218.1589830-2-ankit.k.nautiyal@intel.com
(cherry picked from commit f7abc4af2b19240a145a221461dfe756cc01d74a)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 756bb0b1c83be..bb5a2a40b64c6 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -4583,7 +4583,7 @@ int intel_dp_as_sdp_unpack(struct drm_dp_as_sdp *as_sdp,
 	as_sdp->length = sdp->sdp_header.HB3 & DP_ADAPTIVE_SYNC_SDP_LENGTH;
 	as_sdp->mode = sdp->db[0] & DP_ADAPTIVE_SYNC_SDP_OPERATION_MODE;
 	as_sdp->vtotal = (sdp->db[2] << 8) | sdp->db[1];
-	as_sdp->target_rr = (u64)sdp->db[3] | ((u64)sdp->db[4] & 0x3);
+	as_sdp->target_rr = ((sdp->db[4] & 0x3) << 8) | sdp->db[3];
 	as_sdp->target_rr_divider = sdp->db[4] & 0x20 ? true : false;
 
 	return 0;
-- 
2.53.0



