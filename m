Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EA0349B0A;
	Thu, 15 Jan 2026 16:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496293; cv=none; b=CHZ1MthAD2CogIelaJbd4X/Zi3aPkMvKeGnJD8oERAamDoiR7oRimnyq2xaY4+5w76hrMguPSh/u78xJCMX1+SukhcDmShtpikPBbTlhPHj5/Rm6lg1vRdm8YQCyAxMny/WoqCi5AAPl7yQkUaYuRsHB2VWvJhCsnfy7hdPlzTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496293; c=relaxed/simple;
	bh=i/SkeoHCRvmpFzw5t4FRNmLzYK4OtOY6mSOi4ZUxkBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMdRcEgJUsvfd2TZhFiHRI3Zh4VlCHgdAlqhu8sf3BqEwJXICbzYNipLpGh1hv1u3zLFlIDQTcILuz14gfE02TfEyDy5GjmdLY2ThoMIRwrkOMDnI1UG00NUQWQU9i57LcP76G5PP4vl5ehSIiXw6DLGMd5mZbzL0ccoZPt2eBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fUy6pEZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fUy6pEZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14749C116D0;
	Thu, 15 Jan 2026 16:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496293;
	bh=i/SkeoHCRvmpFzw5t4FRNmLzYK4OtOY6mSOi4ZUxkBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fUy6pEZyb3CkI1z6fYDdWhHVo6afFuCf2+0O3btLNnJqhiCW9RCaooFPHniV3kcRK
	 luBhE75B9x2JkhsHMx9xfoLf9kB3J2yNzoIKhJXgLRdR2TuKUzGR7bs95YUc1g6lwA
	 zZ3sBQiZl+DWU/6rqG1hnCTvHQmUglrRQTELA2WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 112/181] drm/amd/pm: fix wrong pcie parameter on navi1x
Date: Thu, 15 Jan 2026 17:47:29 +0100
Message-ID: <20260115164206.359630342@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit 4f74c2dd970611d3ec3bb0d58215e73af5cd7214 ]

fix wrong pcie dpm parameter on navi1x

Fixes: 1a18607c07bb ("drm/amd/pm: override pcie dpm parameters only if it is necessary")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4671
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Co-developed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5c5189cf4b0cc0a22bac74a40743ee711cff07f8)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
index 0028f10ead423..d0fd9537e6236 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
@@ -2463,8 +2463,8 @@ static int navi10_update_pcie_parameters(struct smu_context *smu,
 									pptable->PcieLaneCount[i] > pcie_width_cap ?
 									pcie_width_cap : pptable->PcieLaneCount[i];
 			smu_pcie_arg = i << 16;
-			smu_pcie_arg |= pcie_gen_cap << 8;
-			smu_pcie_arg |= pcie_width_cap;
+			smu_pcie_arg |= dpm_context->dpm_tables.pcie_table.pcie_gen[i] << 8;
+			smu_pcie_arg |= dpm_context->dpm_tables.pcie_table.pcie_lane[i];
 			ret = smu_cmn_send_smc_msg_with_param(smu,
 							SMU_MSG_OverridePcieParameters,
 							smu_pcie_arg,
-- 
2.51.0



