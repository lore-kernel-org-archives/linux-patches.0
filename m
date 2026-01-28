Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BE91885A5;
	Wed, 28 Jan 2026 15:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614455; cv=none; b=nGkmVflglkhX48hAU5pCyFY/D5dBT2vnT7wQXyqHaT+cD8MrXt4dXtwVp5aJ8Zkf7l1+ge6+CkUyqpzxk0lFfGdv9Ei/R1rT2l9ZhDl6C9U2Rt3IMi+Sf0/KaD0m77tsinMtOs2OFglpnMDOuYP6T5gJ4UsA7YP9hmf28KBlDYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614455; c=relaxed/simple;
	bh=xi0X9MhWtg0iQ7vQ5fbFzUpwyCsYcYaRCTkfgTLakY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXa3EFTQ0UUte/7dZgb5Grue9/TMHTJCxlvzO2w7KhtzgvlK3+Me4zY+KIwly3ghxYOMAf5o+f61RW5Vtzv9u3haGfFBpOvPjH4btHBEYjp5krFlwELT4GPGE08zCNRyrxj9kQsW7VrYtCl85rWg6XojKzs06qkbX5iXp1EXkwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQMYwJQ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQMYwJQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76842C4CEF1;
	Wed, 28 Jan 2026 15:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614454;
	bh=xi0X9MhWtg0iQ7vQ5fbFzUpwyCsYcYaRCTkfgTLakY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQMYwJQ39UkjzoSOcg8lxfjybgYuyOylbNuLP9gJA2z0EqhmdDFBcnAjfz2n/eWiS
	 /3+Ot4tiOT56zTwEqMny+bHX+9zN71kaSr943yPEbySE1nKbIKQa2H9xcOTNxQ9WPQ
	 cO+jcaXPc+1j4fVQnrwGyi+zC92kEJFSfHgr+tK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/254] pmdomain: qcom: rpmhpd: Add MXC to SC8280XP
Date: Wed, 28 Jan 2026 16:21:26 +0100
Message-ID: <20260128145348.783044291@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1bb9f70ab04c8..823604952b5ec 100644
--- a/drivers/pmdomain/qcom/rpmhpd.c
+++ b/drivers/pmdomain/qcom/rpmhpd.c
@@ -217,6 +217,8 @@ static struct rpmhpd *sa8540p_rpmhpds[] = {
 	[SC8280XP_MMCX_AO] = &mmcx_ao,
 	[SC8280XP_MX] = &mx,
 	[SC8280XP_MX_AO] = &mx_ao,
+	[SC8280XP_MXC] = &mxc,
+	[SC8280XP_MXC_AO] = &mxc_ao,
 	[SC8280XP_NSP] = &nsp,
 };
 
@@ -541,6 +543,8 @@ static struct rpmhpd *sc8280xp_rpmhpds[] = {
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



