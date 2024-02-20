Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA50776C9C;
	Tue, 20 Feb 2024 21:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463662; cv=none; b=rIAzFvWnp2bu2GU9u6/rfDmV5vTZmFxLmhaTovajAq/vSwEKW4SvTLCax1ydnI8StQ9q27KGWFE9mHcoZsc7RyYxVmscVY4ZThaNeNFGAjOz5bkw7o9ADBjGK6e2L43yY35GjhkcF830A8YnTdDPjShrcu/9n6zUKSloNztHjJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463662; c=relaxed/simple;
	bh=fNvm29eMgMrs9ceLs03ZSBjUMoI0dPTAN+WYEl4hjiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plS9JXdFINJczoHDlC7mku2BQc8w7UbegVTEEjSc5vN8/ENZYCsnzzWbZFnlWnLm2F1B8ACwMzGJYWV3H/yy5ynzihIalj0ho09C3nvsnQI79fxFYkoqLGb3QB86qvlY3rkXP2rqksi4iPcvfjP6Gd137pKqVcvoI3bThMDReI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sn9EqxFH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sn9EqxFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DD7C433F1;
	Tue, 20 Feb 2024 21:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463662;
	bh=fNvm29eMgMrs9ceLs03ZSBjUMoI0dPTAN+WYEl4hjiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sn9EqxFHbtIpaZTaFvmFVldLoABgVbeUf3pcDPa1Uu9Ey6QM1a4Mm/Xqm7UKP7Q6J
	 toNC3NB+S2q3dlMzP3gbKCewyplD1sIJpG1PCPuVbilj7Dh62C1mts0GSWeLiYyrZV
	 txPMDMsYvUN/2hpzFoGcPwzPIbitECf22KZtXcTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/331] interconnect: qcom: sm8550: Enable sync_state
Date: Tue, 20 Feb 2024 21:53:22 +0100
Message-ID: <20240220205640.299819834@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a10c8b6549ee..16b2dfd794b4 100644
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



