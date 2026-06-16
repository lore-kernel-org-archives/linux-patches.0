Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A59243DA2C;
	Tue, 16 Jun 2026 15:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623514; cv=none; b=IJk9iXliZDC2X98tkD6guPkJfZRxJ+oeKvK3jO3i5zlk5Ub3FZoYVJJzFTwz7Pc4+WGn82+6LAEZ8bnSC/KQCUT3fk9W7E/KAwZjK3IaWRmuViDwWhtrlohsszORP0UvkrpUZkH9dJDF9k5Yt6lcSzovXq9BmTI8v9hORBL+wqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623514; c=relaxed/simple;
	bh=G1gw/Pj+os1Yt6Ygn4NHgsKUkjNezIAjSxW2Z03Gxbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGV15NLVYv9YDvJB3EYahC077438xb2sWDTshwqyAVfxkm/DV6O2k3uBsoexDYWlgwhJmAaSl5nua3yWYLsf+cBYm4odA3nbQFiIU29c6S9s65UX+gO54k/Qchks0JhW7QKFW4Q2Ys78pIhbhptEjf9+qtppdRWd5+cCdSB4gpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q4r5aGaS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4r5aGaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3D01F00A3D;
	Tue, 16 Jun 2026 15:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623513;
	bh=uJ6+4zjjM2b8E3omX2qZ6tBk+kl7wVXdObZEFARKugs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q4r5aGaSZ8lTmzKOo64+w0oRdCv8PqzTC/Ue3KJb0K9/WrDwGgZtEGftfmWeE6UJC
	 o6q61g0/4HAsLud+W3O0Dlx2NdNgovHZMzYeKHupjx76By3QUJSq8iqS4OC6TOh9h2
	 j7WdjA1EwDQVxa96aIKW4sFHknIBWl39MdVcjCN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Alex Hung <alex.hung@amd.com>,
	Melissa Wen <mwen@igalia.com>,
	Melissa Wen <melissa.srw@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 162/378] drm/colorop: make lut(1/3)d_interpolation props correctly behave as mutable
Date: Tue, 16 Jun 2026 20:26:33 +0530
Message-ID: <20260616145118.786537939@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melissa Wen <mwen@igalia.com>

[ Upstream commit 94ff735296d371045fce163451a3d65e44ac4729 ]

As interpolation props are actually mutable props, any changes should be
handled by drm_colorop_state. Move their enum and make it correctly
behaves as mutable.

Fixes: 7fa3ee8c0a79 ("drm/colorop: Define LUT_1D interpolation")
Fixes: db971856bbe0 ("drm/colorop: Add 3D LUT support to color pipeline")
Reviewed-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Fixes: 9ba25915efba ("drm/amd/display: Add support for sRGB EOTF in DEGAM block")
Signed-off-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Melissa Wen <melissa.srw@gmail.com>
Link: https://patch.msgid.link/20260609110420.1298352-3-mwen@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_atomic.c      |  4 ++--
 drivers/gpu/drm/drm_atomic_uapi.c |  8 ++++----
 drivers/gpu/drm/drm_colorop.c     | 16 ++++++++++++++--
 include/drm/drm_colorop.h         | 28 ++++++++++++++--------------
 4 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
index ec7534227f66d4..b31bb3f9b11aae 100644
--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -829,7 +829,7 @@ static void drm_atomic_colorop_print_state(struct drm_printer *p,
 	case DRM_COLOROP_1D_LUT:
 		drm_printf(p, "\tsize=%d\n", colorop->size);
 		drm_printf(p, "\tinterpolation=%s\n",
-			   drm_get_colorop_lut1d_interpolation_name(colorop->lut1d_interpolation));
+			   drm_get_colorop_lut1d_interpolation_name(state->lut1d_interpolation));
 		drm_printf(p, "\tdata blob id=%d\n", state->data ? state->data->base.id : 0);
 		break;
 	case DRM_COLOROP_CTM_3X4:
@@ -841,7 +841,7 @@ static void drm_atomic_colorop_print_state(struct drm_printer *p,
 	case DRM_COLOROP_3D_LUT:
 		drm_printf(p, "\tsize=%d\n", colorop->size);
 		drm_printf(p, "\tinterpolation=%s\n",
-			   drm_get_colorop_lut3d_interpolation_name(colorop->lut3d_interpolation));
+			   drm_get_colorop_lut3d_interpolation_name(state->lut3d_interpolation));
 		drm_printf(p, "\tdata blob id=%d\n", state->data ? state->data->base.id : 0);
 		break;
 	default:
