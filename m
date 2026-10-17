Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9433BE63F;
	Sat, 17 Oct 2026 17:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258212; cv=none; b=oAe3LT3yKAPd3j14DeT4RkYVNnRAU05XOmaeqT42Vphjg8Sb9nLX7QA+nte4Mhs5WsR0NVgJ6kOsqWRzeGTAKyaGP772Y0DV/JGeW/Xxk2Fa4QfELnd5oAWeeMLCeIhd/Jx10lG7bWc4V/mQmtqLcf8GCoRN7OMXW1EcIlsUcS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258212; c=relaxed/simple;
	bh=EDjmUpflCw1KSuM8+lTL6/xsHY3WnAVL/CUHUjb9Y0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PM+fUJTZ4XVLJe+qbMdR7IEcGA7lc704cchnLQ6aA3yhSsn1svcYpaBBkSwHo4qRyDWLSAQ3ENQ2q+/X4iAIXs2ofPXdNCNpO4x8VFx5z3urmTVJeiW3M2E3ytYanZ0jXWSWmAII3mk9AP5fCYkt0XUGSagLay44rx5ANzNreYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PSZeMgFw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PSZeMgFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DA51F000C4;
	Sat, 17 Oct 2026 17:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258211;
	bh=PbT/o6zI61dvwlnDgma0cUVg09iX/SQ1r3OZcRV26+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PSZeMgFwuzSjVodHZ+qg6PB8gkRP69huTSm6cO6NB+DGjGpkYQOUYULzHtzKWecxa
	 4INpdifhGrSIMp/tUWhdJqzrlhqjnvlWYT04ynXU0mtfB63ws4spIbFrIbEb0qxDMx
	 nutNsmU8hIIJ6dfeKXujz0czKSPmmNxi4cDk0Y6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0810/1674] drm/amdgpu: Show vram vendor only if available
Date: Sat, 17 Oct 2026 17:51:22 +0200
Message-ID: <20261017160451.910919890@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 89a7c0bd74918f723c94c10452265e25063cba9b ]

Ony if vram vendor info is available, show in sysfs.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.7.x
Stable-dep-of: 33cc891b56b9 ("drm/amdgpu: hide VRAM sysfs attributes on GPUs without VRAM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
index 451c37d04e456..403a7c976dfa2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -212,8 +212,23 @@ static struct attribute *amdgpu_vram_mgr_attributes[] = {
 	NULL
 };
 
+static umode_t amdgpu_vram_attrs_is_visible(struct kobject *kobj,
+					    struct attribute *attr, int i)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct drm_device *ddev = dev_get_drvdata(dev);
+	struct amdgpu_device *adev = drm_to_adev(ddev);
+
+	if (attr == &dev_attr_mem_info_vram_vendor.attr &&
+	    !adev->gmc.vram_vendor)
+		return 0;
+
+	return attr->mode;
+}
+
 const struct attribute_group amdgpu_vram_mgr_attr_group = {
-	.attrs = amdgpu_vram_mgr_attributes
+	.attrs = amdgpu_vram_mgr_attributes,
+	.is_visible = amdgpu_vram_attrs_is_visible
 };
 
 /**
-- 
2.53.0



