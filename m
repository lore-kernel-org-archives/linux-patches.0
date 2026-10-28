Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215318;
	b=wgaTY14Cl/YV17UnxSBvTUQHhith54AQjcoh5KY2ifWzJCzF61QYg0hdgS1ZKhnevSTH
	 wTiP39QZY4StMej+gtDjHdChBtW+VI5jQKzFSzcRbIIMXPP4DPkbu9u1sG91CrjJDeSb+
	 rPtufi/mHurX19P/g+sgjSIM7RiF0pj45cYtKWfkPQpeAV1grAYG9g+Z9G/Mej+eoxKIF
	 8NG6UbK8lgDNfOTK+fExT3M5W40bjP5YYuQALt4i18uJrrTOb5lJwMzMC68fxPCU0Y6Iv
	 QwGwSmJc2hns/uDjiY6FUhXe16aNxnRfStGvULQ1gdieCtWNwIprZQJ4WXvuncROYkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215318;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IO9n8YvOsAsjIDXBjHk6FZy6SqVPgZ/gHfPYQKHMDJ0=;
	b=4U2/SXul9eU3lYDdp+hR+J3t2rfDtbrj4+yoSxTZ6nvjD7mYIy0CWbmBtT9Yb3lnY5Mu
	 gbdx24P+l29HK4kqcBxP8iVIyG+SmiH/8hUlDgKV+1INdwB9K+Lj7I0/UAOrFFF4IWQvg
	 3so/8WLediFXipdiGZm86WmDs9J8u4RY83SkJLzXlxFCHkpdJhmxqCN7nhwx1mXoufzJe
	 WS7dkTbagPCIQxShzT0vJw0vpvILwoY1BUuCkFrtdaMrRIUNg57x31jt47yqNEYyaL9IA
	 oBVlSuvYkBEVP9iVrj9ywpFwjSM759Kgq2DoRKzwcUhbiha+def7+Gk7uEW4ob2Ksqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZfcfQ0rW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1E5606A31D;
	Wed, 28 Oct 2026 19:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZfcfQ0rW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2561F01825;
	Wed, 28 Oct 2026 19:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215318;
	bh=IO9n8YvOsAsjIDXBjHk6FZy6SqVPgZ/gHfPYQKHMDJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZfcfQ0rW1VIWlviAvH7Fco0kVHGcXAInDDV4hWjjRK6+k8xYEmlueYH3mYlcKr6ZU
	 D8FWtZuvv+KSLOiI9LkByXg20Wz1F9kDTwCJl+Wf8XFgHyKTWXveNnSciJQLDXy8aB
	 oVXwj1hgRMUtZBcc9NK7KANN49B7YwZOAT0oLZ/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1168/1887] drm/amdgpu: Use dbg level for VBIOS check messages
Date: Wed, 28 Oct 2026 17:54:24 +0100
Message-ID: <20261028170525.982385346@linuxfoundation.org>
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

[ Upstream commit 635c659fceed82f934623188471ff604e098aab7 ]

Driver has different ways to fetch VBIOS. If one of the methods doesn't
find an authentic one, it will show misleading info messages eventhough
a subsequent method finds a valid VBIOS. Keep the message level at debug
and add device context.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 65bff2661760 ("drm/amdgpu: Release VFCT ACPI table reference")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c | 26 +++++++++++++-----------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
index 2a313964f63df..61642429a0627 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -47,35 +47,37 @@
 /* Check if current bios is an ATOM BIOS.
  * Return true if it is ATOM BIOS. Otherwise, return false.
  */
-static bool check_atom_bios(uint8_t *bios, size_t size)
+static bool check_atom_bios(struct amdgpu_device *adev, size_t size)
 {
 	uint16_t tmp, bios_header_start;
+	uint8_t *bios = adev->bios;
 
 	if (!bios || size < 0x49) {
-		DRM_INFO("vbios mem is null or mem size is wrong\n");
+		dev_dbg(adev->dev, "VBIOS mem is null or mem size is wrong\n");
 		return false;
 	}
 
 	if (!AMD_IS_VALID_VBIOS(bios)) {
-		DRM_INFO("BIOS signature incorrect %x %x\n", bios[0], bios[1]);
+		dev_dbg(adev->dev, "VBIOS signature incorrect %x %x\n", bios[0],
+			bios[1]);
 		return false;
 	}
 
 	bios_header_start = bios[0x48] | (bios[0x49] << 8);
 	if (!bios_header_start) {
-		DRM_INFO("Can't locate bios header\n");
+		dev_dbg(adev->dev, "Can't locate VBIOS header\n");
 		return false;
 	}
 
 	tmp = bios_header_start + 4;
 	if (size < tmp) {
-		DRM_INFO("BIOS header is broken\n");
+		dev_dbg(adev->dev, "VBIOS header is broken\n");
 		return false;
 	}
 
 	if (!memcmp(bios + tmp, "ATOM", 4) ||
 	    !memcmp(bios + tmp, "MOTA", 4)) {
-		DRM_DEBUG("ATOMBIOS detected\n");
+		dev_dbg(adev->dev, "ATOMBIOS detected\n");
 		return true;
 	}
 
@@ -117,7 +119,7 @@ static bool igp_read_bios_from_vram(struct amdgpu_device *adev)
 	memcpy_fromio(adev->bios, bios, size);
 	iounmap(bios);
 
-	if (!check_atom_bios(adev->bios, size)) {
+	if (!check_atom_bios(adev, size)) {
 		kfree(adev->bios);
 		return false;
 	}
@@ -145,7 +147,7 @@ bool amdgpu_read_bios(struct amdgpu_device *adev)
 	memcpy_fromio(adev->bios, bios, size);
 	pci_unmap_rom(adev->pdev, bios);
 
-	if (!check_atom_bios(adev->bios, size)) {
+	if (!check_atom_bios(adev, size)) {
 		kfree(adev->bios);
 		return false;
 	}
@@ -185,7 +187,7 @@ static bool amdgpu_read_bios_from_rom(struct amdgpu_device *adev)
 	/* read complete BIOS */
 	amdgpu_asic_read_bios_from_rom(adev, adev->bios, len);
 
-	if (!check_atom_bios(adev->bios, len)) {
+	if (!check_atom_bios(adev, len)) {
 		kfree(adev->bios);
 		return false;
 	}
@@ -215,7 +217,7 @@ static bool amdgpu_read_platform_bios(struct amdgpu_device *adev)
 	memcpy_fromio(adev->bios, bios, romlen);
 	iounmap(bios);
 
-	if (!check_atom_bios(adev->bios, romlen))
+	if (!check_atom_bios(adev, romlen))
 		goto free_bios;
 
 	adev->bios_size = romlen;
@@ -337,7 +339,7 @@ static bool amdgpu_atrm_get_bios(struct amdgpu_device *adev)
 			break;
 	}
 
-	if (!check_atom_bios(adev->bios, size)) {
+	if (!check_atom_bios(adev, size)) {
 		kfree(adev->bios);
 		return false;
 	}
@@ -440,7 +442,7 @@ static bool amdgpu_acpi_vfct_bios(struct amdgpu_device *adev)
 					     vhdr->ImageLength,
 					     GFP_KERNEL);
 
-			if (!check_atom_bios(adev->bios, vhdr->ImageLength)) {
+			if (!check_atom_bios(adev, vhdr->ImageLength)) {
 				kfree(adev->bios);
 				return false;
 			}
-- 
2.53.0



