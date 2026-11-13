Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591360;
	b=NHfMA849SI5GoA9X6URFGUvvWjxvU6Ls75I86Mo3uKjkb+aDa8ZdrC+Fadvk7GW7i6aX
	 QS8exyN73zYVgf6CmjHSCVDdZDT3Zr5MBEUfRz/mkCAY1SfGKTvf4JjWokTHnldaaIynj
	 0mxm002Y4H55po2fqiUfu+9Lrt86Nuke8vydPOy13/5m09oNZa7CfLtJCiUUwjv9Q4UnB
	 2T/io8Ws9cCOnnGIBa1ZYcY+/xTED7QA6GWu7gDEDPB8TFYEXXCgCs1thjSfSMIfip7M6
	 TMdS3MpSrXFxGQ2X/Ofdndvz5objq5Z4JfmMdrAEDJLNzpggt8fxPVg9Co1k6erVCoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pGOu/AxGj2WySTcOXteVUsuyV3RPdFeZIuBrQO/GuyM=;
	b=zIqMsIrK2kXaYW0egaMt1w7jPqKQiXgGZYioesTbBooOAaVFqdx9ZzX147FhtzMLQvkZ
	 csGV/f+russggTtNToXPXJLFMDtvb/CRgABhZl9eNHl2vYjNJGLvIwYLXbbtag71zohLo
	 likmbukCq9P1U7ZIAt27nYTY3Xg5B21FdDaMS94cpQAGRkmwIyokvsIx0fc9d1BtY2NwJ
	 KmhTmzzAmP/Evivi0Nde5vcZbmGqnGhgInjqfuZsUU0Xs2LXlFh0O9L0wGNq8PZrTCCSn
	 pVX+hrwNeBe6WfyGRehDGOXGUihzHftTopdxu5cGnEzYsGC4KVcor6WFHSygSuUx3Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ezEvkPr3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194FD606B22D;
	Fri, 13 Nov 2026 17:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ezEvkPr3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66891F000C4;
	Fri, 13 Nov 2026 17:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591359;
	bh=pGOu/AxGj2WySTcOXteVUsuyV3RPdFeZIuBrQO/GuyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ezEvkPr3/QDvsX/0y8G6xfYDrQVJYwUpw155NGitBGUeec1ZCrHxma7GmPkVHU6qV
	 6u2fS+6aPVCXd7kU/R/J+LgzoR74JIeaE8jTqMtZoyIgxrfTlLBO6qwLCv5FjCmlLn
	 ji3Dq/v+c3JD0AiXHtUyh2yqFyv6ZIVnD5Nd9grI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 428/670] arm64: dts: ti: k3-am625-sk-common: Set eMMC clock pin as OUTPUT
Date: Fri, 13 Nov 2026 10:49:52 -0500
Message-ID: <20261113153826.246122660@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

[ Upstream commit 8ef8a0e38d1377c6d51c06f95c64d87641b2c717 ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruiv7 Rev. C: Table 12-246. MMCSDi I/O Signals

Fixes: d19a66ae488a ("arm64: dts: ti: k3-am625-sk: Enable on board peripherals")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260909214743.899477-11-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am625-sk-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am625-sk-common.dtsi b/arch/arm64/boot/dts/ti/k3-am625-sk-common.dtsi
index a9e372e9feada..db85d354133f6 100644
--- a/arch/arm64/boot/dts/ti/k3-am625-sk-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am625-sk-common.dtsi
@@ -98,7 +98,7 @@ main_mmc0_pins_default: main-mmc0-default-pins {
 		bootph-all;
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x220, PIN_INPUT, 0) /* (Y3) MMC0_CMD */
-			AM62X_IOPAD(0x218, PIN_INPUT, 0) /* (AB1) MMC0_CLK */
+			AM62X_IOPAD(0x218, PIN_OUTPUT, 0) /* (AB1) MMC0_CLK */
 			AM62X_IOPAD(0x214, PIN_INPUT, 0) /* (AA2) MMC0_DAT0 */
 			AM62X_IOPAD(0x210, PIN_INPUT_PULLUP, 0) /* (AA1) MMC0_DAT1 */
 			AM62X_IOPAD(0x20c, PIN_INPUT_PULLUP, 0) /* (AA3) MMC0_DAT2 */
-- 
2.53.0



