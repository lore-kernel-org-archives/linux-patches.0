Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590447;
	b=DNen9J9as1mEMth9uj3LSYzMmZwarktY9JQNH/FCp+Mjn5jlIYzJKfwWSkBOkjRebq93
	 7pRC7IXzD6dJ6cnzuTakcQxGJR6uHkv895J3SMWMwZ/T3punT6UKMW1wY6VFCpLVQOZIA
	 VmEAJxKT9MUMSr94cwevr7aH7J+WGCOpc35fuDdHj3L2lm0HqqW72r1aRR2SE0wphdX3N
	 D9T1eHEPNmaRLhpK+/budzf8uWAf/4ONroK36LdVRSp2ZBxjDkgtxaiQmY9yvQzoPkMwL
	 Yf+1QxjuEPWjS0HrfsSNX18q2FFGJOnvKgYKXmapPmqvPV5AabCF0FIbCcLB1/XT2Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590447;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0j7oc8yHgUMCBApp7i1/YvtBu3rcqGOnVnrRuL3erpA=;
	b=ju9y/BF6UDEzrr3XFNksK3Heras6i4WAzIq9APjh2mEGt4lQSzbQdOJct+sCs3CxwpfS
	 TbeMuO/GeA+mbpezZ4tpt73mzWm24yQe5f6VG7tP06aAolNuJppFW0gHuX2TApAmqZuqn
	 ktz21JK3mwd5Q/Fi+Tfk0nd7A0tYO8xTa+g9A+XQwgMAIB78xntoV/0iZ7jdi9LXGpQfJ
	 eJE+YMuuEOobSS88qjyvS0/zTFR57lf5eD9D5YzQm5sILsTsLjt4dW7KXKwiALwdAfnpx
	 fL+9tbN67kZJ9VgPkRFB26EZDCODtACE20wioldMXjv95mTIT5lkhaFubR6qQxU7cJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ClWXFV5Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4A460A6F60;
	Fri, 13 Nov 2026 17:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ClWXFV5Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A78D1F000C8;
	Fri, 13 Nov 2026 17:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590447;
	bh=0j7oc8yHgUMCBApp7i1/YvtBu3rcqGOnVnrRuL3erpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ClWXFV5ZmK23J5WMCNTQNlW7CeEeYrfwBaTDCYQBmqXZZuQqcWLYIGaV69fp8lLfK
	 vHHYbChK992USWH3kXKfkIQRPo2sktDUfDlKijuwFtr3ZCAkYnj1mAxseaUPhlO2K8
	 AIhbwGWElbUlMHZ6QAAnhlBApt3zVflqLgvkYfmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danijel Slivka <Danijel.Slivka@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Milan Milicevic <Milan.Milicevic@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 404/686] drm/amdgpu: clear RB_OVERFLOW bit when enabling interrupts for navi10_ih
Date: Fri, 13 Nov 2026 10:48:57 -0500
Message-ID: <20261113153834.674431940@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



