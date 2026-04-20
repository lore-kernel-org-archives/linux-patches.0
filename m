Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFBF244661;
	Mon, 20 Apr 2026 16:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701238; cv=none; b=GYk/2gx1cWwul21fUtw/r52bIlKfyhyKL9183CgmpcGCvlyW0WNi973JbZUYzqVp7yuD+4MI4Btzkb/o3akJj3cGjx0C/UddfnPabFjVspZk4zQuKKCFgP/x/iI00VIcFEnWM5xMC7E9juakObRwb89bdbt2dy9i7u294TJtAgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701238; c=relaxed/simple;
	bh=0PK6Ho8H3Pu/KpwVwHCWVgy1SSYIBT5v6qa8RWe3kfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqqApvLFtuj1zW94pHophlsZDxjy5yUcriNX3Gx3hxWd6mhocBG/W5aE7M6SO8rmv6viMhkFEZu+1qjs1E4koGGHmLnh7hsYCvdoXdwtVWzpaflZL0cJKR+OD6U1ehzIoSeY7okQ/qV7KeqbWkusbvLFT7xcj2+YZfPSMP2Rw9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t0Y8+oLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t0Y8+oLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95591C19425;
	Mon, 20 Apr 2026 16:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701237;
	bh=0PK6Ho8H3Pu/KpwVwHCWVgy1SSYIBT5v6qa8RWe3kfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t0Y8+oLC1MTl90IemPPOGFpiVAoGNvynPFYP7BU0KQcx/I1Ftvtm/5MlJ7aJKvHoR
	 Ciye8ekHy5z+q7DwE41BBuEIJc63tWLvAKiwNWH9DQt3HrIQSuVCWrO2oFHM0fhPEc
	 KtKWZaVUhUoDqdgOJcfoyxS3AqWVtpUh/sACszj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel J Blueman <daniel@quora.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/162] arm64: dts: qcom: hamoa/x1: fix idle exit latency
Date: Mon, 20 Apr 2026 17:41:07 +0200
Message-ID: <20260420153928.298812763@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6eef89ccdd121..8843dac449000 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -280,7 +280,7 @@ CLUSTER_C4: cpu-sleep-0 {
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



