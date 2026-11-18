Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033917;
	b=xHTa5BEKS2ta+BWKpRvgv+kGEbgUJtHrkmjYivwzcNZRBoxmBE8fZilNEXBjiJXEKjTP
	 RbRWGR9TR66952fDBXkW16UKoplMHWCWd6AqFgqTEBl+namB34iaH9DzFCeMfdyyaUwH+
	 NbORK55SoSQ5Msae1xKx4y0mRkfTcqPrSjrQ1GGPDRDirFH+Ssi9iKsrckw39rj+NdvfK
	 10BCiwK8sZjVP/dCRFRxQ9YQMTw57yjz5mQ4wEdhFLCuISa76w06Xr78ePvfOTG0w6n2b
	 x3FrWwILxnjPLoWBHu+b+3BvmYacGygcMcwXdnyp/auONpcc7WOkcSK3Qrf5JhTYjtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wOsKH4Zv/JTebWxJ1OjMrc3RZHl1NuS5MqYB/peiZXg=;
	b=RMJghi8SLCX5sogerYBysnb2K7Ihm8XFzMrUvw8DtBW1r5S5/ZQXKZMzL/vNCp+pXLkf
	 7JWwsfXKfJdh86wJhB7kIGJvqE/FCufApjzfUHt78vUcEhK8/sp/XTUgId5OopdxX5Ow3
	 g+alpo2YD407BtcST0uAJvkG1drXop+wCWzBc4P9WwLcLAfcT+Wok/Q/8dC4EmKLIlWC2
	 EdlTNqXOo57Y8g/AGnj+ONBm1ze4d5wT3gHlhXHKIRW0ptgleNo/h2zm1lPuFhQbU5+lD
	 fKvFGq/K5noOhJ/QBOQMbZOT0RmfB+eZHMuGotL05JNJErRRjWRfJLvnSa/syqktv+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="aiCwQ7/Y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4263606A31C;
	Wed, 18 Nov 2026 20:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aiCwQ7/Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DB61F000C4;
	Wed, 18 Nov 2026 20:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033917;
	bh=wOsKH4Zv/JTebWxJ1OjMrc3RZHl1NuS5MqYB/peiZXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aiCwQ7/Yx2PfinbUFyxdgIthkvDAILJwouBM6LQS9UH76WBCVErkKE1FRb2PydTR7
	 69rb7cRsuDexalbqGOkPgwWuFU/tK6hAaPwaVJx0W0Pjp8VEPP0HqsER4nnqvrbBXP
	 pGY/ED8C4KAAxV9BCcAdzNnF9GQ9b5nNR/Eozuh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Brian Masney <bmasney@redhat.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0185/3318] clk: imx: imx8qxp: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:13:27 +0100
Message-ID: <20261118150320.297817340@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit cd21fdcbef3fb32136f72075ab668b075423b3f6 ]

The driver has a match table for the of bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Link: https://patch.msgid.link/20260705001705.70400-1-pengpeng@iscas.ac.cn
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8qxp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/imx/clk-imx8qxp.c b/drivers/clk/imx/clk-imx8qxp.c
index 6d458995f3887..a986317a6bb18 100644
--- a/drivers/clk/imx/clk-imx8qxp.c
+++ b/drivers/clk/imx/clk-imx8qxp.c
@@ -315,6 +315,7 @@ static const struct of_device_id imx8qxp_match[] = {
 	{ .compatible = "fsl,imx8qm-clk", &imx_clk_scu_rsrc_imx8qm, },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, imx8qxp_match);
 
 static struct platform_driver imx8qxp_clk_driver = {
 	.driver = {
-- 
2.53.0



