Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD9815198D;
	Wed,  5 Feb 2025 14:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764047; cv=none; b=kQGZ2C8WyOtMdMPsv2fUPKCpZ25VrKbRUcuaC725SdvbJ0dxRw0PDOxE3HWB8Gcc6W2oht9IA7qTvhQepzwVyHMGA+yAi6aSLZdRUIsrPEkD/obM3jGwoa/bpM3nqBbiildGFhGqikic1zKTR5yL+bE6WJlHqLIaGbMX7oocYfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764047; c=relaxed/simple;
	bh=j2w+Zm8/oH3rG+0oXlQ8mLwxrvZelXiMeeBcOu56Mtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohzQJLi3IOK99CrU5JH2fWYoCX6AcK6pX/fTnkmcLUqVBDv8j9OuxghQXDzIREPzgM6Bd51rjsceK6rKoroVT4X9pKzfE6hwcMTCX6lGnMNh8fCB8K89bxHg45GHDInJxa5HtlVWU5pboo8vjIcGxircBLUSNbVX3sccysohkPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/otCmzW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/otCmzW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81840C4CED1;
	Wed,  5 Feb 2025 14:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764047;
	bh=j2w+Zm8/oH3rG+0oXlQ8mLwxrvZelXiMeeBcOu56Mtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/otCmzWg78ZfItje0CL6KpqP+sYQHzpvlqJa6vV6Q2YEEYgLU+B/6TBMwy6/EO08
	 sgjq6x+dBrahfMSEobrL0AdH0TxzDY9mq9ybkWX6SyAIaQ2zjeCPf3EuGLcad9qyPv
	 xlKDUOAEfEnHthEDj2sF/opuLYE96ci7jOTBr06E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 065/590] drm/msm/dpu: link DSPP_2/_3 blocks on X1E80100
Date: Wed,  5 Feb 2025 14:37:00 +0100
Message-ID: <20250205134457.743540591@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 3a7a4bebe0dbe22686da7de573f183e0c842883a ]

Link DSPP_2 to the LM_2 and DSPP_3 to the LM_3 mixer blocks. This allows
using colour transformation matrix (aka night mode) with more outputs at
the same time.

Fixes: e3b1f369db5a ("drm/msm/dpu: Add X1E80100 support")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/629966/
Link: https://lore.kernel.org/r/20241220-dpu-fix-catalog-v2-8-38fa961ea992@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_2_x1e80100.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_2_x1e80100.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_2_x1e80100.h
index a3e60ac70689e..e084406ebb071 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_2_x1e80100.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_9_2_x1e80100.h
@@ -159,6 +159,7 @@ static const struct dpu_lm_cfg x1e80100_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_3,
 		.pingpong = PINGPONG_2,
+		.dspp = DSPP_2,
 	}, {
 		.name = "lm_3", .id = LM_3,
 		.base = 0x47000, .len = 0x320,
@@ -166,6 +167,7 @@ static const struct dpu_lm_cfg x1e80100_lm[] = {
 		.sblk = &sdm845_lm_sblk,
 		.lm_pair = LM_2,
 		.pingpong = PINGPONG_3,
+		.dspp = DSPP_3,
 	}, {
 		.name = "lm_4", .id = LM_4,
 		.base = 0x48000, .len = 0x320,
-- 
2.39.5



