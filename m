Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064121;
	b=Fu6FfJSRDA81tkW/jcYMGJ6RdByFoDREuikM59APxFThiZmZgBzRZAuQik7tnj0fSqIf
	 n/ZntNA9qJbTA6lk4zNKs7EKzLkLH/NTMW6+Hu92Xj2pyynfjVPS16/LLLSlPmBlyXoCV
	 AIxYFfJymEGA+QTFmP+2UBJYXhpsjBsAMaFEp5n7P8lzaTZfMnlj+ZQGKryMfA547wZjz
	 CgfznDoZZb1cLSpWduUxyhDUbqLYn+mkNw0LAHkQ9ACZ66F6wYA086Ds2F9xlarXAJHxN
	 pbDdxUArU6XGpFvmjpxqrwUVbh6iGepvLvP9Z7EuvOLPtkn1WryI+fBMyvCwv7mrefg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2TpUYZUoB/XUbZcKyaAeicgucUcIwqMZZ8eLtg7rdS8=;
	b=TXqKvtwF9PhvlknpmJ+BttK93RhBYuq6cg/N9pfxUi3ujyX/Ycl8vzVsgFlzGbDGR/pD
	 NSSPili4gf+5ceDdQtuFArKOHGQdlY32qeLKJ8AEvuEKr8AaKHH4HkcZLxiHtAP2Zr2f+
	 EDgpGH11oOmW/oIMZClFizG0t0UpWF5mzMuSTC+8wby3T80Mj5sLhs1PaWeKUxBAz9+Ix
	 6JKz3EG4KdBStpEU3Tn9IVP38BG7F97DjkI3ZK/NM2aN4+a2hag5n0kcGSLU9dQf3rrh5
	 9XsL9xW7Q1nRR2Tn0UYbdrOc20EcvAgIruAvdywYhZJgVxsWTY07+CwA3TKjZIcrgTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dOSqiPEd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4EF60A6F4F;
	Sat,  7 Nov 2026 15:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dOSqiPEd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1478D1F008A1;
	Sat,  7 Nov 2026 15:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064121;
	bh=2TpUYZUoB/XUbZcKyaAeicgucUcIwqMZZ8eLtg7rdS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dOSqiPEdzG3CNipx69dbinS3Pn4LZUAmxVaECjMrqHVg+RgG9k1iDRCyNITEycMFt
	 3OrbsuVS2g5ey1M8GSFie2D6klSG1yL9pNw8QHdJQ2Mmt20OaQI6+EVWm+m6AVignv
	 rnQsTMfYlgrlQ5QXSDOM4AKE6zGzuZZpi36coiCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0277/1257] arm64: dts: freescale: imx8mp-toradex-smarc: fix SMARC_SLEEP# gpio-line-names typo
Date: Sat,  7 Nov 2026 08:42:53 -0500
Message-ID: <20261107134947.129522513@linuxfoundation.org>
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

[ Upstream commit 90bc5a53c7f0733ec37a5c041b4e1aefa3d8d965 ]

gpio3's gpio-line-names has "SLEEP#" instead of "SMARC_SLEEP#" for the
SMARC SLEEP# connector signal, while the gpio-keys node driven by the
very same GPIO line already labels it "SMARC_SLEEP#", and the imx95
Toradex SMARC variant names the equivalent line "SMARC_SLEEP#" too.

GPIO line names are meant to be stable across the whole Toradex SMARC
family, using the official SMARC-connector signal names from the
SMARC specification and the SoM datasheet's pin assignment table, so
userspace GPIO tooling that looks up a line by name works the same on
any Toradex SMARC board.

Fixes: 97dc91c04558 ("arm64: dts: freescale: add Toradex SMARC iMX8MP")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-toradex-smarc.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-toradex-smarc.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-toradex-smarc.dtsi
index 0348da385f239..eb8b9db7e3cd7 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-toradex-smarc.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-toradex-smarc.dtsi
@@ -323,7 +323,7 @@ &gpio3 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_lvds_dsi_sel>;
 	gpio-line-names = "ETH_0_INT#", /* 0 */
-			  "SLEEP#",
+			  "SMARC_SLEEP#",
 			  "",
 			  "",
 			  "",
-- 
2.53.0



