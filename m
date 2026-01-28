Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D586C2FE044;
	Wed, 28 Jan 2026 15:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615519; cv=none; b=lcwcK3lLa3yPda5hc4piRYnJIR9GG4z1mJ9fr74csP/ra0e4WCRijwZfHH6T86GFKBaXM2C8PDrRmOKT5L12Mdp2DO7cFqD6yF8ltZiwO2dSZ+m88sAw+RPGm5EZGrYKDmiGcv7qNHJi7MoJVv3pYG//Q0gXFzKlTa1k758/pMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615519; c=relaxed/simple;
	bh=dIWee2nD9/+w3t5V/WGxYvwHYAxrwJAsQdXvGZLnDaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATLpH9hxicp8fKgjBicDpsYfHAlz4eQ40pxg2DTFNYQhh9TDbTSy32hB1A5m0SyGuZTzT2H26vuG2xO2ArwAWGlXkAtnP0ScIxrmvYeEWR0G4kdgxVttsA2eGGOKYUJYrXibG0At9mNHFqLAfyuIO7S6kIfp1dVEAnrS7ZVpk4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9jlaChG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9jlaChG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1A8C4CEF1;
	Wed, 28 Jan 2026 15:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615519;
	bh=dIWee2nD9/+w3t5V/WGxYvwHYAxrwJAsQdXvGZLnDaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9jlaChGMFFtnjuw3oxIb4ftjlBdda/3Qzt6GgXx0OkRQHnh1nc7spZ1xJKMQwGFz
	 vdFLX4aAmNJrsE/heI8igFf3VN6zAi8CYwAR6S8fAwA6osrS5LOrFLerh+8pgXuuXS
	 BCocg4gCajqSnMESuTtjY6c4RDl/VKakQhfSQ5+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 009/227] pmdomain: qcom: rpmhpd: Add MXC to SC8280XP
Date: Wed, 28 Jan 2026 16:20:54 +0100
Message-ID: <20260128145344.675085257@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 5bc3e720e725cd5fa34875fa1e5434d565858067 ]

This was apparently accounted for in dt-bindings, but never made its
way into the driver.

Fix it for SC8280XP and its VDD_GFX-less cousin, SA8540P.

Fixes: f68f1cb3437d ("soc: qcom: rpmhpd: add sc8280xp & sa8540p rpmh power-domains")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20251202-topic-8280_mxc-v2-2-46cdf47a829e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/qcom/rpmhpd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pmdomain/qcom/rpmhpd.c b/drivers/pmdomain/qcom/rpmhpd.c
index 4faa8a2561862..4c3cbf3abc750 100644
--- a/drivers/pmdomain/qcom/rpmhpd.c
+++ b/drivers/pmdomain/qcom/rpmhpd.c
@@ -246,6 +246,8 @@ static struct rpmhpd *sa8540p_rpmhpds[] = {
 	[SC8280XP_MMCX_AO] = &mmcx_ao,
 	[SC8280XP_MX] = &mx,
 	[SC8280XP_MX_AO] = &mx_ao,
+	[SC8280XP_MXC] = &mxc,
+	[SC8280XP_MXC_AO] = &mxc_ao,
 	[SC8280XP_NSP] = &nsp,
 };
 
@@ -675,6 +677,8 @@ static struct rpmhpd *sc8280xp_rpmhpds[] = {
 	[SC8280XP_MMCX_AO] = &mmcx_ao,
 	[SC8280XP_MX] = &mx,
 	[SC8280XP_MX_AO] = &mx_ao,
+	[SC8280XP_MXC] = &mxc,
+	[SC8280XP_MXC_AO] = &mxc_ao,
 	[SC8280XP_NSP] = &nsp,
 	[SC8280XP_QPHY] = &qphy,
 };
-- 
2.51.0



