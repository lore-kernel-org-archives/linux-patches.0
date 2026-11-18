Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043295;
	b=4zIbXTZXgijVA419z4twHNyErHFWOcS0BsoXo745IGmeyTYxkS6jBGMjvXyUv4NyjY8Q
	 PxZnWmCbuptnWjP8mEZWf9As+l4M2ZVGsf9lyU7zFfGnIc6ugUYSdnEzZR16bWsl4xd6q
	 zpzHBM8enYYW3Ptr9Lcz5167BUKXxhCVwqsBZzJttWt9sUrlcCeOoBMLxP5IqTGGedF8c
	 GACJ3FoOjncMJOJweKPheUgctDKjI4p/oNsfWKOltq3+VUu2O9eSRn4dXMNLpswXKLaYS
	 h1JJIHbzK/kBtmor/BebHz0aGoSyT9MVHcCq4O+efOJ8oOSO91hLZEhUwWYgHO5HB+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gYr4U1aZ75U2wtzOMLhw42hWKV+zZHrmAe+yR+NcB6c=;
	b=Xvr+VsDGIG/6vK25NNjshKROZAFRC1YG6BD7yQtHOFsr+NYPWIhNTYw+5d2lGq8u63wS
	 TlWikkCn0caYkPpOqtwyIqJNw0vdWkzQFNNDquU2FQpUQbJp5ks1XRuPg7ZXg+4iF7uYE
	 6DJgneJY6vuWmXaM+Wua4ZT4+Wls8O6JAhgPlVGhgmc+vtZAeJ56UTDCKjJuPioDpGLR7
	 aYLaWlGLHir1HHuU2MQbtpILtRlZd2hDerNtqGV+E7I+5fid1hUIpUinZQFUnJC0U8ouo
	 IT1V92bQ0RhhCtg2qcIQGeOtm8AEhxk51H59LDy/IcbL8iF6cXKsqjvPplmN9OYhmgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qW1qt/8p";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35C5606A32A;
	Wed, 18 Nov 2026 23:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qW1qt/8p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF8A1F000C4;
	Wed, 18 Nov 2026 23:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043295;
	bh=gYr4U1aZ75U2wtzOMLhw42hWKV+zZHrmAe+yR+NcB6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qW1qt/8psyM5H7Mw+n13ED7r40hXan2yM3WG/ZOqajnww4JOnhrnGNm/oPThZJWZ/
	 DZ4OBc7jqa0CwB4rZFNf6XpYGOAR1A4EtQNFzUrU5nXpnqPBpVBC52gdi7aJI4I2R4
	 MGrFxM2qIxTB0pS1vFKbDoN5Sje6ge2gOO+G0Hio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Brian Masney <bmasney@redhat.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0161/2857] clk: imx: imx8qxp-lpcg: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:19:55 +0100
Message-ID: <20261118150207.147730266@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit e89485455ac49925565061733c0d73d568333fc0 ]

The driver has a match table for the of bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Link: https://patch.msgid.link/20260704150344.59563-1-pengpeng@iscas.ac.cn
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8qxp-lpcg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/imx/clk-imx8qxp-lpcg.c b/drivers/clk/imx/clk-imx8qxp-lpcg.c
index 5e31a6a24b3a3..a1569ddca7bd8 100644
--- a/drivers/clk/imx/clk-imx8qxp-lpcg.c
+++ b/drivers/clk/imx/clk-imx8qxp-lpcg.c
@@ -359,6 +359,7 @@ static const struct of_device_id imx8qxp_lpcg_match[] = {
 	{ .compatible = "fsl,imx8qxp-lpcg", NULL },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, imx8qxp_lpcg_match);
 
 static struct platform_driver imx8qxp_lpcg_clk_driver = {
 	.driver = {
-- 
2.53.0



