Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043293;
	b=gSzpESpyZXflt1g6xI4byKT2RHOZ6e2yWTYdhfAtL+LUHM6dTolBXZkqcoTFW1hkBZyh
	 IQCLz0rLn32ofLQVl7q1/bP1k2HcVpg7av832pLDsrq23JzbtE9NnJQQcHjXNjEbkT00E
	 HtfZPIUtsybvA01SSn0ohBCxDxiOR6Q8xNgg1FoWLB1HhXFyLFmsrUamJ7n4EbRVo3NQ8
	 DxO75u+o0tiQQ0mtlkleI31tWw1wa4R8TryGz4PWsW8AfUs/cOWe2K8O9NLwPjKP/Y/7M
	 3ic/jMEMBm7qv+wBS6Z0SqtNyWfe4fiEOg+kZ9j+bUYV+2+LwiRizFglOVx5IrQFYuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043293;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gD0LM0fOhCZY7OE8psksn0/vRWmueVn70mQ7gNk+XQw=;
	b=fnHCTpQdHk5zHNS+TseprA8YcEWjPgt58bo5yKejFTfkcWV4ubsnfU8oP4DK7TwwWvfm
	 VQSxT426PnBx4WFj4JtvNkjQBhMDBvT9y/Q5ZNBXYDIlRcgF7dgpO+GrRgNXFlgnjBWRw
	 ooXk4be6uGRJv0L/kVfNWyNC0uYlLk4dXCVRsBsLjrwYjcGm4bCVIzpenVFtep/BD4M0u
	 boDCyXrx9H6TZTs+9im9/dFpvLxqNZTkv44QIp0sGpD67neERib2HwVROUSBVu+m4wSyL
	 3zRcPOXPp5jf+92D0wu7y17C0v511w5S/4sUgACtu8g1tFqDFENa8+jZOrkct2/adTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h3rFOHF+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD78606A330;
	Wed, 18 Nov 2026 23:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h3rFOHF+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD1E1F000C4;
	Wed, 18 Nov 2026 23:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043293;
	bh=gD0LM0fOhCZY7OE8psksn0/vRWmueVn70mQ7gNk+XQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h3rFOHF++YRmLsibWEGzZtW+nSP1JcSyjirt1j707vgVHrA5ZD33/iJd9YclM2yj7
	 lBuSxtIxbWdrK+CZtw4J4LpyEA+pcmcG6CMZgU8NNlLzvNNpQLQilacZi4h8RTFRbx
	 ZEs5JeJnWJp6grp1cRg5UQyf73afaT7umrJDcCps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Brian Masney <bmasney@redhat.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0160/2857] clk: imx: imx8qxp: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:19:54 +0100
Message-ID: <20261118150207.110965324@linuxfoundation.org>
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
index 28265e28856c2..bd350ab1e012d 100644
--- a/drivers/clk/imx/clk-imx8qxp.c
+++ b/drivers/clk/imx/clk-imx8qxp.c
@@ -316,6 +316,7 @@ static const struct of_device_id imx8qxp_match[] = {
 	{ .compatible = "fsl,imx8qm-clk", &imx_clk_scu_rsrc_imx8qm, },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, imx8qxp_match);
 
 static struct platform_driver imx8qxp_clk_driver = {
 	.driver = {
-- 
2.53.0



