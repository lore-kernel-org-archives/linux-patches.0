Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016817;
	b=ZHHvQ3QzwZz9n+T+iVZCAMKIrDZXuTrqn1dsn3YvGfoTKD4dIuWn9QAkLcfpD/L68+7l
	 69LJH/cUdDCgcuiZMYNBzS5UV8qg7kQOj4kzPD+nX8t4toK7XroongaKlMRYuErPsLWTE
	 31eF0B1wauIZJ9f+Afe1P7mC5eAMTD84kQdtLZ3WhpxUSKMaxBrl/8WW+rdhP5W25SqU2
	 bB1y/wZzQZni+kfzGdUvluHb/MyHmMt4X/n6jT8QPhDJaIttLvr59TSu4CyfEKuPbCX8n
	 8Rs52VoMVT1+HqdKE+ZoVmAR+9EetSsst2PBzUxjiNjsT17XpsOlxczJjI3bxZokJWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4S1gpFgQ+jgUJgF+uQeLw4AN8A623hiirqrYQupjQsM=;
	b=4ZfaOaGAGNCTNAk6l4f9irlVO4sJUqrwBzJo0AvaP0o5L41lc9yvQhi2XiqGc7Qzoqc4
	 t+9qjsu+HDU8wacQCvNTVBwkW4ArDrQYk5Yy6XZWFyA2Fs4s/mBN8Pp75zW8TqE+/fRNB
	 CFpP9LALcz30gj3zpd3OjWQa1ST5lHz78JudyaPFC9qQMRPPwHH00C81hemKb9tG8+R0L
	 4gQYoggxTeMzUAbaXPEnEsVcHdkiw9M8F7cOjtkwDtAoaj6q4BIPC2GJkBgGcS7ORTewC
	 a+QrPs9SuUgeIt7MlStFdpmx+0ojbukoXqJ52rA68VzE70vS8plZH8abdDTqX9iUHXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=buldjQNg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673CD606A32A;
	Wed, 18 Nov 2026 15:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=buldjQNg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97F41F000C4;
	Wed, 18 Nov 2026 15:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016817;
	bh=4S1gpFgQ+jgUJgF+uQeLw4AN8A623hiirqrYQupjQsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=buldjQNgrnnT+7kSmKM40ySG7F+aI9oWzyboJEEoZgeFNYLKg1mEV3H5tv/olhGI/
	 ZeyulDI9GOFaDh/CuxGKDKi4a9mZ+QOaSaE9mp4GioLHvcewg1yVYNO4simCTz3VNQ
	 C+aqcYfoV/QhufkYMtrRommzc9bLrPzWFyDDBiXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0664/2651] arm64: dts: ti: k3-am62l-evm: Remove unnecessary internal pullups for MMC0
Date: Wed, 18 Nov 2026 15:31:44 +0100
Message-ID: <20261118150311.782613663@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

[ Upstream commit dfba8329b8ebd49807ed1c1b336992e5791c7e48 ]

AM62L EVM has external pullups on MMC0 CMD and D0 pins [0]. Remove
internal pullups considering:
- Internal pullups are not required, without internal pullups, RDAT and
  RCMD values of 47K are within spec
- having both pullups (stronger pull) results in unnecessary power
  consumption

[0] https://www.ti.com/lit/zip/SPRCAL6

Fixes: 00fb4c73b67d ("arm64: dts: ti: k3-am62l: add initial reference board file")
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260909214743.899477-3-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62l3-evm.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62l3-evm.dts b/arch/arm64/boot/dts/ti/k3-am62l3-evm.dts
index 84a0cfaaf196a..964387eb51788 100644
--- a/arch/arm64/boot/dts/ti/k3-am62l3-evm.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62l3-evm.dts
@@ -253,9 +253,9 @@ AM62LX_IOPAD(0x01e0, PIN_INPUT_PULLUP, 0) /* (D8) I2C2_SDA */
 
 	mmc0_pins_default: mmc0-default-pins {
 		pinctrl-single,pins = <
-			AM62LX_IOPAD(0x0214, PIN_INPUT_PULLUP, 0) /* (D2) MMC0_CMD */
+			AM62LX_IOPAD(0x0214, PIN_INPUT, 0) /* (D2) MMC0_CMD */
 			AM62LX_IOPAD(0x020c, PIN_OUTPUT, 0) /* (B2) MMC0_CLK */
-			AM62LX_IOPAD(0x0208, PIN_INPUT_PULLUP, 0) /* (D3) MMC0_DAT0 */
+			AM62LX_IOPAD(0x0208, PIN_INPUT, 0) /* (D3) MMC0_DAT0 */
 			AM62LX_IOPAD(0x0204, PIN_INPUT_PULLUP, 0) /* (D4) MMC0_DAT1 */
 			AM62LX_IOPAD(0x0200, PIN_INPUT_PULLUP, 0) /* (C1) MMC0_DAT2 */
 			AM62LX_IOPAD(0x01fc, PIN_INPUT_PULLUP, 0) /* (C2) MMC0_DAT3 */
-- 
2.53.0



