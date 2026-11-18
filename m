Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054390;
	b=WEWyonIYKDOSuwJ8PFA69o5h15PCB9WMftVuZG9EwF6BcllqNsBsxQETsvxnVQ2G0V35
	 Ld4kq2y40E2KTM8y2SQVnOMAhbWP+q1wU7ny+rRrsgX+fSBuYI5AIcC+QZWSEY0nO8ea4
	 g8jqgS7OqCm6YsLNUso/mXlblzipD7Rqo5xxSFFuq3iJSTIUJrH6bbJoinV2KyTBcearv
	 1EhYi2xxLhT2Qx0o/bFyKjsTe/W7sSdzZuy11wPH9FQOn6CX9l5+v3/stCzYIjJIJ7N23
	 ++KMjlcdAEr56QpMPjgO+EKhrgCQUoV0wPFrWxqLfuPQ8c5GXFrvd5Z6zmoiqNkw/qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054390;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vf/WcG/O+Q+06rYIPrqMeDzTCyrEFv3vJQzQbS0x3Ig=;
	b=xgSUJ+x3OLbneVX6g61twHhzrgMkJ7Iqf3r1Z+zsFcduF3kGkVUBCL4HIFgkgV9bWVIz
	 /7L/mPzbNpluarRwotiJr2wtWXGbhW8sy5On4pXY6VE20ZhNGXj9LGKeK2bYzre7XkaYB
	 6BKJnfyRiPgXc8dpsBBww8m9VYLdPpJPLKVt2mv4+I2Eb/CHEY/0z9AevIqHzQH1/T9vP
	 eR73i2PounWTetuND6XrkHlEn76hUm1/e4V/RFR9cVjiJT7O6vx/7ZYuZhAnr05W5YdyJ
	 EEA52ms9rf4Ym6dWWB8EDvEBaZRrx1aMWCnmT2iQzhzM4cX986fbdbO4ZcBKoiRveFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QJoyDEbr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6A2606A320;
	Thu, 19 Nov 2026 02:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QJoyDEbr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D121F000C4;
	Thu, 19 Nov 2026 02:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054390;
	bh=vf/WcG/O+Q+06rYIPrqMeDzTCyrEFv3vJQzQbS0x3Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QJoyDEbrV1B89wIqtZAHX/fZgHt/hlX3bMJFWJBjGGMNj82vnE3E7CVlWgW5LKpFO
	 GKH5k4DyEpxsVy2MpxQwDbKpv9tbPG5bMZAe+4RezoVTEzn5bD5grXqnKwZ9G8sIxh
	 Bbxue6SaERmSDykzsFUEuBYFKzSH1uHHi8VMKZ3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danijel Slivka <Danijel.Slivka@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Milan Milicevic <Milan.Milicevic@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1258/2214] drm/amdgpu: clear RB_OVERFLOW bit when enabling interrupts for navi10_ih
Date: Wed, 18 Nov 2026 15:48:54 +0100
Message-ID: <20261118150101.983360826@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Milan Milicevic <Milan.Milicevic@amd.com>

[ Upstream commit 146b96974b33b8cca52755ffed3cd24a82836013 ]

Port this change to navi10_ih.c:
commit afbf7955ff01 ("drm/amdgpu: clear RB_OVERFLOW bit when enabling interrupts")

Setting IH_RB_WPTR to 0 does not clear RB_OVERFLOW if RB_ENABLE is not
set. Pulse WPTR_OVERFLOW_CLEAR after RB_ENABLE (and with
WPTR_OVERFLOW_ENABLE) so overflow is cleared when interrupts are
enabled.

Signed-off-by: Danijel Slivka <Danijel.Slivka@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Milan Milicevic <Milan.Milicevic@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 713fb4ab04f4d2af6120f8eb607c5673b2759b38)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/navi10_ih.c | 28 ++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/navi10_ih.c b/drivers/gpu/drm/amd/amdgpu/navi10_ih.c
index 2c42b9a7ba74b..9425a9448cf51 100644
--- a/drivers/gpu/drm/amd/amdgpu/navi10_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/navi10_ih.c
@@ -161,6 +161,34 @@ static int navi10_ih_toggle_ring_interrupts(struct amdgpu_device *adev,
 	tmp = RREG32(ih_regs->ih_rb_cntl);
 	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, RB_ENABLE, (enable ? 1 : 0));
 	tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, RB_GPU_TS_ENABLE, 1);
+
+	if (enable) {
+		/* Unset the CLEAR_OVERFLOW bit to make sure the next step
+		 * is switching the bit from 0 to 1
+		 */
+		tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 0);
+		if (amdgpu_sriov_vf(adev) && amdgpu_sriov_reg_indirect_ih(adev)) {
+			if (psp_reg_program(&adev->psp, ih_regs->psp_reg_id, tmp))
+				return -ETIMEDOUT;
+		} else {
+			WREG32_NO_KIQ(ih_regs->ih_rb_cntl, tmp);
+		}
+
+		/* Clear RB_OVERFLOW bit */
+		tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 1);
+		if (amdgpu_sriov_vf(adev) && amdgpu_sriov_reg_indirect_ih(adev)) {
+			if (psp_reg_program(&adev->psp, ih_regs->psp_reg_id, tmp))
+				return -ETIMEDOUT;
+		} else {
+			WREG32_NO_KIQ(ih_regs->ih_rb_cntl, tmp);
+		}
+
+		/* Unset the CLEAR_OVERFLOW bit immediately so new overflows
+		 * can be detected.
+		 */
+		tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, WPTR_OVERFLOW_CLEAR, 0);
+	}
+
 	/* enable_intr field is only valid in ring0 */
 	if (ih == &adev->irq.ih)
 		tmp = REG_SET_FIELD(tmp, IH_RB_CNTL, ENABLE_INTR, (enable ? 1 : 0));
-- 
2.53.0



