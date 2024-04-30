Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348CA12C816;
	Tue, 30 Apr 2024 10:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474019; cv=none; b=mADHtRBlxb4zRcXKaljKTQtD6VdopfZRVTXJAGh/sXmrGTTd/+VucVmbCeq/bsQ/MikrLTclvZMP+3LT8oj8NSUuUf8DkNG2M8BNvmeH5Lzc3407uKKEBhrkC9Az6qsO8TPlaRRv0mAC/dDf4DHzpdliPz1Ug6+XgJxpNt5qXJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474019; c=relaxed/simple;
	bh=eqgrsHDs7PPwahUBFGRkfG6rxyUN5C3Yol2cnPgh1VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JnJe7nlIXN8x1GmbA2jZ6sR28peQ37/2nYUSkMgJ4wsM9oIbVLGjbwYYygKI0tl1zeJX3Tz3Dz3omVvI3gQxqMBIUk+lAzTqyAoxdkxmaEp5hLCIE+O98Ifa3+OsZrMtIwnD/itnVE1CRbVdwhvbCmJ20Xs5/njkWJ4tyUcmiBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDfmWpXQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDfmWpXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60FFAC4AF1A;
	Tue, 30 Apr 2024 10:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474018;
	bh=eqgrsHDs7PPwahUBFGRkfG6rxyUN5C3Yol2cnPgh1VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDfmWpXQyC7huxcQyOKYQ714qhbgUIXvjGtPVG3Goy4hdsE3K9mUGNQzyUZmLD96B
	 JgrWlpfh4hfagTYXCXapUrB63jxzATMSudf/vT09/CDSm7CRyK0lUK7TJCxS4Mc1Ua
	 x/s97Oo3oicUOlUcLgGB+PCf/R7O2eKFQLsr9xmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajendra Nayak <quic_rjendra@quicinc.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 036/228] arm64: dts: qcom: x1e80100: Fix the compatible for cluster idle states
Date: Tue, 30 Apr 2024 12:36:54 +0200
Message-ID: <20240430103104.857566654@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rajendra Nayak <quic_rjendra@quicinc.com>

[ Upstream commit cb939b9b35426852896790aba2f18f46df34e596 ]

The compatible's for the cluster/domain idle states of x1e80100
are wrong, fix it.

Fixes: af16b00578a7 ("arm64: dts: qcom: Add base X1E80100 dtsi and the QCP dts")
Signed-off-by: Rajendra Nayak <quic_rjendra@quicinc.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240317132918.1068817-1-quic_rjendra@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100.dtsi b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
index be1285d9919e0..5ba7924aa4355 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -278,7 +278,7 @@
 
 		domain-idle-states {
 			CLUSTER_CL4: cluster-sleep-0 {
-				compatible = "arm,idle-state";
+				compatible = "domain-idle-state";
 				idle-state-name = "l2-ret";
 				arm,psci-suspend-param = <0x01000044>;
 				entry-latency-us = <350>;
@@ -287,7 +287,7 @@
 			};
 
 			CLUSTER_CL5: cluster-sleep-1 {
-				compatible = "arm,idle-state";
+				compatible = "domain-idle-state";
 				idle-state-name = "ret-pll-off";
 				arm,psci-suspend-param = <0x01000054>;
 				entry-latency-us = <2200>;
-- 
2.43.0



