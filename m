Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030364;
	b=hge2xiIPHWnRJ4KVytz9kq6xsPhs21mKW+0PISwShDYlZIxXVz2gVa/xmIFkE7XOb924
	 dxIjzHst7U6z8hDN0hY5hfgyDzxzu4HU/M/+D3ypfuuOjems8Lduoxj8arKuxMqZcKMMw
	 dWHgBZeZnWt5D+KjETWNJ9hIa+n5O+ShJ5x4ijvslAW5zwyVHXJUOZfbDOAm1DCRD92Ya
	 1nACqGkOb67gFyKPNfZUlP9rXDdrQbkOoF/xJfNAikrYVOK6AuhuNOG2gyfRH+wH9AUY2
	 fC5weQ8IzMl5fsWKVXzpaNGX1N9tLu6D43EqAgdnzdjA1w5G5D4zDMellVWVsgPYeZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZRozOafoOz62IowSZEMfHLMouigHE4HieWZsakiVlRM=;
	b=Hg1pjQQBOQvunYxkc7zTnVawM3U+qxdk7W7qpS1QZAHii8OKxgSsVdQXOAEv+JBeBtAm
	 ox+1pFDENAYyT9a83i6ATNwv+7p5iMP0NVY43mtUVuC8NgVfpqdbu6BkdvWg5ZF/QPW+f
	 VCA3oD6ss6v3LhXbfqo0DlMEt4h2OY7LlxrxLP17edaOdIliyg9eGA2yIRFAOEfZQeSG3
	 1RP/eA8e9kRWIu4uubodgFVOU92mC4PDAlzo0xUlS9vQUOW3gadQQhRqEn9wFflooPc8D
	 JlJiojvdWWGVZzkjza4DQUa8lEw8fMjpwu2aNTzSA86JgrCfpvq3B4czTiOZrhsXa6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IIV4Igxy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D44606B101;
	Wed, 18 Nov 2026 19:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IIV4Igxy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0951F000C4;
	Wed, 18 Nov 2026 19:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030364;
	bh=ZRozOafoOz62IowSZEMfHLMouigHE4HieWZsakiVlRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IIV4IgxyckOwTWYuDH562AIZjioh/gSsbtvCgjkm4oXESTOuMki/LdfcIDTEDOrDH
	 6zLRSZucgNZYESQhNx/XKmUrE7Lw7ZELJ9CzPtmowSnv8TyyPfUwlKPFjyUO7mfL5e
	 J7LMq5qNpEQxQQQSv3XwZJhFmN//N3f7s91wPjyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0677/1756] arm64: dts: imx93-14x14-evk: fix reserved memory node names for remoteproc
Date: Wed, 18 Nov 2026 15:46:44 +0100
Message-ID: <20261118150036.216807869@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit e62f7ef5320d05361ee7f665568d05361b0c59d9 ]

The imx_rproc driver checks for the name "vdev0buffer" to skip mapping
the vdev buffer region, as it is handled by rproc_add_virtio_dev.
With the node named "vdevbuffer", the check fails and the region gets
unnecessarily mapped. Rename it to "vdev0buffer" to match what the
driver expects.

Fixes: 0481dadbc5e5 ("arm64: dts: imx93: support i.MX93-14x14-EVK board")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93-14x14-evk.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93-14x14-evk.dts b/arch/arm64/boot/dts/freescale/imx93-14x14-evk.dts
index 236a44c1782ae..6d036a72d2b69 100644
--- a/arch/arm64/boot/dts/freescale/imx93-14x14-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx93-14x14-evk.dts
@@ -54,7 +54,7 @@ rsc_table: rsc-table@2021e000 {
 			no-map;
 		};
 
-		vdevbuffer: vdevbuffer@a4020000 {
+		vdev0buffer: vdev0buffer@a4020000 {
 			compatible = "shared-dma-pool";
 			reg = <0 0xa4020000 0 0x100000>;
 			no-map;
@@ -138,7 +138,7 @@ &cm33 {
 	mboxes = <&mu1 0 1>,
 		 <&mu1 1 1>,
 		 <&mu1 3 1>;
-	memory-region = <&vdevbuffer>, <&vdev0vring0>, <&vdev0vring1>,
+	memory-region = <&vdev0buffer>, <&vdev0vring0>, <&vdev0vring1>,
 			<&vdev1vring0>, <&vdev1vring1>, <&rsc_table>;
 	status = "okay";
 };
-- 
2.53.0



