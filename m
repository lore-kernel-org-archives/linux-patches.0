Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144DB3054E7;
	Tue,  2 Sep 2025 13:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819712; cv=none; b=tbmWP3FflHhpOfzlsnTfDEV+DsAdrijmGB6bjWuDyhN/M8kmQkWEKr3+ddenM0cgaDyCJltdpVJBrMQsUI4D6cgDqSAnoVvgcLM67hTbdyTm0MFpW/I6x5zlKPoP8f/sf6hUQ3GBg4I3yqHcAfiAsmaxaCxRtA8VN47oriaDWPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819712; c=relaxed/simple;
	bh=n1UNF6nk5yes3ixYAUmlNNPa6roXY5qz9rCF/HUZotc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCfhqbWrDxEyU97dngmmQckJV3TIq2KfLZT6TbPwCvBIJnfw1VT/nOXM/bIMvk9/od7j+Q3rw4ss5X/TMRe5faOMl0F0iM2CbQkepvGJMrtOe8BAROPCJRExfiZlh8hCpEULVvKtxtSnNCG2kD99V+vBnJMVQRiCLqSf8Q+fL/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nt+wLLfX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nt+wLLfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E3AC4CEED;
	Tue,  2 Sep 2025 13:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819711;
	bh=n1UNF6nk5yes3ixYAUmlNNPa6roXY5qz9rCF/HUZotc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nt+wLLfX/RGky5m+BwSoMoEGWGQG6z9vRX75vOXSNWDROrdv/faOOuLYqmelAYcA3
	 y+KH60QJkxnuWp3N3kHJMhmbuuddONpUqNaa40zUR20wBvxqC1m289fql0buTV7bU3
	 k8hUSbaZOxPtgvdDUOa1ZAhixU8xNZcCzQ9QbF5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 116/142] Revert "drm/amdgpu: fix incorrect vm flags to map bo"
Date: Tue,  2 Sep 2025 15:20:18 +0200
Message-ID: <20250902131952.728700543@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit ac4ed2da4c1305a1a002415058aa7deaf49ffe3e upstream.

This reverts commit b08425fa77ad2f305fe57a33dceb456be03b653f.

Revert this to align with 6.17 because the fixes tag
was wrong on this commit.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit be33e8a239aac204d7e9e673c4220ef244eb1ba3)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
@@ -88,8 +88,8 @@ int amdgpu_map_static_csa(struct amdgpu_
 	}
 
 	r = amdgpu_vm_bo_map(adev, *bo_va, csa_addr, 0, size,
-			     AMDGPU_VM_PAGE_READABLE | AMDGPU_VM_PAGE_WRITEABLE |
-			     AMDGPU_VM_PAGE_EXECUTABLE);
+			     AMDGPU_PTE_READABLE | AMDGPU_PTE_WRITEABLE |
+			     AMDGPU_PTE_EXECUTABLE);
 
 	if (r) {
 		DRM_ERROR("failed to do bo_map on static CSA, err=%d\n", r);


