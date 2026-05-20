Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6A740960B;
	Wed, 20 May 2026 18:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302657; cv=none; b=dUhDXjt+uWdIggxaxj05bmtbW1otjTo4TcOuAHpyoF/I38d1ZLvTYLrfIseKTIQGfOGuK3jcrHbTcdrpGKP0O1NIy+QBJYUmNKEg+O+MopvkDVr7/6PxqQy7abFrVI7QXKY27TpMNJkVUM+u73mrbUj6e8afgIc2y2fovN5P+Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302657; c=relaxed/simple;
	bh=jsm/0qV9UeuGJFFmtmTUYiEieCP3AdO3WOUqC2z0JuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QbNKnF999nIkdeyOzwLgpEUFGGYiKpKBsyMLlztP9eMYtYw3pS8MU+nNZizIGJdZ4eLGbt/A/pD/1CbE4WqYptTvr1Pk3tuQrf3i0DKJW3MoZl7UHHI+o73QVCEAF/HgKA1kv9TJVKPn8YvYX+9mqN9lE2dGT7/J1GH38+Qm2vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2LeWwCJr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2LeWwCJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1977B1F000E9;
	Wed, 20 May 2026 18:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302656;
	bh=3qUJOrxLiWgfdCQqndk8ZqfVpzj7rlb2MX4naKVXGGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2LeWwCJrjUqM/nYNkoBTDyLQAJbwG2dPrudGsgb+rGoWaK9JIxGHPzoA7efrTKIgt
	 OxLJXPga7fAsaWqdmpYtdyypxVb6MwwCefuF24XSGZkkM6hBka0aWzGcTnj2GwjBoM
	 x81wfNHsz3QZErbEMxUfaWyJEEzUqJeKx0F/Agno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Vinod Govindapillai <vinod.govindapillai@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 299/508] drm/i915/wm: Verify the correct plane DDB entry
Date: Wed, 20 May 2026 18:22:02 +0200
Message-ID: <20260520162105.121597380@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9653ed8726935..3b30776b73b21 100644
--- a/drivers/gpu/drm/i915/display/skl_watermark.c
+++ b/drivers/gpu/drm/i915/display/skl_watermark.c
@@ -3239,8 +3239,8 @@ void intel_wm_state_verify(struct intel_atomic_state *state,
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



