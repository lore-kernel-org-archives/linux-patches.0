Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F826478861;
	Tue, 21 Jul 2026 15:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648543; cv=none; b=hJ88hy5nxAdT7wZKrZCY/5YoDLA5hFInKahJIMl3DOHOUArQafMN9BsFiPntmRizzo6gyvXQQLOuWQErqVJeSn4+zY9WaP27mxw38B8XvgGOfRo0/OpmUvWsZGyznKAB8eHS6GBVle4zNMtjJ78dETqxQKJOHv5sqj9TMYCBN/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648543; c=relaxed/simple;
	bh=+SPIGHh6bq9LDHCO0rsp4uI5G5jRAi6qzPFvYIu5sJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=af3Ni3pruT3TpFG9B0a3Dw7R3DeeasjNEDWtrnUYS9KgGgojQ+Dd7B6IAttQEwxjypE6vAj1MFIFO8rpw+SNjpV/znRTGnnDi4OopTmPtV8eufJ894ruJDd3vRW9cuzzB2vJzW5zzuRTDoV1txsagu198FbGANXTrUDRNF0nOEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yFQEgx/7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yFQEgx/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0AE1F00A3A;
	Tue, 21 Jul 2026 15:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648542;
	bh=KPXvi8sKdCQxrSzJ7cxalOyJazO/YOyqDdzjk7tn08Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yFQEgx/7MLEjJuFOYoyDdgT43Wlfq8rPVl0oY8PzTuGNxyKZmZijC9zS3pOzHoSHy
	 7fcfo2UK23VkR5YjhqeVgbxc5ngdpg1WJKw4D/VZlbqGzFh4MLN9gYEZKFdnqb47yY
	 ThYoX9ITvITznbAnRPY4ENxY9tJCuRKELHoypTyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Sun <sherry.sun@nxp.com>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0240/2077] arm64: dts: imx8qxp-mek: Remove unnecessary PCIe EP vpcie-supply
Date: Tue, 21 Jul 2026 16:58:33 +0200
Message-ID: <20260721152558.336811438@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit b5ba136d535f1060322af31c0cf74d85ea19892d ]

For PCIe endpoint mode, only M.2 power supply needs to be ensured.
On imx8qxp-mek, the M.2 power is always on and cannot be controlled,
while reg_pcieb only controls the M.2 W_DISABLE1# signal. Remove the
unnecessary vpcie-supply property from pcie0_ep node.

Fixes: 1c9b0c6044c2 ("arm64: dts: imx8: use common imx-pcie0-ep.dtso to enable PCI ep function")
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Reviewed-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8qxp-mek.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts b/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
index 623169f7ddb5fa..c07138055229c7 100644
--- a/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
@@ -742,7 +742,6 @@ &pcie0_ep {
 	phy-names = "pcie-phy";
 	pinctrl-0 = <&pinctrl_pcieb>;
 	pinctrl-names = "default";
-	vpcie-supply = <&reg_pcieb>;
 	status = "disabled";
 };
 
-- 
2.53.0



