Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015138;
	b=N7rjoT8yF3IZmopOb1Mw5dvKOpAj7CktVF/GKB2NfqekvGeOfSrXnqV8hcUPV8QBKBPQ
	 gUo4XsjAMgi/CygZmEBcnUrRdpLZrydJSLZv4VKrDijNofgynChJgn4b2P9x4tVQiU+kJ
	 yE4gBbumwTMP77UPe/dfEpL18rSKWhlRsQDh9YMwBavJrtGkkxxjRfWW4lSqhqpD4TNc7
	 K97YPN35xQ63aOFUukIj9ITDIPrBcFNuChHeq52VxOvBkWQyk6L3zI7K2YkNbvup3MYsp
	 UzuMGV+Edn3g1yPOlhGUZeFebxB9tO4W1Y1PFooOTphrH86Sp/GKqKtVFPW/qy6WREg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HxDnBJbFibhXspisEnHu+ValLqjl6M9xJjqyBVrKWXM=;
	b=muN2lC3mEyldEatyzzJaNVxaeE5PeVuYFwFDTQ9YgXELGsn2ILKLBfAadf7eHR4sw3Ld
	 Ju7DtG1bUsNTOAYGiv9ft6UpMswGrITIQTtbzyOGcKOHMEAFq8ISclub2korEWjLfr2UL
	 nwtudzr3REKsy0M9xxRxrvIEOrqFTuTe0C4hc4y4XPk8dWJyq3KJJ5augydGDgfGC/cHv
	 Sknf/XtRhGwAo9ZUtI41YHxRhDQnL3vjhcuvNuZeL4gLz3PsUsGbqs03S+cylL+nfVS1e
	 gyK7IIht3FK/YtvV+nV/gl2BHxnHuKQ1gEHBrufq61MkuuAMsCyK1yNM2/N1JqsjgDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aCo6NOmD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB0A606A32F;
	Wed, 18 Nov 2026 15:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aCo6NOmD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0C61F000C7;
	Wed, 18 Nov 2026 15:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015138;
	bh=HxDnBJbFibhXspisEnHu+ValLqjl6M9xJjqyBVrKWXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aCo6NOmD7AqtNWFc9MRj8844ug+RewUzYD/97lKy/pMQiz71kaFkgMR4kS+Y40lf9
	 DUtObeqx+s+jvz3RBc2nVLntDPTnRo/+qqfiSwMoXdnlW3zPH6jTmnYTK8LMtqYbKb
	 p5x07THiRkyiaPTFYP1puDzWnCrnUp48SLIkOfw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sonny Jiang <sonny.jiang@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0029/2651] drm/amdgpu: VCN 5_0_2 disable VCN_RRMT
Date: Wed, 18 Nov 2026 15:21:09 +0100
Message-ID: <20261118150249.028532393@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Sonny Jiang <sonny.jiang@amd.com>

[ Upstream commit 400af1fb41676c25966624b8ce0f5c09aee2a9b3 ]

When RRMT is enabled, VCN firmware's register access is remapped so
that VCN instances on different dies (VCN0/1 on MID0, VCN2/3 on MID1)
require different target addresses for the same logical register.

Remove the RRMT capability detection so the driver always assumes RRMT
is disabled, using local-die SMN addresses for all instances.

Signed-off-by: Sonny Jiang <sonny.jiang@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: a56c2536c399 ("drm/amdgpu: cancel idle work in hw_init failure paths for vcn/uvd/vce/jpeg")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_2.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_2.c b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_2.c
index 5291ebbc5c3e2..9f9b3a47f63ba 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_2.c
@@ -203,8 +203,6 @@ static int vcn_v5_0_2_hw_init(struct amdgpu_ip_block *ip_block)
 	int i, r, vcn_inst;
 	uint32_t tmp;
 
-	if (RREG32_SOC15(VCN, GET_INST(VCN, 0), regVCN_RRMT_CNTL) & 0x200)
-		adev->vcn.caps |= AMDGPU_VCN_CAPS(RRMT_ENABLED);
 	for (i = 0; i < adev->vcn.num_vcn_inst; ++i) {
 		vcn_inst = GET_INST(VCN, i);
 		ring = &adev->vcn.inst[i].ring_enc[0];
-- 
2.53.0



