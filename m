Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060826;
	b=qwTL7CrlldhmAD+qjng7j0UzrbEoMh2FMMrKTp7sPDmqjW3uqqPsbBpFw6cw0kSdeMa6
	 IDIlwLgxMEMLihgURMkop9zDGoOUoiD15FZci5A41t4McZtUQMwzLBJqCe1I9o2He8KLi
	 O1egiNQg9qwfBp1AXqFKncZit03Oox5EraPV1MkQDfh5m5GbuJ7XPdKHGVXHT9uNBJ1et
	 VH7OebKITzTMhGSAsE8e8nxqMvwik9vQZKtrjMzB2h12YmnLdpZp3qCdD82lBM5g6m00F
	 mJIVg71GnYti/CMXBa7YYs98PdtEp82HwbQ3u7y+6n2rrY0n18BeWAqAB4HRPOc8CJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H3kcMAk/5rhV4YUrdTelHTydTg4/hlde+Lte7saPSKs=;
	b=T1tYgtzalwVsV3XNChPa0M7oK1ZIslIutTX6I+lDytqdKdtc2qjG+Nbgbk9GiH0hRiCS
	 HDmxDUMHmOEoxgbxqxMnRmLp4CKx0+EXBWq88nR3FlYv2rWzqHkxsbB6T10JasbgSl4b/
	 V94hn5+6VomWHE8RvEr3eYX2VEWKdqdW76aU/aoXNhhYcIzZ52BHjHbz95Vw/UZM7EhII
	 535p/c//Uwhz4jRsIoQbXTbW2Y9yRG/4bpwBgsBrhpGFpKoUzwO8/iiLlqMODY7QBT8md
	 dSaRR28S0w86nn4ns0qfcosSln18xLTGoRNXlJN7SyfC2MQ8QvddfDVy4i/pebWwENg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dVWgYqVu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8A7606A32C;
	Sat,  7 Nov 2026 14:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dVWgYqVu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19CAD1F0089F;
	Sat,  7 Nov 2026 14:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060826;
	bh=H3kcMAk/5rhV4YUrdTelHTydTg4/hlde+Lte7saPSKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dVWgYqVub8kZ/PdHCtQhWX6zo5nyDyNEAl+17jM5NQUjP3AXP7CGMaGrgqUCwRhRs
	 EQynmeq8YlWK3q8BY4nIRY7n0NUIz8l1rIYAozLzHM4erwiwhtLug54a6aw/HkURy/
	 4RJU7pzTLjNCjHfPUiX0hE+jTVeL7c5Glfp2GSXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Brian Masney <bmasney@redhat.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0222/1536] clk: imx: imx8qxp: add missing MODULE_DEVICE_TABLE()
Date: Sat,  7 Nov 2026 08:37:18 -0500
Message-ID: <20261107135003.900264086@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3ae162625bb1a..15b08fc02f920 100644
--- a/drivers/clk/imx/clk-imx8qxp.c
+++ b/drivers/clk/imx/clk-imx8qxp.c
@@ -337,6 +337,7 @@ static const struct of_device_id imx8qxp_match[] = {
 	{ .compatible = "fsl,imx8qm-clk", &imx_clk_scu_rsrc_imx8qm, },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, imx8qxp_match);
 
 static struct platform_driver imx8qxp_clk_driver = {
 	.driver = {
-- 
2.53.0



