Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E8520899D;
	Tue, 12 Nov 2024 10:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407370; cv=none; b=p+A5J64dCOlYX1Av0vPjfuXSuTdGfn/xEHUUAXXGPemhpnEDKGjqPIVj28glHIExUlL3YrgdmGSBRvVf1Fq9Yv4yoG1sUFkDlFTqKOkIW+iNx7+Ez5ME2EVxDcp7ZXYKtb1VLPhKzt5MxuSIiGvjBXKT+o84lPeBRwcCyMFR9V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407370; c=relaxed/simple;
	bh=ZRZTsWnLE1ZOVWwa6D8t8zNW2X0R2vTXZmpKpLesbJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uE+w3abmMfGHcyykazoaY74MgW8TixwUgETpIP6tXorRhxTFJJky0Rgojtg9pI7rgf7xSYDx6tevJACPzDGDS0tcFGZ0uRSMTiT0yFHUlsDs4VCbpm9yaW9j5dj0K2HFewrydx1k4xvIRAclIWvDIa8ZqaJ4kc8mbs6sUqUIDs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sb920ccX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sb920ccX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBCA1C4CECD;
	Tue, 12 Nov 2024 10:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407370;
	bh=ZRZTsWnLE1ZOVWwa6D8t8zNW2X0R2vTXZmpKpLesbJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sb920ccXMjIsxpSddUlA4N6NJJn/+ecrDgkdd4nEyMXl4zAaKdSIciUrn4b2Y5eUj
	 AcHBpoYvlDnvYXMBssB7Moe4m4Le8orx50KvYuMjUSoc3/lGll+ZwqFNFK6XcSKhul
	 oYDK4PjSNyC2khBX3w7LgfmK9Xwvcnx8rEPhuiME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 56/98] drm/amdgpu: Adjust debugfs eviction and IB access permissions
Date: Tue, 12 Nov 2024 11:21:11 +0100
Message-ID: <20241112101846.401607571@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2009,11 +2009,11 @@ int amdgpu_debugfs_init(struct amdgpu_de
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


