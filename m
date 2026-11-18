Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029689;
	b=OfGRX6jThRXzFJFWJXgN4aP+p/iLTwLc243HtQX/EB1JTodZXOFswy39PKhsecPNwK6R
	 R1IgOAw2o1xKvtSIBso9vLydO3dKNjqp9RYbpH5XjCCJOj8i8OXcXwkxOpi1qXTyO52b7
	 5eo3+lSD+83zRLrkuZDuluv4YXCdV4uReh/e9qMxzW6AZouSw6aCgnjkQE1ReMZnwoJJQ
	 U/f1VCvDJAJ0k44JavV2IPa/bkSioQSQFwoQSO36fMp00qEcPjOchYOPX6vXtg529Fikg
	 CGyRqfoi2Q1Y4G8iDOjjQ0/5THZyI3dd8+AS6vwRVj9R+uoN8ICrQWO+M2Px2IZysjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029689;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/OX6Fb91R/wn6/llM8ghIpCnBrvKXZKTvfnzIhC0qlU=;
	b=h3T/f2mhnMjRrvpnlPdndId2SBuPi6m0Y+881iFyo2rGfKqmqD4V24M+9QNe2kNVFCPt
	 H3hFlSmFCjU5my7M71BUn/nO8wFPV671TW0uQntzLitHDabDiVE6BG6o8meXsqdKHKFin
	 vm/qpL0VzEriaqwG8Kskul/IxutZJ2HJCL1wCthR52s852x2DGol9II/vLGH6AOHyqEUw
	 y2oAj9mqxQ1srfsugTnR/JVpYRd/nJ4Olhos2w+6ZQT4mRLokM+mI6doouYkTOkK65GDU
	 spndHtveeXN2VFgcg+VCo/yphYPeFOSB7XLZD8Epmp+Ks04xstnKDeyw5DABwaYTNmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SROtS4zM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4DC606A31C;
	Wed, 18 Nov 2026 19:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SROtS4zM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173EF1F000C4;
	Wed, 18 Nov 2026 19:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029688;
	bh=/OX6Fb91R/wn6/llM8ghIpCnBrvKXZKTvfnzIhC0qlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SROtS4zMxKzLDhG/cw6eTTII74adTzHwdPN6ixOaoKtkBK5NBTf9IT7o11h1Be+KV
	 ePt9BST3cE1kR9GxbZJqD6w4sFtybXJpMrfD00rwp7x2vUDodkKQ3q7SC9t7MFrrMY
	 sq2eu/ZyjrOCT13lDTTZUqvXr/eO/eF3WDs0LDlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0440/1756] clk: si521xx: correct the SI52147 OF output enable map
Date: Wed, 18 Nov 2026 15:42:47 +0100
Message-ID: <20261118150026.252097362@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

[ Upstream commit 7a4cc47d715f08309089d40b8c29fb0ba79917db ]

The SI52147 data sheet assigns DIFF0 through DIFF3 output-enable bits to
0x17 in control register 1. The OF match data uses 0x15, leaving the
DIFF2 bit out of the map, while the I2C ID table already uses the
documented value.

Use 0x17 for the SI52147 OF entry so both enumeration paths expose the
documented outputs.

Fixes: edc12763a3a29 ("clk: si521xx: Clock driver for Skyworks Si521xx I2C PCIe clock generators")
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-si521xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-si521xx.c b/drivers/clk/clk-si521xx.c
index 4f7b74f889f1e..b8f71ccb5e033 100644
--- a/drivers/clk/clk-si521xx.c
+++ b/drivers/clk/clk-si521xx.c
@@ -373,7 +373,7 @@ MODULE_DEVICE_TABLE(i2c, si521xx_id);
 static const struct of_device_id clk_si521xx_of_match[] = {
 	{ .compatible = "skyworks,si52144", .data = (void *)SI521XX_OE_MAP(0x5, 0xc0) },
 	{ .compatible = "skyworks,si52146", .data = (void *)SI521XX_OE_MAP(0x15, 0xe0) },
-	{ .compatible = "skyworks,si52147", .data = (void *)SI521XX_OE_MAP(0x15, 0xf8) },
+	{ .compatible = "skyworks,si52147", .data = (void *)SI521XX_OE_MAP(0x17, 0xf8) },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, clk_si521xx_of_match);
-- 
2.53.0



