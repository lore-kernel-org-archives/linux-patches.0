Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6AD224B07;
	Mon, 23 Jun 2025 21:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715496; cv=none; b=Einkr/csBWitS4Bl9L5byKpb6wR9bGhEP3BI2z88h8Xenz1XOw6DiEskmxk6AOnCEnJda8wcd/c1a47ObMtwgwjJ0d/nVB1wt+MgWn2fP3U45wFno0C/ZQEV74MlF3vIdobgPxb9X/GD/+DN4jD4ZnRp3CWuT/Kf2k1DcYTDqRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715496; c=relaxed/simple;
	bh=PcnRw3ln1PoLyzzXt246pQgF784fGXfnQA4GO0Of7AQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SafW5TPaYGECOa5dVnutIWvUYpwblW3FsA7FbN8qSlULQHXQ9rc5c09cjmTDEyNbXhJfVk/6itHxRF/aP4p7p3csCt26T5V3bMDIahzrAWuUeyugYlBInqwnkw7jF+BN135+fcPPgvMwBAygP26uQ0XFfXPIhH0726DM69NYRCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W36+NZaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W36+NZaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D54C4CEEA;
	Mon, 23 Jun 2025 21:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715496;
	bh=PcnRw3ln1PoLyzzXt246pQgF784fGXfnQA4GO0Of7AQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W36+NZaTGCWlBbY2JSge9zFBxgXrJ0dzEjjbvxc3xxS2M9NS52ZjlEzREBTNwIjkx
	 8Hf396gRzmgsL/6Nv+S/qIlMmqt6zhhwA36NtYQbyUUWy7hWxRHJfdadyw8fgBIkT5
	 As5EUkFyfIbJPkZ6Bfmu5cVXUU0MiTGi/WCcMSb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Maya Matuszczyk <maccraft123mc@gmail.com>,
	Anthony Ruhier <aruhier@mailbox.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 281/411] drm/msm/a6xx: Increase HFI response timeout
Date: Mon, 23 Jun 2025 15:07:05 +0200
Message-ID: <20250623130640.723602997@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil P Oommen <quic_akhilpo@quicinc.com>

[ Upstream commit 5f02f5e78ec9688e29b6857813185b1181796abe ]

When ACD feature is enabled, it triggers some internal calibrations
which result in a pretty long delay during the first HFI perf vote.
So, increase the HFI response timeout to match the downstream driver.

Signed-off-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Tested-by: Maya Matuszczyk <maccraft123mc@gmail.com>
Tested-by: Anthony Ruhier <aruhier@mailbox.org>
Patchwork: https://patchwork.freedesktop.org/patch/649344/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_hfi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_hfi.c b/drivers/gpu/drm/msm/adreno/a6xx_hfi.c
index d4c65bf0a1b7f..a40ad74877623 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_hfi.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_hfi.c
@@ -102,7 +102,7 @@ static int a6xx_hfi_wait_for_ack(struct a6xx_gmu *gmu, u32 id, u32 seqnum,
 
 	/* Wait for a response */
 	ret = gmu_poll_timeout(gmu, REG_A6XX_GMU_GMU2HOST_INTR_INFO, val,
-		val & A6XX_GMU_GMU2HOST_INTR_INFO_MSGQ, 100, 5000);
+		val & A6XX_GMU_GMU2HOST_INTR_INFO_MSGQ, 100, 1000000);
 
 	if (ret) {
 		DRM_DEV_ERROR(gmu->dev,
-- 
2.39.5



