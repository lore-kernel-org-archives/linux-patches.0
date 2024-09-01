Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FCF1C68C;
	Sun,  1 Sep 2024 16:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208666; cv=none; b=JguSFtw/bbEkDqmZbe57XGx0OvUuGHjdh+AqdThgiMLvP2hKdkPLlGO8Xur4iZa3fXaSJth+rTK5D4d1mBgCkGLmdFdtdzhJ6YoCV5PBnPJPL8s92E/R+XgbsPMnXjMn18yNhFxlSmMeO0XZwQCY0UG2VaawApITe+918tupanU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208666; c=relaxed/simple;
	bh=rT9V43RbkMJYEU4kDz/Ojf2HwDQ1ud2lU6eWPlUZhbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=as+rGfK7E8OvemBhVxDbjf1IXMYYFyEjFuMByQSVspSXceilJwoNzYWJN39j7NUBMejEC+yqhU/wPy1eG/oOcSQ3cHgF6z976QWa9NnEStr8fjt8Mva0nZS2LJQ4dwcJhp6F79oRRNL+AW81AzftE8oFzSCsiM6lGKA+k7g0vWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSQSrfNm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSQSrfNm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D759C4CEC3;
	Sun,  1 Sep 2024 16:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208666;
	bh=rT9V43RbkMJYEU4kDz/Ojf2HwDQ1ud2lU6eWPlUZhbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSQSrfNmp0yVOEX+1ivXcD1XYZCQF63gB/CM+jEll49So1x64QtUeWbFBw8MDAiZL
	 Zat9y4nZA9ODHNY98uibzK3FBIRgxeDXWxzLzPnhz1g5aBQcsHQC0rWqsH9cyViMbd
	 0Z2R7lVlRHS7Yn6W/4amaOxb3v+uO9jm2t2gn5XE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 127/149] arm64: dts: qcom: x1e80100: add missing PCIe minimum OPP
Date: Sun,  1 Sep 2024 18:17:18 +0200
Message-ID: <20240901160822.229977617@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit 98abf2fbd179017833c38edc9f3b587c69d07e2a upstream.

Add the missing PCIe CX performance level votes to avoid relying on
other drivers (e.g. USB) to maintain the nominal performance level
required for Gen3 speeds.

Fixes: 5eb83fc10289 ("arm64: dts: qcom: x1e80100: Add PCIe nodes")
Cc: stable@vger.kernel.org	# 6.9
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240722094249.26471-4-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -2814,6 +2814,7 @@
 				      "link_down";
 
 			power-domains = <&gcc GCC_PCIE_6A_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
 
 			phys = <&pcie6a_phy>;
 			phy-names = "pciephy";
@@ -2935,6 +2936,7 @@
 				      "link_down";
 
 			power-domains = <&gcc GCC_PCIE_4_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
 
 			phys = <&pcie4_phy>;
 			phy-names = "pciephy";


