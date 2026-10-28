Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215321;
	b=fR5bRo9QkbXsCQtmjnJjNYRblRKhWdF0sPkIGGZAy/vTKr88shAdKzQgXsMpahBxw/Zd
	 act/LL4/6F7iknj2r1a3kwho3xhElOmGYVjRF8eyl8HWQUW9WBOOGHoIUcgCyfuygtYGN
	 x4BYQIRTIMue1gPpSKFJevi3SOJnvVjae1LKQZLoZoJsKwBwtw9oBEB7igNqiaYqrTZ7J
	 FfRDVeUBG/iMcIGyWTgRJtQSIK7yyBSEWKdeeU7LvrhzKxDs/myktYKkRyzjXtAdMCocz
	 lg0d9Nvdrp7FSdSvuzZsW88vucOZe+jgRu4UJnRFBEWKuiC3EFWeKd+PCg8s5/Sh6uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215321;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=imAMPj9tqyMgjiPBi+LwzwEunDNCl/Oz8FAgTGzn5OA=;
	b=VHJAj+peDbGQ3dcatUiE8FSgvoRIn/f7JWiG0GyWwivHB4AlgL9ts88uXTpVSohOcC9I
	 iJ6RFxY4pCcgtu7t54wu1vfcK89A1987nnswzKCMDuNAcr6waf2ota9cOVZGvCP4Dd6hk
	 wadv+LiSEgw1MP6BwjW6bEgGtCckKDC2KuqZUtXy8tjW7SbJVhiItDAOXMNszv0wuwpb4
	 NQbtkjFzLhrBj1wVyg7E21eGdfrSnWgM3m8MPZtNAsuYQHD79uqAEt7xukXgE9FQsBt1E
	 FCDqfYFV/y3wi6L60/J+od0V1iyOF1MghKCf9wQL5VS5n2h+t+oUP6wLCAyY5qIMCBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jwzjEaRo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179A7606A31C;
	Wed, 28 Oct 2026 19:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jwzjEaRo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F7A1F01825;
	Wed, 28 Oct 2026 19:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215320;
	bh=imAMPj9tqyMgjiPBi+LwzwEunDNCl/Oz8FAgTGzn5OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jwzjEaRo0J2Si7t1ygVqyLTeB2qOh1Ql3zWrcVBuJL29+0MF1mVp9AXoWXzECpsPJ
	 5fvlK/3J/SuTFfys4Ra39mvfwuvBOvxtg8lxnskEg5zZQ70Luyo9AK78mf8fTwrZA8
	 7Ey9vYvLyhfxy3QcYBcjyJWOdTiOF35S9L1UvchQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1169/1887] drm/amdgpu: Add wrapper for freeing vbios memory
Date: Wed, 28 Oct 2026 17:54:25 +0100
Message-ID: <20261028170526.004151747@linuxfoundation.org>
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

[ Upstream commit e986e89659e18ba986db044df58f165042817dc3 ]

Use bios_release wrapper to release memory allocated for vbios image and
reset the variables.

v2:
	Use the same wrapper for clean up in sw_fini (Alex Deucher)

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 65bff2661760 ("drm/amdgpu: Release VFCT ACPI table reference")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h        |  1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c   | 20 ++++++++++++++------
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |  3 +--
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index c4287e09658fa..c8e619ae33f41 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -384,6 +384,7 @@ bool amdgpu_get_bios(struct amdgpu_device *adev);
 bool amdgpu_read_bios(struct amdgpu_device *adev);
 bool amdgpu_soc15_read_bios_from_rom(struct amdgpu_device *adev,
 				     u8 *bios, u32 length_bytes);
+void amdgpu_bios_release(struct amdgpu_device *adev);
 /*
  * Clocks
  */
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
index 61642429a0627..27e086de3686d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -84,6 +84,13 @@ static bool check_atom_bios(struct amdgpu_device *adev, size_t size)
 	return false;
 }
 
+void amdgpu_bios_release(struct amdgpu_device *adev)
+{
+	kfree(adev->bios);
+	adev->bios = NULL;
+	adev->bios_size = 0;
+}
+
 /* If you boot an IGP board with a discrete card as the primary,
  * the IGP rom is not accessible via the rom bar as the IGP rom is
  * part of the system bios.  On boot, the system bios puts a
@@ -120,7 +127,7 @@ static bool igp_read_bios_from_vram(struct amdgpu_device *adev)
 	iounmap(bios);
 
 	if (!check_atom_bios(adev, size)) {
-		kfree(adev->bios);
+		amdgpu_bios_release(adev);
 		return false;
 	}
 
@@ -148,7 +155,7 @@ bool amdgpu_read_bios(struct amdgpu_device *adev)
 	pci_unmap_rom(adev->pdev, bios);
 
 	if (!check_atom_bios(adev, size)) {
-		kfree(adev->bios);
+		amdgpu_bios_release(adev);
 		return false;
 	}
 
@@ -188,7 +195,7 @@ static bool amdgpu_read_bios_from_rom(struct amdgpu_device *adev)
 	amdgpu_asic_read_bios_from_rom(adev, adev->bios, len);
 
 	if (!check_atom_bios(adev, len)) {
-		kfree(adev->bios);
+		amdgpu_bios_release(adev);
 		return false;
 	}
 
@@ -224,7 +231,8 @@ static bool amdgpu_read_platform_bios(struct amdgpu_device *adev)
 
 	return true;
 free_bios:
-	kfree(adev->bios);
+	amdgpu_bios_release(adev);
+
 	return false;
 }
 
@@ -340,7 +348,7 @@ static bool amdgpu_atrm_get_bios(struct amdgpu_device *adev)
 	}
 
 	if (!check_atom_bios(adev, size)) {
-		kfree(adev->bios);
+		amdgpu_bios_release(adev);
 		return false;
 	}
 	adev->bios_size = size;
@@ -443,7 +451,7 @@ static bool amdgpu_acpi_vfct_bios(struct amdgpu_device *adev)
 					     GFP_KERNEL);
 
 			if (!check_atom_bios(adev, vhdr->ImageLength)) {
-				kfree(adev->bios);
+				amdgpu_bios_release(adev);
 				return false;
 			}
 			adev->bios_size = vhdr->ImageLength;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index af0922eaa7908..fda32238cc6b3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4196,8 +4196,7 @@ void amdgpu_device_fini_sw(struct amdgpu_device *adev)
 	if (amdgpu_emu_mode != 1)
 		amdgpu_atombios_fini(adev);
 
-	kfree(adev->bios);
-	adev->bios = NULL;
+	amdgpu_bios_release(adev);
 
 	px = amdgpu_device_supports_px(adev_to_drm(adev));
 
-- 
2.53.0



