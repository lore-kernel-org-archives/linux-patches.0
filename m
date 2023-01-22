Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1CD7E
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EE7C433D2;
	Sun, 22 Jan 2023 15:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400253;
	bh=WlljdbMggn9jXhgPj4lGprYe0QLD0lechZ7E628n1bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkB6cglPRcfxm8cye4sOh9PPJk1hHE0Il91exx8N0IkLyw/7FnU2kjwN8RnKIow2x
	 +pkP6wy6gvX/0JXCdAooY65HUSJwHMidtjqEmEGpmlc2Ut5v3f5q0WD6cY5EWBw8Sm
	 8bnpEAesbvPeLua3l3qarn50H64Mcd4N3FoRzEU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasa Dragic <sasa.dragic@gmail.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.4 47/55] drm/i915: re-disable RC6p on Sandy Bridge
Date: Sun, 22 Jan 2023 16:04:34 +0100
Message-Id: <20230122150224.116522355@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150222.210885219@linuxfoundation.org>
References: <20230122150222.210885219@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sasa Dragic <sasa.dragic@gmail.com>

commit 67b0b4ed259e425b7eed09da75b42c80682ca003 upstream.

RC6p on Sandy Bridge got re-enabled over time, causing visual glitches
and GPU hangs.

Disabled originally in commit 1c8ecf80fdee ("drm/i915: do not enable
RC6p on Sandy Bridge").

Signed-off-by: Sasa Dragic <sasa.dragic@gmail.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221219172927.9603-2-sasa.dragic@gmail.com
Fixes: fb6db0f5bf1d ("drm/i915: Remove unsafe i915.enable_rc6")
Fixes: 13c5a577b342 ("drm/i915/gt: Select the deepest available parking mode for rc6")
Cc: stable@vger.kernel.org
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 0c8a6e9ea232c221976a0670256bd861408d9917)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_pci.c
+++ b/drivers/gpu/drm/i915/i915_pci.c
@@ -418,7 +418,8 @@ static const struct intel_device_info in
 	.has_coherent_ggtt = true, \
 	.has_llc = 1, \
 	.has_rc6 = 1, \
-	.has_rc6p = 1, \
+	/* snb does support rc6p, but enabling it causes various issues */ \
+	.has_rc6p = 0, \
 	.has_rps = true, \
 	.ppgtt_type = INTEL_PPGTT_FULL, \
 	.ppgtt_size = 31, \


