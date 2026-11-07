Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062045;
	b=Gxc8UjNQX7n8dRXCI0isuTn67wws8pJ9XMdcfJm/10Ti8m67u6EDEUwyUEM1XPByGzA+
	 OdVaNxuc5+11YW1eeZjt2tTxpjpODFSv2inGBYkD960pTfHWbgaUaCGD4TCGgOBRMvAYS
	 w85mqkZku9f+h1dg9k69DKgahJRTzimblAtKIvLma7EIlOY0KO/SH9RQve1qPlFJq2qmc
	 +yOHGNd5DokYmhmf+4skxAEXG9Jq0LrYUdfUnUQAFvSQFum2Lj1ji8zcFeSQ9n7vlg4H7
	 K+Gn2TxfvXCsyN99UoioXC4AwaZi3Le4hQ7aRFHMKAT4kb47DlpM5eXaTgvAEa80CDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=80zyzOAqgX5B6iVuPkQez88LXp+qp0jarP+v+ZrdqV0=;
	b=v7fbVMMJpMFoFwqXN1jBJJso0gFDJ5NZ45OkiOgu3rAS6yqbYnnA1Lah10rEz1Q42y5l
	 0qhmnTLL0z562QkF69fe2I5cauMmrvOkZ2tXaeOJIkrIiNR0uTSEwg75AFc5e9YNyJZ4o
	 1/zWzof343i2KS34KPpJ/2WfvzaxrdIVVlOAJqJ+Om99gTyYywA01ND96hlFVIVhOMs6S
	 AslkomPEz2VRBh4NqrEUshNYke6AZFiyHt71HadkpzhtirrBGLV8d2ItqVAr86UPGsXPv
	 EMW9cMzfgmFPRALEUhrBgik/ltHRbKtomQUC53cbI72O6HmWTE1kl8DCHUrPUJodokA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ywqid1zB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B567B606A335;
	Sat,  7 Nov 2026 14:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ywqid1zB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629AA1F008A1;
	Sat,  7 Nov 2026 14:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062044;
	bh=80zyzOAqgX5B6iVuPkQez88LXp+qp0jarP+v+ZrdqV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ywqid1zBuVYQjB3QoIwf1pX59eGkXnsbF3vRflaZgGF6r9QfEtSTEH6ZoxY3DYuGN
	 nePw6d5Eg47jtE1EzfEPiZt3Y6nMDOzMMHwPfEljOmN+OireM/dg40bUWZQWmMc8kZ
	 CWMDToMG40qP/67ns/j2oGzn3q/i/bNZVoCMEBEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1026/1536] arm64: dts: ti: k3-am62x-sk-common: Set SD clock pin as OUTPUT
Date: Sat,  7 Nov 2026 08:50:42 -0500
Message-ID: <20261107135026.495849731@linuxfoundation.org>
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

[ Upstream commit 1e2e5016bda94b2bcd86258b5eb77fe3006639a0 ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruiv7 Rev. C: Table 12-246. MMCSDi I/O Signals

Fixes: d19a66ae488a ("arm64: dts: ti: k3-am625-sk: Enable on board peripherals")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260909214743.899477-10-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi b/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi
index 4f2d45fd36766..9d45d8dad381e 100644
--- a/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi
@@ -186,7 +186,7 @@ main_mmc1_pins_default: main-mmc1-default-pins {
 		bootph-all;
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x23c, PIN_INPUT, 0) /* (A21/C18) MMC1_CMD */
-			AM62X_IOPAD(0x234, PIN_INPUT, 0) /* (B22/A20) MMC1_CLK */
+			AM62X_IOPAD(0x234, PIN_OUTPUT, 0) /* (B22/A20) MMC1_CLK */
 			AM62X_IOPAD(0x230, PIN_INPUT, 0) /* (A22/A19) MMC1_DAT0 */
 			AM62X_IOPAD(0x22c, PIN_INPUT, 0) /* (B21/B19) MMC1_DAT1 */
 			AM62X_IOPAD(0x228, PIN_INPUT, 0) /* (C21/B20) MMC1_DAT2 */
-- 
2.53.0



