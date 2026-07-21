Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9308403AFB;
	Tue, 21 Jul 2026 17:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655856; cv=none; b=PvLagLki101S5AO5Xct8gKpQXCLqXOXoG5ZmaTi+8Jq4qkCkwZ2p8c2GWKVaLKYcRIsmWl9NIGnvKLe0tkv+qOPgkymTxcl3bwblzyud/oHeoRweDtPPrcl52y3O0KbrhajsJuh8solC6p1UFAJVHs8IZGkS7yqq/gCHfbjQwwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655856; c=relaxed/simple;
	bh=AIt+As1c1LehXycTR6MhQIs2toWTct4DADdvJeW3AqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3ZNh/VzuZGHAdi8d9sSA/9CwLFSx8YcvvZoZRDmEUifQmV8a3Uyjw0wsufMsZ7MAG4XoTTVpdCTvjq+6QxF34oPp6LcRPZim4mQ0nPc+AC3Fcice/ZCx3tOSlDFuRQPYM7ZV89LmlLsT1HqD5BeHg5xdb6bWSDCgNWWxJZQNJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xK0/uaBW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xK0/uaBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CDA81F00A3A;
	Tue, 21 Jul 2026 17:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655855;
	bh=cTuw+jMmmDClz40HFrIjlMTZTFNmnHc4zvOeGaBliPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xK0/uaBWxUnZcMLsrYUvptWt7ehyoiruis0qFcL6RBgAjMavFuNIcjBQSMQ2KmHWL
	 pldTkJUE3VbJ4xn8HE5lkh1pdv/+lajoP3l6SvWtkGxVvr/qNtB/4D3GHyCbdGmSjN
	 Y5IZNcUzSENbLuVQkhHTiam83jO0795wbpY7+YPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Sun <sherry.sun@nxp.com>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0167/1611] arm64: dts: imx8qxp-mek: Remove unnecessary PCIe EP vpcie-supply
Date: Tue, 21 Jul 2026 17:04:43 +0200
Message-ID: <20260721152518.645213744@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ea78e843415235..eb869770408797 100644
--- a/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
@@ -647,7 +647,6 @@ &pcie0_ep {
 	phy-names = "pcie-phy";
 	pinctrl-0 = <&pinctrl_pcieb>;
 	pinctrl-names = "default";
-	vpcie-supply = <&reg_pcieb>;
 	status = "disabled";
 };
 
-- 
2.53.0



