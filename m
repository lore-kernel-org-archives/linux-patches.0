Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064126;
	b=CJJ6okRdknIoQAca630o9565RB4TIlba2HjXAElFygMd7uzN0OJiqA5hdZ7Yo+aSTC8i
	 yhj7tOxcyUL76axAAiEKSQ0UzayKvBJPvxMAfRNv36dfuwfA//afgOdEBf26XnBFK7W80
	 iBbGWGwXhKgm/Zr0vm6LNXR4F51p1anKvmbjktQzTWdJsRsMF4UqNDb8QoYhJ8ecM5Kw/
	 rIhaspp2xDGezMh48NhybGwYcbOm9t5jc3lntQI7iDFjdzkW/l/f7ySDFf7xSYHy4CfAz
	 ULw4/6QClivoaqv8V1hF+6S0bjtkO70hAmxRQ4+sBIg1hGB/9Y2gFKr3t08nnwASvKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064126;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AoVlqDIzFQsfQxMyojFFddGQD/IFUjeJWYud2VVe9zo=;
	b=Y85LPFPzxLjJT+SHgpyCMtweJnRPyjWQYEb8u9T5SBU2s2cF5H3mrZinNPdcw0Hjuh9P
	 bYCY23clYjtraQB1NBVxrgeZB73YQg6WSf25dU1hxNNeORChXII7uWNooWnJ/ZuMv91Sq
	 MSAsUm0cPhrAuvws8UPIYWeLdh1qvr4O/IpjYILplE/la8CRhzvHyUsZjClefA7Kb6b0z
	 vraI+lR0B0KsxDm3jKgyGughDucECADZTsdmcigAjtZvmNMU03TQaIijiSoIR8ahhkpY/
	 bg2iV8+DcsHTWVHg9GVGzg8Cg6ZLIQiZLQi2KQdnUxa43lr6Ps3m/qRIddbMlQTBoAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="P/BA/uOV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BEA606A9CF;
	Sat,  7 Nov 2026 15:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P/BA/uOV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5E91F008A5;
	Sat,  7 Nov 2026 15:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064126;
	bh=AoVlqDIzFQsfQxMyojFFddGQD/IFUjeJWYud2VVe9zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/BA/uOVlgU8tFGPYgr+a7bWX5cUzhD0Iwg08LG1GVGuRy7+k0G3DMt7i+uAN7Gl/
	 IGvIm7YurzHqabv++vyJwcfPY8LcRmytPzNRwMDetSs/q69sVK1bhOp1LdekmUlVlx
	 x70+zjnx+zTIYTUUjk/nLvA4SLtob+PnSuUBqWTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0279/1257] arm64: dts: freescale: imx95-toradex-smarc: enable Wi-Fi SD interface
Date: Sat,  7 Nov 2026 08:42:55 -0500
Message-ID: <20261107134947.182314352@linuxfoundation.org>
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

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit b91cb164517d6cfbccd8bedad11827d8ea3bcb97 ]

Enable usdhc3, used for the on-module u-blox MAYA-W260 Wi-Fi/BT module,
it was left disabled by mistake in the initial commit.

Fixes: 90bbe88e0ea6 ("arm64: dts: freescale: add Toradex SMARC iMX95")
Cc: stable@vger.kernel.org
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx95-toradex-smarc.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx95-toradex-smarc.dtsi b/arch/arm64/boot/dts/freescale/imx95-toradex-smarc.dtsi
index a6c5398a81e3c..4c102f2132148 100644
--- a/arch/arm64/boot/dts/freescale/imx95-toradex-smarc.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx95-toradex-smarc.dtsi
@@ -839,6 +839,7 @@ &usdhc3 {
 	keep-power-in-suspend;
 	non-removable;
 	vmmc-supply = <&reg_wifi_en>;
+	status = "okay";
 };
 
 &scmi_bbm {
-- 
2.53.0



