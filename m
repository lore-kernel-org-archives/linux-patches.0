Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4DD322749;
	Mon, 20 Apr 2026 15:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700682; cv=none; b=OK4P+ovNd1q6ooz/equIdQArQOst6oiZ4ihRyRTec59iCvUY/HVI7hjaYUdYie5bNAaGO7K0JVEkNai2//zyN9rx37C/oMx/H9bXZkrZS7P8MlQGbDjHqCRnwVFzFwb5e/jUXIg0XcUTo5TD5e7hWEuu6qhQBLcFVXZ4VVuawH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700682; c=relaxed/simple;
	bh=rWadQ8rEMrUcuqopHTb4hzRpnm1jyezo3XqCKTyijNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhMWtzwIXPJoW7dHfJVb1AycktMOcfFlhqhMy5+R94qAJ0g0pE6fUxGff2U0fBXM1G5kSGI+NaOK5oqh+EpFBit3mEDodZ5N7KVa4lWq6MgahboNswyzf+0z/jbaAmIVJKYAwaHrJXN06VNlqPZRfv8FkO7osMGGQywinC802io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ji93EyjY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ji93EyjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533AAC19425;
	Mon, 20 Apr 2026 15:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700682;
	bh=rWadQ8rEMrUcuqopHTb4hzRpnm1jyezo3XqCKTyijNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ji93EyjYlakQK6KnvtoSRCe1NpXxxphJOkjaHkRjrXVxjFYCq/cBBhvGlFa8x+Tx/
	 2V6TWMRTO4LawFwb6haP2NCMU9aJ75gB5W8DreXNVZtclgrl7JlD43NJwYipR30Xb5
	 TsW5N36pCrRKYVBCCUPZmUvAQnAgx4Eww+uuisG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel J Blueman <daniel@quora.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 047/198] arm64: dts: qcom: hamoa/x1: fix idle exit latency
Date: Mon, 20 Apr 2026 17:40:26 +0200
Message-ID: <20260420153937.310572635@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel J Blueman <daniel@quora.org>

[ Upstream commit 3ecea84d2b90bbf934d5ca75514fa902fd71e03f ]

Designs based on the Qualcomm X1 Hamoa reference platform report:
driver: Idle state 1 target residency too low

This is because the declared X1 idle entry plus exit latency of 680us
exceeds the declared minimum 600us residency time:
  entry-latency-us = <180>;
  exit-latency-us = <500>;
  min-residency-us = <600>;

Fix this to be 320us so the sum of the entry and exit latencies matches
the downstream 500us exit latency, as directed by Maulik.

Tested on a Lenovo Yoga Slim 7x with Qualcomm X1E-80-100.

Fixes: 2e65616ef07f ("arm64: dts: qcom: x1e80100: Update C4/C5 residency/exit numbers")
Signed-off-by: Daniel J Blueman <daniel@quora.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260220124626.8611-1-daniel@quora.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100.dtsi b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
index 6d97329995fe7..efe8d5e7079fe 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -281,7 +281,7 @@ cluster_c4: cpu-sleep-0 {
 				idle-state-name = "ret";
 				arm,psci-suspend-param = <0x00000004>;
 				entry-latency-us = <180>;
-				exit-latency-us = <500>;
+				exit-latency-us = <320>;
 				min-residency-us = <600>;
 			};
 		};
-- 
2.53.0



