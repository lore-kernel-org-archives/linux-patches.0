Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064100;
	b=MtOR743G1Dr4Dn/2KHOZjIDCWdHya+AW0vdmTUanz5W8jgn7Ic3fKZ1oxKtzs7YMpZiS
	 fN9We+u0Lu5lknM1fsC89t2OFRdJGDVY2TLObo0oS7FCDntQ0or+VBCtOvi/mv1AOHtRw
	 ps159TtMP3I7guIGR2q2nQTVRMgiTiG+9k59pknYh95+pAn+KEmTFsSpB8ZhepQdAIwo5
	 psuukmGRcayJuNKIyDkT7fWdRuMCiV7/a3AXt2QfUsRbRIygoZXQoBa7osuQxeI448sZL
	 xbQ4qlvpjq6USYEUDeYiAeljkxwrWS8ntKOWtfcjKoZOXHD8Hzuvy0bDXHyTwku7L6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064100;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xf8+niUyWJPQ4e9PGsL32MKtYR89+6A8MiQO6eVEmT4=;
	b=e4VJnKkpvBJLGsQvPuEgR0lu/rtvr4bKPrxscMmUhNOC5oxiAqlkdxj8GYfeQl+Klc13
	 +1Ei0+T40/fdVWe1OwqdksI4aZtcbdJ1+8uMIww4Zvhl9wrsEugwzPbCkGx9YJP/iOR9Z
	 XHr14TtVICJq2eZg4fNNivkLm+p1l++sDOC0c7PSMsRs8fYXmIjeEdUvbjGFYb379ZemN
	 SYopwPGl+ZhtErSl4AITsK7iSh+cwjxb1/sQicoSAn749KGG/vAmirQR4AAyKCfOQmWpo
	 exg6JLIO55vvSmky44+2r9/RHlwQukSMWj9NbphrGrgZG/N8fXMavdyG7CIMT0LL3Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ONItVs2M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC6C606B889;
	Sat,  7 Nov 2026 15:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ONItVs2M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5061F0089F;
	Sat,  7 Nov 2026 15:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064100;
	bh=xf8+niUyWJPQ4e9PGsL32MKtYR89+6A8MiQO6eVEmT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ONItVs2MJiTLhkXAOAQsJl6koNY4lAkjs8rGZLO1YWGc2O4j7Xjymd2AM9GJgxryt
	 lFKf7kiEAxKaH9ff5uaFk05ReoIeUkGoDAkecjZOI1QWbk6QL/75OxfCGDeDdqod8Q
	 Ao6k1irpC8CduZfqZVFhSteqsjdiQKSGJ2WOSaJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0261/1257] media: marvell: manage the MMP camera clock provider
Date: Sat,  7 Nov 2026 08:42:37 -0500
Message-ID: <20261107134946.712151866@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 9887716132d6c3c58cc67841dfb441c5a4a0d209 ]

mmpcam_probe() registers an OF clock provider before requesting the IRQ.
Neither a later probe failure nor driver removal unregisters that provider,
although the underlying clock is registered with devm_clk_register().
This leaves the provider referring to a clock whose lifetime has ended.

Use devm_of_clk_add_hw_provider() with the existing mclk_hw so the provider
is unregistered before the managed clock and camera storage are released.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 81a409bfd551 ("media: marvell-ccic: provide a clock for the sensor")
Cc: stable@vger.kernel.org
Assisted-by: OpenAI:GPT-5.6
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/marvell/mmp-driver.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/marvell/mmp-driver.c b/drivers/media/platform/marvell/mmp-driver.c
index d3da7ebb4a2be..4c31b62751a12 100644
--- a/drivers/media/platform/marvell/mmp-driver.c
+++ b/drivers/media/platform/marvell/mmp-driver.c
@@ -25,6 +25,7 @@
 #include <linux/list.h>
 #include <linux/pm.h>
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
 
 #include "mcam-core.h"
 
@@ -269,8 +270,8 @@ static int mmpcam_probe(struct platform_device *pdev)
 	/*
 	 * Add OF clock provider.
 	 */
-	ret = of_clk_add_provider(pdev->dev.of_node, of_clk_src_simple_get,
-								mcam->mclk);
+	ret = devm_of_clk_add_hw_provider(&pdev->dev, of_clk_hw_simple_get,
+					  &mcam->mclk_hw);
 	if (ret) {
 		dev_err(&pdev->dev, "can't add DT clock provider\n");
 		goto out;
-- 
2.53.0



