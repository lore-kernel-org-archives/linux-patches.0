Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7511885AA;
	Fri, 15 Nov 2024 06:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653779; cv=none; b=ceCaYuIn5UIfl1jpG8j3kkC9CbF8LoAaZhaG5ALi5FKPf/sZfXrTEuACUjfRrauUWZqFoEw0G3I1NMrrDalKypVrTNQ/KU+iOmb6TnXzIAYTJbHrm6LPRF4EGnqhakQlOT94oEJJl/UU0aKaKeMkhw3+jdLlogvaiEWVzniFF8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653779; c=relaxed/simple;
	bh=95+PnBtSyLTqpx4fi9kDEAadli6MSJJito0RPEZhu4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nv2Kc90X+O1ztlqWgDyL+WNr3NWH7+BoSbRRRlche9VxRHCoQn55EJKNuQ+HeneoS1bgUG+pf4I4Y9syFAbsH5ze4pLJfBXNqMNGGbz73fsbIO0GsX+WctyqbzSS0DzFc7Lvy32pog32Xde43Yb+zBChs3mW49DYNrvbZbGIHiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gosh4umh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gosh4umh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E208DC4CECF;
	Fri, 15 Nov 2024 06:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653778;
	bh=95+PnBtSyLTqpx4fi9kDEAadli6MSJJito0RPEZhu4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gosh4umhv3eKfKo4TPX5eIdfJRE2fbOA7iMggah9alJ/bKM9THjsDuu6U3zsh6YF1
	 mNGsTBFNoY/FY85wJ0IGjnwxAoY+O8OG8J1t9BeNaLOP31GHpq7pwg4SfUu5Cnm1h+
	 zeGrV6OkPd7A98vatsEdf2fZ1ChZfCzbCaacAZu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 34/82] drm/amdgpu: add missing size check in amdgpu_debugfs_gprwave_read()
Date: Fri, 15 Nov 2024 07:38:11 +0100
Message-ID: <20241115063726.793698917@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4d75b9468021c73108b4439794d69e892b1d24e3 upstream.

Avoid a possible buffer overflow if size is larger than 4K.

Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f5d873f5825b40d886d03bd2aede91d4cf002434)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -396,7 +396,7 @@ static ssize_t amdgpu_debugfs_regs_pcie_
 	ssize_t result = 0;
 	int r;
 
-	if (size & 0x3 || *pos & 0x3)
+	if (size > 4096 || size & 0x3 || *pos & 0x3)
 		return -EINVAL;
 
 	r = pm_runtime_get_sync(adev_to_drm(adev)->dev);


