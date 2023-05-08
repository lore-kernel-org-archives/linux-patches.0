Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB436168C9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31340C433D2;
	Mon,  8 May 2023 11:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544005;
	bh=4yzpv1lESWxUI8QSCHjR9Ibt5YWLU0734K7jP7alsBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fpt56W6pf0vmybhOojloM/fB4M3mBPbuPj3yO4u3weucuIk/C9gVFQg63QLEulZJp
	 cClfHcN7Uz4OS2DB2Y7xrvFAr5vkOAS6KZGHpp2+0LEIi/Z1qlXyd7tRSu4cxRgbOG
	 DIUwX81eARVeFW2h49TGkC+Xafx2c/D4yo3LltwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 271/694] arm64: dts: sc7280: Rename qspi data12 as data23
Date: Mon,  8 May 2023 11:41:46 +0200
Message-Id: <20230508094441.050850145@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 14acf21c0d3f7b7298ffcd2e5b5db4a476ec6202 ]

There are 4 qspi data pins: data0, data1, data2, and data3. Currently
we have a shared pin state for data0 and data1 (2 lane config) and a
pin state for data2 and data3 (you'd enable both this and the 2 lane
state for 4 lanes). The second state is obviously misnamed. Fix it.

Fixes: 7720ea001b52 ("arm64: dts: qcom: sc7280: Add QSPI node")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230323102605.2.I4043491bb24b1e92267c5033d76cdb0fe60934da@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 98c7e534f1ab9..95b3819bf4c0e 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -4353,7 +4353,7 @@
 				function = "qspi_data";
 			};
 
-			qspi_data12: qspi-data12-state {
+			qspi_data23: qspi-data23-state {
 				pins = "gpio16", "gpio17";
 				function = "qspi_data";
 			};
-- 
2.39.2



