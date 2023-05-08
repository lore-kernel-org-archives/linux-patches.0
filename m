Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CEAD11CA1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5828C433D2;
	Mon,  8 May 2023 11:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543791;
	bh=dlN3lxcHYBqF3hhBJMc0yOwZO6ZMSjMUXymQ5juBmvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EFEm9rErcL/ogek8wHLL0W8IAGbMKXlnW/oY82BuITmL7LMMeE550tSncXxqoKgKi
	 b4ua/hX1sQVOEB7kz05YO1OiCs9BoTLaqel3OTFv0ycDSu+VqtIsOykpzqwZtZ6fOa
	 4d7IFZHjS251WJsvpDwqBeZ7qp3TqVdok73RTceQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@kernkonzept.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 202/694] arm64: dts: qcom: msm8916: Fix tsens_mode unit address
Date: Mon,  8 May 2023 11:40:37 +0200
Message-Id: <20230508094438.948787712@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stephan Gerhold <stephan.gerhold@kernkonzept.com>

[ Upstream commit 608465f798bb3eaf6773a49b893902860858e294 ]

The reg address of the tsens_mode nvmem cell is correct but the unit
address does not match (0xec vs 0xef). Fix it. No functional change.

Fixes: 24aafd041fb2 ("arm64: dts: qcom: msm8916: specify per-sensor calibration cells")
Signed-off-by: Stephan Gerhold <stephan.gerhold@kernkonzept.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230308123617.101211-1-stephan.gerhold@kernkonzept.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8916.dtsi b/arch/arm64/boot/dts/qcom/msm8916.dtsi
index 0733c2f4f3798..0d5283805f42c 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -503,7 +503,7 @@
 				bits = <1 7>;
 			};
 
-			tsens_mode: mode@ec {
+			tsens_mode: mode@ef {
 				reg = <0xef 0x1>;
 				bits = <5 3>;
 			};
-- 
2.39.2



