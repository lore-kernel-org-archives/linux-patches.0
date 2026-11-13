Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585766;
	b=OPQ5Tq4V3McPa2rL56puy8Z7CHhbi+47/hquLguexR2GJWr0A/oft0TQJFgmo5EM+Efq
	 t5bMCj+jffS2nF7ebFXkH3hkB7/0j7dFP+Lq+Nb953gU9ejz9f48jm2lbIoi/DbIyKLXZ
	 REfOE2WFByAYtCEvwR16AcQZlTZojct8SZ9cYP1IA29shqZ5XY/wz/AzTM0Ptu7fLGbca
	 OxLtKWf1xmXJk0yTn+3ehyAu35RiZSPFzjJLFiNiRSKUflySry/wMnOo3GgkZcg3ks5FY
	 5bLojK0utk6/EXAWk6korp81t9j7oCUKcaMvr0mO/xCuDmoH4Z9P+o+RobZpQJEXBpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OlCMIO92eVtwGgne3dAnKJiENoIMEzXzpkfBWgq8I9I=;
	b=5jLyqQvKI2tV0mCXwikrwbTSkVGgnglV5mPsou1m8t8VhAToVgm0QolZvrz8uoFligkR
	 E2vs3fx0dcCNy4X7eiIcUMGERbh/TmYqLS6cOqRHc2dp3G4YURLXnoGJyLYRGyTlNY4jT
	 zWnDgfHUTfKDBXHp2WVU49F7GgNMkPkNafli8jn58E2gz0qHtVltii9WTQqVvW6tswi4a
	 WYEudGVPIN/RK9Ng+Xz4hIn99xE8LnLxVi3oKsouRONh5AmDfSz6UoQZJec+G/Gxwefo8
	 WS9I577g+wCSDy3NOJp8ven1l1FSnay6T9WvIeQII4Py/UhLrl6BaO7MtTT8XO3g8tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MeQ9comM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D9A606D445;
	Fri, 13 Nov 2026 16:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MeQ9comM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1356C1F000C4;
	Fri, 13 Nov 2026 16:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585766;
	bh=OlCMIO92eVtwGgne3dAnKJiENoIMEzXzpkfBWgq8I9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MeQ9comMM7dQ8P+EJ01OwOsvenn5JqVF0OyU2+pho4l+1rDrAfqWUUWjSXao/Z/sV
	 8ZRBfLJpjanCbURa62rKkFjXVnibFs0bw1nWyRJksBOkUcWXFQXsSa1sy0Kuxc2cm4
	 fTb78c9r0MHigqEyy7sQLeEjQbfAYdVeIZiGHiZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danijel Slivka <Danijel.Slivka@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Milan Milicevic <Milan.Milicevic@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 358/507] drm/amdgpu: clear RB_OVERFLOW bit when enabling interrupts for navi10_ih
Date: Fri, 13 Nov 2026 10:51:02 -0500
Message-ID: <20261113153807.991638230@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index 4cd325149b63e..1e23d123e7f77 100644
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



