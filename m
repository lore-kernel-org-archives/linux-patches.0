Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618820;
	b=OBbaRu81PCXOJ8h2Uparx7+uQd2PkeYrL5Z4HpUOzmUXozu9th4oF/KLJCYF/UVgHws8
	 1veexhPVOebXnz+lGC/CWdjZ0Hb8zXBomca9Vf0VGZ6fsipTuLx2+vjcFHosyfdgG1wp8
	 f8oj3fitES8CnhwOTz1WbAp0Y/q4vRJiBeJNiIYuB2yfWmpEPd595tWLHU/cmRqMHjZsv
	 6fkp7VhbVSCDBfWZ306RZJG7kSuQ4Fi3Dq6E/wL8cBG46t+d1uFKnKOen6jZq28JuSIGQ
	 hqFi5O1OwUQ6G9ac26tL+CKVfR74i0g1HsOZgLzL/AkP75HB4srgiOGs/804hC6sC1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C9lMdwpSlMFGwUP3rx+jryDtZS4UAWQxevr3dqoGQjo=;
	b=k3RxYJ2/bL8I1xbtSlMHo/3TqjqPY9/f0QTwUUuBJqvf7oaJt9Ec3TWXQPv3jkSyZ8B9
	 rocGPjlubvRWt67S/3emAkT+8EQfk2Ww/199lRMk8cqYds9uMMRSvZrJqKI/ZyRWrEP1g
	 PIvDdAVur+Dr5RTXaK+zql+JHebYTFoBCsDLQ51qFwv3oiZt2+ky0ExiESbpOUaaX1SlB
	 9I2iaZJiRhATxamIpaEV6lyKU361eIo2fdcEiIciZCqMxJ4pCybo2Uon1+VAaDoagKBwW
	 E8zWRFzXivDFuhfB3vvNwGkkJoo3rJH52ZIU8Ogt3o2NvIGNJV13F6mfTpBiRexk5sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aLkTnZCJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDB8606A321;
	Wed, 25 Nov 2026 15:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aLkTnZCJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3ED1F000C0;
	Wed, 25 Nov 2026 15:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618819;
	bh=C9lMdwpSlMFGwUP3rx+jryDtZS4UAWQxevr3dqoGQjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aLkTnZCJ1YZEUi2TFELE0xHrH9IrDQ+c0c9NKMyaqmqQMxQ0kutYHufs2f0edTV9f
	 BmbKSZfhD4HD/6RNSP0fNzVN9z0BFeBQ+YlJblyO+ailc2qr22iL3OtM3VEScSfD9w
	 eswkti/JElzx/zzjsb6Ab1O7mIiBiq9D9xTjMdzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raag Jadav <raag.jadav@intel.com>,
	Riana Tauro <riana.tauro@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0397/1005] drm/xe/hw_error: Guard csc_hw_error_work() with runtime PM
Date: Wed, 25 Nov 2026 15:28:55 +0100
Message-ID: <20261125143831.045445207@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raag Jadav <raag.jadav@intel.com>

[ Upstream commit a890a885b982f73e6e984e828ffda06b5121c4b6 ]

xe_device_declare_wedged() callers are expected to hold a runtime PM
reference. Fix it.

Fixes: a7df563b45b0 ("drm/xe/xe_hw_error: Handle CSC Firmware reported Hardware errors")
Signed-off-by: Raag Jadav <raag.jadav@intel.com>
Reviewed-by: Riana Tauro <riana.tauro@intel.com>
Link: https://patch.msgid.link/20261022051303.282805-4-raag.jadav@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit fc8d229d76102489b6f56538a818c285a87db1e9)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_hw_error.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_hw_error.c b/drivers/gpu/drm/xe/xe_hw_error.c
index 5f2abc9485ff5..f726179c22e38 100644
--- a/drivers/gpu/drm/xe/xe_hw_error.c
+++ b/drivers/gpu/drm/xe/xe_hw_error.c
@@ -14,6 +14,7 @@
 #include "xe_drm_ras.h"
 #include "xe_hw_error.h"
 #include "xe_mmio.h"
+#include "xe_pm.h"
 #include "xe_survivability_mode.h"
 
 #define GT_HW_ERROR_MAX_ERR_BITS		16
@@ -170,6 +171,7 @@ static void csc_hw_error_work(struct work_struct *work)
 	struct xe_tile *tile = container_of(work, typeof(*tile), csc_hw_error_work);
 	struct xe_device *xe = tile_to_xe(tile);
 
+	guard(xe_pm_runtime)(xe);
 	xe_survivability_mode_runtime_enable(xe);
 }
 
-- 
2.53.0



