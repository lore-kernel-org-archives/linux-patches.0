Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3887E187FED;
	Tue, 30 Jul 2024 16:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355330; cv=none; b=diTdGyXOh4BvnA1pC3qlNlhVjhZ/YP9zmWP8HDcMEq3BgID5iLc12DXGe8gizc1PohjYHAuqLgZYhbuKUTaiT7AjEa6Wpj4FZKCuu+Z8N0UbfM/fJr/bqRd6gifMpEvMOGfXoLmD5U3A1rr1vc1VjJK8jEI49B7XBa4Zk/s0BzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355330; c=relaxed/simple;
	bh=19jz7nuKmqrVRu1ab9vtmJwGsl50NjIr49LlWIJFd94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+dOjOrHsw3bOjSJyFS5ITiTPmuDEs17lMu4iABChWfOi/o+h3LV7xpvUcwiBSnbOAGZOpbBIHHEeSikLvnuVhHS0Xf0p4yWOWRLl2mlV5FUWOwsc7o/+zmW7VAsHQ1fHoxzY/iGco3zcX7ajMEDArc4zPIvSqbTGeQM38I383c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UPlwt8rE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UPlwt8rE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994C7C32782;
	Tue, 30 Jul 2024 16:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355330;
	bh=19jz7nuKmqrVRu1ab9vtmJwGsl50NjIr49LlWIJFd94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UPlwt8rEbwPty/CFD8tK1dRxksee/fp59xzjkIKMZJdXMjbbu94MbcmPrKECp709/
	 ZMuM+nanTvxzPuTmdKeanVnHvf0ZATQKiHJEFWdYm0WCN/Ft2DJmpm7t77UCZzbnS0
	 2HfkbnjaQTA7cLladPCyp3LFxX3mF6GToMoOOq/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 041/809] soc: qcom: socinfo: Update X1E PMICs
Date: Tue, 30 Jul 2024 17:38:37 +0200
Message-ID: <20240730151726.271557790@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 85f5656a4f3f188cb950cf8dc88f3f0e4e656bae ]

Assign the correct name to ID 82 and fix the ID of SMB2360.

Fixes: e025171d1ab1 ("soc: qcom: socinfo: Add SMB2360 PMIC")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240522-topic-x1e_pmics_socinfo-v1-1-da8a097e5134@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/socinfo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/socinfo.c b/drivers/soc/qcom/socinfo.c
index 277c07a6603d4..41342c37916ae 100644
--- a/drivers/soc/qcom/socinfo.c
+++ b/drivers/soc/qcom/socinfo.c
@@ -133,7 +133,8 @@ static const char *const pmic_models[] = {
 	[72] = "PMR735D",
 	[73] = "PM8550",
 	[74] = "PMK8550",
-	[82] = "SMB2360",
+	[82] = "PMC8380",
+	[83] = "SMB2360",
 };
 
 struct socinfo_params {
-- 
2.43.0



