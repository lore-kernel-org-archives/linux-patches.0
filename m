Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044209;
	b=OVYoca6WzBkuE4ppkZGRfX8PfdDAbJAsYl6wRJ1a39SY2O6fo86g7k7kRtYYDadINpnY
	 meDrIgtmV+OsdJ8UUrFFU29bmHvmr1IDC1Txa0wWIzvUvj5VScGXqBz1EgzNKQ2Egb+u0
	 mW5+ewHuwduSGL4by3XzqtKLKhmlofRI6CtLIBUx/9YYqKIsJU6D3HWQp841+0+lYAb5e
	 qT3+cv88I8bgoG4NmsnnLAYRxDwqkRgdGFGeATG1Cp6v6BfzxC2kXZUVOaZkjRQFiaYEF
	 l6Pl12pC5kewPt4tm6zPZPsAh/C+OiFwp9mjvlX3+hCClFSES0Und/6lIVP3EmJIrGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044209;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=uelwbtENpVO9yI7JtUPufShTPSn5wGtSdFScwu5FZrA=;
	b=XD/kW5bTx2r6UkfYc/MK+HT86iiYxiLzetnP1S+lFNRXZRBTdrmvDhlUGu/UaoXhJzGb
	 DsYgfhRPs4LkZp74L9pW0EPb9JHdZ9r/rft9QHL3IeH/AOg2ltoosYmrvGUOyA1DpWMi7
	 DZQ5aTP8dAmbIv7ZfaslDd7Klqt1FGIElSidw26JMiHlakzXn9uvLq9/T96jx1fWEbPj6
	 WBGx3PmPEX6kCuasqVnvPVklVV1O4drps0Jl3KibjSf7Dtx9klVIiyWclkVci4PHjkMTE
	 aLlFbymzzW7DkxLHbbjZG2IuAJO0DXhZBZkjqnFDExshk55EKNP0182WsZwlpjXpQhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PoP82Bss;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB962606A320;
	Wed, 18 Nov 2026 23:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PoP82Bss
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1231F000C4;
	Wed, 18 Nov 2026 23:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044208;
	bh=uelwbtENpVO9yI7JtUPufShTPSn5wGtSdFScwu5FZrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PoP82BssukpOf3aDOv4GmIqc+NgEcD45pi5l8poY5c7ohDv7OLda6YS+glvueAMip
	 BbCjKSkqbogZEPguKQXlfPvbk/cVtOWZog+IWCOSK12W1uMJrOPNFnNnDo7vgpmZrw
	 2oPG49Q17C1beObwHs7g6cmpBhOEuS8rv+4h7UZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Sunpeng Li <sunpeng.li@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0486/2857] drm/amdgpu: serialize vblank counter reads against GPU reset
Date: Wed, 18 Nov 2026 15:25:20 +0100
Message-ID: <20261118150218.937773700@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Vitaly Prosyak <vitaly.prosyak@amd.com>

[ Upstream commit 1a6023edfbb5673f55fab6348f135fb3b1428ea5 ]

The vblank counter callback reads display registers and scanout
position without holding reset_domain->sem. During GPU recovery,
display commit work can call the callback while reset owns the
semaphore for writing. The hardware access then triggers the
lockdep_assert_held() in amdgpu_device_skip_hw_access() and sets
TAINT_WARN when lockdep is enabled.

Try to acquire the reset semaphore for reading before accessing the
hardware, and hold it across the counter and scanout-position reads.
If reset is already in progress, return DRM's cached software vblank
count instead. This avoids blocking behind reset and avoids accessing
display hardware while it is being reset.

The cached count is less accurate than the hardware count, but is
used only when reset prevents a safe hardware read. This addresses
the reset-time warning from this vblank path; it does not suppress or
fix unrelated lockdep warnings.

Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Sunpeng Li <sunpeng.li@amd.com>
Signed-off-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Reviewed-by: Sunpeng Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 51a4359f7431a4be5e42803c8bdaf7e0e5be2934)
Cc: stable@vger.kernel.org
[ sashal: Added the drm_vblank.h and amdgpu_reset.h includes needed to compile, with context adjusted for include differences in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
index e2a46651a4633..f4cdcbb880dbe 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -29,6 +29,7 @@
 #include "amdgpu.h"
 #include <drm/amdgpu_drm.h>
 #include <drm/drm_drv.h>
+#include <drm/drm_vblank.h>
 #include "amdgpu_uvd.h"
 #include "amdgpu_vce.h"
 #include "atom.h"
@@ -42,6 +43,7 @@
 #include "amdgpu_gem.h"
 #include "amdgpu_display.h"
 #include "amdgpu_ras.h"
+#include "amdgpu_reset.h"
 
 void amdgpu_unregister_gpu_instance(struct amdgpu_device *adev)
 {
@@ -1315,6 +1317,9 @@ u32 amdgpu_get_vblank_counter_kms(struct drm_crtc *crtc)
 		DRM_ERROR("Invalid crtc %u\n", pipe);
 		return -EINVAL;
 	}
+	if (!down_read_trylock(&adev->reset_domain->sem))
+		return drm_crtc_vblank_count(crtc);
+
 
 	/* The hw increments its frame counter at start of vsync, not at start
 	 * of vblank, as is required by DRM core vblank counter handling.
@@ -1360,6 +1365,7 @@ u32 amdgpu_get_vblank_counter_kms(struct drm_crtc *crtc)
 		DRM_DEBUG_VBL("NULL mode info! Returned count may be wrong.\n");
 	}
 
+	up_read(&adev->reset_domain->sem);
 	return count;
 }
 
-- 
2.53.0



