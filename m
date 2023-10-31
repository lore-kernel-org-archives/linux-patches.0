Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913A320B10
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DV2iB6gV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B7DC433C8;
	Tue, 31 Oct 2023 17:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774362;
	bh=UsqMiai21uDwrtGB3O7VphrhdyfjZjOLzMGv5ylwgeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DV2iB6gVKj5tGzMbnOK+cSyqjAvTTjnMjU2kK7gk57UhKk27/ufKFeP4zoU3jxRsC
	 YMfwxk9dbEvK5P5XiFOy4AMcq5Sr24KpgQipgzZ+2R4vXDudk6pQ4TTbZ0kvYpsJZW
	 YTXfzTdgyyOgnPhzVG4wz73NnKOCcYNkxUvlHHlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Obbard <chris.obbard@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.5 020/112] arm64: dts: rockchip: Add i2s0-2ch-bus-bclk-off pins to RK3399
Date: Tue, 31 Oct 2023 18:00:21 +0100
Message-ID: <20231031165901.945485112@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Obbard <chris.obbard@collabora.com>

commit 3975e72b164dc8347a28dd0d5f11b346af534635 upstream.

Commit 0efaf8078393 ("arm64: dts: rockchip: add i2s0-2ch-bus pins on
rk3399") introduced a pinctl for i2s0 in two-channel mode. Commit
91419ae0420f ("arm64: dts: rockchip: use BCLK to GPIO switch on rk3399")
modified i2s0 to switch the corresponding pins off when idle.

Although an idle pinctrl node was added for i2s0 in 8-channel mode, a
similar idle pinctrl node for i2s0 in 2-channel mode was not added. Add
it.

Fixes: 91419ae0420f ("arm64: dts: rockchip: use BCLK to GPIO switch on rk3399")
Signed-off-by: Christopher Obbard <chris.obbard@collabora.com>
Link: https://lore.kernel.org/r/20231013114737.494410-2-chris.obbard@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -2430,6 +2430,16 @@
 					<4 RK_PA0 1 &pcfg_pull_none>;
 			};
 
+			i2s0_2ch_bus_bclk_off: i2s0-2ch-bus-bclk-off {
+				rockchip,pins =
+					<3 RK_PD0 RK_FUNC_GPIO &pcfg_pull_none>,
+					<3 RK_PD1 1 &pcfg_pull_none>,
+					<3 RK_PD2 1 &pcfg_pull_none>,
+					<3 RK_PD3 1 &pcfg_pull_none>,
+					<3 RK_PD7 1 &pcfg_pull_none>,
+					<4 RK_PA0 1 &pcfg_pull_none>;
+			};
+
 			i2s0_8ch_bus: i2s0-8ch-bus {
 				rockchip,pins =
 					<3 RK_PD0 1 &pcfg_pull_none>,


