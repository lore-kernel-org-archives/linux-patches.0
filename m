Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4BE3BF2FF;
	Thu, 15 Jan 2026 17:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497284; cv=none; b=ZBpDFzv3hKDpWn7AMGpOWSuptXoBMOI1wIGa1JBuLblYApP/KmXIuQbIeQxLdt4J6wovVtrPu9Bp/Gt2VaZxU6St0P/1Caiwn6frJAHjc0+02YJ3G4H6TJ5tVcqF7hpS3C4YX8RMySY7Ctdqtwz87b6T0+A+Na2zT12Nph0dVb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497284; c=relaxed/simple;
	bh=CaFYCpxqX7eheg7m4kdWllnucWP2U+XDGt4tdOF3YCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVYWMxwBuw5R2HdOYct4v+i87wdSDHI2jyHB6sDX8vzvgvGomjWH1fuj6Zjbb7siusWtjDhtQf7qjlDDQSIO5hvyKHAOF2Q7xosM8NS5A4EWtZFkWRpOJUM9sxxlWvy9GQphPP1m0adWTzIcjrk9KJDmUh0UNDLMDbjQDG8koAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NURgDnCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NURgDnCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C313C116D0;
	Thu, 15 Jan 2026 17:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497283;
	bh=CaFYCpxqX7eheg7m4kdWllnucWP2U+XDGt4tdOF3YCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NURgDnCcnwgMnB9uYR6QAjLd5W/nKF6MRi2RGz45Lh3cqi5LwLpyxpzLtFVB5ZPpR
	 kl9zyleQO+u7+vor7hDU02sf/oLvYBTSwTWLbm8jVFvCBC+lMCKh5t8fbhjnYc1CZb
	 lXpyG6C5hFnI1koX3AGvgomDko2bM31Y6GFfuPns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Song <songkai01@inspur.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/554] drm/i915/selftests: Fix inconsistent IS_ERR and PTR_ERR
Date: Thu, 15 Jan 2026 17:41:12 +0100
Message-ID: <20260115164246.467679728@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Kai Song <songkai01@inspur.com>

[ Upstream commit fc7bf4c0d65a342b29fe38c332db3fe900b481b9 ]

Fix inconsistent IS_ERR and PTR_ERR in i915_gem_dmabuf.c

Signed-off-by: Kai Song <songkai01@inspur.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211022120655.22173-1-songkai01@inspur.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c
index 4a6bb64c3a354..3cc74b0fed068 100644
--- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c
@@ -102,7 +102,7 @@ static int igt_dmabuf_import_same_driver_lmem(void *arg)
 	obj = __i915_gem_object_create_user(i915, PAGE_SIZE, &lmem, 1);
 	if (IS_ERR(obj)) {
 		pr_err("__i915_gem_object_create_user failed with err=%ld\n",
-		       PTR_ERR(dmabuf));
+		       PTR_ERR(obj));
 		err = PTR_ERR(obj);
 		goto out_ret;
 	}
@@ -158,7 +158,7 @@ static int igt_dmabuf_import_same_driver(struct drm_i915_private *i915,
 					    regions, num_regions);
 	if (IS_ERR(obj)) {
 		pr_err("__i915_gem_object_create_user failed with err=%ld\n",
-		       PTR_ERR(dmabuf));
+		       PTR_ERR(obj));
 		err = PTR_ERR(obj);
 		goto out_ret;
 	}
-- 
2.51.0



