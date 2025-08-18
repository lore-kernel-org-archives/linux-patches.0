Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D478731E0FF;
	Mon, 18 Aug 2025 13:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522625; cv=none; b=NR2I/KNIEQ9pq0qfzDnXEZS4nMWadm7sigRF7Ukk1daUuRtDOZqCQQno9M2GPcpYryoDuKTamfJp/unw1ITUluCsJFZxBlaJKp9ytUfq8P8hKFRcQymRvqqk6jmW9wv9Ax1sd01K4dYE6SdrsDqKNwyGbkNB2nW6wNUTOn4zMJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522625; c=relaxed/simple;
	bh=5CZnMHRIZ5mK0/cbDMAj1oaIHbnP7y0L6vqo5YGYdSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7HD7/+g9DP4jlNvZaOA2UCGmC7XuHeJtMmCnBPyQwk6JkR3rpVrotZSRyONl9Y+rzVjLkHuKtWGEbtnw1a7Ck0xGD5vjs2qng5RuXF+fh8f3VJrbMbFWs+PvPAzv7QJPjpmr9WfurCg1z8tJqEuvfvAxUOtI9fHhZljFg1xB+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wm9ZKDYc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wm9ZKDYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE073C4CEEB;
	Mon, 18 Aug 2025 13:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522625;
	bh=5CZnMHRIZ5mK0/cbDMAj1oaIHbnP7y0L6vqo5YGYdSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wm9ZKDYcCMZWdbSMA+ytOq3gqMI/qcwNST2AfcGu46ZYJuMQ2qr/+0hruIc8RFhvX
	 TkY91cbtaw7lfGIfcfncXZepmPCWVAgHd1Zj0n1h4PLg/Dc2zIYsczOOA1NQZs8PsI
	 WSJ/kUUZBgOeaMNICX43jcFPfz5cX8e88FNA9NAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Xiao <Jack.Xiao@amd.com>,
	Likun Gao <Likun.Gao@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 372/444] drm/amdgpu: fix incorrect vm flags to map bo
Date: Mon, 18 Aug 2025 14:46:38 +0200
Message-ID: <20250818124502.842948106@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Xiao <Jack.Xiao@amd.com>

[ Upstream commit 040bc6d0e0e9c814c9c663f6f1544ebaff6824a8 ]

It should use vm flags instead of pte flags
to specify bo vm attributes.

Fixes: 7946340fa389 ("drm/amdgpu: Move csa related code to separate file")
Signed-off-by: Jack Xiao <Jack.Xiao@amd.com>
Reviewed-by: Likun Gao <Likun.Gao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b08425fa77ad2f305fe57a33dceb456be03b653f)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
index 02138aa55793..dfb6cfd83760 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
@@ -88,8 +88,8 @@ int amdgpu_map_static_csa(struct amdgpu_device *adev, struct amdgpu_vm *vm,
 	}
 
 	r = amdgpu_vm_bo_map(adev, *bo_va, csa_addr, 0, size,
-			     AMDGPU_PTE_READABLE | AMDGPU_PTE_WRITEABLE |
-			     AMDGPU_PTE_EXECUTABLE);
+			     AMDGPU_VM_PAGE_READABLE | AMDGPU_VM_PAGE_WRITEABLE |
+			     AMDGPU_VM_PAGE_EXECUTABLE);
 
 	if (r) {
 		DRM_ERROR("failed to do bo_map on static CSA, err=%d\n", r);
-- 
2.50.1



