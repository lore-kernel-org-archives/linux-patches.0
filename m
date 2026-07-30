Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1C3373C1A;
	Thu, 30 Jul 2026 15:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426185; cv=none; b=F+RVFWRwDryE+Ge0k6nMPSoT49O35q76bEQ2w7vu6yWMTER5FkpIwjMzGco1cageusxtVdG30vLLc9aZLuWMyOtKeQe3xcWK1YYDY+e3bGjzJlm67tf/3is4yFbIFtyOIG4g0JkEpYYNvmczUVD10Hn6vnnM6rzhZEQPgVvoTIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426185; c=relaxed/simple;
	bh=IWaxZap6V9f7WaN4ioZFeiYv0n5vOki4SGLiu1ed1zE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSYu6BKQYxGWg3mTJWw6VdME8DPWxP9x/OFQSloiqlVhl9P/o+grmCp1JvLhu8OwtH1wIWIbAh2t3pVK00gCAdtokdlnEg5YY9iOa/ADH0W/kuTgDv7qnFu/4Y7aRj3f8GIRH+NDy/9AQXD3ziGH8l5RC5nGCwjWK7eqaM+pZ1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PpB0eXAE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PpB0eXAE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684CA1F000E9;
	Thu, 30 Jul 2026 15:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426183;
	bh=Bh7Lmik0Cy5fHeqXTNT4OK0S7NrIIVlXV/Q74d8SYrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PpB0eXAEErqtv1RD73jqWf/Mslx6eFHIQ31u6gTRnXemWd75LZl36r6qLIQPos3NG
	 Cfyy+ordDEkQEQ+K5vyK3pHYTIz6MT/HJB2jKlvJKyYnLAw518SgakG2eCWEn3zaoZ
	 xBdwTLsmRqzVThQduuhb8Ddi8mAMkOFxjDG/E9+s=
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
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.12 286/602] drm/i915/gem: Do not leak siblings[] on proto context error
Date: Thu, 30 Jul 2026 16:11:18 +0200
Message-ID: <20260730141441.980842631@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

commit eed3de2acf6aa5154d49098b026710b646db67ee upstream.

After a successful BALANCE/PARALLEL_SUBMIT extension on context
creation, error during processing of next user extension leaks
the siblings[] array. Fix that.

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
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Link: https://lore.kernel.org/r/20260701073030.44850-1-joonas.lahtinen@linux.intel.com
(cherry picked from commit aa65e0a4b51b3b54b53e4142aaa2d997aa1061ff)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_context.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -771,8 +771,8 @@ static int set_proto_ctx_engines(struct
 		struct intel_engine_cs *engine;
 
 		if (copy_from_user(&ci, &user->engines[n], sizeof(ci))) {
-			kfree(set.engines);
-			return -EFAULT;
+			err = -EFAULT;
+			goto err;
 		}
 
 		memset(&set.engines[n], 0, sizeof(set.engines[n]));
@@ -788,8 +788,8 @@ static int set_proto_ctx_engines(struct
 			drm_dbg(&i915->drm,
 				"Invalid engine[%d]: { class:%d, instance:%d }\n",
 				n, ci.engine_class, ci.engine_instance);
-			kfree(set.engines);
-			return -ENOENT;
+			err = -ENOENT;
+			goto err;
 		}
 
 		set.engines[n].type = I915_GEM_ENGINE_TYPE_PHYSICAL;
@@ -802,15 +802,21 @@ static int set_proto_ctx_engines(struct
 					   set_proto_ctx_engines_extensions,
 					   ARRAY_SIZE(set_proto_ctx_engines_extensions),
 					   &set);
-	if (err) {
-		kfree(set.engines);
-		return err;
-	}
+	if (err)
+		goto err_extensions;
 
 	pc->num_user_engines = set.num_engines;
 	pc->user_engines = set.engines;
 
 	return 0;
+
+err_extensions:
+	for (n = 0; n < set.num_engines; n++)
+		kfree(set.engines[n].siblings);
+err:
+	kfree(set.engines);
+
+	return err;
 }
 
 static int set_proto_ctx_sseu(struct drm_i915_file_private *fpriv,


