Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216765;
	b=eWqrUX+pt7Yg5OsFcRpP6Dw+34fHP4IbNPFEt3LMjS3sUZkjvqm8cY6xzEO4xXw48XD7
	 ax+EMDeG0Sbz/FRKYoqosnB4Wj4kpJEIKqSSFEd4NxbkyylpankLyeuwIK9a2VyKTK7H6
	 x/xWc5EgVARX41fNebi5xsAklrppLIfSXafSqCj2Ht+2GTWgs664BKBEjrNU5suU7bzUo
	 Yw8Eiha+ms/CE1rqA0SeH6+/zkaM8lYYfC581oQUoMryAY2ykXfpsHJvD0Rd6u3Z7yTNG
	 HyPkJPEIveguT6uMzUff2PI1Rdc1qdiAUaSfzGsvvPd0MvHO2EQmZPu9+qVv0KXk12A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216765;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bylWdeluuBxKH235aUnz/AlhYiHC6UhBbi5ggGvK8NU=;
	b=JrIg0MTC58ioNS0PGluTQtRwpeeKGN5UaYaSrLmNA8DSbpA5wP6lSTkV3t+ZFs3MNQb9
	 wmAOj7vwtou73VTTWqXPRTQwQZaAAXEPC+iDyX/hzZQMd9VSTIXxukb/cewAPISHPZ/9m
	 PmL2dJZlTHxxUsBSVf5MBLbNilYeDcAFPdCWYA3OtlBK38NrfwiyFgHHIRPEfRGdzL1Uj
	 dKBE5wbhJS9fBlQx0Gax6aG3o/K2CC5/FtTVQJavQr+TZmM3uPYKQ7YfJNk1SD83FEoZL
	 LG13t9IyIrvi6fHxAdyfOzLDqEQCS4t8Oo6O+rtirdPBhM+edwbHHi37UDOhs6+QsBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VBjPtExK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D981606A31A;
	Wed, 28 Oct 2026 19:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VBjPtExK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85E71F01825;
	Wed, 28 Oct 2026 19:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216765;
	bh=bylWdeluuBxKH235aUnz/AlhYiHC6UhBbi5ggGvK8NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VBjPtExKHYyMjYmbNy/Fn3bDnpt1fC1QYjdxAHIzN0AsciB1NIaKG+FNkyEApxVWl
	 EYBr2USF9ILNzWF+H47l0GoBVZs3iGt4xkAqEnRA6vpEsZMt0rNB3AvGS20e3XJo1I
	 HE9K77N4oFNUn/JRwuGybw9+Wt8iHb8nQGlTWUx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Le Ma <le.ma@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1671/1887] drm/amdgpu: Add vbios attribute only if supported
Date: Wed, 28 Oct 2026 18:02:47 +0100
Message-ID: <20261028170537.483027372@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 184d83848242b2465b466a0a8e6eb58f1df10407 ]

Not all devices carry VBIOS version information. Add the device
attribute only if supported.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Le Ma <le.ma@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 6229898d46c0 ("drm/amdgpu: fix buffer overflow during vBIOS update")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c | 9 +++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.h | 1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c   | 5 +++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c      | 2 --
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
index 816014ea53817..6511ece584760 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
@@ -1793,6 +1793,15 @@ const struct attribute_group amdgpu_vbios_version_attr_group = {
 	.attrs = amdgpu_vbios_version_attrs
 };
 
+int amdgpu_atombios_sysfs_init(struct amdgpu_device *adev)
+{
+	if (adev->mode_info.atom_context)
+		return devm_device_add_group(adev->dev,
+					     &amdgpu_vbios_version_attr_group);
+
+	return 0;
+}
+
 /**
  * amdgpu_atombios_fini - free the driver info and callbacks for atombios
  *
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.h
index 4153d520e2a36..b639a80ee3fca 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.h
@@ -217,5 +217,6 @@ int amdgpu_atombios_get_data_table(struct amdgpu_device *adev,
 
 void amdgpu_atombios_fini(struct amdgpu_device *adev);
 int amdgpu_atombios_init(struct amdgpu_device *adev);
+int amdgpu_atombios_sysfs_init(struct amdgpu_device *adev);
 
 #endif
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 5f6e5a5032675..f75937cba2953 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3984,6 +3984,11 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 	/* Get a log2 for easy divisions. */
 	adev->mm_stats.log2_max_MBps = ilog2(max(1u, max_MBps));
 
+	r = amdgpu_atombios_sysfs_init(adev);
+	if (r)
+		drm_err(&adev->ddev,
+			"registering atombios sysfs failed (%d).\n", r);
+
 	r = amdgpu_pm_sysfs_init(adev);
 	if (r) {
 		adev->pm_sysfs_en = false;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 87871f5f199eb..7a19c3e73209e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2856,12 +2856,10 @@ static struct pci_error_handlers amdgpu_pci_err_handler = {
 
 extern const struct attribute_group amdgpu_vram_mgr_attr_group;
 extern const struct attribute_group amdgpu_gtt_mgr_attr_group;
-extern const struct attribute_group amdgpu_vbios_version_attr_group;
 
 static const struct attribute_group *amdgpu_sysfs_groups[] = {
 	&amdgpu_vram_mgr_attr_group,
 	&amdgpu_gtt_mgr_attr_group,
-	&amdgpu_vbios_version_attr_group,
 	NULL,
 };
 
-- 
2.53.0



