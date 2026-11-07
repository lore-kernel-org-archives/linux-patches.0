Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062040;
	b=z0ttR5WQJBoduIWQpkMZvhCFDE38QrvR+uYVTJj9Lb2wZZrqmr3WS9x5qlzV3qCQqhFN
	 4OpNra6kExcrHNMQSvHQLCPan143ceM7/SwZlx8soYaPloRjgBSWdUq5tWKBb6Jw9L17n
	 FPwzQi9oN8fUqy+ZZvp+jVuaGnujWKz/KLWx+GYj3+2sBiRTVu/2vCxk3UVdEqeWp2NTq
	 oJlkJUpAdNfn/WcLnMlfXHt3LGRYnOIEFeRRhP6gqhUyaK/9kVeXyvs4f4GLQq4M4480q
	 9X6kiOW2REQadYdRabc4jdTcwjbv4tR7RA77rB20gjlKh8qhEjBdgP3ERSLmZkj+QxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/D8EEoBZb26x6OMQZvjy5aDuMbWIVq3TCc5ri+E3dlY=;
	b=jA6OQntwJQdvykJD6mDT3FdEUfgmax5gjZYesl+cnFw8yx0rW+5ntlLhmyelmr8Zvvlg
	 NHjzprYyL0Bi0nIN3zn9xXgbI+iDD4fBaY+cG0Z/uFGCRKClixN5ei8H54152avlaLthh
	 JlLZHRXhaMQQwqcs2uE05MAMEEwvaHFtVKDc/KWSkCKk+OArDtbU3oN8XzzqYR2vhP0sL
	 Ey8OcmJSpGXxp5VXdNoIQTvHA9vkX18cj4jCvA7EzO83LHqihTFX0fw8g6HLAl/lAsxHU
	 82swg4I1bSXEjXMfq28rYsZ94JTI0jBaYHnpIADVPO/9Tb4R1J4VUh9KwY+lVesqgow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x0s9pZ7y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BA1606A332;
	Sat,  7 Nov 2026 14:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x0s9pZ7y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910FA1F0089F;
	Sat,  7 Nov 2026 14:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062039;
	bh=/D8EEoBZb26x6OMQZvjy5aDuMbWIVq3TCc5ri+E3dlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x0s9pZ7ydauXaf7dW1aleEKd9M18esqcGhQMmcYaKF4d9mNcpjNMdoZ1s6pfefkAW
	 rHOWlM/x+40u6kvM6EYlAkzDiH/AD08Yd1KFE+kAUY/aFzThzCw1hqwrt/KXksLANK
	 ypkW/67vTf63QASz0XMYBWvi5PMenJ+mTdoOa4Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1022/1536] arm64: dts: ti: k3-am62a7-sk: Set SD clock pin as OUTPUT
Date: Sat,  7 Nov 2026 08:50:38 -0500
Message-ID: <20261107135026.384301534@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

[ Upstream commit cfad4f39124b218c2cbbbe17e742971abc9ac8b4 ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruj16 Rev. C: Table 12-257. MMCSDi I/O Signals

Fixes: 38c4a08c820c ("arm64: dts: ti: Add support for AM62A7-SK")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260909214743.899477-5-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
index 59971c46d80c1..d948d3535bc6b 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
@@ -306,7 +306,7 @@ AM62AX_IOPAD(0x1f8, PIN_INPUT_PULLUP, 0) /* (AC2) MMC0_DAT7 */
 	main_mmc1_pins_default: main-mmc1-default-pins {
 		pinctrl-single,pins = <
 			AM62AX_IOPAD(0x23c, PIN_INPUT, 0) /* (A21) MMC1_CMD */
-			AM62AX_IOPAD(0x234, PIN_INPUT, 0) /* (B22) MMC1_CLK */
+			AM62AX_IOPAD(0x234, PIN_OUTPUT, 0) /* (B22) MMC1_CLK */
 			AM62AX_IOPAD(0x230, PIN_INPUT, 0) /* (A22) MMC1_DAT0 */
 			AM62AX_IOPAD(0x22c, PIN_INPUT, 0) /* (B21) MMC1_DAT1 */
 			AM62AX_IOPAD(0x228, PIN_INPUT, 0) /* (C21) MMC1_DAT2 */
-- 
2.53.0



