Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225801D1E7A;
	Wed,  2 Oct 2024 14:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878482; cv=none; b=guoAwxtBM5mwUXqeJJ74/BxtByzXPKdye7I9456JdpigqUAzDwpKjSug4mp67EDDb+O/MTfB8gSikHIhXfsDETmW5TBZ90H6hn7NOQdSVcpajofvKGC8r4b+oic0mUQixeHiS6VXgniJQq4am81foL3Pft7t9AxwnJ/yNPLKu5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878482; c=relaxed/simple;
	bh=UvdyW19y7PuG+qqlli+UCgrD6/wXxtBRXjpGf7R51So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M06OEcGx3uCG/oiKuj1jJ3uFf6/zWafXXrE56YFoNbpRtnBAXWtGHZT2Sm7hmbKmdR3Fnhs/8l8PRtUcP2vusaEZvziQEkXOzFPGICDNeelqqAw/Ppt2HXNCsWH/brofYr9C5HBkRNXMs9yJ8h0jSGLWUBAuGinbTuLuL8Wzneg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nnEKWMOX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nnEKWMOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6372FC4CEC5;
	Wed,  2 Oct 2024 14:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878481;
	bh=UvdyW19y7PuG+qqlli+UCgrD6/wXxtBRXjpGf7R51So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nnEKWMOXZ1auHuqULoXBrOCefjyAc6vx8rVt+MXI5ypEjB4tXvfRl6Pky9brm7qgN
	 qcoDBkkYikMWaXZEJPL952ogaUCcnV61CplxJzsflqTawA9RwalQJbzZM5LeIdufxZ
	 fXDbu3bn5jUiwxkvptFvBJHBTCpyZkDb5n9eUL0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 428/634] interconnect: qcom: sm8250: Enable sync_state
Date: Wed,  2 Oct 2024 14:58:48 +0200
Message-ID: <20241002125827.995702371@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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



