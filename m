Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A7816C688;
	Wed,  3 Jul 2024 11:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005890; cv=none; b=Cejh4pnwEwq3G2RndtJwMIK4ODmVsNjJEFDfhcdKdjSuHUWLazxZuAcv90MGeMEdcq/Uc/6KRW5PKVIlakQBIauMrt653fNJ4wiPr4S4ZyVSDT02zwEG5ncyNT8nu/A0pY77Ftpf1VJlG3g23S58Xh54gOdVZCiDdEZ+gM3v64c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005890; c=relaxed/simple;
	bh=DhFjr4JGVVFSZG4QTdtvBA4eVwP6liBNS6TatkINTZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U23DmUYl6F7yfFIo57bysNmsmfm2NThqVUADaN9S4OXY+Z9GDmuR4iyGn7xCyEbCaPCaHBbqgNjCH4psXilLFFqiepiVWafSuq0uUmVlTRal/gHiu5fcC3rXJDeZOIGXkLJ+OXnqZsUtA0dUK2wiaNhD08BBrD2GQjv3vs9ySf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rw2iqVl0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rw2iqVl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1D8C2BD10;
	Wed,  3 Jul 2024 11:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005889;
	bh=DhFjr4JGVVFSZG4QTdtvBA4eVwP6liBNS6TatkINTZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rw2iqVl0gcK3l5d61oDS6kCSHc+R7GENFh7JB7ZJvWzCThc5Bs6rKz31EX0fVklK3
	 uKVRxujbWCjqr5LZRX1YZgnfnlGGbsJmVBfupUlAcIEA3+NV3GSSg/oFQDB0CmEBfy
	 pBUhDSY74YPpIw9s2PeiBsiaJT83R1eMVUwC7u4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.15 230/356] arm64: dts: imx8qm-mek: fix gpio number for reg_usdhc2_vmmc
Date: Wed,  3 Jul 2024 12:39:26 +0200
Message-ID: <20240703102921.813776007@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

commit dfd239a039b3581ca25f932e66b6e2c2bf77c798 upstream.

The gpio in "reg_usdhc2_vmmc" should be 7 instead of 19.

Cc: stable@vger.kernel.org
Fixes: 307fd14d4b14 ("arm64: dts: imx: add imx8qm mek support")
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8qm-mek.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
@@ -32,7 +32,7 @@
 		regulator-name = "SD1_SPWR";
 		regulator-min-microvolt = <3000000>;
 		regulator-max-microvolt = <3000000>;
-		gpio = <&lsio_gpio4 19 GPIO_ACTIVE_HIGH>;
+		gpio = <&lsio_gpio4 7 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 	};
 };


