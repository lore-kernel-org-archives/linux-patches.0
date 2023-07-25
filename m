Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733061D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AE0C433CB;
	Tue, 25 Jul 2023 11:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283855;
	bh=upDRi5XA/xGN59LYW5xg4m///czAqNETzmL3DKZ1Jts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bBvY7+TaSdSf+wpgxL8FBL92v9HVPwOMUJzDDj98npAehsFwLARJ0Vkmnjc33nor9
	 QtcpQsqLF3z8S34fyDmF3aDi3PZ4HuaW2C+7QJv/OMtdJvj3it5ZkuktzHVAgtKHHh
	 noGdDHeu7cQ7EXLDRApQHPMzbjzGkWBaMshertcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 146/509] ARM: dts: stm32: fix i2s endpoint format property for stm32mp15xx-dkx
Date: Tue, 25 Jul 2023 12:41:25 +0200
Message-ID: <20230725104600.414863219@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Olivier Moysan <olivier.moysan@foss.st.com>

[ Upstream commit 076c74c592cabe4a47537fe5205b5b678bed010d ]

Use "dai-format" to configure DAI audio format as specified in
audio-graph-port.yaml bindings.

Fixes: 144d1ba70548 ("ARM: dts: stm32: Adapt STM32MP157 DK boards to stm32 DT diversity")
Signed-off-by: Olivier Moysan <olivier.moysan@foss.st.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dkx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dkx.dtsi b/arch/arm/boot/dts/stm32mp15xx-dkx.dtsi
index 47df8ac67cf1a..75869d6a1ab24 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dkx.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dkx.dtsi
@@ -406,7 +406,7 @@ &i2s2 {
 	i2s2_port: port {
 		i2s2_endpoint: endpoint {
 			remote-endpoint = <&sii9022_tx_endpoint>;
-			format = "i2s";
+			dai-format = "i2s";
 			mclk-fs = <256>;
 		};
 	};
-- 
2.39.2



