Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213366;
	b=FN/8Jgt1bif569st6X0l/8ea9p7d4r6JVIl1zSB2ZAp9Km11aqpnphczUa2IZWYoLeh2
	 bI7W+O4jkz7Mq4HtjlSjFKJESlfkrgDV0wRZlYQR8awZFBXGJ0bV+nEc987c2647uvqz6
	 Cpy7Z1SdTcE4gfLRg1vdntXHnV25572OtQOCjenuZGXNHY6F0S79GTKFuN0473hEdMHpJ
	 IlnpcikXTohJfF6mmu5p/DSq6HBTfR0Fg7MPMM+uIF5wpoK9Beb96BsiM81wX0A/gFGSu
	 sFJRB+8mdkfmrAVr8krYT13tiojYoEPjl+Iqek1sRXmWfM1bGOlgJb5QFep4hB7Y3bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Gg+IKGXBxVnJznuMbMhyMPZ9y6dXbGduIs2RH4JmrDY=;
	b=pVJg/TlTzva5bkwNlAnBHgIo6X9OLhXlH2n8Z6Nhfa5MArlXaw61tqvY/XhAj4S5xo5d
	 uA9d1unEvVlJdhZ+s1Pyto68TY8RmTGoURONhlVnWvlMD/pPQLTWgwKgif6tgBdxshxcr
	 jbSnACNTz6wvEgVOcSBov4duKkS5Bpi1Jf4ONvWp6H12W+0DKBXkYRJepx6nK2m0exWwb
	 OCHyyAc9RR6qqmjr8+73w3jy/w+wveoxYHTblyWsEwC7o3TuFzNkEHPqfnfS2YeGHg9gy
	 wdP+fkLa8AUuODCjXylJNViyUzmmJdEiaGWbzDR9b4lOzn1QuBUE4Q0QenyqMXhqVAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bMIjtUZy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45D7606A31A;
	Wed, 28 Oct 2026 18:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bMIjtUZy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEBC1F01825;
	Wed, 28 Oct 2026 18:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213365;
	bh=Gg+IKGXBxVnJznuMbMhyMPZ9y6dXbGduIs2RH4JmrDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bMIjtUZy4/wRn29YIHAwUkf0X3OXjBD+7CdTcQBWkHt6QHxb00FaukAM09sprg6xI
	 HCnAawGVWaFCwKaLZsBCCGgcQw0Df54ayqNgqAFPT7inRmlbvAGV+LOAqOXkNb4X1P
	 g+Zw21W67INsa45WtpgtAenL2gqEkd81fN8yYYeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ayhan=20=C3=87i=C3=A7ek?= <ayhancicek@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 0478/1887] drm/amdgpu: make Mac FB workaround generic
Date: Wed, 28 Oct 2026 17:42:54 +0100
Message-ID: <20261028170510.128878550@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -652,20 +652,17 @@ void amdgpu_gmc_get_vbios_allocations(st
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
 	    !amdgpu_device_has_display_hardware(adev)) {


