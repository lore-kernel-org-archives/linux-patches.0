Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057426;
	b=mEvUdw/+4pUd+a67xOheTrVrz57EFTMxE59alBlHi4MoUcbfucpNKhSJ3CD0y6wp6YIq
	 AIm7WfBxKAXEp1vKxCQAVYHO9iZ+j8lPZQoGCh0RgWmCbAHnWd2+zZEjWvISl46RVojnN
	 FPPdqaIT+1oaSH9guIoICpQbhBSrHhB/ioQ8Q0k+uSNTKd+/Tb2mfYt7caAIuVbqTm3xg
	 0QUfgyD1H2sOOIN9LfsHicyobzIE9KfmX9RS1lJRIgH79yX+BEGvlN+UhRTt6TfVFuSDi
	 dreojCzgzoqj/BjpLR6YgxExuS22XjsqojvLQXvL1KCBJopR2xVYcMyOGH1S57J0i0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057426;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ymp6a5IizbA2JM17uYehrbWLCv8TWvXVqA3NVEo6z1Y=;
	b=HxoCBvTNkEbVAzs4gJCcoRKdt+Ch04TYFlDQJpQMSJUPQy2dueRTZQDGDq9nTMxxu+1f
	 6isz1Jprjp9+PzGY0Zj6w7ut/d5LSvf/R6x4Vkhd9YGSDSf+nKrmL4rhOAg6TEd4uqRvK
	 LR0a75shXDcKSO3wM/TgD50FETxNZxbFptYNMf+8cwYci5YPySvUA/QZ6JQgfhVUgP3oQ
	 dUUj4eWGabu3CZWgmPd9NVm958cPgkUUB87gLT+/1Bvpw3VxCqLa59dG+nKar4CYPUSRA
	 VW2YVwPVylmOMb5Bc6JbiSQyJkL2IOSyD4guecOowY/0apQO+UYwjxSrqcnOqa39VqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qi4ooGvp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46ABB606A336;
	Thu, 19 Nov 2026 03:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qi4ooGvp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F72C1F000C4;
	Thu, 19 Nov 2026 03:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057426;
	bh=Ymp6a5IizbA2JM17uYehrbWLCv8TWvXVqA3NVEo6z1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qi4ooGvpP5lDjZli2ETUQK7063d9sSXft594MYoWYHNE4xAt2SsFoFt2qtIrIVhUJ
	 7+m8c5UNhJM40fOALsTLpUg+Hy46M9BBT7PPe6rwFeomTQGKOVYlyZbEppMtL/wnIj
	 sIra2I+TT6f36WxvbljbhAYoWFbUS9LxMY/2Kq9Y=
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
Subject: [PATCH 5.10 0125/1848] clk: imx: imx8qxp-lpcg: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:36:03 +0100
Message-ID: <20261118145916.301083676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 522c03a12b693..d2976e0015666 100644
--- a/drivers/clk/imx/clk-imx8qxp-lpcg.c
+++ b/drivers/clk/imx/clk-imx8qxp-lpcg.c
@@ -221,6 +221,7 @@ static const struct of_device_id imx8qxp_lpcg_match[] = {
 	{ .compatible = "fsl,imx8qxp-lpcg-lsio", &imx8qxp_ss_lsio, },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, imx8qxp_lpcg_match);
 
 static struct platform_driver imx8qxp_lpcg_clk_driver = {
 	.driver = {
-- 
2.53.0



