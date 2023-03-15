Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E334431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136E9C433D2;
	Wed, 15 Mar 2023 12:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883124;
	bh=KiXl2hRFUutpZmLcHGX8IfKBYY8a2+Ncm0xZJHfwQKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1YeIhCC+CG+idU1IqrmB8TELfQSm5WYUlY39A4h71DaF7Q4ytGf5fjRkBLTXqj6pp
	 VyPkJNCw3Mk0Gygq2PYahjWMR5EWYoZViNP/JP1F4B9KFbQzti4g1lhn9r8vBOn7oq
	 AkgNDOercQQdg33EsxgBREwFFszuZrWYLIKxOsj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Pekka Paalanen <ppaalanen@gmail.com>,
	Sebastian Wick <sebastian.wick@redhat.com>,
	Vitaly.Prosyak@amd.com,
	Uma Shankar <uma.shankar@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Joshua Ashton <joshua@froggi.es>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	dri-devel@lists.freedesktop.org,
	amd-gfx@lists.freedesktop.org,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 007/145] drm/connector: print max_requested_bpc in state debugfs
Date: Wed, 15 Mar 2023 13:11:13 +0100
Message-Id: <20230315115739.225726207@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Harry Wentland <harry.wentland@amd.com>

commit 7d386975f6a495902e679a3a250a7456d7e54765 upstream.

This is useful to understand the bpc defaults and
support of a driver.

Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Cc: Pekka Paalanen <ppaalanen@gmail.com>
Cc: Sebastian Wick <sebastian.wick@redhat.com>
Cc: Vitaly.Prosyak@amd.com
Cc: Uma Shankar <uma.shankar@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Joshua Ashton <joshua@froggi.es>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: dri-devel@lists.freedesktop.org
Cc: amd-gfx@lists.freedesktop.org
Reviewed-By: Joshua Ashton <joshua@froggi.es>
Link: https://patchwork.freedesktop.org/patch/msgid/20230113162428.33874-3-harry.wentland@amd.com
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_atomic.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -1052,6 +1052,7 @@ static void drm_atomic_connector_print_s
 	drm_printf(p, "connector[%u]: %s\n", connector->base.id, connector->name);
 	drm_printf(p, "\tcrtc=%s\n", state->crtc ? state->crtc->name : "(null)");
 	drm_printf(p, "\tself_refresh_aware=%d\n", state->self_refresh_aware);
+	drm_printf(p, "\tmax_requested_bpc=%d\n", state->max_requested_bpc);
 
 	if (connector->connector_type == DRM_MODE_CONNECTOR_WRITEBACK)
 		if (state->writeback_job && state->writeback_job->fb)


