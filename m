Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907931DE2C0;
	Wed, 19 Mar 2025 14:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394955; cv=none; b=faVM3PbxpH8W2PV2H4aw1lyUg+9YA0ieovQbyTuZcFSaUakWiWCzIKpvyPYHFxtiafbq5+Ky0R16vyS4FLhSLhamr/XHlvzKyiLP8BiGqjQt2Jg8oxcydKxWeiIm65ci48ky5Ug0uOt+qqhdQpF5vJEnVME6BK5nTDnSn7dIbjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394955; c=relaxed/simple;
	bh=bwpvQDk5+bIJo58sPCJ4iVSI9qyaQN/z7tI5aQKitNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBFvcxdegtq3oXlBH5a8AWaEvG6a9cz7rXtBJmfv5ox4qCDThcQ3l5CJVM+6TYJzuN+P9KBYWTS4O9TZ05Y/rhdjTQMujlYvg32y6s3ozrXGgRxj99WiJGtNJ+h/oOdMlkobv0brf0YoWT6pjuDWsBBL58FY/rOPy6pOMUYYNCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fo7l2gxc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fo7l2gxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680E6C4CEE4;
	Wed, 19 Mar 2025 14:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394955;
	bh=bwpvQDk5+bIJo58sPCJ4iVSI9qyaQN/z7tI5aQKitNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fo7l2gxcopZAdSS/PiWgokv/Px9IBTG8d/Y3eH4KvlFRqblylRCq4afuELYtgi5r5
	 wqyT+jaSnfoqm8WKZkCF5So09GU1IdEKVvOO+A1LcW5wMFJFYnJ8ULyqO6hkzxbGUc
	 howNiRo/ihRWkQDqFV5sJY14S1VEWXiJcKB/jLmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boyuan Zhang <Boyuan.Zhang@amd.com>,
	Sunil Khatri <sunil.khatri@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 181/241] drm/amdgpu/vce2: fix ip block reference
Date: Wed, 19 Mar 2025 07:30:51 -0700
Message-ID: <20250319143032.205877086@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit ded6ad4c6e2005e959ea09abba16c451433dd34b upstream.

Need to use the correct IP block type.  VCE vs VCN.
Fixes mclk issues on Hawaii.

Suggested by selendym.

Fixes: 82ae6619a450 ("drm/amdgpu: update the handle ptr in wait_for_idle")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3997
Reviewed-by: Boyuan Zhang <Boyuan.Zhang@amd.com>
Cc: Sunil Khatri <sunil.khatri@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 02438acd252395628d74cfac692efbb676d21521)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vce_v2_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vce_v2_0.c b/drivers/gpu/drm/amd/amdgpu/vce_v2_0.c
index c633b7ff2943..09fd6ef99b3d 100644
--- a/drivers/gpu/drm/amd/amdgpu/vce_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vce_v2_0.c
@@ -284,7 +284,7 @@ static int vce_v2_0_stop(struct amdgpu_device *adev)
 		return 0;
 	}
 
-	ip_block = amdgpu_device_ip_get_ip_block(adev, AMD_IP_BLOCK_TYPE_VCN);
+	ip_block = amdgpu_device_ip_get_ip_block(adev, AMD_IP_BLOCK_TYPE_VCE);
 	if (!ip_block)
 		return -EINVAL;
 
-- 
2.48.1



