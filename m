Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209085;
	b=p53cig3esmqi8thtVUrNTgR9TlI0186FCfH3XaYqW2C+cXOzxMK3QR8r1GykreFVgjQw
	 C+6sE2swVIrjkaiuod1HBPMR4nR8m5eAKuBVcOrogr4QmiAVn6//LG//m3EAoIbhmYjyk
	 nmo9hYYymQsVBLQV95LkB9YgTBrJXikVLH/GlEEn8zcogp5NvXQ9cFWpedHU2SUJLwPxF
	 z4VMF8VZtxMUrWrcctRkODF9Px6qGKw/9CA/5h50Ha8b2x3IqeQUXZ2iFF3dAi/DBaVEm
	 KeJg5wBsTsakvPj7O7ERXxtACwIuP5fnBxCv90+g8CM+N+QWojiEC0hYjHCCZXSgCIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gHJiPQR/8a+3UDffElevRTR4JCaTneE2o87OClIJNN8=;
	b=NxX7jDFmWTZN9FISx0eGolnHD4Mq9AxMmbabknlORxvmQwX2oSU0pJ/NQzJ9mosiTzq2
	 S7bXb7JPPfyE0+BwhQPM6QNAHF1qMJIr7AtFy9GUICWIvgwZpCJcDRr3Hh9mLT5OugYcl
	 aqXX6vUtt3hphiULwsp6CDSmLGFOk+MO9o8EgyEfPJljxCiBudSxn5FiDpAd/2ofhH/j8
	 L/ZLJXaR6K0HxAx3iT+gzq90C+RSHWc0EAiG6zZ+qlAA3p0/8iLPvP7eWhmFqHNg1DKBp
	 RayNwQO7AGs2iuLk3KlJk3aKZfWxWliSwN6VKrhE4uU8KmFUJJdSBCUwZYQnurqkoMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DI2fW64c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4F6606A323;
	Wed, 28 Oct 2026 17:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DI2fW64c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCFE1F01825;
	Wed, 28 Oct 2026 17:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209085;
	bh=gHJiPQR/8a+3UDffElevRTR4JCaTneE2o87OClIJNN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DI2fW64cCHseVEnx91mi/y+JBLcoMusRLM7wdg5et3JncJrNy5iruLuuldFL5s3QE
	 UvjoFglVveNSClupJnFNw8kkLU/+c51GbHI/5KhksaAP98iVx1p2gYIZmS89aHczBJ
	 S2Ecb55AazXLWCrZlY+ExEE7G8fK6zZU8S6Hk5PA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ayhan=20=C3=87i=C3=A7ek?= <ayhancicek@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 347/516] drm/amdgpu: make Mac FB workaround generic
Date: Wed, 28 Oct 2026 17:58:19 +0100
Message-ID: <20261028170011.711628998@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -489,20 +489,17 @@ void amdgpu_gmc_get_vbios_allocations(st
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
 
 	if (!amdgpu_device_ip_get_ip_block(adev, AMD_IP_BLOCK_TYPE_DCE)) {
 		size = 0;


