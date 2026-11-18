Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054122;
	b=VUUEBc2vsCB4kv+/X1jwec4kNY6F7m3iNTQtlMQhlrORPqDSvrY6DgbAnONBUUslFZTp
	 FCVQVP2jB1NH8z4S9qQsgQDfPSOY2IXTo6R7HkByLT4Um0TfPrYdb0/Sefzi3Prr6C8xe
	 xb8R7LV1w721NFydFLjwur2SVXbB90Vrb353r3962BSGSNifD1bxAHa3mOV4IrH+U0RRO
	 ynJA9FNUUAZ3FDWK54lsLtVC3OLu97LTTT2O5ylPwk2MFeKFgGzdQIahQhGqbRxIYgV/U
	 T56rrBm4HujOq35LHV13jbs2BIO1nFQzH3jUQ8SBc0RhaiuCWq92tixnkTgQNve93pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tkyPu19bbVzP0R+LZP1QO/aY7Msevp6IN1Afy3Bd6Bc=;
	b=40u4d0VO5NrDQj/vs+ZZ5Pp3w7ps2QMfQNAk7nUJOu8LZGorSSPKPxjtg4+W63Q0Z39C
	 VV7DQgne8rW4dcc+AtUmsW1nJBm4Jdgrni5eKPmS0u0eq6JkvONtOyVMiO892B1jvR+4F
	 fu7eYfG619bRWLxea/7a9L2FdkfNB+lfToOE1X0p7pktA5rKmrLnF83WL9Z75SibTYNal
	 8kGG302MWBibMMDCahajOC0nsO2ganqRcUbs2jLjiv3Onn72CNpxSdzWoNHSh8AnPPQQY
	 5BuLmiy1w5c5KvU0LAKT/it5XLZTP3HTX9w3jr9+YFwuAJDM97GZMUJee2KLlwiK2lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rw1NxVyT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4083B606A33E;
	Thu, 19 Nov 2026 02:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rw1NxVyT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3381F000C4;
	Thu, 19 Nov 2026 02:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054122;
	bh=tkyPu19bbVzP0R+LZP1QO/aY7Msevp6IN1Afy3Bd6Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rw1NxVyTBZ90Hy1ZPLRlemjsMGJ1ueeAIzhIhryO6kqm2EvN4LBzM5vb9ynGJF+FA
	 n7sgyEHcAYvhJwddhUc0d8CmUsV7yNPwi2bFFS8htcLULD1cATSzph3CL/35N6Rvhy
	 c/6S9n3EbqmyNHOpGc7B60eew9AU4kAn6qBDPE14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1109/2214] nvmem: rockchip-otp: alloc clks with main struct
Date: Wed, 18 Nov 2026 15:46:25 +0100
Message-ID: <20261118150056.515006421@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 9f99bb979f930e52e6861114fe03535d4bc2f374 ]

Use a flexible array member to simplify allocation slightly. No need for
a separate calloc.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260530205333.117458-3-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 9fc6a1592d84 ("nvmem: rockchip-otp: Serialize reads")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/rockchip-otp.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/nvmem/rockchip-otp.c b/drivers/nvmem/rockchip-otp.c
index b5a84b379da40..aaa044bb231b8 100644
--- a/drivers/nvmem/rockchip-otp.c
+++ b/drivers/nvmem/rockchip-otp.c
@@ -64,9 +64,9 @@ struct rockchip_data {
 struct rockchip_otp {
 	struct device *dev;
 	void __iomem *base;
-	struct clk_bulk_data *clks;
 	struct reset_control *rst;
 	const struct rockchip_data *data;
+	struct clk_bulk_data clks[];
 };
 
 static int rockchip_otp_reset(struct rockchip_otp *otp)
@@ -239,7 +239,7 @@ static int rockchip_otp_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	otp = devm_kzalloc(&pdev->dev, sizeof(struct rockchip_otp),
+	otp = devm_kzalloc(&pdev->dev, struct_size(otp, clks, data->num_clks),
 			   GFP_KERNEL);
 	if (!otp)
 		return -ENOMEM;
@@ -250,11 +250,6 @@ static int rockchip_otp_probe(struct platform_device *pdev)
 	if (IS_ERR(otp->base))
 		return PTR_ERR(otp->base);
 
-	otp->clks = devm_kcalloc(dev, data->num_clks, sizeof(*otp->clks),
-				 GFP_KERNEL);
-	if (!otp->clks)
-		return -ENOMEM;
-
 	for (i = 0; i < data->num_clks; ++i)
 		otp->clks[i].id = data->clks[i];
 
-- 
2.53.0



