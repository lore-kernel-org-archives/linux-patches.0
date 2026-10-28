Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211459;
	b=rTfQ8hg+Ix4POmtwmHf0v+pB//PZb/odOhLjwjuX+ubUmCaUR2SENUCRBzkcflQKvIOg
	 gral6bFaKK+5b1vOLEHJODWyAnW5/gsqFKEBUeXLD3VTSivxXnHR2xeOnhIBX2EJDRI1j
	 twSvE8CNc0eIKasvZHXBKOAze0LgXK8tFV3l0HNQH7O7zSln8O4Ds7UnXd7Lni5RLeo/0
	 m1eNhmF120aQfND1Rt84JLDza4YBZZkF3ZjxbnhqKBaeeyd7Yfejn07yHCT8BKdNLbpzb
	 FcAmi/AhBIFvqJBvqNPVmDo5lVmep2GPqbLjwjErVuKBapJXS1dtGYbQndrl+hHzSdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211459;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=yCdgsdmklSC1El5bFBHePrpyuZNZ9UinJGVkWHbMyrk=;
	b=VBLQmhiRFgoGVYKdIKCUWQklQ+877fus1YIGiHI22HgbmX+PvH7wQP+7VYC5hAxym+es
	 HOQSA+1qCdz9Y/7Wo0jfa6Vi3HTnqoOMwWH91zF6/0/UZulsKQRZKG0n82nvs0Fmqd95B
	 VTFTgNvcoXuVcLZwXJ6wb6FfUMjYP5O01zWZrimari+tsoEIVgO47rDfKkOmPSwu8qzFA
	 fWX7QyBtjz/T2O/HlIfKAytIzRf5TuXtcJ6VeOO7z8VK3AhIW87UNoUnrRBNjqAguYX57
	 A5NO17apJCpvDax9hW62I1wUHbxpRBVinU35owaerM7WT/IdW4/NSdHGZywFeP9v+Uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lGBoTae9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AA4606A31D;
	Wed, 28 Oct 2026 18:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lGBoTae9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525971F01825;
	Wed, 28 Oct 2026 18:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211458;
	bh=yCdgsdmklSC1El5bFBHePrpyuZNZ9UinJGVkWHbMyrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lGBoTae9rRp7FxLxjUJxNDTIexeoE2s6M2aILq5i+ESBMGDvt1stuXpoNMCrcEoED
	 vofb08BJpnBDjedmGvRDSHS9oBP4z6YWH2Z1Od2nAoeE0nbQ14Vs2qLRRUhgybC2G2
	 htYRlz1mZ3qnq6hFdXvn+/K2KRJfa3jjJytFp1DY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ayhan=20=C3=87i=C3=A7ek?= <ayhancicek@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 385/571] drm/amdgpu: make Mac FB workaround generic
Date: Wed, 28 Oct 2026 17:58:52 +0100
Message-ID: <20261028170017.151029551@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit c7f44ec5c4ec760e74351f1843dcb8322f67cbf6 upstream.

Rather than adding a case of every chip where this is seen
just check if the FB is at 0 and the ssid is apple.  This
should cover all chips which fall into this case.

Tested-by: Ayhan Çiçek <ayhancicek@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c54e4d10507722398dc90cf3c532e50b86cf425a)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -693,20 +693,17 @@ void amdgpu_gmc_get_vbios_allocations(st
 	case CHIP_RENOIR:
 		adev->mman.keep_stolen_vga_memory = true;
 		break;
-	case CHIP_POLARIS10:
-	case CHIP_POLARIS11:
-	case CHIP_POLARIS12:
-		/* MacBookPros with switchable graphics put VRAM at 0 when
-		 * the iGPU is enabled which results in cursor issues if
-		 * the cursor ends up at 0.  Reserve vram at 0 in that case.
-		 */
-		if (adev->gmc.vram_start == 0)
-			adev->mman.keep_stolen_vga_memory = true;
-		break;
 	default:
 		adev->mman.keep_stolen_vga_memory = false;
 		break;
 	}
+	/* MacBookPros with switchable graphics put VRAM at 0 when
+	 * the iGPU is enabled which results in cursor issues if
+	 * the cursor ends up at 0.  Reserve vram at 0 in that case.
+	 */
+	if ((adev->pdev->subsystem_vendor == PCI_VENDOR_ID_APPLE) &&
+	    (adev->gmc.vram_start == 0))
+		adev->mman.keep_stolen_vga_memory = true;
 
 	if (amdgpu_sriov_vf(adev) ||
 	    !amdgpu_device_ip_get_ip_block(adev, AMD_IP_BLOCK_TYPE_DCE)) {


