Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDE5154A1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7E4C433D2;
	Mon,  8 May 2023 10:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540046;
	bh=s+RkJHwfx+/S1xRGIHQNAAgbalalE2WFrz9H5e3o4Xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UB9tBxza3jmqyt9f3T3rzmmJj6nzjioI7KGvq/5XOAMQH9hXKP2PeFw/JvqVZTcjd
	 nLVSB4f9Miy0jWhdQflFHbhscm3XFIk4FsVHB3ohjEvXE8zmlEMMy9zpvX8g3/JtDu
	 VbJyntXlqu6ybKD9JVkFzt018Y/Tz6LsfMW92bLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 222/611] arm64: dts: sc7280: Rename qspi data12 as data23
Date: Mon,  8 May 2023 11:41:04 +0200
Message-Id: <20230508094429.622387300@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
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
 arch/arm64/boot/dts/qcom/sc7280.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -4345,7 +4345,7 @@
 				function = "qspi_data";
 			};
 
-			qspi_data12: qspi-data12-pins {
+			qspi_data23: qspi-data23-pins {
 				pins = "gpio16", "gpio17";
 				function = "qspi_data";
 			};


