Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA741175A99;
	Mon, 17 Aug 2026 14:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977038; cv=none; b=lTwGHL5ZLlEb5eDz/xnCVKEA9dba1f62namT1agtUHs4Ybr9MJEgDkjLJalt/OFgDvvsURCgzpWRSQCVjtKoBcLBFevSF3zhNm4AyxBCcIOKirvIKAXnOh280Vvo9/4uDomWfcosoyjeetET68IytHOJ9cdT4aAWZFu0xewzBdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977038; c=relaxed/simple;
	bh=akIQOLQhwnjKk+HnNd/pPfJE+AIk8m4Ka6wacNEwPTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqQpKrusxpS0ukZ2Kh7z+UV39htvCbtgxqZ31LVBhIaxrUS2vQmivGMewfZgk7YPaVUzUa4FaDz8Er7KcuiMHPTjtYAoVMG76tjPsLqrzpkC3i92uQv+jcwMx297nsupZXjQcPLieBGs6cm2+aP1ejTclA6tda0chr6Ak/1lsHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APnfjlOr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APnfjlOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211B11F000E9;
	Mon, 17 Aug 2026 14:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977036;
	bh=6CKdukadY4B95b7CTbJT/NsCMcrIpWqyzICHcCxTs0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=APnfjlOrzMDtswvq3ySRdvTME0VDFpeKS056CBDemjIZbT/9WbtDgHYI+/u9Dpu2U
	 EvlP+ejZGdlVNv2bw5iBdzwrxPDzpNCvGFg3BoYRJwN8FtMo9I2C2oeNxtn3jOwfnv
	 /T/C4UV3UDOxzbYdT6aqgLzpOYBmsj/C7MMeGpp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	Faith Ekstrand <faith.ekstrand@collabora.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.15 150/456] drm/i915/gem: Fix NULL deref in I915_CONTEXT_PARAM_SSEU
Date: Mon, 17 Aug 2026 15:29:00 +0200
Message-ID: <20260817132545.943070284@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

commit 2b56757a9a7456825eb668fde92299e01c5e2721 upstream.

Setting context engine slot N into I915_ENGINE_CLASS_INVALID /
I915_ENGINE_CLASS_INVALID_NONE and attempting to apply
I915_CONTEXT_PARAM_SSEU to the same slot N will deref NULL.
Fix that.

Discovered using AI-assisted static analysis confirmed by
Intel Product Security.

Reported-by: Martin Hodo <martin.hodo@intel.com>
Fixes: d4433c7600f7 ("drm/i915/gem: Use the proto-context to handle create parameters (v5)")
Cc: Faith Ekstrand <faith.ekstrand@collabora.com>
Cc: Simona Vetter <simona.vetter@ffwll.ch>
Cc: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.15+
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patch.msgid.link/20260701075555.52142-1-joonas.lahtinen@linux.intel.com
(cherry picked from commit 36eda5b5c2d40da41cc0a5403c26986237cf9e87)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_context.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -652,7 +652,7 @@ static int set_proto_ctx_sseu(struct drm
 		pe = &pc->user_engines[idx];
 
 		/* Only render engine supports RPCS configuration. */
-		if (pe->engine->class != RENDER_CLASS)
+		if (!pe->engine || pe->engine->class != RENDER_CLASS)
 			return -EINVAL;
 
 		sseu = &pe->sseu;


