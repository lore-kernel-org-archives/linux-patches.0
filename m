Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829702;
	b=3uCcfouhujhLAOja4EDk4lUtLtIee9Q4/PICB32FyX8C9ReAqJ/npuYPHwWLLQxEjDDo
	 3O+yUIEYJ1ODflvymdCUcvA/urVO+bruJyIObHjp4slTqwM2DwUnFKZg3BbwQoUnOV1Hz
	 zi2Ze/5sA23IBvDPC0PCZfO8o3RBkWlg5zHUX9R9JaY1quHtWe2HhETyC+/aFCUb0HO8p
	 iJtDeYAcqANptZjEpqgloPcNfn/LqKl+9L74Bg31VMtK83Zy2Tc6lDW+iNB92hqZE/Hio
	 JL494HWD1+dGY4Jc5c4PGk1tmFPzPSejDs8PMDssc2h49gYX7Rv6fnfZI0J5GfTz0Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829702;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sVNfF0Ft3YBYIxa8bTBSlcW7LIDvTt/Yd+mQCHwPTx8=;
	b=1c8WyukELddTmdngwptCUAb0jFbrScSNRmltIOZdpHUsgjtg5pkE3VWsX9QPuogBYO5F
	 EDEG4/nxEhZYj1Et4joD+F6XB9nlW/cpktIk3fhT9qBu2+4a1xPOXPvodLfRPb/pRc+7d
	 DrdAhhuxJQyGv+oBTRDsrYn+NmsK973KVKsPKfFxRtrDfUfDZOKXWqUpl8+UD0BRQEu0q
	 +DB/uh6didRECaWr3prOpCjRlmLoHl0dnAvTthXxy3s+gkRVS3J4EppsR86THwSXWbiBJ
	 AjR6av06UmGaCyVY/G+QnKm+cHp23gpi+qjxJh7MzKjEnvTy3RbYPOt2jYvxUTlO9VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OBmG+Da0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21006075DF0;
	Wed,  4 Nov 2026 22:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OBmG+Da0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F751F00919;
	Wed,  4 Nov 2026 22:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829701;
	bh=sVNfF0Ft3YBYIxa8bTBSlcW7LIDvTt/Yd+mQCHwPTx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OBmG+Da0/147fRDSjS/w3UlwMOZ27gPfOxyTTYKvBrGJF+EVHYt03/TOrZ0Fr8psX
	 s3Pro43ESURLkNFICcpwVw6/hAcmlWqm00XeU/Gp2LmOqJSvWnEzVmu/1s5T5qMKIg
	 SC/bTwPZVILFOyzZv2R2uXD/ue7TUNzB0AxVySEw=
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
Subject: [PATCH 6.18 0262/1005] clk: imx: imx8qxp-lpcg: add missing MODULE_DEVICE_TABLE()
Date: Wed,  4 Nov 2026 15:59:55 -0500
Message-ID: <20261104211051.207533756@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1dae3410ee99a..f0cf6cf918992 100644
--- a/drivers/clk/imx/clk-imx8qxp-lpcg.c
+++ b/drivers/clk/imx/clk-imx8qxp-lpcg.c
@@ -354,6 +354,7 @@ static const struct of_device_id imx8qxp_lpcg_match[] = {
 	{ .compatible = "fsl,imx8qxp-lpcg", NULL },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, imx8qxp_lpcg_match);
 
 static struct platform_driver imx8qxp_lpcg_clk_driver = {
 	.driver = {
-- 
2.53.0



