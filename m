Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7051DB127;
	Tue, 26 Aug 2025 13:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215559; cv=none; b=JDlrN9lnZUUf4DNrdb0dBaH29GijwQf2xMjYn5S7vxTK3my4Y+9Qm7vzP6mpe8xvuFnVyXyzKyX5akGfVO7Y7sLDyiiQmFhdRZLK0o9w2B+NK78hSCmnsaNSDHuqNjW88dY7g2odoBnzf9uFZH2HWnUJILm9mGoWA/LqjV+Pq1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215559; c=relaxed/simple;
	bh=/MD4zmlpTiXKV9rJVSwaS+j51LzygHOijN8gOagfRRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oep14ecHBMx17pLQ4Mdy/HvC5CK8ElwGpRcC5/F8hB5/qiGFYVBXd+rmB/2huSdt9aT+d6M5PLXEh3XM9LFbp4CwXWUm/7ZlXTGmK7o8QxT0ya3Yioh+OeXHvkOIP9Bm4Ee3zB6q+xspbmMZQGoKQzMLMTRkLOwZGgPNUGRmVUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZ0UnkU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZ0UnkU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1083C4CEF1;
	Tue, 26 Aug 2025 13:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215559;
	bh=/MD4zmlpTiXKV9rJVSwaS+j51LzygHOijN8gOagfRRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZ0UnkU5FzApoOPF/gnKjC0UXfZZMbDqvw48iRipqMoIc9A3nG6beJPuWHgLRmziZ
	 9yMRUybf75nsG0UJTHjxKWMpplsOWhM4xI85Ydw/nN4K+Z3xy10S2q4yfeTAZqXW2u
	 ui0CMpa5NM9QhfHevpUG2A0qg4dEo0waVkw8hz74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xilin Wu <sophon@radxa.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/644] interconnect: qcom: sc7280: Add missing num_links to xm_pcie3_1 node
Date: Tue, 26 Aug 2025 13:02:50 +0200
Message-ID: <20250826110948.455114476@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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
index f8b34f6cbb0d1..cd5efeb764044 100644
--- a/drivers/interconnect/qcom/sc7280.c
+++ b/drivers/interconnect/qcom/sc7280.c
@@ -164,6 +164,7 @@ static struct qcom_icc_node xm_pcie3_1 = {
 	.id = SC7280_MASTER_PCIE_1,
 	.channels = 1,
 	.buswidth = 8,
+	.num_links = 1,
 	.links = { SC7280_SLAVE_ANOC_PCIE_GEM_NOC },
 };
 
-- 
2.39.5



