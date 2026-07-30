Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BF7432E6E;
	Thu, 30 Jul 2026 14:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422424; cv=none; b=iAq5hSQBuFvwHEI5JHLySzOpVaQ/KZpHiPqg7tdHogomgrbArBSQfHtjW4TlYFrV+dgIfzTXf+XWVqbkNbewCJyp+P6pMPqAskSlxudGyAtAaLfM9jfM2AEa4Ut8LLOZ5rEuJ6n9xv8fJuPpDGUm2BzD6yzhm1ykm9iibvPlG18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422424; c=relaxed/simple;
	bh=/4xVhCavjN7yxjASS9V5yAj/kwSqFh0EOT9qCbedw0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YhPjeuHV7eIralIGLXpc7yBhbF6lzjb+snoWRG7HXiNltMswArZKuxM06mRNIOxBXvIwcIYoGWD/4/PyFWiuNE9M2uSMLeDXT+/Jw+8lMs39Sd436TbNd4ScQZ/RrAeZMHXpUVrCYpzaXV7G2sP1BDCNmioEsiBg+eaezCMUDjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJk12J5C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJk12J5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85B21F000E9;
	Thu, 30 Jul 2026 14:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422423;
	bh=wS2bfUI/z15Q3AQ2BbiOD4xJ6TahG/Lo4O8T7NvQgoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WJk12J5CaSeAyaeEpuBu4f35rOi1U3iCn8fcDq+wPTQQt+IObn090JtGbnmRgrbjO
	 5IKVaMFy8kPieoMtws4LgylHBpqHPS0tuBQwuT1tUkhtgvtvCfvdKIVeBP/TSthFWT
	 qwJFp1+iu7jDv4Dk2zwk3xOLgWRJX9Xv3qAurl8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	Animesh Manna <animesh.manna@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	=?UTF-8?q?Micha=C5=82=20Grzelak?= <michal.grzelak@intel.com>
Subject: [PATCH 7.1 433/744] drm/i915/bios: range check LFP Data Block panel_type2
Date: Thu, 30 Jul 2026 16:11:46 +0200
Message-ID: <20260730141453.501005652@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 2084503f2d087bf956198e7f6eb25b03a7049cb2 upstream.

While the panel_type from LFP Data Block is range checked, panel_type2
is not. Add a few helpers for range checking, and use them to not only
check panel_type2, but also improve clarity and correctness in the panel
type selection.

Discovered using AI-assisted static analysis confirmed by Intel Product
Security.

v2:
- Fix commit message typo (Michał)
- Add is_panel_type_pnp() (Ville)

Reported-by: Martin Hodo <martin.hodo@intel.com>
Fixes: 6434cf630086 ("drm/i915/bios: calculate panel type as per child device index in VBT")
Cc: stable@vger.kernel.org # v6.0+
Cc: Animesh Manna <animesh.manna@intel.com>
Cc: Ville Syrjälä <ville.syrjala@intel.com>
Reviewed-by: Michał Grzelak <michal.grzelak@intel.com> # v1
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patch.msgid.link/20260626140155.1389655-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit c9ebe5d2f25729d6cfbbb1235d640bf67f9275df)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_bios.c |   36 +++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -623,6 +623,21 @@ get_lfp_data_tail(const struct bdb_lfp_d
 		return NULL;
 }
 
+static bool is_panel_type_valid(int panel_type)
+{
+	return panel_type >= 0 && panel_type < 16;
+}
+
+static bool is_panel_type_pnp(int panel_type)
+{
+	return panel_type == 0xff;
+}
+
+static bool is_panel_type_valid_or_pnp(int panel_type)
+{
+	return is_panel_type_valid(panel_type) || is_panel_type_pnp(panel_type);
+}
+
 static int opregion_get_panel_type(struct intel_display *display,
 				   const struct intel_bios_encoder_data *devdata,
 				   const struct drm_edid *drm_edid, bool use_fallback)
@@ -640,15 +655,21 @@ static int vbt_get_panel_type(struct int
 	if (!lfp_options)
 		return -1;
 
-	if (lfp_options->panel_type > 0xf &&
-	    lfp_options->panel_type != 0xff) {
+	if (!is_panel_type_valid_or_pnp(lfp_options->panel_type)) {
 		drm_dbg_kms(display->drm, "Invalid VBT panel type 0x%x\n",
 			    lfp_options->panel_type);
 		return -1;
 	}
 
-	if (devdata && devdata->child.handle == DEVICE_HANDLE_LFP2)
+	if (devdata && devdata->child.handle == DEVICE_HANDLE_LFP2) {
+		if (!is_panel_type_valid_or_pnp(lfp_options->panel_type2)) {
+			drm_dbg_kms(display->drm, "Invalid VBT panel type 2 0x%x\n",
+				    lfp_options->panel_type2);
+			return -1;
+		}
+
 		return lfp_options->panel_type2;
+	}
 
 	drm_WARN_ON(display->drm,
 		    devdata && devdata->child.handle != DEVICE_HANDLE_LFP1);
@@ -762,13 +783,12 @@ static int get_panel_type(struct intel_d
 				    panel_types[i].name, panel_types[i].panel_type);
 	}
 
-	if (panel_types[PANEL_TYPE_OPREGION].panel_type >= 0)
+	if (is_panel_type_valid(panel_types[PANEL_TYPE_OPREGION].panel_type))
 		i = PANEL_TYPE_OPREGION;
-	else if (panel_types[PANEL_TYPE_VBT].panel_type == 0xff &&
-		 panel_types[PANEL_TYPE_PNPID].panel_type >= 0)
+	else if (is_panel_type_pnp(panel_types[PANEL_TYPE_VBT].panel_type) &&
+		 is_panel_type_valid(panel_types[PANEL_TYPE_PNPID].panel_type))
 		i = PANEL_TYPE_PNPID;
-	else if (panel_types[PANEL_TYPE_VBT].panel_type != 0xff &&
-		 panel_types[PANEL_TYPE_VBT].panel_type >= 0)
+	else if (is_panel_type_valid(panel_types[PANEL_TYPE_VBT].panel_type))
 		i = PANEL_TYPE_VBT;
 	else
 		i = PANEL_TYPE_FALLBACK;


