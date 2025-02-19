Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C7728629E;
	Wed, 19 Feb 2025 09:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957290; cv=none; b=kpXN+5QuNY6k7nIyOlID9aOiP0TwRqr6mc6d6W0n05KBP+rl21c/3XGkZzSHJdV/2fAJIuB/EcrlsFvIHdOh2a3JCoEej9Uz4+sChrTidI5nEBoHHUGGMbJwmpbkKpn7j/RbwgZji5TxB6wYtXeCGmEqzsPBtmUMQtGU9RGBiAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957290; c=relaxed/simple;
	bh=1rMtAGpzfxIhs2LUAgnARlwuxweml2qTxXBYHfPPnCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cb9sPiSwsiTYkeW/lTsMb/dmy2CAXMD4cP5jgLFFW/xFIAWdP0/kLKi+scXix5+iQ2zjhTWLc/qj4EUPLGKbKUXiwH60KBqvz6lapWac/EQOXe2/RzkSsXacJrFwDz7Y7/z9kkST3TFFD0bqWE+mW7JgMYyP8Np1UrhYpFhclaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYCNr4xI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYCNr4xI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB85C4CED1;
	Wed, 19 Feb 2025 09:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957290;
	bh=1rMtAGpzfxIhs2LUAgnARlwuxweml2qTxXBYHfPPnCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JYCNr4xIq2+RQG2HIVqjyz4zZl5+dNXiyVPVujg6Gm3/rlyjSGhm3N4yAIrD/3Zns
	 O7igfXccs/Ps0N1vLqY2PPXg5qw7rBQ6eGoRHv1S3i5GS+6WwyZIDKbjbkm87f7Vo3
	 mhZlyb9t07bsTGcJ5GdKsMqIMQQc2m/5elwtXeCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Mikolaj Wasiak <mikolaj.wasiak@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 474/578] drm/i915/selftests: avoid using uninitialized context
Date: Wed, 19 Feb 2025 09:27:58 +0100
Message-ID: <20250219082711.652419563@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Karas <krzysztof.karas@intel.com>

[ Upstream commit 53139b3f9998ea07289e7b70b909fea2264a0de9 ]

There is an error path in igt_ppgtt_alloc(), which leads
to ww object being passed down to i915_gem_ww_ctx_fini() without
initialization. Correct that by only putting ppgtt->vm and
returning early.

Fixes: 480ae79537b2 ("drm/i915/selftests: Prepare gtt tests for obj->mm.lock removal")
Signed-off-by: Krzysztof Karas <krzysztof.karas@intel.com>
Reviewed-by: Mikolaj Wasiak <mikolaj.wasiak@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/iuaonpjc3rywmvhna6umjlvzilocn2uqsrxfxfob24e2taocbi@lkaivvfp4777
(cherry picked from commit 8d8334632ea62424233ac6529712868241d0f8df)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/selftests/i915_gem_gtt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c b/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c
index e050a2de5fd1d..e25f76b46b0a4 100644
--- a/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/selftests/i915_gem_gtt.c
@@ -164,7 +164,7 @@ static int igt_ppgtt_alloc(void *arg)
 		return PTR_ERR(ppgtt);
 
 	if (!ppgtt->vm.allocate_va_range)
-		goto err_ppgtt_cleanup;
+		goto ppgtt_vm_put;
 
 	/*
 	 * While we only allocate the page tables here and so we could
@@ -232,7 +232,7 @@ static int igt_ppgtt_alloc(void *arg)
 			goto retry;
 	}
 	i915_gem_ww_ctx_fini(&ww);
-
+ppgtt_vm_put:
 	i915_vm_put(&ppgtt->vm);
 	return err;
 }
-- 
2.39.5



