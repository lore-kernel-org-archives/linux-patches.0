Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064073;
	b=yVnt+qn7IDeTLcwfXnw5+lfbqpOuAGpF2fw+0Cc5Pt8NULEM8LIe0F0j6wbagockOzP4
	 ftfzM/jHdSb1H0efv33y3zNp9rGNAg/18z/nMFfVbFJmC3krFcTk6kWOV/W57uTETGDJg
	 sMWAD/flKk0yWvNJekIYfAzz6M3I0aSbege8p5v9q/B4uhSalln4ABcdC+wa25hH/obvx
	 Qz+7eKBt0/l/dsSZj6ojUXlt65d4WD10JXEKMykoRK4QCiU1lBjE5qtm+mkICDrQ6bGi6
	 ViSzWDbcajlzlqZNUg6cYD1cvtVFBWUM3dPjGUPFH/UJUqyCXcAks7FMDUPuqaSLP6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e1+qgqWwbVpuCq1y1b/pVQG0j077Q5YBMbBA2PLAWrI=;
	b=ABvR0n0h7f+uwDPGgcUKh9HV1i9Npw8Jgk57vJlNVm3ho2GwTIsUfx2EhPM4n6zZIbCu
	 bNT/qvPx1TQ482iuim/hoR5vaSLcqKl6KP8ilAgGaZJANmKm1QfZDCZl9D4AB6R819P8p
	 PxguzgbdE2FmBbkC8n7IzKoed4CIwp3xnyR2ngKfpb8Pmpjo1nEYvZPU1877/LrsrGqq8
	 d/m7XERQPYgAHOqckfTWpjA9ms8pZwY3uISW+HwZxnvMFUa4Au4IY/FLL9FmCb6FG3PC9
	 LDVSMlX9J1+Ch2t9d/Je1On0SYQv3r+SOmgwxx6BU0/d7ie6mYBYpjJQwCwQ0FolFKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DqEbWazX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBDA606A9DA;
	Sat,  7 Nov 2026 15:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DqEbWazX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19981F008A1;
	Sat,  7 Nov 2026 15:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064072;
	bh=e1+qgqWwbVpuCq1y1b/pVQG0j077Q5YBMbBA2PLAWrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DqEbWazXYbrlgBo6qKFa0muuKFBiWnrCzK1lUVwnyBKFnjKdkdKSlsinkzqBihAiA
	 5EXrWxsRv7wqGYZsoqZ8hYpLlUrVaAQleFzr3fzQZN4aSlXGqmZ0cYXOusc85ueNMB
	 8oB+QQyixUCKSyjLxjRcfjwyGwjyeHVwh+9BV4Zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0239/1257] arm64: dts: ti: k3-am625-sk-common: Set eMMC clock pin as OUTPUT
Date: Sat,  7 Nov 2026 08:42:15 -0500
Message-ID: <20261107134946.120677395@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 9c83626826453..085b067d96fbb 100644
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



