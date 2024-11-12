Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0B820E33B;
	Tue, 12 Nov 2024 10:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407061; cv=none; b=R/vq9e/wzw4DBMwsDQgBLc3H++GImS2aA37XMWYe05VJZqsGoHfj3oDwUsMF46oxDro3JPTLz2kpfCqX2zclso5HZ3crDF2ewgopS5X3HdVTHzWH52gbZ+EkOICzFcLYsnJM0N89ReGGE3ToyVb1fVd1jsTliLTnaeMMryqmHyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407061; c=relaxed/simple;
	bh=0ZHWuKYW9rFqcWG3Rhc7B4SsNFerwt4XR4FV7NI3Yh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9ZcF64P5IIbD0Ky2dQahnLoF0pdp1SE11LXnqO4NrYdZ2wU1oIuhWaX01AGR9x+sELSkPBHeA9dzlhV4sHEEeODAq3c26G9mZ/t9o/A573fF/22EzItwq2o0nffaJSqyA72eFVvnm8ExOPByV43xNMo4TK7BpZP9HRWqijUdn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1WkQXlqH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1WkQXlqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEACBC4CECD;
	Tue, 12 Nov 2024 10:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407061;
	bh=0ZHWuKYW9rFqcWG3Rhc7B4SsNFerwt4XR4FV7NI3Yh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1WkQXlqHRQQsjqr0rodonQmIIE0JLLJZg9NUrKyZd1ZSyExakZvXBj+qcT85G5iAV
	 k3rfo34mNrqUyPFGf9jh0V1Tc4E4lma4Za/x+UNQRJYECIOx7eTLw/qF3lCvkW6XRs
	 im4b6cy2I+O1Fq6R4UyJtZT2IwqPoC8b8beEAQBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 39/76] drm/amdgpu: Adjust debugfs eviction and IB access permissions
Date: Tue, 12 Nov 2024 11:21:04 +0100
Message-ID: <20241112101841.273345621@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit f790a2c494c4ef587eeeb9fca20124de76a1646f upstream.

Users should not be able to run these.

Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7ba9395430f611cfc101b1c2687732baafa239d5)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -1523,11 +1523,11 @@ int amdgpu_debugfs_init(struct amdgpu_de
 	amdgpu_securedisplay_debugfs_init(adev);
 	amdgpu_fw_attestation_debugfs_init(adev);
 
-	debugfs_create_file("amdgpu_evict_vram", 0444, root, adev,
+	debugfs_create_file("amdgpu_evict_vram", 0400, root, adev,
 			    &amdgpu_evict_vram_fops);
-	debugfs_create_file("amdgpu_evict_gtt", 0444, root, adev,
+	debugfs_create_file("amdgpu_evict_gtt", 0400, root, adev,
 			    &amdgpu_evict_gtt_fops);
-	debugfs_create_file("amdgpu_test_ib", 0444, root, adev,
+	debugfs_create_file("amdgpu_test_ib", 0400, root, adev,
 			    &amdgpu_debugfs_test_ib_fops);
 	debugfs_create_file("amdgpu_vm_info", 0444, root, adev,
 			    &amdgpu_debugfs_vm_info_fops);


