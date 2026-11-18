Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051253;
	b=MDRCLK3v7m/FGCto6K7pkpmlr56zkydoUAcqF74wQi1ZfEto+j885OrJA2ZYHkCnOxe9
	 rHsmdVqcxGI17xFREBI0ThIdzstoRIKhihyqzeO+uRTMjlYeGjBjcVYJhyEzR5pTX+IGP
	 ZWNVJfd2KzwfI1z7GN/OUnUXZuKWJNEPSKScRti2pYazcr8ryaTDpoxNaqm4ZhaKoFv2E
	 5D0g9DDSheK6xmU7+3qFCwqiPRXDQ+yvnXUsG4fvn5zcAquFMIAeNRivk1ZYPGraOcLKd
	 bIagceDj3BeItJGq02gglSanGyKLCvdi4Fqx82q5we0suvzdsIvFU/gAEESBfZedx2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051253;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bCFjZynG4jCgIWoP13v7VWh5XYT1C609BB87oGHseWU=;
	b=sEInkGNsOgF4mnRhaLaXWBTXqP4QW19NIW3lX5E4UoAB1OFXMbRCtxuuRDtuSqSvZg31
	 m0BepQhIBb0I8Pc6jDx/jkpVyplRTc2AaplNbikPqlUS7a7ZmXBTP4lpEl6viCyzkNr4y
	 3DYZCHr0LhPSH9mRG6Ir3z7COblpOdjT8PN9yDo20BUu3XpFgqprGqUFpcy1hV6h/fJoW
	 XY3vphUco24A39Ct1TdCl9sEO0il8rpWPBsBcAgcH1GqEhmez6WAl13/n3X0GN08CqXik
	 +RzaUk7nVnIizeAHiSyh9FlzhDxBfYFn6edpNJlo80qj23QxQi1PvsMvt9O/ymCxFpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nlp4qiDa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D25F606A31C;
	Thu, 19 Nov 2026 01:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nlp4qiDa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9091F000C5;
	Thu, 19 Nov 2026 01:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051253;
	bh=bCFjZynG4jCgIWoP13v7VWh5XYT1C609BB87oGHseWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nlp4qiDaQ8ryjZEn704zEMBUhuR2iXUF880P7/cjvtDms0l4LFb3Ltb6gqlmddfLj
	 TrVxUmJOpnm8ieNHbjh2jCeLRN3SBuhOI/y+P9FERUUlkUn6N/cGSfsVi3yuhTlW1N
	 SvwydneqTBCpEmZAILO7X3J+hhsU1qaWKwui03Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Brian Masney <bmasney@redhat.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0144/2214] clk: imx: imx8qxp: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:30:20 +0100
Message-ID: <20261118150015.929021084@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6d41ae4ebf726..1c6a4b75a9a21 100644
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



