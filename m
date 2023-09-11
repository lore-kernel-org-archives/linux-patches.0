Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA1311705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:41:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD61C433C7;
	Mon, 11 Sep 2023 14:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443313;
	bh=y62njVEuWdaAu1zB77H9u89JYr/5jDK2CysGUdZuIRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q09U7CPXcOwKeU4vLMsiRrVmr5e38cjttilQF58XVz6gjiGm2mTkUtqprcdYeCKCq
	 W336O2bwFYKlzXDJDWGWizHe/21d17gi62cvt2biRuZot4USdqg8CMNAo8yClMXnBd
	 qfuOJofP1ZxT+Yp6Ls7fKumybdLbRueAYj53UPa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 305/737] ARM: dts: stm32: Add missing detach mailbox for DHCOM SoM
Date: Mon, 11 Sep 2023 15:42:44 +0200
Message-ID: <20230911134659.091224465@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit deb7edbc27a6ec4d8f5edfd8519b7ed13cbd2a52 ]

Add missing "detach" mailbox to this board to permit the CPU to inform
the remote processor on a detach. This signal allows the remote processor
firmware to stop IPC communication and to reinitialize the resources for
a re-attach.

Without this mailbox, detach is not possible and kernel log contains the
following warning to, so make sure all the STM32MP15xx platform DTs are
in sync regarding the mailboxes to fix the detach issue and the warning:
"
stm32-rproc 10000000.m4: mbox_request_channel_byname() could not locate channel named "detach"
"

Fixes: 6257dfc1c412 ("ARM: dts: stm32: Add coprocessor detach mbox on stm32mp15x-dkx boards")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
index e61df23d361a7..74a11ccc5333f 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
@@ -416,8 +416,8 @@ &iwdg2 {
 &m4_rproc {
 	memory-region = <&retram>, <&mcuram>, <&mcuram2>, <&vdev0vring0>,
 			<&vdev0vring1>, <&vdev0buffer>;
-	mboxes = <&ipcc 0>, <&ipcc 1>, <&ipcc 2>;
-	mbox-names = "vq0", "vq1", "shutdown";
+	mboxes = <&ipcc 0>, <&ipcc 1>, <&ipcc 2>, <&ipcc 3>;
+	mbox-names = "vq0", "vq1", "shutdown", "detach";
 	interrupt-parent = <&exti>;
 	interrupts = <68 1>;
 	status = "okay";
-- 
2.40.1



