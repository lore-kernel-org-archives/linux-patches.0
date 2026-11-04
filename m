Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829684;
	b=pwANXIdac3wq7a6kbwJ/RqSYgV1765wiKgkS3VHLq9/cWqH2ScApZ+yJ3EcYoWxn0HYA
	 961lqm3kpk2i+zN1ldklNllt/u0cs966E4tm8PyW2FaRu9zkbufpRXTjhT3+AbCmHRwTo
	 S6+dstUNIisuYozQ7FX3AQjuHdQ/vDCElvltZcDw0+t0XBGo/s6dO30s6OgirfEKaO5UQ
	 5JCiZ36YalAgfjXB5PpwyGcqMre5VTPwpBoi4xcmBlLkdjEs1aB1UxxAK4Y1QmAVwXyru
	 nPWZz3k0GUKWX8r+MsRx4bxMO1dYDQXmocB6daVqPHabXKZPCdUKb3gjNsYRXBdTSLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829684;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uGnq5ZjKhLLO18ST69KcJHPCVszO4DLAdJMXiTGwIoA=;
	b=FGuWd+Ymkf4MvhJ9Aw7umuUpAzmeMcQL5qpyiqVu1nBm3RmxFuJYUPo1Fm3G9hO7TLG5
	 8UBD8EXGSQvgz514LEutNowdo3Bdjcpb+wWL0cSGzb7mmiUEup/2/jK1Vr06yVnl4HJGu
	 bbY9BhOxISL8i8YODs/tMi9on6/mXU4RHaVAdTJreQ+qPiVpkc0WMSjGC7PCQwnLpFtBa
	 PAsWdSSF3y9JOtxD8NgvJU1+XFGksFlMWYcCrYnEF1MpkGLtV58tvMHHCBDoyPUcRAW/7
	 z6yh2c85RMw4KX3QVhKh7YUlqyoB38aNGQ49rlirdmoSLhzsbdIb1lrW49w0mnF+8yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SsqC13T0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5485B606EE91;
	Wed,  4 Nov 2026 22:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SsqC13T0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3711F00919;
	Wed,  4 Nov 2026 22:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829684;
	bh=uGnq5ZjKhLLO18ST69KcJHPCVszO4DLAdJMXiTGwIoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SsqC13T0GZ4SOam238/L0asvdkqQQff6Ca8WCPLCnQ9P/bXtTOoBaWVvm3okt7AXh
	 23O2C44eeD0G7OmKTyieDHm4vKMLYtzMOfl2zwTTtuNItavkQiJWc9l377VOiz3Swd
	 9VKQqhdaePvS36vz+6UEmUrqldUn990DoQy7QdDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Brian Masney <bmasney@redhat.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0261/1005] clk: imx: imx8qxp: add missing MODULE_DEVICE_TABLE()
Date: Wed,  4 Nov 2026 15:59:54 -0500
Message-ID: <20261104211051.178777158@linuxfoundation.org>
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



