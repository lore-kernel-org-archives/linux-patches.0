Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874B92F7461;
	Tue, 12 Aug 2025 17:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020505; cv=none; b=tmX9ObwTGRrVivUUmP4001xmWXPyWrpSCVlWq1uIPPN5pH37OGRJ6YLyp4drffa57jdURSCsx3uiAD9GGG6DavC43+PSu/RwWc1yX8vlIOVN5RY1JOYg8vUHVjrIbj7YHBoyc3ocSliUQQCd69ch9mKyS9r4k8q6XpSiNnmVmKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020505; c=relaxed/simple;
	bh=zCokfvh5qzRH51ZBdKsTyofNyVMnFVtYDyDJtQ7r97I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJMOVc+PN28L1JKhOU0nFLrT3EirUeBnnr8JHJi8Vy55LOAafz9jM+TDaBMm1LbzfzP1J0eoCNRDy4tlFzvqh/NtEIi8gCES2wyEupRcNU9GJSfYDUIDPo09mvAzyu3jfP8Yx1pEb4T6y0CRQ97hhZ09VsNZ9KtOwXP2UNXfN9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSoQ/L7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSoQ/L7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE898C4CEF0;
	Tue, 12 Aug 2025 17:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020505;
	bh=zCokfvh5qzRH51ZBdKsTyofNyVMnFVtYDyDJtQ7r97I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSoQ/L7Aa9i5YqLjvNJo1PicrdkXxpLPy1s/z6+UJLYyh/Muo2cEZpQbED434yOo/
	 8d/jEj5T6baewFyk1hZvqioaiD4Gmc6plSBApokz5mmduun5vV12FmtsaOEmeMhpPM
	 oNvbqDOf0EBqtX/p9YXtrYGlzzSbSQxdTUNftLdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/253] interconnect: qcom: sc8280xp: specify num_links for qnm_a1noc_cfg
Date: Tue, 12 Aug 2025 19:28:01 +0200
Message-ID: <20250812172952.690185226@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 02ee375506dceb7d32007821a2bff31504d64b99 ]

The qnm_a1noc_cfg declaration didn't include .num_links definition, fix
it.

Fixes: f29dabda7917 ("interconnect: qcom: Add SC8280XP interconnect provider")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250704-rework-icc-v2-1-875fac996ef5@oss.qualcomm.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sc8280xp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/sc8280xp.c b/drivers/interconnect/qcom/sc8280xp.c
index 489f259a02e5..d759b04e3391 100644
--- a/drivers/interconnect/qcom/sc8280xp.c
+++ b/drivers/interconnect/qcom/sc8280xp.c
@@ -47,6 +47,7 @@ static struct qcom_icc_node qnm_a1noc_cfg = {
 	.id = SC8280XP_MASTER_A1NOC_CFG,
 	.channels = 1,
 	.buswidth = 4,
+	.num_links = 1,
 	.links = { SC8280XP_SLAVE_SERVICE_A1NOC },
 };
 
-- 
2.39.5



