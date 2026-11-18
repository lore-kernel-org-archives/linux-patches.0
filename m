Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047584;
	b=U8qNE4zgRJTuM6GBXnCEhliJeQyY4u9VZI8Y97vApmRiDC7rW2qZtJtwwd7KgOQBHmGJ
	 i9fvzuiePR790o8KPKSNoPMBwg7eQ7MDpz8MjjHwn5rfU53wVmGW3DtlyllN8CaeGp6u5
	 EN+tpIiEncnXz90F/ge6JyAozB5X2+Hgm9Z4NVDNMtJNQGehHtCfJ4dPyvTuQptR8TpLm
	 PHAvYnhA+5AtfuXbwThH47734YnpkBm+/w+zAtoOdrWc2F8qGGNG3bvpFeP6yvxVZCpuK
	 2crAxtkd1GZ0zUKWTRZi7ReD/phanA/Cbdxa3LFAALW0v3yvY9SqlWvK3402zp7g5RA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=djDkScP7ANXTFUcgOYOEJ+S2h/PAHXY+Z6tjVGV92kI=;
	b=olSeEVGHpTNsJ4al15ks2/qNfrnQLDN1gRscrikn+1TwQmmUfRcOBCe5k/DcZBTZNEyb
	 gvMwRK5bbtbhz0rh4LUTsLu/XmMe3o0FiUQ/jvPBpnk8PbCnhy/Db3qMEc5nOvfzooYhS
	 jjU25hVPDAhz/jc0P+URnYhIZ7icIsfSVxhbZYn6e6bovNiidvldGqnXr1aZYmDNGcBFw
	 9ALjXc+8A+yxOGRl5BIIMtOSGS0QDA67HQWauEMj5Bo9QJkmL+LJVwhL0OxflrJ9uV4K2
	 jmVUnDd0C839oLWjqnt5M8K6V7M/p7XTph3+VZv5DYndDn5I3uvu27TSqdxr2x65O4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hc1BzRut;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADC2606A31C;
	Thu, 19 Nov 2026 00:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hc1BzRut
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB941F000C4;
	Thu, 19 Nov 2026 00:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047584;
	bh=djDkScP7ANXTFUcgOYOEJ+S2h/PAHXY+Z6tjVGV92kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hc1BzRuthKWNGnpz738OhtZ9GK9uGjZ8y9Hvk0iMtNAxcPTTvG6iEk46YpV2Wpm18
	 brxe+vmr3T4zv+M8e25Dy+6mB+XqTJXtq5kOUNiOAMjDJQw8EfNS63e0MJpOzpu/aS
	 ZvdeO0GVNT/A3daDahyE8cugSJ78JO/SFJCM6KFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1692/2857] drm/edid: parse display info has_audio similar to is_hdmi
Date: Wed, 18 Nov 2026 15:45:26 +0100
Message-ID: <20261118150302.259217193@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 0374ffa507d8106202a956f5951226f1d9eac22e ]

Since we already iterate everything that's needed for determining audio,
reduce the need to call drm_detect_monitor_audio() by storing has_audio
to connector info.

Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/391a93b25c6bcbb39854aaa2813570cfb1580ed9.1685437500.git.jani.nikula@intel.com
Stable-dep-of: 0de95c96655c ("drm/amdgpu: Only enable HDMI audio if display supports it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_edid.c  | 6 ++++++
 include/drm/drm_connector.h | 8 ++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 511021179ecbd..52bf6755f36ea 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -6032,6 +6032,9 @@ static void drm_parse_cea_ext(struct drm_connector *connector,
 			info->color_formats |= DRM_COLOR_FORMAT_YCBCR444;
 		if (edid_ext[3] & EDID_CEA_YCRCB422)
 			info->color_formats |= DRM_COLOR_FORMAT_YCBCR422;
+		if (edid_ext[3] & EDID_BASIC_AUDIO)
+			info->has_audio = true;
+
 	}
 	drm_edid_iter_end(&edid_iter);
 
@@ -6055,6 +6058,8 @@ static void drm_parse_cea_ext(struct drm_connector *connector,
 			drm_parse_hdr_metadata_block(connector, data);
 		else if (cea_db_tag(db) == CTA_DB_VIDEO)
 			parse_cta_vdb(connector, db);
+		else if (cea_db_tag(db) == CTA_DB_AUDIO)
+			info->has_audio = true;
 	}
 	cea_db_iter_end(&iter);
 }
@@ -6193,6 +6198,7 @@ static void drm_reset_display_info(struct drm_connector *connector)
 	info->max_tmds_clock = 0;
 	info->dvi_dual = false;
 	info->is_hdmi = false;
+	info->has_audio = false;
 	info->has_hdmi_infoframe = false;
 	info->rgb_quant_range_selectable = false;
 	memset(&info->hdmi, 0, sizeof(info->hdmi));
diff --git a/include/drm/drm_connector.h b/include/drm/drm_connector.h
index 5dfde32447798..a34d169549934 100644
--- a/include/drm/drm_connector.h
+++ b/include/drm/drm_connector.h
@@ -597,6 +597,14 @@ struct drm_display_info {
 	 */
 	bool is_hdmi;
 
+	/**
+	 * @has_audio: True if the sink supports audio.
+	 *
+	 * This field shall be used instead of calling
+	 * drm_detect_monitor_audio() when possible.
+	 */
+	bool has_audio;
+
 	/**
 	 * @has_hdmi_infoframe: Does the sink support the HDMI infoframe?
 	 */
-- 
2.53.0



