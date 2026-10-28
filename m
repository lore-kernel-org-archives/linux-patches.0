Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215335;
	b=CkRHrCwZ0Z/Cf5ni+ppp4azg19EgoZT0X3ipwqQVPV63Hj1oXjEKsc2b1CD//jPiq3vd
	 QCc70meB5pVi6SjLl0NTtkq8gD1IQkKhGGV10beSUhGphZqhuHIhzjoPjr2PX7NzLvQ2J
	 IDZ/lMWQ0aZcPb3jKh50gSFMrSgSk7Z/KFte4YRZsEOoT4xkft+KipAgl/thdhNoPoyhO
	 U7Xnwv+NKybHLjaGO4/wuN0A5HgjVfxFoXy0gujVPrkepHjLWtXbuF+pKE4QcY8fXTHS8
	 LJ52kIZOqCTsApQVGjjm7NpK7/rTXd35Xe0sCs7BD7NlzSVUzbCd2v3GtUB5ua4/dow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215335;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=kvBmzT7eapWWXIcMTnWD3Mp8l6EQHjLokm0qR6kqJxE=;
	b=P/SWgol4yDnFXwdc+oY/j2HXhEnXWyIz2VLYZzw096iAQPKHXaYenEN5f7CBRVq4A6LV
	 dzyrcAUON9S2HFS354FckSeTzm6YrkkP6YQyu/NisIk2g1p0w7GelCyhxoaDBQf/JxVNA
	 LeLxtu0Q3toMqvG4EdNr6EbVcSm9MZw6X/131iv2mkldEa7BugsnERFU53htWkJ8UPTyL
	 H+cuP1LyI0pimtO/+UhB689LXZ1U60jVaZYfptuhjdbQxfpaVsyk4B4WVTzmb0qMOm0bs
	 Gx5z2w2rrgsMQvdgvQSyNPoLLQ/L56zTTWpbUEfIpMTMMg+I0il+LVgZ4qMkuWRt6ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0iZSSQ2O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0BF606A31A;
	Wed, 28 Oct 2026 19:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0iZSSQ2O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866911F01825;
	Wed, 28 Oct 2026 19:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215335;
	bh=kvBmzT7eapWWXIcMTnWD3Mp8l6EQHjLokm0qR6kqJxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0iZSSQ2OUPTlbDekaML7lla4wB4gOdJG7SXqAEBnhYbCr59KxhcJ6pwLao2tcyEBE
	 MHWZ++H7zWPC5d8qwzksWOLaqt1MlBOseQrH+wxo3Tqz6d5RfTXWBV1UlpFDOIJ4z9
	 dhxZHnEeAry0z1vKZxYkHGIwaK1msfgKRlOzXJj0=
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
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Micha=C5=82=20Grzelak?= <michal.grzelak@intel.com>
Subject: [PATCH 6.1 1173/1887] drm/i915/bios: range check LFP Data Block panel_type2
Date: Wed, 28 Oct 2026 17:54:29 +0100
Message-ID: <20261028170526.099385449@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 2084503f2d087bf956198e7f6eb25b03a7049cb2 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_bios.c | 36 ++++++++++++++++++-----
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
index efbb0cffd3bc9..3ccbe6026946e 100644
--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -618,6 +618,21 @@ static void dump_pnp_id(struct drm_i915_private *i915,
 		    pnp_id->mfg_week, pnp_id->mfg_year + 1990);
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
 static int opregion_get_panel_type(struct drm_i915_private *i915,
 				   const struct intel_bios_encoder_data *devdata,
 				   const struct edid *edid, bool use_fallback)
@@ -635,15 +650,21 @@ static int vbt_get_panel_type(struct drm_i915_private *i915,
 	if (!lvds_options)
 		return -1;
 
-	if (lvds_options->panel_type > 0xf &&
-	    lvds_options->panel_type != 0xff) {
+	if (!is_panel_type_valid_or_pnp(lvds_options->panel_type)) {
 		drm_dbg_kms(&i915->drm, "Invalid VBT panel type 0x%x\n",
 			    lvds_options->panel_type);
 		return -1;
 	}
 
-	if (devdata && devdata->child.handle == DEVICE_HANDLE_LFP2)
+	if (devdata && devdata->child.handle == DEVICE_HANDLE_LFP2) {
+		if (!is_panel_type_valid_or_pnp(lvds_options->panel_type2)) {
+			drm_dbg_kms(&i915->drm, "Invalid VBT panel type 2 0x%x\n",
+				    lvds_options->panel_type2);
+			return -1;
+		}
+
 		return lvds_options->panel_type2;
+	}
 
 	drm_WARN_ON(&i915->drm, devdata && devdata->child.handle != DEVICE_HANDLE_LFP1);
 
@@ -755,13 +776,12 @@ static int get_panel_type(struct drm_i915_private *i915,
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
-- 
2.53.0



