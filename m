Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4272226980D;
	Wed, 30 Jul 2025 09:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868292; cv=none; b=ibcslPRTG3fdnJTS4/gL0Y9KZs3Yt/z7i1IjqXCDruDtVBb4dwl+5+hf6YF5u6+tgJ0VxrrPefqbhjb9ZZT0Y94e4kX3k59i+0UzRHKX8X2LBtK6BB+e1tqQ8a0ctqbWVEx75/xW9vf1PRVAm9trcZD1cDd+lx8Ad3bA7MT+lEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868292; c=relaxed/simple;
	bh=LV6fUu18EnFC6SfgtJphV6MiihCQydbVV1DeZVR93EU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoW9M/z7vG+E0qVOdMBv3/m/J0c1P3NSNi1rjQ899iORfo5nhyzA1xcQvWx4c65/QTGprWNAqeR3lT35cCmDpTFvGNOk4p0W1GwiF6ThLYnRDLN+iOiv/Z507plJMojRVBTqQNgHgd9HV2finExj3WBmnrfzcCKWdf8FZV7+GHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5hGaehq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5hGaehq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65601C4CEE7;
	Wed, 30 Jul 2025 09:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868290;
	bh=LV6fUu18EnFC6SfgtJphV6MiihCQydbVV1DeZVR93EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5hGaehqJbx2/lu3TTSsR3uslzHPFcrBiuQau358fdSQCOWUfB3RPow+8Qfsd2F/m
	 r/+1gKsDpYZnsnjNIYA77VuCD1u3y0DwLDKce92Qv03870tA2ZM8GlosOYuWWrzx9h
	 3tCUPIbM3eOVtr2JvgC+7WPyrVVQgUw6OCeCvfw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xilin Wu <sophon@radxa.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 05/76] interconnect: qcom: sc7280: Add missing num_links to xm_pcie3_1 node
Date: Wed, 30 Jul 2025 11:34:58 +0200
Message-ID: <20250730093227.066023793@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xilin Wu <sophon@radxa.com>

[ Upstream commit 886a94f008dd1a1702ee66dd035c266f70fd9e90 ]

This allows adding interconnect paths for PCIe 1 in device tree later.

Fixes: 46bdcac533cc ("interconnect: qcom: Add SC7280 interconnect provider driver")
Signed-off-by: Xilin Wu <sophon@radxa.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250613-sc7280-icc-pcie1-fix-v1-1-0b09813e3b09@radxa.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sc7280.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/sc7280.c b/drivers/interconnect/qcom/sc7280.c
index a626dbc719995..728589ec80264 100644
--- a/drivers/interconnect/qcom/sc7280.c
+++ b/drivers/interconnect/qcom/sc7280.c
@@ -165,6 +165,7 @@ static struct qcom_icc_node xm_pcie3_1 = {
 	.id = SC7280_MASTER_PCIE_1,
 	.channels = 1,
 	.buswidth = 8,
+	.num_links = 1,
 	.links = { SC7280_SLAVE_ANOC_PCIE_GEM_NOC },
 };
 
-- 
2.39.5



