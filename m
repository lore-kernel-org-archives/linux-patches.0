Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038524;
	b=w9a72AhKWKC8efpC+qnjQ6ex5E82lMrTTuFWXWo6LwlOKNK+Qrh4WX7UrlN7ahkeiT+Y
	 uA7Czk0NcIQSDo4DbrDVT1+iEbyUpmfyhcBdvaeo9hE3hZoM9UIV1ERsFwoqqD1pvF87/
	 dThjCwkz6p6xX68s1BwVJeMnvKEOajt9SKyOlSm3rEPtKdziuIs7BQx3br4Pv69XHLSaY
	 AHqFbYAseeOX/IRktObReQiXcp2JF7flYVyZIE0STaQ6fnCskV6RrF+t6K0yawWxZvnaJ
	 iJtNUwR7vZ/4PPZmi0pDof2q2x1hywvPqquPh93FMd6hm+MSKpvGhQVoOZRqJpMUsXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ltzy3seZVpcOlc79fNLB/RSlVRP22aSlkalZ+8Fo4H4=;
	b=GYajHYP1mwLtmAmwEp39kwYCBXsHpfT4AqKLWmQX0MzDLNfPCe7VnN13IPgdWTLXo3zI
	 KBRFkyXV8mSEZ0JNYbGuObtPoypx0+zaVgYhg23VSdcS5BjTjiy6uoJuXxGIRBmad5xTd
	 vFOlhOIAqyFitk3hmQtAscPqwnTGZsT83F9/MPQ/jeNy4FpJ+uKhTKBsKsnjfd0FG1Gqy
	 L2AoHRG40OIWD/TYtldA8KLQOGKJZ6/i+0Tdfde0+688mLjLqXevc4OzhOarPIv4gz7cS
	 l9xBkKKS6qI41G5ctoTbx9+UXFHy3Q3v6wynRE1xzo4AAJM7KPrUwsJ+GLEPbVjo7mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IsJex7sG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1577A606A325;
	Wed, 18 Nov 2026 21:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IsJex7sG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F381F000C6;
	Wed, 18 Nov 2026 21:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038523;
	bh=ltzy3seZVpcOlc79fNLB/RSlVRP22aSlkalZ+8Fo4H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IsJex7sGCEQYchvgDi+FyAC08FoxcDB8DH8b4Xmu1gRucYkQR/CO0eODyRc8yVO8k
	 T4gYOLzgIN+GChgP8wYz5ZoTjRVfvFC6LCnCQVDAJTGafxHOtzAIPV10eCiU55O9eW
	 tG7n5pJQxCHyyJKUWqosKSI7noJt530u+oe6BdrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Maciej Kucharek <qchcio@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1772/3318] drm/amdgpu: reset SI ASIC on MacBookPros with VRAM at 0
Date: Wed, 18 Nov 2026 15:39:54 +0100
Message-ID: <20261118150415.017966329@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Kucharek <qchcio@gmail.com>

[ Upstream commit 5b56ede880317bd912f914d5cd38ba1d357677fa ]

On MacBookPros with switchable graphics, the firmware puts VRAM at MC
address 0 when the iGPU is enabled.  The EFI stub enables the iGPU on
these machines through apple_set_os().  On a MacBookPro11,5 (Radeon R9
M370X, 1002:6821, subsystem 106b:0149), the driver adopts this layout
at init:

  MC_VM_FB_LOCATION=0x007f0000, HDP_NONSURFACE_BASE=0
  VRAM at 0x0-0x7fffffff, GART table at 0x1400000

The driver posts the ASIC again on S3 resume and after a GPU reset.
The VBIOS asic_init table then moves VRAM back to the VBIOS default:

  MC_VM_FB_LOCATION=0xf47ff400, HDP_NONSURFACE_BASE=0xf4000000

gmc_v6_0 does not reprogram these registers.  The GART table is then
no longer in VRAM, and the gfx ring test times out:

  amdgpu: ring gfx test failed (-110)
  amdgpu: resume of IP block <gfx_v6_0> failed -110

Reset and post the ASIC at driver load on Apple boards with VRAM at 0.
The driver then uses the VBIOS layout (VRAM at 0xf400000000) from the
start, and later posts keep it.  After the reset, FB_BASE is not 0, so
a module reload does not reset the ASIC again.

The test is the same one that commit c54e4d105077 ("drm/amdgpu: make
Mac FB workaround generic") uses: an Apple subsystem vendor and VRAM at
0.  The VI quirk for the MacBookPro14,3 resets at load for the same
reason:

  commit b6b1d9721851 ("drm/amdgpu: reset VI ASIC on MacBookPro14,3")

Other Apple SI boards get the same reset if FB_BASE reads 0 at load.

Tested on a MacBookPro11,5 with 7.2.5 and this patch: the panel comes
up at boot, and 4 of 4 deep S3 cycles resume.  Without the patch, S3
resume fails every time.  The GPU reset path is not tested.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/5978
Assisted-by: Claude:claude-opus-5-5
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Maciej Kucharek <qchcio@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 60dd16ae10f286cb9cce5b6027b2d5ee869637af)
Cc: stable@vger.kernel.org
[ sashal: Replaced MC_VM_FB_LOCATION__FB_BASE_MASK with its equivalent literal 0xFFFF to avoid conflicting header definitions. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/si.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/si.c b/drivers/gpu/drm/amd/amdgpu/si.c
index 4b81f29e5fd5a..5d4561ca22549 100644
--- a/drivers/gpu/drm/amd/amdgpu/si.c
+++ b/drivers/gpu/drm/amd/amdgpu/si.c
@@ -1509,6 +1509,16 @@ static bool si_need_full_reset(struct amdgpu_device *adev)
 
 static bool si_need_reset_on_init(struct amdgpu_device *adev)
 {
+	/*
+	 * MacBookPros with switchable graphics put VRAM at 0 when the iGPU
+	 * is enabled.  Any later post (S3 resume, GPU reset) moves it back to
+	 * the vbios default, so reset and post on load to start with the
+	 * vbios layout.
+	 */
+	if (adev->pdev->subsystem_vendor == PCI_VENDOR_ID_APPLE &&
+	    !(RREG32(mmMC_VM_FB_LOCATION) & 0xFFFF))
+		return true;
+
 	return false;
 }
 
-- 
2.53.0



