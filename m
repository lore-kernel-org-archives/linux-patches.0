Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060828;
	b=x6yVaKb9NqV8w/EEjPGWYbbwXkHRMlBYRBRyRpkF4GBBVOr5lrPme/4QpaWN1eGEDiM3
	 m3cnDONKGLmCs5isXgR6+N0PSrJTMf8HvwzPkofg3Ir+U0woHrPiZdIQSQMNWaFN+VcWE
	 An/DPw1TmUuTnyDbQDfJ3qEj7z24KBkA2I/Nl16fI9C2cD0BATEKEui0heDGKecQHfVUb
	 5QkfpslKFEzvxz3vrJPxYO4SjjopjskMb8g+dY7/NqvKTvAfqjSxSojuCZ6iXYSIaRcaG
	 sclHSGbPAOh88lT4A+pRj4P73YONY6o07oce40aX6g++SWxOkgUHXkMyao7i9rF5dww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060828;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GnzO33mplxhzeILeW6SX+5B7dkz6j/IQeDNulXy1bGI=;
	b=heDKGfBEBvGojmfDy5pDOnjZ55I2B10ojriw6WgZLvqVacBEi8kwd0zdTyL3AFCwdyY0
	 b6qiBwI1NdrOAOUpMBzx3E2WLeJTtPSTQbxFruMa6w0JY0J9Ih4J7OFzY8qE8kEaJTCkQ
	 GPYEYSc6zv/bUenuIuoGK0OwGwNwfr1ui1faieJtwPFckXA02lDzeOarUuVZmF4bPToVF
	 HBxbEhuphqG+/j5+v8n3r4AU/hfqF4hnoSDlJiJwVVAjDq2k9bGcuB0BT+kIK2FQkdznr
	 0idO6m9zHNEunqmKTqaji0PIXCf+vW5CZlAkHsjOBr+/tAUyZOCg+SxRxAoKFrO67Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s9TdaAJd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBD6606A330;
	Sat,  7 Nov 2026 14:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s9TdaAJd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645221F0089F;
	Sat,  7 Nov 2026 14:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060827;
	bh=GnzO33mplxhzeILeW6SX+5B7dkz6j/IQeDNulXy1bGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s9TdaAJdO5RLRz1+dNJrCYMqJ31O2NWPcpTEKiqY/0680k2JwfVz37aGYDYKDYgz2
	 yYPnMnNrFtu49xg1GnVvwC2f3FIao1SD4rQa2x/Njppuz4I8hV/y6ksoNACMdgIDSD
	 gBc7WZTbUTPIwOqNQAzNhn97IWKl89FsnvDvVyQs=
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
Subject: [PATCH 6.12 0223/1536] clk: imx: imx8qxp-lpcg: add missing MODULE_DEVICE_TABLE()
Date: Sat,  7 Nov 2026 08:37:19 -0500
Message-ID: <20261107135003.927579497@linuxfoundation.org>
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
index d0ccaa0402252..36d7ed46d426f 100644
--- a/drivers/clk/imx/clk-imx8qxp-lpcg.c
+++ b/drivers/clk/imx/clk-imx8qxp-lpcg.c
@@ -355,6 +355,7 @@ static const struct of_device_id imx8qxp_lpcg_match[] = {
 	{ .compatible = "fsl,imx8qxp-lpcg", NULL },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, imx8qxp_lpcg_match);
 
 static struct platform_driver imx8qxp_lpcg_clk_driver = {
 	.driver = {
-- 
2.53.0



