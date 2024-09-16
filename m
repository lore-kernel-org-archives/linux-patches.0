Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4614C14AD19;
	Mon, 16 Sep 2024 12:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488159; cv=none; b=ajcZ6kWoGR3GXpAbz6yIu9/sQ0SEW+3pyH3WH/baPr4AShK9nnr0slADY7Mmec2ieXRl83q2RH4OL3bfpwyHbDmGWLaNNlCqdkpy/b8K5tWc3v+v5pp7gJ21nKYpRBA2QueMWPQPd7bcog20QwOgCjXOJOomeT9oej9LZE8W16M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488159; c=relaxed/simple;
	bh=IdS+GGEyy90VnIDqJPCLvBlSGhoP9p5PoBgBnCOOiNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCH+PEErAMZbtqRZjUyEaXmxnXdD4ifvIS/Wb/k8OzQpoomH6xrVbUAYkfR3yDgoPpZezJZaEFH5/GGlrQq2TM8qKBVjAVttmOSF4pAeJ03l4JFw9yEIvS3W47EtpwX0BDZsmwnHybeD6V56hxLnlj8O/k1kAgGHWMm9rm9oYLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t3AQtgFx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t3AQtgFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB572C4CEC4;
	Mon, 16 Sep 2024 12:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488159;
	bh=IdS+GGEyy90VnIDqJPCLvBlSGhoP9p5PoBgBnCOOiNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t3AQtgFxHHHC9zWA8PSxSCDAcy0Z5hMmrGP3VCVMsUyaHcOlFIMI7ZUzdaHe0ifqZ
	 GwdpNSk7MTqsVfXzFG6DgJlTYujtjjZ3uM9WjM7/sDDxCH7+bjy6GBXstQXaK/cOhi
	 0cElwGx7khDVbydJHNE2QTqo/fjw8iKvAU9/8Y64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yinjie Yao <yinjie.yao@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 016/121] drm/amdgpu: Update kmd_fw_shared for VCN5
Date: Mon, 16 Sep 2024 13:43:10 +0200
Message-ID: <20240916114229.458767597@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinjie Yao <yinjie.yao@amd.com>

[ Upstream commit 507a2286c052919fe416b3daa0f0061d0fc702b9 ]

kmd_fw_shared changed in VCN5

Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit aa02486fb18cecbaca0c4fd393d1a03f1d4c3f9a)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
index 1a5439abd1a0..c87d68d4be53 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vcn.h
@@ -461,8 +461,11 @@ struct amdgpu_vcn5_fw_shared {
 	struct amdgpu_fw_shared_unified_queue_struct sq;
 	uint8_t pad1[8];
 	struct amdgpu_fw_shared_fw_logging fw_log;
+	uint8_t pad2[20];
 	struct amdgpu_fw_shared_rb_setup rb_setup;
-	uint8_t pad2[4];
+	struct amdgpu_fw_shared_smu_interface_info smu_dpm_interface;
+	struct amdgpu_fw_shared_drm_key_wa drm_key_wa;
+	uint8_t pad3[9];
 };
 
 #define VCN_BLOCK_ENCODE_DISABLE_MASK 0x80
-- 
2.43.0