diff --git a/drivers/gpu/drm/drm_atomic_uapi.c b/drivers/gpu/drm/drm_atomic_uapi.c
index 87de41fb445931..aefcf58e4f0399 100644
--- a/drivers/gpu/drm/drm_atomic_uapi.c
+++ b/drivers/gpu/drm/drm_atomic_uapi.c
@@ -747,13 +747,13 @@ static int drm_atomic_colorop_set_property(struct drm_colorop *colorop,
 	if (property == colorop->bypass_property) {
 		state->bypass = val;
 	} else if (property == colorop->lut1d_interpolation_property) {
-		colorop->lut1d_interpolation = val;
+		state->lut1d_interpolation = val;
 	} else if (property == colorop->curve_1d_type_property) {
 		state->curve_1d_type = val;
 	} else if (property == colorop->multiplier_property) {
 		state->multiplier = val;
 	} else if (property == colorop->lut3d_interpolation_property) {
-		colorop->lut3d_interpolation = val;
+		state->lut3d_interpolation = val;
 	} else if (property == colorop->data_property) {
 		return drm_atomic_color_set_data_property(colorop, state,
 							  property, val);
@@ -778,7 +778,7 @@ drm_atomic_colorop_get_property(struct drm_colorop *colorop,
 	else if (property == colorop->bypass_property)
 		*val = state->bypass;
 	else if (property == colorop->lut1d_interpolation_property)
-		*val = colorop->lut1d_interpolation;
+		*val = state->lut1d_interpolation;
 	else if (property == colorop->curve_1d_type_property)
 		*val = state->curve_1d_type;
 	else if (property == colorop->multiplier_property)
@@ -786,7 +786,7 @@ drm_atomic_colorop_get_property(struct drm_colorop *colorop,
 	else if (property == colorop->size_property)
 		*val = colorop->size;
 	else if (property == colorop->lut3d_interpolation_property)
-		*val = colorop->lut3d_interpolation;
+		*val = state->lut3d_interpolation;
 	else if (property == colorop->data_property)
 		*val = (state->data) ? state->data->base.id : 0;
 	else
diff --git a/drivers/gpu/drm/drm_colorop.c b/drivers/gpu/drm/drm_colorop.c
index 27139862b12086..6751add3cba96c 100644
--- a/drivers/gpu/drm/drm_colorop.c
+++ b/drivers/gpu/drm/drm_colorop.c
@@ -321,7 +321,6 @@ int drm_plane_colorop_curve_1d_lut_init(struct drm_device *dev, struct drm_color
 
 	colorop->lut1d_interpolation_property = prop;
 	drm_object_attach_property(&colorop->base, prop, interpolation);
-	colorop->lut1d_interpolation = interpolation;
 
 	/* data */
 	ret = drm_colorop_create_data_prop(dev, colorop);
@@ -417,7 +416,6 @@ int drm_plane_colorop_3dlut_init(struct drm_device *dev, struct drm_colorop *col
 
 	colorop->lut3d_interpolation_property = prop;
 	drm_object_attach_property(&colorop->base, prop, interpolation);
-	colorop->lut3d_interpolation = interpolation;
 
 	/* data */
 	ret = drm_colorop_create_data_prop(dev, colorop);
@@ -496,6 +494,20 @@ static void __drm_colorop_state_reset(struct drm_colorop_state *colorop_state,
 						      &val);
 		colorop_state->curve_1d_type = val;
 	}
+
+	if (colorop->lut1d_interpolation_property) {
+		if (!drm_object_property_get_default_value(&colorop->base,
+							   colorop->lut1d_interpolation_property,
+							   &val))
+			colorop_state->lut1d_interpolation = val;
+	}
+
+	if (colorop->lut3d_interpolation_property) {
+		if (!drm_object_property_get_default_value(&colorop->base,
+							   colorop->lut3d_interpolation_property,
+							   &val))
+			colorop_state->lut3d_interpolation = val;
+	}
 }
 
 /**
diff --git a/include/drm/drm_colorop.h b/include/drm/drm_colorop.h
index 5bcb510e56c0a7..272ebff2de72e2 100644
--- a/include/drm/drm_colorop.h
+++ b/include/drm/drm_colorop.h
@@ -183,6 +183,20 @@ struct drm_colorop_state {
 	 */
 	struct drm_property_blob *data;
 
+	/**
+	 * @lut1d_interpolation:
+	 *
+	 * Interpolation for DRM_COLOROP_1D_LUT
+	 */
+	enum drm_colorop_lut1d_interpolation_type lut1d_interpolation;
+
+	/**
+	 * @lut3d_interpolation:
+	 *
+	 * Interpolation for DRM_COLOROP_3D_LUT
+	 */
+	enum drm_colorop_lut3d_interpolation_type lut3d_interpolation;
+
 	/** @state: backpointer to global drm_atomic_state */
 	struct drm_atomic_state *state;
 };
@@ -293,20 +307,6 @@ struct drm_colorop {
 	 */
 	uint32_t size;
 
-	/**
-	 * @lut1d_interpolation:
-	 *
-	 * Interpolation for DRM_COLOROP_1D_LUT
-	 */
-	enum drm_colorop_lut1d_interpolation_type lut1d_interpolation;
-
-	/**
-	 * @lut3d_interpolation:
-	 *
-	 * Interpolation for DRM_COLOROP_3D_LUT
-	 */
-	enum drm_colorop_lut3d_interpolation_type lut3d_interpolation;
-
 	/**
 	 * @lut1d_interpolation_property:
 	 *
-- 
2.53.0



