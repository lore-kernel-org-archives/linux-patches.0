Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906308F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:42:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143F4C433C7;
	Sun, 16 Jul 2023 20:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540141;
	bh=eFWoOiPfC4EiZU4f1jA6mdIYei3/g1E2KX3yg/W0jj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ta319e7I1ik+m0X5t/gCHU/4eS5r8TstLX/F5lLE+ntkQMbiqAE5pTXc6ZCQg/St2
	 q/wScxTPqcorUN+OOoQXknffdwz0R35nCgbnQAzHga/OQryalmNyLLhEFW6xI8nLPv
	 vExhkJZZr4fcYiTmihGeaQkZSUUE0tHDssE5bBQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 230/591] ARM: dts: stm32: fix i2s endpoint format property for stm32mp15xx-dkx
Date: Sun, 16 Jul 2023 21:46:09 +0200
Message-ID: <20230716194929.823391901@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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
index 8b48d3c89a047..fdc48536e97d1 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dkx.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dkx.dtsi
@@ -438,7 +438,7 @@ &i2s2 {
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



