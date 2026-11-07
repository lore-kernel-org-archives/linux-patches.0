Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064076;
	b=van7d27gHEsg/I69Idl21tlEch1h3PbitplTpDCzYBwJFyofQ3dfDAwjaYi+hrm6btD6
	 ZLJxtgjN3ojq+U24Dun76HmNuAHBVHmT/cWl1Guli4zTBvLoVNAmTRrPXlCTgIrDb7nEY
	 00PixsSm4nonCSBG18Pok5O2bk6ZncXX76OaE7A2S+zm5VCLhyshKVIAFZgZmRqkRvYsG
	 ecZGb2fkXvcU/B/J3dlfQQBpsPC+/ymDLaO/HPy+PXhkRC7nCAo4MDGDqAGa4jpSPdwFC
	 IAU5a2v9peWrQKx4uN7S5luluSJYPaZ4dn9byuHR0sbJuElhm0IgOrgcVBlkSHbiHdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064076;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z8cPGFyhUrL4l1RfmklORH3LLffedN0aTnOGrGop/H0=;
	b=gWMq3n9nC2JzpMrpIfcAJLJJVUJGqVLcp9eevHJwiCUfPDoSEgrCLwDYnN0JvqMbjghN
	 tRwROPcD4jZO9LSTQIr4u1lsNvuOfYtXoK0af/uiqEAf4hD0jn2JIJnze5DnRqS9uCZh2
	 h0IN8md++ezEF3+l9tdMVD9Xyn4Ncm3vN8Jm/Mbl2ICYo4QL3z5VA5p0CAtsGzQKLfZf+
	 7yOS3SKu5N8xDt+jV0Bjusny+q/Evon3cAg0qBzvzwVAzpSy/jaxLsFeZ2LYZEs47UrTr
	 7c6xLezhjR6pnvWPBnzT8dnpNcmtcGXtKcWQyZecQTS5LPErGA9Q0oT7NQuRRtCE/cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PIqs9cEH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D1A606C03A;
	Sat,  7 Nov 2026 15:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PIqs9cEH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431911F0089F;
	Sat,  7 Nov 2026 15:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064076;
	bh=Z8cPGFyhUrL4l1RfmklORH3LLffedN0aTnOGrGop/H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PIqs9cEH/WPgVD4x4T33MJ9Wd+sMlWTMAKwJqwGItFAJSpA61HDzBqq5xoPteTTLY
	 hrpCXzaHdLKaTh1Hu8CBpNoOMf61DgKijua6B5XbVLmyrFbd+qYxSwGKCbLoqfzx/L
	 V/NT6MiGmBjy8ASFFj8oWeFyQbXjKr0ab0J/r5Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Stefano Radaelli <stefano.r@variscite.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0242/1257] arm64: dts: ti: k3-am625-var-som-symphony: Set SD clock pins as OUTPUT
Date: Sat,  7 Nov 2026 08:42:18 -0500
Message-ID: <20261107134946.200643554@linuxfoundation.org>
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

[ Upstream commit dbe55d5f2930b27e9a3ce71f0c9b1bb0ad91a012 ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruiv7 Rev. C: Table 12-246. MMCSDi I/O Signals

Fixes: acb4cd35dbd2 ("arm64: dts: ti: var-som-am62: Add support for Variscite Symphony Board")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Stefano Radaelli <stefano.r@variscite.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260909214743.899477-14-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am625-var-som-symphony.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am625-var-som-symphony.dts b/arch/arm64/boot/dts/ti/k3-am625-var-som-symphony.dts
index 7951d7ec952b5..082bf81143dcb 100644
--- a/arch/arm64/boot/dts/ti/k3-am625-var-som-symphony.dts
+++ b/arch/arm64/boot/dts/ti/k3-am625-var-som-symphony.dts
@@ -391,7 +391,7 @@ pinctrl_mmc1: main-mmc1-default-pins {
 		bootph-all;
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x23c, PIN_INPUT, 0) /* (A21) MMC1_CMD */
-			AM62X_IOPAD(0x234, PIN_INPUT, 0) /* (B22) MMC1_CLK */
+			AM62X_IOPAD(0x234, PIN_OUTPUT, 0) /* (B22) MMC1_CLK */
 			AM62X_IOPAD(0x230, PIN_INPUT, 0) /* (A22) MMC1_DAT0 */
 			AM62X_IOPAD(0x22c, PIN_INPUT, 0) /* (B21) MMC1_DAT1 */
 			AM62X_IOPAD(0x228, PIN_INPUT, 0) /* (C21) MMC1_DAT2 */
-- 
2.53.0



