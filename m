Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C34D3CCFB0;
	Wed, 20 May 2026 18:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301105; cv=none; b=FwY7iaAq6xnZ/lQKCkTVlX5ZmgEJHnGsIPRaZrHeT4jI2uJZiz2ipcynsTcQpvQxhlwTdy8S7XvH3yhWTZFaFZ/BKYCbOAJdPOUJr0z/CZ9E4Kd18nDI2x15DwcOTNNBzrdBRUJEJr35LRnJX6eRpoSw7hEM49griVYYWo5WOWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301105; c=relaxed/simple;
	bh=/hBuqdIJFE4hd0MRIdcldDa6TkCXJBNRmKtcmFZ/3ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LvLc/PDB9LksAYUPRBtEG9grDXh8gr+VN8uj4D9xpdln9sxWxU9sJA6X/waPbSTf/P//FnHNCYH1B8EByEFK3zcckL9fHsShHI8G0q3Rf+c6fjibCbluLgbXCTR49C1DlWuMcRPGDdanZRS9a860Pws7Kmn6kB9DL4LahH+lk1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bBz1cTTj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bBz1cTTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A721F000E9;
	Wed, 20 May 2026 18:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301104;
	bh=Kr46I+UtZMQymxd7yhLclKm9qZPQ4LU1VLyJ4bvze8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bBz1cTTjSJuTLASawmjX125sVyCNSo7Yx818oZxpBoEjCZFwRJEJjx1X2QTdDQ3ZB
	 zhDt5Jw/igQ7dHLmXljXwIEuZldaGVszBilZmxA0bwTXI6uPR5Rvza7t0Un6CadUD4
	 RTmJhvZqmwrWanpbAUJyiYG9fQZUNvt6J6b6l+j8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Vinod Govindapillai <vinod.govindapillai@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 426/666] drm/i915/wm: Verify the correct plane DDB entry
Date: Wed, 20 May 2026 18:20:37 +0200
Message-ID: <20260520162120.502872961@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit a97c88a176b6b8d116f4d3f508f3bd02bc77b462 ]

Actually verify the DDB entry for the plane we're looking
at instead of always verifying the cursor DDB.

Fixes: 7d4561722c3b ("drm/i915: Tweak plane ddb allocation tracking")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patch.msgid.link/20260324134843.2364-5-ville.syrjala@linux.intel.com
Reviewed-by: Vinod Govindapillai <vinod.govindapillai@intel.com>
(cherry picked from commit f002f7c7439de18117a31ca84dc87a59719c3dd6)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/skl_watermark.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/skl_watermark.c b/drivers/gpu/drm/i915/display/skl_watermark.c
index 2b05db764a3a9..0c868be53f2f9 100644
--- a/drivers/gpu/drm/i915/display/skl_watermark.c
+++ b/drivers/gpu/drm/i915/display/skl_watermark.c
@@ -3718,8 +3718,8 @@ void intel_wm_state_verify(struct intel_atomic_state *state,
 		}
 
 		/* DDB */
-		hw_ddb_entry = &hw->ddb[PLANE_CURSOR];
-		sw_ddb_entry = &new_crtc_state->wm.skl.plane_ddb[PLANE_CURSOR];
+		hw_ddb_entry = &hw->ddb[plane->id];
+		sw_ddb_entry = &new_crtc_state->wm.skl.plane_ddb[plane->id];
 
 		if (!skl_ddb_entry_equal(hw_ddb_entry, sw_ddb_entry)) {
 			drm_err(&i915->drm,
-- 
2.53.0



