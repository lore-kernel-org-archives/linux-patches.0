Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D701DF27F;
	Tue, 12 Aug 2025 18:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023321; cv=none; b=jMb4lb6Ll09bfy4Mzdtp/7Tmow/lp8kd4juY6zEeTMR0Pso3r6SI5mVk3T0RBLigbj0MBsckUVHYl3uJTRuShIDS9ijVsBSnFBuX1f3uANLk7eDQPDd8XehY57j8IeP6QUlBoGSpduJYDJKCwvMd3Cqt0iSbE5Xohpifyehp+Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023321; c=relaxed/simple;
	bh=mwGfJXg+1hOUziTQwBpOxfkz5yHesmWMPMAPl9G94L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8uJkmJ9aV+XBl4vUOB1rQjB6kvxl1tWstPlPrH0GoIdPNaO4IMs9tM2t5pMMJe8QX780/xLgTp9p78fPOJCsM+yS6HSqoH565JzI+qxrJkMVcKx8gA+jXn8xOrQsTOIWaqueQ2kJOzCh/Hpy+lXw8WEvGwg5J3bEMvJG5onfcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5XAGHpg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5XAGHpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB178C4CEF0;
	Tue, 12 Aug 2025 18:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023321;
	bh=mwGfJXg+1hOUziTQwBpOxfkz5yHesmWMPMAPl9G94L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5XAGHpg9ZVnL3+KlpODRqFQO+Fp7Tuy8T27XpCG4G8VR6q0tEp5mLw3hUBbIlJTb
	 U/FkWasOfxalT/6EECM0gYsRDK5XZMpApgRJn1XNsPW+7GzOzQrwaDQSwjskJKCWhO
	 zWSMzPNbEkyVF2kuywhozi5pjYCyggRsxzlf+TsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Gan <jie.gan@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 045/627] arm64: dts: qcom: qcs615: disable the CTI device of the camera block
Date: Tue, 12 Aug 2025 19:25:40 +0200
Message-ID: <20250812173421.052456871@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Gan <jie.gan@oss.qualcomm.com>

[ Upstream commit 1b7fc8a281cae9e3176584558a4ac551ce0f777d ]

Disable the CTI device of the camera block to prevent potential NoC errors
during AMBA bus device matching.

The clocks for the Qualcomm Debug Subsystem (QDSS) are managed by aoss_qmp
through a mailbox. However, the camera block resides outside the AP domain,
meaning its QDSS clock cannot be controlled via aoss_qmp.

Fixes: bf469630552a ("arm64: dts: qcom: qcs615: Add coresight nodes")
Signed-off-by: Jie Gan <jie.gan@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250611030003.3801-1-jie.gan@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs615.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/qcs615.dtsi b/arch/arm64/boot/dts/qcom/qcs615.dtsi
index 559d3a4ba605..e5d118c755e6 100644
--- a/arch/arm64/boot/dts/qcom/qcs615.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs615.dtsi
@@ -2462,6 +2462,9 @@ cti@6c13000 {
 
 			clocks = <&aoss_qmp>;
 			clock-names = "apb_pclk";
+
+			/* Not all required clocks can be enabled from the OS */
+			status = "fail";
 		};
 
 		cti@6c20000 {
-- 
2.39.5



