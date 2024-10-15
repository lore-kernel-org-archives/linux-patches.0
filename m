Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD661C07DC;
	Tue, 15 Oct 2024 13:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997491; cv=none; b=F5qzwBcO1tZ4yYgET7QV0sjqXBsnY1niYt+ghf9OMeBYHywfv9IwfxsaVO4wxfC2A3B6fRbP7861Dp7E4ZEzd4ZkECh5RZNzYYgslsy8HA1m1rgZ3rJ0Xog0fVWlHYYw9eXySibwz8F3lBMMj7zQrFiFWzrwuIkpdFtATLEb/vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997491; c=relaxed/simple;
	bh=k1EYbrxMZLNSrmGGbAbNzXr12PY6eO+3uXPDwE1Ox18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hheefGMvWPBea/OZEndVNieVZDnte2hL0Jar6inTW8zY7nAH418dq/nlTW/xIWJEJAUVJ/kHgvjasw3XmpQnjM1Sn3zaA4h1NMiJJLRurH2looYQZFbvD62zVIJQ78y4SRHB2aqNpyDugpi5Ha6O+z+gzkVynI8Apqi81eEnfzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/tJeH6x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/tJeH6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF964C4CEC6;
	Tue, 15 Oct 2024 13:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997491;
	bh=k1EYbrxMZLNSrmGGbAbNzXr12PY6eO+3uXPDwE1Ox18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/tJeH6xOCPNy9ZHPJXwFDLwQcAmy83dEv5uV2J7Wc86XDs8L4MZleo+8OyOrcRUq
	 f70tL1dtl1ZacxjlIVmlyb+2Po4F1nt40ed8KcdTOMKkgrHyEAZitv6+nT8loXSgoy
	 sv7JrnXPtL+gFHga+LpbKYimkP543/NNuRJx+i8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 197/518] interconnect: qcom: sm8250: Enable sync_state
Date: Tue, 15 Oct 2024 14:41:41 +0200
Message-ID: <20241015123924.587759553@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit bfc7db1cb94ad664546d70212699f8cc6c539e8c ]

Add the generic icc sync_state callback to ensure interconnect votes
are taken into account, instead of being pegged at maximum values.

Fixes: b95b668eaaa2 ("interconnect: qcom: icc-rpmh: Add BCMs to commit list in pre_aggregate")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231130-topic-8250icc_syncstate-v1-1-7ce78ba6e04c@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sm8250.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/sm8250.c b/drivers/interconnect/qcom/sm8250.c
index 40820043c8d36..cc558fec74e38 100644
--- a/drivers/interconnect/qcom/sm8250.c
+++ b/drivers/interconnect/qcom/sm8250.c
@@ -643,6 +643,7 @@ static struct platform_driver qnoc_driver = {
 	.driver = {
 		.name = "qnoc-sm8250",
 		.of_match_table = qnoc_of_match,
+		.sync_state = icc_sync_state,
 	},
 };
 module_platform_driver(qnoc_driver);
-- 
2.43.0



