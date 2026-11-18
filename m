Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037814;
	b=fneCJuPzGHPT8Qpy/3izQXNwrxNOuKPS2PkjbkhLKVffELf4p4649DuTgoc5gl3wnG5y
	 Yiw1a23SYwbNyWBciDrywjwNk74Nv1D1PmGqqeheRViiZdfr1tEjwOagFi50HbihKhh7f
	 RPNRBsr+TqWj4zv/e7ttyPphRY/aDz5wdfs6HjB5zz+4O09/7VnxEz02Jh2CG4rzPcRFY
	 BbAjc1l66dAbpqWlP/L3oXFfVkFr/rs2GzZOjRuyIpOppRvcPz0F48wZm2KrhtJC/JMIS
	 WOe3+U30VDGXK/nlpbVeXn0PZeoo/qYzJ5WgvrcYN7X+IP8C27tk0yYTRK2LgcV+mfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nufRLpoD9wU9ASrkZZrlz9fSF9PgKBnuJRJri3vTDMg=;
	b=tTLt3qAiPPGEX/UAVmBYOY+Hzpxo3l3cMlcMdjCPMlCEiaTONkgvIEQHUAZWYu9ikOch
	 iN6W8AouNN1YsEPLdKjioVwuCV9Plpg3PrvG5HBnIBW95cv1TzlPSjG1T8pDyfMRqqbjJ
	 zG7Jz8ZFxgmbdwVEpiL/9aNT7EMpOkU6K6lgv9WUxfeMKMTR9pvxIowXbpwc0Od5nAIwP
	 200Lub+c+QHmMbxrqe99hU7yZdHWTn+TGhODnkMHkrUATj/LPr4go4+TMH0K1yucJKNUV
	 2o4gBFohiILmYXMcGAjml4NmpLp/yQt5uyeF+l+7cxqCVQDC+sYa8129OCaZX00PbLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jVdDzwna;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78897606A334;
	Wed, 18 Nov 2026 21:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jVdDzwna
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C101F000C4;
	Wed, 18 Nov 2026 21:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037814;
	bh=nufRLpoD9wU9ASrkZZrlz9fSF9PgKBnuJRJri3vTDMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jVdDzwna+hoya3rFFUDFVV6a790tV6xG2mulkcL6DAshA3I4uFy2FeDk0ftY4B4zg
	 c6BIYoe+gH7d48ksUB4jCWIunwbrVVXoBLeHoapcwDfDl61zYInWeJ6uZuIg50dtZk
	 HSkrB7W/mCJ5FpzRqQQC5paWFIPjHr35TmNjTxwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danijel Slivka <Danijel.Slivka@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Milan Milicevic <Milan.Milicevic@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1528/3318] drm/amdgpu: clear RB_OVERFLOW bit when enabling interrupts for navi10_ih
Date: Wed, 18 Nov 2026 15:35:50 +0100
Message-ID: <20261118150406.807410145@linuxfoundation.org>
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
index 737eff53f54f0..cdfc334d793b7 100644
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



