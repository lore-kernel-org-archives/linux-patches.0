Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC2821745F;
	Tue, 12 Nov 2024 10:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407773; cv=none; b=F+Bgq9nv2+TuaIbGq9DPFfm7O30G4cEQVBQfcOkpUUAuu6jl9++vEjk7CBJPfmubFx3eg4Pjvu18dUeCUfPNrCq9jGp2B+auqG1jI2BkeX2tIayKUqm+dOBXs4EmcmdbKqJt2XzYdID1Xd865Pw17V4GBqEHhTKjV6JFbzOjPcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407773; c=relaxed/simple;
	bh=aRWOcev3gX0yUHdJxEhAAQz60mtovqYzodhd779e3dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DupQ3/JioyaJF5Z6hmMZWA2bLJFAlF2UPu7l7GRGVZjCElRr1kFh84cVU1dlzJyfZv97UJ76Uo4EBU2Wy1ZWuNi11PjV683UPOr0vE91VFf7Wx7LgToK1PBvanS7jHMJ2vhuFvWltVQKpYbsfLbVVEMxqUs5jkzMHLagEn4cWV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKn0Q31l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKn0Q31l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194C4C4CED7;
	Tue, 12 Nov 2024 10:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407773;
	bh=aRWOcev3gX0yUHdJxEhAAQz60mtovqYzodhd779e3dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QKn0Q31lAG6+w5jFt0ao6hzNu1icEvUZAiar5z3eW2HHtLjxaJDEX9b9JtUhYPwWY
	 HPR9uJ/3iSVeGBdtb68F7vA4L0WDZGLiu/Z7VRxCYId6LZjcsMu3JEOZUgf0vclapw
	 ljccIRLXARCUUf+lKNWhM866wwUYwQE1tWbOtZ+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 078/119] drm/amdgpu: Adjust debugfs register access permissions
Date: Tue, 12 Nov 2024 11:21:26 +0100
Message-ID: <20241112101851.700941300@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit b46dadf7e3cfe26d0b109c9c3d81b278d6c75361 upstream.

Regular users shouldn't have read access.

Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c0cfd2e652553d607b910be47d0cc5a7f3a78641)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -1641,7 +1641,7 @@ int amdgpu_debugfs_regs_init(struct amdg
 
 	for (i = 0; i < ARRAY_SIZE(debugfs_regs); i++) {
 		ent = debugfs_create_file(debugfs_regs_names[i],
-					  S_IFREG | 0444, root,
+					  S_IFREG | 0400, root,
 					  adev, debugfs_regs[i]);
 		if (!i && !IS_ERR_OR_NULL(ent))
 			i_size_write(ent->d_inode, adev->rmmio_size);


