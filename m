Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839B881205;
	Mon, 15 Apr 2024 14:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191882; cv=none; b=swzgxWSbWSntPFtm3S/8A3mfDtxybT6nN4RfWQMmmGsjM6Rq3QU69rkNTS/KOoEKj+rlVuJszgyz1TygaiPxJ3GbRhHcJGyKcFXu9P1b1Xx6BDCcV8/pEQ3FH8o7BlW7q91tKitK/jOYNN/YDQrdDi/9nFU26Pw7FS41p1Qxe80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191882; c=relaxed/simple;
	bh=QsswlKDAJaHHMCmIewTtP6mHWc1k7lTJJ2kWft2i3JI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fiVuDOyufW4XuS7cT6AfD1uZ93/xUNetXv9g14Dqsjh8ypnUkdWGO+lv/+0sMefaDo/Bh5GSstUhg8RzhDvlzIdzAbvDR4krwqfIsBYvNT11p9r10eh7xdjtVBS+cL2+4ykLnsTg/Ss/MVt/JJjaYbzJrpBZaTZLioHMm1c/FVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXrLeC5r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXrLeC5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E5BC113CC;
	Mon, 15 Apr 2024 14:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191882;
	bh=QsswlKDAJaHHMCmIewTtP6mHWc1k7lTJJ2kWft2i3JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXrLeC5rQtx/KpPuXFgrN34WpNqZ0irjqmw9N+26pQ3QY/q+28Mbtx5G2nzMok+rq
	 bHMwrd5I7CX4jHWc3MOCsIqg1bqRdBOoiiYoflQPhbGlUw8CfYM5xT5C6HYZUlWpYW
	 fcMJ7k2eMdtBU4x6iLIzBFO3i9tE1rbJh5AiOJhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidya Srinivas <vidya.srinivas@intel.com>,
	Vandita Kulkarni <vandita.kulkarni@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.6 116/122] drm/i915: Disable port sync when bigjoiner is used
Date: Mon, 15 Apr 2024 16:21:21 +0200
Message-ID: <20240415141956.851212531@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit 0653d501409eeb9f1deb7e4c12e4d0d2c9f1cba1 upstream.

The current modeset sequence can't handle port sync and bigjoiner
at the same time. Refuse port sync when bigjoiner is needed,
at least until we fix the modeset sequence.

v2: Add a FIXME (Vandite)

Cc: stable@vger.kernel.org
Tested-by: Vidya Srinivas <vidya.srinivas@intel.com>
Reviewed-by: Vandita Kulkarni <vandita.kulkarni@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240404213441.17637-4-ville.syrjala@linux.intel.com
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
(cherry picked from commit b37e1347b991459c38c56ec2476087854a4f720b)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_ddi.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -4111,7 +4111,12 @@ static bool m_n_equal(const struct intel
 static bool crtcs_port_sync_compatible(const struct intel_crtc_state *crtc_state1,
 				       const struct intel_crtc_state *crtc_state2)
 {
+	/*
+	 * FIXME the modeset sequence is currently wrong and
+	 * can't deal with bigjoiner + port sync at the same time.
+	 */
 	return crtc_state1->hw.active && crtc_state2->hw.active &&
+		!crtc_state1->bigjoiner_pipes && !crtc_state2->bigjoiner_pipes &&
 		crtc_state1->output_types == crtc_state2->output_types &&
 		crtc_state1->output_format == crtc_state2->output_format &&
 		crtc_state1->lane_count == crtc_state2->lane_count &&


