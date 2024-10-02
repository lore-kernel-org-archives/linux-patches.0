Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B941D07BB;
	Wed,  2 Oct 2024 13:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876504; cv=none; b=V4J0A61T549tegRuInbKiJHp+lODr9FeCMyaRgGJkfGk3NJMfdaC/Vj1nIKrhDhtlZh3m5Z6YyX4nC32kDBfPzzKNcmFHcZB5Ng1sEKcRCtEe6Xt54sjqYLnC8SEAxBFegoz/KXISub+0YmJkd8e5/wGJKbVODk4JLDSNf3aJHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876504; c=relaxed/simple;
	bh=O7wnbfHV7xIJoA2Yp6+qfJQ3ufU+jhnC8HMRhZL5syw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHRT2FRyXDaIp7cGKH0TdCsJw4jAplXlTlPn/1s6CjGacoroDOjY2z2WMGk/FCjib9Xsqcp/U+GUQMXiLofPMOZ2o/r5P4WSfstrVOpxk+aUa1/LlhgaEGTeNECaAocS6LJCjEFW9vb0soVa2Gbxj+PdFjw+whY1s+CIOd3pnk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frBd0MDS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frBd0MDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B651C4CECE;
	Wed,  2 Oct 2024 13:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876503;
	bh=O7wnbfHV7xIJoA2Yp6+qfJQ3ufU+jhnC8HMRhZL5syw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=frBd0MDS3J4flysSVzcYqJ1EdMUpwA6iQV/j6xac9mzBphaTiBvEtPtUyAnJvd/aL
	 3FZJ/LpHKoLVXyOipUg9mnEDTLVqhBW1SITCfgaZy+xfriIOtZY6t7xKWPUY0EQygh
	 +DsiBUiebMmHDoYw+p0rwSyeEQM8cfD7mPcJVlwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 467/695] interconnect: qcom: sm8250: Enable sync_state
Date: Wed,  2 Oct 2024 14:57:45 +0200
Message-ID: <20241002125841.100188328@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit d3681b30214eb5885092ce4586f07237dc3c522f ]

Enable the generic icc sync_state callback to ensure interconnect votes
are actually taken into account, instead of being forced to the maximum
value.

Fixes: b95b668eaaa2 ("interconnect: qcom: icc-rpmh: Add BCMs to commit list in pre_aggregate")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240804-sm8350-fixes-v1-8-1149dd8399fe@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sm8350.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/sm8350.c b/drivers/interconnect/qcom/sm8350.c
index b321c3009acba..885a9d3f92e4d 100644
--- a/drivers/interconnect/qcom/sm8350.c
+++ b/drivers/interconnect/qcom/sm8350.c
@@ -1965,6 +1965,7 @@ static struct platform_driver qnoc_driver = {
 	.driver = {
 		.name = "qnoc-sm8350",
 		.of_match_table = qnoc_of_match,
+		.sync_state = icc_sync_state,
 	},
 };
 module_platform_driver(qnoc_driver);
-- 
2.43.0



