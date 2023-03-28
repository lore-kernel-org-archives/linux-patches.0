Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D708BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8332AC433D2;
	Tue, 28 Mar 2023 14:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015527;
	bh=H13oUMTu6UH6DJRlWhlSVQ4Yj6Ut4X1/Ebkvnh0F5iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A0/u4bq0TddpNzkNDcwipZxdieOCbC4U0oh4evr+h2ab0AIacAlMZ2LxDuapiXaCf
	 sAI784ASIHV9v/i78ShPnFRqpG5EBDhNA1IPzY/9csyeHBNZfeMvoKboCdTgHeVtG0
	 64yvpFy7UdhBEnQECJQcSHU+5eyRtBbSE+EqjMuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Harrison <John.C.Harrison@Intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/224] drm/i915/guc: Rename GuC register state capture node to be more obvious
Date: Tue, 28 Mar 2023 16:40:46 +0200
Message-Id: <20230328142619.459820738@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Harrison <John.C.Harrison@Intel.com>

[ Upstream commit 583ebae783b8241a30581c084ad6226051b594c5 ]

The GuC specific register state entry in the error capture object was
just called 'capture'. Although the companion 'node' entry was called
'guc_capture_node'. Rename the base entry to be 'guc_capture' instead
so that it is a) more consistent and b) more obvious what it is.

Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230127002842.3169194-9-John.C.Harrison@Intel.com
Stable-dep-of: 8df23e4c4f72 ("drm/i915/guc: Fix missing ecodes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c | 8 ++++----
 drivers/gpu/drm/i915/i915_gpu_error.h          | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
index 685ddccc0f26a..13118609339ac 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_capture.c
@@ -1491,7 +1491,7 @@ int intel_guc_capture_print_engine_node(struct drm_i915_error_state_buf *ebuf,
 
 	if (!ebuf || !ee)
 		return -EINVAL;
-	cap = ee->capture;
+	cap = ee->guc_capture;
 	if (!cap || !ee->engine)
 		return -ENODEV;
 
@@ -1561,8 +1561,8 @@ void intel_guc_capture_free_node(struct intel_engine_coredump *ee)
 	if (!ee || !ee->guc_capture_node)
 		return;
 
-	guc_capture_add_node_to_cachelist(ee->capture, ee->guc_capture_node);
-	ee->capture = NULL;
+	guc_capture_add_node_to_cachelist(ee->guc_capture, ee->guc_capture_node);
+	ee->guc_capture = NULL;
 	ee->guc_capture_node = NULL;
 }
 
@@ -1596,7 +1596,7 @@ void intel_guc_capture_get_matching_node(struct intel_gt *gt,
 		    (ce->lrc.lrca & CTX_GTT_ADDRESS_MASK)) {
 			list_del(&n->link);
 			ee->guc_capture_node = n;
-			ee->capture = guc->capture;
+			ee->guc_capture = guc->capture;
 			return;
 		}
 	}
diff --git a/drivers/gpu/drm/i915/i915_gpu_error.h b/drivers/gpu/drm/i915/i915_gpu_error.h
index efc75cc2ffdb9..56027ffbce51f 100644
--- a/drivers/gpu/drm/i915/i915_gpu_error.h
+++ b/drivers/gpu/drm/i915/i915_gpu_error.h
@@ -94,7 +94,7 @@ struct intel_engine_coredump {
 	struct intel_instdone instdone;
 
 	/* GuC matched capture-lists info */
-	struct intel_guc_state_capture *capture;
+	struct intel_guc_state_capture *guc_capture;
 	struct __guc_capture_parsed_output *guc_capture_node;
 
 	struct i915_gem_context_coredump {
-- 
2.39.2



