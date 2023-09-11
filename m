Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D6F11715
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF06C433C8;
	Mon, 11 Sep 2023 15:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445147;
	bh=AarQ9HyL8sRWIWcKwhjNmojZjywbfXJatRbUGQBydwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E2agp/yW4zON06GAtTM016o3svDjPnROFoDDuFXwNKx/0pq7u5tFTPZBUfLHCCHdd
	 DHgMl6GEm3CeKt82KOCClO1wgJkHiy8moXNipzmoOKxb456ppLw6U1HMWLR5NT+LPF
	 coLm0mUOTm+DndWMZHLnZjgAd2+Wf/UVp2RwPKQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 243/600] ARM: dts: stm32: adopt generic iio bindings for adc channels on emstamp-argon
Date: Mon, 11 Sep 2023 15:44:36 +0200
Message-ID: <20230911134640.772970186@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Moysan <olivier.moysan@foss.st.com>

[ Upstream commit c46e9b6cc98245f7264a8d15394d1f95d433abec ]

Use STM32 ADC generic bindings instead of legacy bindings on
emtrion GmbH Argon boards.

The STM32 ADC specific binding to declare channels has been deprecated,
hence adopt the generic IIO channels bindings, instead.
The STM32MP151 device tree now exposes internal channels using the
generic binding. This makes the change mandatory here to avoid a mixed
use of legacy and generic binding, which is not supported by the driver.

Signed-off-by: Olivier Moysan <olivier.moysan@foss.st.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Stable-dep-of: 0ee0ef38aa9f ("ARM: dts: stm32: Add missing detach mailbox for emtrion emSBC-Argon")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp157c-emstamp-argon.dtsi | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp157c-emstamp-argon.dtsi b/arch/arm/boot/dts/stm32mp157c-emstamp-argon.dtsi
index b01470a9a3d53..94e38141af672 100644
--- a/arch/arm/boot/dts/stm32mp157c-emstamp-argon.dtsi
+++ b/arch/arm/boot/dts/stm32mp157c-emstamp-argon.dtsi
@@ -97,9 +97,11 @@ &adc {
 	adc1: adc@0 {
 		pinctrl-names = "default";
 		pinctrl-0 = <&adc1_in6_pins_a>;
-		st,min-sample-time-nsecs = <5000>;
-		st,adc-channels = <6>;
 		status = "disabled";
+		channel@6 {
+			reg = <6>;
+			st,min-sample-time-ns = <5000>;
+		};
 	};
 
 	adc2: adc@100 {
-- 
2.40.1



