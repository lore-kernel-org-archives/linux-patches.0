Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B3037B011;
	Sat, 12 Sep 2026 16:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232280; cv=none; b=qa6uYWkGAPtSi0uA/ouxQI+ucATmdLr2l7hIGoSX5anAuZGnMnhc8k4UD97AjsUZKMXQXQvuEAS2y8Tj0oQ9MgXd1b2ephGtEYld8cpKQqAQBEtZRPP+xLuO6mwkSycVEMxnKrELwrVASnf/zYsSgm/+W9Gwn7zcO9YrWjHZ5b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232280; c=relaxed/simple;
	bh=4x4ncw0+EVjdKWSy6UnP9fADxggTunE7rxE79HMK9LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIQrnNq//QiTKAjmUcjZhT1OpwvSqTrBUJ782aLvM//yOAmB8WXKRX63qjO3LHBmFMo40EHabqYpcSY+SRle5IkIm4HrkUDis/Wlsp3pBuJ6hU6sglpK2x0zw5DuQKyR2d8pBP3PnLNWXAO/t35qc9MhchStJo+KuiMD6KV5oAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JbJyHRRy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JbJyHRRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B781F000FF;
	Sat, 12 Sep 2026 16:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232279;
	bh=iscAmV2wdaANYuNqWvSQAJo9wIBMwtFdRxmVhDoxMbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JbJyHRRymGwuA1IibWQPOYmxh1TQH3ZM4vZnlFzYZrs2eW+0LK9v/74OJnnptwHtf
	 NeMZTuRdvGBCNWSmguKMGL2CylHHHjPsrgy2K3kMghu3RKnOgj1e9POiED3H0hllXu
	 UqVvg0unyrGV/PLOuBZJdPfFSsoapguOdayw0jIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1170/1191] arm64: dts: qcom: sm8550: Flush RSC sleep & wake votes
Date: Sat, 12 Sep 2026 09:04:58 +0200
Message-ID: <20260912065614.418031392@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 4b2c7ac8e469ab7f92e50c34ad4012a77e79d078 ]

The rpmh driver will cache sleep and wake votes until the cluster
power-domain is about to enter idle, to avoid unnecessary writes. So
associate the apps_rsc with the cluster pd, so that it can be notified
about this event.

Without this, only AMC votes are being commited.

Fixes: ffc50b2d3828 ("arm64: dts: qcom: Add base SM8550 dtsi")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230531-topic-rsc-v1-8-b4a985f57b8b@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 20790336eada5..7bc87711dfc3e 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -2563,6 +2563,7 @@ apps_rsc: rsc@17a00000 {
 			qcom,drv-id = <2>;
 			qcom,tcs-config = <ACTIVE_TCS    3>, <SLEEP_TCS     2>,
 					  <WAKE_TCS      2>, <CONTROL_TCS   0>;
+			power-domains = <&CLUSTER_PD>;
 
 			apps_bcm_voter: bcm-voter {
 				compatible = "qcom,bcm-voter";
-- 
2.53.0



