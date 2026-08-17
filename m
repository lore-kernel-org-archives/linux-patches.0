Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446C23DD851;
	Mon, 17 Aug 2026 15:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979316; cv=none; b=VBpW8lFPFU6Ikl/AtHTcfNiPrXwjmA2A1u2unDysgbv7+N1JFJ3SmbAb4PN1qieBuisKIhEFbOulue8HIBcIBdttiNffTcKjN/CG5aXEYlFOcvif9VUS+Cou1W0SMQ5gmLyZAwd0dCquIXMUYi7BR1DeRL2V7d34kfh1b7nN3uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979316; c=relaxed/simple;
	bh=cSZh55Iqv9rXlo6lsCJX8xYlhj5HH4IKKA34igVaPNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqAtUwWmJnVBxbPvNvCZJ2KbxcacH5jhJn5DnuN7IpzIv8Y/FW6r2KQtOA2gXAL/orwqkx/3bD/MBSAQbotyN/zg0dQEEv5fHfSUQv/+OxFOe2ix06t069AyKodJrbvBtbdn/UDsu+8Vm/6C3IBZL29qE1DEdZgKZQRVYcK9Pns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWsK+UK4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWsK+UK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5893A1F000E9;
	Mon, 17 Aug 2026 15:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979314;
	bh=1rI5O8OmhWd4kLhmPY5C/+zSM+dhB47Ea6js42Ui26A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rWsK+UK4CWnb6efmReqqAJqPBhRp/nAtIJ/wJLVRJjGuFEowS2lejuj0xd5K/+C8I
	 dmqkLogqMeG5OQ/TXtagYe9eTNtUyVmWc/ZDLVE8OSaa4AQHq5CpkdfEkQ7pDd8wbY
	 yxZOHLFXkOw+qR2q9KySafWh09JfGozvr0VMgLYA=
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
Subject: [PATCH 6.1 182/609] drm/i915/gem: Do not leak siblings[] on proto context error
Date: Mon, 17 Aug 2026 15:27:58 +0200
Message-ID: <20260817132550.157618467@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -768,8 +768,8 @@ static int set_proto_ctx_engines(struct
 		struct intel_engine_cs *engine;
 
 		if (copy_from_user(&ci, &user->engines[n], sizeof(ci))) {
-			kfree(set.engines);
-			return -EFAULT;
+			err = -EFAULT;
+			goto err;
 		}
 
 		memset(&set.engines[n], 0, sizeof(set.engines[n]));
@@ -785,8 +785,8 @@ static int set_proto_ctx_engines(struct
 			drm_dbg(&i915->drm,
 				"Invalid engine[%d]: { class:%d, instance:%d }\n",
 				n, ci.engine_class, ci.engine_instance);
-			kfree(set.engines);
-			return -ENOENT;
+			err = -ENOENT;
+			goto err;
 		}
 
 		set.engines[n].type = I915_GEM_ENGINE_TYPE_PHYSICAL;
@@ -799,15 +799,21 @@ static int set_proto_ctx_engines(struct
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


