Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214499;
	b=eJ7h4Hz1zYz1dIrJqq5owLvrMrzgREiGiF9+BBA8nG3hjBJPy/l/gtT//kE9zMuhVMMa
	 WygULwDMS+2/2jP+ybTNav00tswwiVogwuKup0NpXI3GTo4+eXVkzjO2jYiVQdi74+LJQ
	 4hU5DhNLl22KVz7GT116dwCa8FRtCu4Lb/w6NJCwKw0WkhW6+meeh51yyWD73X8avMffK
	 Wu2/EUkRPJsF3kRrJU5h2Izx/rCRFFskHX9S9RDTTv3W97Vv7eVU+fchaDuj4ftiitiKz
	 zvBL8bfAWjINMuK5m+ny4+QRZrVmfA8SlQ5lZ2mnivCyZynVlb7dm5G7N2LKezkQX9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214499;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bj+cplsQfY0/Pw4LUxkkrYb2FIXMFiTt5AbjKtPZcvQ=;
	b=0c3eUHC08fpJTQ5WXHSJm9BuyIQq1FbzzXAh0hdTxfPM/9hV8MBNSjpMRsVteX0S+wcH
	 WjeIXly9CcaOWoXDdnX+Vl9J0trWLouqbGQhGdgNdnNqwH7gazm9cSIoZp/o66bOuYnvu
	 eSnaxr+6OPcTD95nNc1Pw9J5Giih4bdBj6E4ApJUYENRfwWOYGpNizvuF8bft11XWo8zV
	 iI5YObKh3v1pyeaWCdI0F+sfMrouhmckS+884UrIMIeLmpWuP9c54Wf5eeG1Cg3mizeFX
	 TCbtjNK066EeSCxN6ml5Bg5HPOC4MEPlMpZM6kNtZrPBtu8yujXHNjChWyRYvc2W0Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tM4qsFnl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B137B606A338;
	Wed, 28 Oct 2026 19:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tM4qsFnl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAD61F031E0;
	Wed, 28 Oct 2026 19:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214498;
	bh=Bj+cplsQfY0/Pw4LUxkkrYb2FIXMFiTt5AbjKtPZcvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tM4qsFnl+qoWSAPUpgFUEdwBvy0Im+2WKtasIrNQT5kNMKU4ckMEWAoqA5rYSxhlc
	 5Ur+W5TU+dygl5zv8ci1jHcKnhx3fU5R4VchtkuOP/SYOxayWdH63QitsWc51NKR+N
	 4xnnheHeR268xsVz8/yKPtIsMLF7ii1dfO/qTuG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0880/1887] drm/amdgpu: Show vram vendor only if available
Date: Wed, 28 Oct 2026 17:49:36 +0100
Message-ID: <20261028170519.442975195@linuxfoundation.org>
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
index 24867e96b5209..aef76467c409f 100644
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



