Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357001171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD02EC433C8;
	Mon, 21 Aug 2023 20:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648618;
	bh=GZqoPox0uf6tI6043WBCAEHPFXmftqEaGenKl5i8slM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NkKqRsumFssFud2VhLBfZCD1wiW1g6En3hlSQnmbR6cD+egI7oybHyvx3LD41G1lP
	 wYWYy1pfY7TClyKYU+r/Kc4XECRRoiQLO7uehLoARZYe4G4PK90BXF/Emt9wdkX8oj
	 ug0l9xpX+uuGvpc9KzCHGigePNtNKjt/MURJMhfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomi=20Lepp=C3=A4nen?= <tomi@tomin.site>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Uma Shankar <uma.shankar@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.4 223/234] drm/i915/sdvo: fix panel_type initialization
Date: Mon, 21 Aug 2023 21:43:06 +0200
Message-ID: <20230821194138.763756410@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jani Nikula <jani.nikula@intel.com>

commit 2002eb6d3ea954dde9f8a223018d5335779937d0 upstream.

Commit 3f9ffce5765d ("drm/i915: Do panel VBT init early if the VBT
declares an explicit panel type") started using -1 as the value for
unset panel_type. It gets initialized in intel_panel_init_alloc(), but
the SDVO code never calls it.

Call intel_panel_init_alloc() to initialize the panel, including the
panel_type.

Reported-by: Tomi Leppänen <tomi@tomin.site>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/8896
Fixes: 3f9ffce5765d ("drm/i915: Do panel VBT init early if the VBT declares an explicit panel type")
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v6.1+
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Tested-by: Tomi Leppänen <tomi@tomin.site>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230803122706.838721-1-jani.nikula@intel.com
(cherry picked from commit 26e60294e8eacedc8ebb33405b2c375fd80e0900)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_sdvo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/display/intel_sdvo.c
@@ -2752,7 +2752,7 @@ static struct intel_sdvo_connector *inte
 	__drm_atomic_helper_connector_reset(&sdvo_connector->base.base,
 					    &conn_state->base.base);
 
-	INIT_LIST_HEAD(&sdvo_connector->base.panel.fixed_modes);
+	intel_panel_init_alloc(&sdvo_connector->base);
 
 	return sdvo_connector;
 }


