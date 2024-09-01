Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B49537FF;
	Sun,  1 Sep 2024 16:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208643; cv=none; b=d4zMhCWRXl45J5T76F4ae8TZXEE00LzfpRS4922JNvbylNrwvsDY+3ypUaBcCq1ffMLBZ4Fg0rAeHP8mngAG8/CyWAlyHE/YJ8OuxHxWk7EiHkxSymzaFN4OffRKHO99+F/EEXr7pLbec03auhMnquvIkL68XzAK54XJB5B7Pak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208643; c=relaxed/simple;
	bh=XuWU6JqykbFbPZQ9yp7InJfmiNIKP+xlmuPcltmztaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRaYsPwAQKGlRPmzoMi6ZJxAK7NUModEGH9d2ehCPOJ/WUio95+xMOoRgAgySquFBJk6OPwScEu/lMpgM/Jaj2ph22qw0e/xxd3UTEYGyTdmFhLuB42lRYu74l2e5upWQHsNMtVq+HAlFobzEtSvKVvU67hcX2QDuXVfcjagyas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zj4uX3Sn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zj4uX3Sn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83BC7C4CEC3;
	Sun,  1 Sep 2024 16:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208643;
	bh=XuWU6JqykbFbPZQ9yp7InJfmiNIKP+xlmuPcltmztaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zj4uX3Sn2Ul0sznzrOdjw7w9YQ+59hBi9uoP+XVhwZ4cn/i63440l2Sql6Jgbs2GG
	 QPoKuM02En4SflLBRpL5JQyB78ZYlqLNKX2LqTDKW+fWJjyZRPr97Iw8i3n2A25479
	 XDEcjexAfMfHo2fkRPdWWqourli3UwvHt9T62H3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Niebel <Markus.Niebel@ew.tq-group.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 145/149] arm64: dts: freescale: imx93-tqma9352-mba93xxla: fix typo
Date: Sun,  1 Sep 2024 18:17:36 +0200
Message-ID: <20240901160822.899034770@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Niebel <Markus.Niebel@ew.tq-group.com>

[ Upstream commit 5f0a894bfa3c26ce61deda4c52b12e8ec84d876a ]

Fix typo in assignment of SD-Card cd-gpios.

Fixes: c982ecfa7992 ("arm64: dts: freescale: add initial device tree for MBa93xxLA SBC board")
Signed-off-by: Markus Niebel <Markus.Niebel@ew.tq-group.com>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93-tqma9352-mba93xxla.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93-tqma9352-mba93xxla.dts b/arch/arm64/boot/dts/freescale/imx93-tqma9352-mba93xxla.dts
index eb3f4cfb69863..ad77a96c5617b 100644
--- a/arch/arm64/boot/dts/freescale/imx93-tqma9352-mba93xxla.dts
+++ b/arch/arm64/boot/dts/freescale/imx93-tqma9352-mba93xxla.dts
@@ -438,7 +438,7 @@
 	pinctrl-0 = <&pinctrl_usdhc2_hs>, <&pinctrl_usdhc2_gpio>;
 	pinctrl-1 = <&pinctrl_usdhc2_uhs>, <&pinctrl_usdhc2_gpio>;
 	pinctrl-2 = <&pinctrl_usdhc2_uhs>, <&pinctrl_usdhc2_gpio>;
-	cd-gpios = <&gpio3 00 GPIO_ACTIVE_LOW>;
+	cd-gpios = <&gpio3 0 GPIO_ACTIVE_LOW>;
 	vmmc-supply = <&reg_usdhc2_vmmc>;
 	bus-width = <4>;
 	no-sdio;
-- 
2.43.0



