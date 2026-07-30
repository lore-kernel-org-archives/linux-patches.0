Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964245C613;
	Thu, 30 Jul 2026 14:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422446; cv=none; b=hzkU1zRbP16bpPk4vBnu6a6oq+3yyuO1YimbsisIh/ACOm7Q6uqdoDpOSQntW9ix9IdfAuHaU9o2rJ+PAka0u/qhcjHhn6sqKssgsedCyRTcu3EJbCm4D9mVcuKYu2K0zA662ao+QY+7bt2Q4k0lq+Mj2q/5ZvKPYrMnFzk0Bsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422446; c=relaxed/simple;
	bh=QJbSR9B518KA2cDFeeEszz+THlq25aPEBpsmqSlYL0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0BhzcnMoMhNNSWzgkkvbZ1KjOMsSgzjhhDW8gI5EJewD076N4EONSBIziSi+VMv5AS1pf5viG2N8VDLLJy516Oz+ns4faE3vRTMs7WicfJf62MR9zfm9z/fklxaMQu2XLY0ffoSMBHa2OGyiXL7wBhGQkjDH9DraeQTwQkpzPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXXhP9hl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXXhP9hl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079A81F000E9;
	Thu, 30 Jul 2026 14:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422445;
	bh=crAmPFLDSIChqJwz3sYoHNzFO/erZsXTPmQJ6URUOLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXXhP9hl5uAZZahEEOZGm4mkyVZrCFddDI6F8GvVCrG1LLDykEJFSH3j1vk3Zd3FE
	 FIHKUpSXxwl/z8dvxys0Xj23NPy4cdXYgrgm0t2lzk2yw25t7v6Eig7/zZLPNPCGxB
	 aOiNj2Ylw86KRG648tNUoXU/Mm5G9SNyXd1v0OiQ=
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
Subject: [PATCH 7.1 440/744] drm/i915/gem: Fix NULL deref in I915_CONTEXT_PARAM_SSEU
Date: Thu, 30 Jul 2026 16:11:53 +0200
Message-ID: <20260730141453.651900420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -856,7 +856,7 @@ static int set_proto_ctx_sseu(struct drm
 		pe = &pc->user_engines[idx];
 
 		/* Only render engine supports RPCS configuration. */
-		if (pe->engine->class != RENDER_CLASS)
+		if (!pe->engine || pe->engine->class != RENDER_CLASS)
 			return -EINVAL;
 
 		sseu = &pe->sseu;


