Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5286F446C9;
	Tue, 20 Feb 2024 21:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464752; cv=none; b=VB8pZtEev/WPm46/Gi/Y4PalvSGxDKDBjDOVAyPkASFylwXIGL+sfxkeaS2fQyhGjNEfq/Fxc104EoYTqy9LloyABveNvaShB7gexN3Do61poTyfU2n5abpd0QxuIlvZujWrTHUG9FwdLipMIho1wpWykHuxaJyo561KWGL9dwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464752; c=relaxed/simple;
	bh=0P+94enaeX/iVczTClIv1G0uJt1HT6J0ePcQ8EUIsgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKxNiJyKGNN+kW5jmg0zHz6HUbkO7aC/7MRtJGJ5rycGvTWbdCfhxZ2MWJZBSFnwIWVPvdJNRnBW7O3qw11/kHpUGen+QmZoxMdrEFOyVQfOd1Y8LvosLqom5DD0ZgenMHKp5GpGrOElipU1Is8ph2KzEjcNUdga8y3qaRFqDVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SkijK/Sq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SkijK/Sq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D404EC433C7;
	Tue, 20 Feb 2024 21:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464752;
	bh=0P+94enaeX/iVczTClIv1G0uJt1HT6J0ePcQ8EUIsgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SkijK/SqboFmEYtUnRmYSEZqO3aMz7vMNqmycN/OFehY4pvoFm+GvZ4KI0qm6HPLv
	 +NlzvgUK7gGBOy9sDN+Aoa8L3sNvTgiz21JWWzoyPuggTQudC5xqIJ8vnoR+LXV5aD
	 9d8hP2FH7hBiBVjPFKSl73PVwKk7h2UMTVxI2vLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 096/309] interconnect: qcom: sm8550: Enable sync_state
Date: Tue, 20 Feb 2024 21:54:15 +0100
Message-ID: <20240220205636.193895040@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 24406f6794aa631516241deb9e19de333d6a0600 ]

To ensure the interconnect votes are actually meaningful and in order to
prevent holding all buses at FMAX, introduce the sync state callback.

Fixes: e6f0d6a30f73 ("interconnect: qcom: Add SM8550 interconnect provider driver")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20231218-topic-8550_fixes-v1-2-ce1272d77540@linaro.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sm8550.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/sm8550.c b/drivers/interconnect/qcom/sm8550.c
index 629faa4c9aae..fc22cecf650f 100644
--- a/drivers/interconnect/qcom/sm8550.c
+++ b/drivers/interconnect/qcom/sm8550.c
@@ -2223,6 +2223,7 @@ static struct platform_driver qnoc_driver = {
 	.driver = {
 		.name = "qnoc-sm8550",
 		.of_match_table = qnoc_of_match,
+		.sync_state = icc_sync_state,
 	},
 };
 
-- 
2.43.0



