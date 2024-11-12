Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0162213ECF;
	Tue, 12 Nov 2024 10:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408253; cv=none; b=k8Gw+QJRDq4jC8M5B5FlOkyeFBLqou3XTyBMYuzrbRnmUSg3UNuQP0IIuwF4g3ogF15UqQzJtRB16W4+TatolQERzCvssBgVZjlMt51PBee7EaObYXp4WHXEEb7vpppRHI2y4ykVzmPsLhN9NxECxDfbaXV8X0Zs662G4jfhbqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408253; c=relaxed/simple;
	bh=GGNlUJKGG77M1UMnjRfY2Ed3roYC3NmW5h/9qSR4qu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sK93Tz4HC5jmqpGfPVSjPRYrHNiftBTJVtB9S3S3HxHasnt/AKgm9KHUIOuRLfXqDmx6Tsz3wrlW0fFn41rZtA+kz5g5JOxBLEi3dA+6IrIS5bV3TBcXi0XdfiLTrPBkStwcsXEMUcwCtiQ756Ydo74caZswrXdzGQ8WPZDaZVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/VroZWf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/VroZWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0508EC4CECD;
	Tue, 12 Nov 2024 10:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408252;
	bh=GGNlUJKGG77M1UMnjRfY2Ed3roYC3NmW5h/9qSR4qu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/VroZWflnSNKMKPk+Ba9ML1WXJw4FywaW1fJw+qZMsBFITGcKhOxmQcB1ZxBxVK5
	 scGm/PaKpccgnwvUMhrLy8oYh+lyfS5GMp/zbTxzBEhTLCpWDzxMzwdoXM2hO0TS0y
	 6FuYkMul3v2a0511rsdjnFvqV2nNXd6TrloRJesk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 107/184] drm/amdgpu: Adjust debugfs eviction and IB access permissions
Date: Tue, 12 Nov 2024 11:21:05 +0100
Message-ID: <20241112101904.974431373@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2194,11 +2194,11 @@ int amdgpu_debugfs_init(struct amdgpu_de
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


