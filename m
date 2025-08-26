Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC49239573;
	Tue, 26 Aug 2025 11:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207637; cv=none; b=CJAZCFNx1cEeB4EcvgU1LDieG9QGxvHC/vNgnZzo/1dDQuhM+lBds8yLcWsMIa/cEWlmMvkQQZQ7//arkH1oue6TYtGcGYNAHT6DHMYO2S6wKEZpKn3fw6wQH7erzgawdiRGPpl2pk0hZaeG7gr17naq2jQC6pyn43/jZvKWucU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207637; c=relaxed/simple;
	bh=5blUN8k3ESaKAo/tQWQm8ECbNZDG++6khP9t0UHQ3h8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNZIXmF7OT6KaSfwL0nNhzCaFW4dzDkTBBia3KWxVF3hQ5HfH1R73wuC6VVJfC+Lt4srt/kUcL+DdGX4as/PBXZPHhRd5iFBvBmEg+klvMZFDah5Kuz5HY+v+6KO6dsuBwhOVX8uniREAeQgeQ83GUCRg0kyYmaGAjqF48bnvF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kbbp1FNS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kbbp1FNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC118C4CEF1;
	Tue, 26 Aug 2025 11:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207637;
	bh=5blUN8k3ESaKAo/tQWQm8ECbNZDG++6khP9t0UHQ3h8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kbbp1FNSLvv5xqNsr0Br+jETG+JEV42Ic46jcDdg/1GV1BayBY934no45KG0kVJs0
	 fmz6gBABn9rWtFZJRRebLbyK9+xApE9L+F9MkkoYXImuIV9OJXO0Ft/TCw/HSHZrNg
	 Zl6qBz5C6sDuSwfsLidr5d5+VbVyfVcfncDoes+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Brzezinka <sebastian.brzezinka@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.16 260/457] drm/i915/gt: Relocate compression repacking WA for JSL/EHL
Date: Tue, 26 Aug 2025 13:09:04 +0200
Message-ID: <20250826110943.783509060@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Brzezinka <sebastian.brzezinka@intel.com>

commit 8236820fd767f400d1baefb71bc7e36e37730a1e upstream.

CACHE_MODE_0 registers should be saved and restored as part of
the context, not during engine reset. Move the related workaround
(Disable Repacking for Compression) from rcs_engine_wa_init()
to icl_ctx_workarounds_init() for Jasper Lake and Elkhart
Lake platforms. This ensures the WA is applied during context
initialisation.

BSPEC: 11322

Fixes: 0ddae025ab6c ("drm/i915: Disable compression tricks on JSL")
Closes: Fixes: 0ddae025ab6c ("drm/i915: Disable compression tricks on JSL")
Signed-off-by: Sebastian Brzezinka <sebastian.brzezinka@intel.com>
Cc: stable@vger.kernel.org # v6.13+
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Krzysztof Karas <krzysztof.karas@intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://lore.kernel.org/r/4feaa24094e019e000ceb6011d8cd419b0361b3f.1754902406.git.sebastian.brzezinka@intel.com
(cherry picked from commit c9932f0d604e4c8f2c6018e598a322acb43c68a2)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_workarounds.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -634,6 +634,8 @@ static void cfl_ctx_workarounds_init(str
 static void icl_ctx_workarounds_init(struct intel_engine_cs *engine,
 				     struct i915_wa_list *wal)
 {
+	struct drm_i915_private *i915 = engine->i915;
+
 	/* Wa_1406697149 (WaDisableBankHangMode:icl) */
 	wa_write(wal, GEN8_L3CNTLREG, GEN8_ERRDETBCTRL);
 
@@ -669,6 +671,15 @@ static void icl_ctx_workarounds_init(str
 
 	/* Wa_1406306137:icl,ehl */
 	wa_mcr_masked_en(wal, GEN9_ROW_CHICKEN4, GEN11_DIS_PICK_2ND_EU);
+
+	if (IS_JASPERLAKE(i915) || IS_ELKHARTLAKE(i915)) {
+		/*
+		 * Disable Repacking for Compression (masked R/W access)
+		 * before rendering compressed surfaces for display.
+		 */
+		wa_masked_en(wal, CACHE_MODE_0_GEN7,
+			     DISABLE_REPACKING_FOR_COMPRESSION);
+	}
 }
 
 /*
@@ -2306,15 +2317,6 @@ rcs_engine_wa_init(struct intel_engine_c
 			     GEN8_RC_SEMA_IDLE_MSG_DISABLE);
 	}
 
-	if (IS_JASPERLAKE(i915) || IS_ELKHARTLAKE(i915)) {
-		/*
-		 * "Disable Repacking for Compression (masked R/W access)
-		 *  before rendering compressed surfaces for display."
-		 */
-		wa_masked_en(wal, CACHE_MODE_0_GEN7,
-			     DISABLE_REPACKING_FOR_COMPRESSION);
-	}
-
 	if (GRAPHICS_VER(i915) == 11) {
 		/* This is not an Wa. Enable for better image quality */
 		wa_masked_en(wal,


