Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047581;
	b=5N74nIodopWaDaSMrBle/H7Yal2/Kob3OYjQHZu+XGiEo1wsjPtq2oZE7dDT3DL+DlHf
	 Q0zM8ofXdfn8E/1W7un/Lqm8oAmBsm6hlkICvpGbWcWMOusFCV67Ly32inj6OlknsVPxU
	 OHY2hvpKoMdpBzkSg8aLnLEOum+ATpOLFQ3CVy3cdPiaDf+UzJPhUH7+Y2WBenx+mYKgO
	 9tWs067XMK+IdoreKxWKjZygyQtq3/IpfLdM3bS1vyTWLyK+8pXU6S+oRfwBxFTPDKqoH
	 Hqn3TbLGV0dfQCKVmRU/DliS7gg4T13q5xM2TrmoqtdfMHlVa1nwqj7XU0RLKF8NQwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=FLXsEUn0m+5xFpvK+b7NNrcC6qAIQ2RM6e/g9Myk/Wc=;
	b=1Phnvrt9BmnTpJLOZNCEtI1Gk+/QDe1Snc4otARdrU57UYNLBzVJS5crntiC8JGlOgQV
	 +6iHRA5FUXQZ5b2F5wSppqls1fim0ar/Lfv47VROnT/pKqv5g82Rn3edr9knXCqfv+LC4
	 AxP6/2PvsjzDptQ/WVmG1lTCsEEiE5zX9gMdXsIPTvNJ5ciIhaegqRr3cFUydXTQZotUd
	 fppec8iWdu7gUmwyJU2Q3HRHil0SU4qDGOhH/XKbSdYJBOBwv3bXhtgzLn3Xmy++Bj5Zy
	 Xyr9+/6ebKLHsNo3TFI/RHBUvWHJBrvbSO54iXhO2n8f9NCNNdZiJsoHQxgHaGvd8GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zHWdBI+q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A208A606A325;
	Thu, 19 Nov 2026 00:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zHWdBI+q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28E01F000C4;
	Thu, 19 Nov 2026 00:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047581;
	bh=FLXsEUn0m+5xFpvK+b7NNrcC6qAIQ2RM6e/g9Myk/Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zHWdBI+qvpbCjWFwwCYddPI3r10ZPgU7JPhnWjuqbNxUwyGfMu6EA9wu0FRKRmKw+
	 HffMCoM0Y2/yoWeyUtyZTTyq81GmZbYoxgSRZ80GJGpZJjW5jwz1935NtcVRRMgsOu
	 JM9WMIUMyQIHqqLUmB0temuivTjqVFfYbn09NFik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1691/2857] drm/edid: parse VICs from CTA VDB early
Date: Wed, 18 Nov 2026 15:45:25 +0100
Message-ID: <20261118150302.224957413@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

[ Upstream commit c3292ab5fbd7045f019418b2ce1977891419ad28 ]

A number of places need access to the VICs. Just parse them early for
easy access. Gracefully handle multiple CTA VDBs. It's unlikely to have
more than one, but the CTA-861 references "Video Data Block(s)", so err
on the safe side.

Start parsing them now, convert users in follow-up to have fewer moving
parts in one go.

Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/7989b2b37837be68953c5d20afd3e93762bfd626.1672826282.git.jani.nikula@intel.com
Stable-dep-of: 0de95c96655c ("drm/amdgpu: Only enable HDMI audio if display supports it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_connector.c |  1 +
 drivers/gpu/drm/drm_edid.c      | 36 +++++++++++++++++++++++++++++++++
 include/drm/drm_connector.h     | 10 +++++++++
 3 files changed, 47 insertions(+)

diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connector.c
index e49e2b0da6590..ca4c543234bbc 100644
--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -564,6 +564,7 @@ void drm_connector_cleanup(struct drm_connector *connector)
 	ida_free(&dev->mode_config.connector_ida, connector->index);
 
 	kfree(connector->display_info.bus_formats);
+	kfree(connector->display_info.vics);
 	drm_mode_object_unregister(dev, &connector->base);
 	kfree(connector->name);
 	connector->name = NULL;
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index b202bb197f316..511021179ecbd 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -5704,6 +5704,36 @@ drm_default_rgb_quant_range(const struct drm_display_mode *mode)
 }
 EXPORT_SYMBOL(drm_default_rgb_quant_range);
 
+/* CTA-861 Video Data Block (CTA VDB) */
+static void parse_cta_vdb(struct drm_connector *connector, const struct cea_db *db)
+{
+	struct drm_display_info *info = &connector->display_info;
+	int i, vic_index, len = cea_db_payload_len(db);
+	const u8 *svds = cea_db_data(db);
+	u8 *vics;
+
+	if (!len)
+		return;
+
+	/* Gracefully handle multiple VDBs, however unlikely that is */
+	vics = krealloc(info->vics, info->vics_len + len, GFP_KERNEL);
+	if (!vics)
+		return;
+
+	vic_index = info->vics_len;
+	info->vics_len += len;
+	info->vics = vics;
+
+	for (i = 0; i < len; i++) {
+		u8 vic = svd_to_vic(svds[i]);
+
+		if (!drm_valid_cea_vic(vic))
+			vic = 0;
+
+		info->vics[vic_index++] = vic;
+	}
+}
+
 static void drm_parse_vcdb(struct drm_connector *connector, const u8 *db)
 {
 	struct drm_display_info *info = &connector->display_info;
@@ -6023,6 +6053,8 @@ static void drm_parse_cea_ext(struct drm_connector *connector,
 			drm_parse_vcdb(connector, data);
 		else if (cea_db_is_hdmi_hdr_metadata_block(db))
 			drm_parse_hdr_metadata_block(connector, data);
+		else if (cea_db_tag(db) == CTA_DB_VIDEO)
+			parse_cta_vdb(connector, db);
 	}
 	cea_db_iter_end(&iter);
 }
@@ -6176,6 +6208,10 @@ static void drm_reset_display_info(struct drm_connector *connector)
 	info->mso_stream_count = 0;
 	info->mso_pixel_overlap = 0;
 	info->max_dsc_bpp = 0;
+
+	kfree(info->vics);
+	info->vics = NULL;
+	info->vics_len = 0;
 }
 
 static u32 update_display_info(struct drm_connector *connector,
diff --git a/include/drm/drm_connector.h b/include/drm/drm_connector.h
index b8ef80e6ce392..5dfde32447798 100644
--- a/include/drm/drm_connector.h
+++ b/include/drm/drm_connector.h
@@ -662,6 +662,16 @@ struct drm_display_info {
 	 * monitor's default value is used instead.
 	 */
 	u32 max_dsc_bpp;
+
+	/**
+	 * @vics: Array of vics_len VICs. Internal to EDID parsing.
+	 */
+	u8 *vics;
+
+	/**
+	 * @vics_len: Number of elements in vics. Internal to EDID parsing.
+	 */
+	int vics_len;
 };
 
 int drm_display_info_set_bus_formats(struct drm_display_info *info,
-- 
2.53.0



