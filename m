Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F12335566;
	Thu, 28 May 2026 20:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999027; cv=none; b=aqkUcIW6QlU00/U/Smaw34/itax6gToeDkeTzhQVx/yBmSnwhx52WKh4MfT2zGySUJROWoLD4te1achrtT8sayD6QNCyglHiubwmhjdN6iz7v/Ks8u/ZyAWcbRjXpAx2jely+T9pl0jbc3I8NPyUFhbZJONTsuGG/I3clZKrKrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999027; c=relaxed/simple;
	bh=GJaO0TUPivO1uNfre57z1y83zy8Gk6UrdTwSPC0bDEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h/RRK20VIKHCO5Gb1YL7jQdGLZLQnDRrmTwKllUn940zXD8Ca0tAyfJpQH/0EnmAkoiaq6mRwVS2ImNXlUPsX0tjhPgHnjMPdymQdhTJhl8OAA5qfAtiVrtzj67ccobienUd+2jyVjPUm8LJXBpcVjpovUuGidsTOCq0cni+32s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kkg3CM4F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kkg3CM4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF12B1F000E9;
	Thu, 28 May 2026 20:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999026;
	bh=wxgjqmSK4EGbqrQrsq/MzboJs0TXDr6TtDg/euMooBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kkg3CM4FWQTW2aydg+U+uh9lpO+fjvFgPTiZ4Ab/2aD2G+96PlCqXc0PvS1YBU+VQ
	 TZQBgk6T6NCzyvzeKW3SB2pB9IaWKXIvIeixvKWSPSLsjlObFEvMocECUaVBP0Jzf8
	 wvw33LoERxwF8dKYz+OyCAAa2xhNVko2QHQ45NfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 381/461] drm/i915/dp: Fix readback for target_rr in Adaptive Sync SDP
Date: Thu, 28 May 2026 21:48:30 +0200
Message-ID: <20260528194658.483273169@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 2906dc6e630ec..d52205d714eee 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -5067,7 +5067,7 @@ int intel_dp_as_sdp_unpack(struct drm_dp_as_sdp *as_sdp,
 	as_sdp->length = sdp->sdp_header.HB3 & DP_ADAPTIVE_SYNC_SDP_LENGTH;
 	as_sdp->mode = sdp->db[0] & DP_ADAPTIVE_SYNC_SDP_OPERATION_MODE;
 	as_sdp->vtotal = (sdp->db[2] << 8) | sdp->db[1];
-	as_sdp->target_rr = (u64)sdp->db[3] | ((u64)sdp->db[4] & 0x3);
+	as_sdp->target_rr = ((sdp->db[4] & 0x3) << 8) | sdp->db[3];
 	as_sdp->target_rr_divider = sdp->db[4] & 0x20 ? true : false;
 
 	return 0;
-- 
2.53.0



