Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F112590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3980C433D2;
	Sun, 22 Jan 2023 15:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400831;
	bh=2sHz0GJPdnwwe2NPypORVOANGNXwiyoCXfSuf1AhwY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yzlPbsT/hrIwMB9NyDmawYUtlrQxTabyvHi5rrTz/maM4gpsDQBtO8qYKOo3+pjGE
	 bxHrwl0cyYwPGvWad7nKoYbmkr93HRZyEwKBKB5Mv2GnEteAFudZFiw471yiD+4ehm
	 dsGSTtaHB+tdQ3iXkiGFGYDWD/TuZKoW/KYelBlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Drew Davenport <ddavenport@chromium.org>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.15 095/117] drm/i915/display: Check source height is > 0
Date: Sun, 22 Jan 2023 16:04:45 +0100
Message-Id: <20230122150236.765700178@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Drew Davenport <ddavenport@chromium.org>

commit 8565c502e7c156d190d8e6d36e443f51b257f165 upstream.

The error message suggests that the height of the src rect must be at
least 1. Reject source with height of 0.

Cc: stable@vger.kernel.org
Signed-off-by: Drew Davenport <ddavenport@chromium.org>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221226225246.1.I15dff7bb5a0e485c862eae61a69096caf12ef29f@changeid
(cherry picked from commit 0fe76b198d482b41771a8d17b45fb726d13083cf)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/skl_universal_plane.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/skl_universal_plane.c
+++ b/drivers/gpu/drm/i915/display/skl_universal_plane.c
@@ -1473,7 +1473,7 @@ static int skl_check_main_surface(struct
 	u32 offset;
 	int ret;
 
-	if (w > max_width || w < min_width || h > max_height) {
+	if (w > max_width || w < min_width || h > max_height || h < 1) {
 		drm_dbg_kms(&dev_priv->drm,
 			    "requested Y/RGB source size %dx%d outside limits (min: %dx1 max: %dx%d)\n",
 			    w, h, min_width, max_width, max_height);


