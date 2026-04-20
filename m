Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96002DE6E3;
	Mon, 20 Apr 2026 16:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701245; cv=none; b=NSLjYjZworicCXIuq7B2eOP+VhgT7y7TA8D0vLCzoP2njdanhxwujE+kAg2+zsYJ5UBL6BCFYkK1yRnls5OqLKGQrC5HcNQ8mHOgdGb/31tRT6wJvqngCsW/ogHvcrJkcLKKZiBvWuvojLGYTCKCg8f7F1yv37QCEKaXeYtGVD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701245; c=relaxed/simple;
	bh=M/19IIrLC8V91ZLtWpZ1j4+xY74w7yXeHwMFuWR1Mwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ulpo9ubgUObdm+ZLyVjnzrlhtpNmJVagO0mkNaoY+gVvNkIJU2VDhq5PBhpmPHNFUSGuilJSEr8BdSdCjbof4IexDRV5re4eFqsPNAXb5wGvQWFdeBVFMMHEvaPZuT9h1VBP5Bsrxpn3YCYYxLHPl9JYIWymIdrpQaSI18MNJtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gLdX78er; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gLdX78er"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB06C19425;
	Mon, 20 Apr 2026 16:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701245;
	bh=M/19IIrLC8V91ZLtWpZ1j4+xY74w7yXeHwMFuWR1Mwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gLdX78erP+eenzqY/QVNoN5nt6OHFSsuzKIbrwWh2YnU2bIJrxf2DfI9W6/4/owAB
	 BmlKyhWPebz160RPeVH77MCS3/PKe1doHlN9JurPzSGARKBCr7t+DOutLJeasIH8dM
	 OJHpVZzMwVz8rEoUfkHa4BSAhMef8slZnlfPED0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Niebel <Markus.Niebel@ew.tq-group.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/162] arm64: dts: imx93-tqma9352: improve eMMC pad configuration
Date: Mon, 20 Apr 2026 17:41:10 +0200
Message-ID: <20260420153928.407199167@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Niebel <Markus.Niebel@ew.tq-group.com>

[ Upstream commit b6c94c71f349479b76fcc0ef0dc7147f3f326dff ]

Use DSE x4 an PullUp for CMD an DAT, DSE x4 and PullDown for CLK to improve
stability and detection at low temperatures under -25°C.

Fixes: 0b5fdfaa8e45 ("arm64: dts: freescale: imx93-tqma9352: set SION for cmd and data pad of USDHC")
Signed-off-by: Markus Niebel <Markus.Niebel@ew.tq-group.com>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/freescale/imx93-tqma9352.dtsi    | 26 +++++++++----------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93-tqma9352.dtsi b/arch/arm64/boot/dts/freescale/imx93-tqma9352.dtsi
index 09385b058664c..f189685370cc8 100644
--- a/arch/arm64/boot/dts/freescale/imx93-tqma9352.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx93-tqma9352.dtsi
@@ -273,21 +273,21 @@ MX93_PAD_SD2_RESET_B__GPIO3_IO07	0x106
 	/* enable SION for data and cmd pad due to ERR052021 */
 	pinctrl_usdhc1: usdhc1grp {
 		fsl,pins = <
-			/* PD | FSEL 3 | DSE X5 */
-			MX93_PAD_SD1_CLK__USDHC1_CLK		0x5be
+			/* PD | FSEL 3 | DSE X4 */
+			MX93_PAD_SD1_CLK__USDHC1_CLK		0x59e
 			/* HYS | FSEL 0 | no drive */
 			MX93_PAD_SD1_STROBE__USDHC1_STROBE	0x1000
-			/* HYS | FSEL 3 | X5 */
-			MX93_PAD_SD1_CMD__USDHC1_CMD		0x400011be
-			/* HYS | FSEL 3 | X4 */
-			MX93_PAD_SD1_DATA0__USDHC1_DATA0	0x4000119e
-			MX93_PAD_SD1_DATA1__USDHC1_DATA1	0x4000119e
-			MX93_PAD_SD1_DATA2__USDHC1_DATA2	0x4000119e
-			MX93_PAD_SD1_DATA3__USDHC1_DATA3	0x4000119e
-			MX93_PAD_SD1_DATA4__USDHC1_DATA4	0x4000119e
-			MX93_PAD_SD1_DATA5__USDHC1_DATA5	0x4000119e
-			MX93_PAD_SD1_DATA6__USDHC1_DATA6	0x4000119e
-			MX93_PAD_SD1_DATA7__USDHC1_DATA7	0x4000119e
+			/* HYS | PU | FSEL 3 | DSE X4 */
+			MX93_PAD_SD1_CMD__USDHC1_CMD		0x4000139e
+			/* HYS | PU | FSEL 3 | DSE X4 */
+			MX93_PAD_SD1_DATA0__USDHC1_DATA0	0x4000139e
+			MX93_PAD_SD1_DATA1__USDHC1_DATA1	0x4000139e
+			MX93_PAD_SD1_DATA2__USDHC1_DATA2	0x4000139e
+			MX93_PAD_SD1_DATA3__USDHC1_DATA3	0x4000139e
+			MX93_PAD_SD1_DATA4__USDHC1_DATA4	0x4000139e
+			MX93_PAD_SD1_DATA5__USDHC1_DATA5	0x4000139e
+			MX93_PAD_SD1_DATA6__USDHC1_DATA6	0x4000139e
+			MX93_PAD_SD1_DATA7__USDHC1_DATA7	0x4000139e
 		>;
 	};
 
-- 
2.53.0



