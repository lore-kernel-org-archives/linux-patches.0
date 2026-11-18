Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048877;
	b=L0wDNyJPN2VHVPSKgEO2JAnpkH/OEVAxwR7aL5YL4CyQmEvOzokGzbY/H8nSuIV/nyhk
	 wwHYflUBuQ8prci3IoCKpuTXMPQf2Urewz5S0FF4yWTOCrzf15aYIM1NhdIRHmlvkx4eJ
	 hUeg0ALDHNwkXpbdAw1P0ekELuGU9peXYMY7tqNslA77RYpj4AXt5WTmSsq2UjCsj1AUM
	 ZGIItsbBEUBeZg00QlYKHM+fyOFfDVF3VOD76kt6bHfjXZMcig9/nrPiRJnFfjpJju6TC
	 XFNtvLcorvRjB3yVDjvWsMXPNjAHd9tYaZvLExlFlJF/y8NjMQce0t+19MzFuZI5hFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jFr04HFwQpfMK3oK4w73HPML+O9EDjYX4nOHdhy98lo=;
	b=ueuf212qPa10StP9+L2nRKVlfYhy21UmnBAYENopp49RavqTH2p7rp7dRAUNu/Y5baco
	 pZEkFprbIHhdVFCHFA6DsVJFK0KWOeE/uPQ6l5XDdUfvMXaEptxKrz+7kKm9Ul6o59aZQ
	 MvuT8kvPf0Ys9rEi563MqwQ6GimTrfpMuctFXAoHjGuD0RXSC50iBYZ1fJY3NgVA8eKRe
	 gYjzkr5wcX9hhGYGf7VpgSsSivcN/EdBzWW8cOvS/2UgxrwsfLn5Dkhk5zzDli2FQOdIx
	 6l53kLasrqshVjZKnksI6tg5L2iNCANgm+IiZiaBjeixgdOIjJ0QERkDlrVGu9EWG0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M6nlsubF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B36A606A32C;
	Thu, 19 Nov 2026 00:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M6nlsubF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7389E1F000C4;
	Thu, 19 Nov 2026 00:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048877;
	bh=jFr04HFwQpfMK3oK4w73HPML+O9EDjYX4nOHdhy98lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M6nlsubFTKCrQ3CB0DsHea2hK0qA6xPBKCjJdOvoK41EFRuttuWpXhYROlVElWy75
	 JcOinaYKMl/89TGwWJXDqpeVDhQikXSvQ3LdUA56W6ISsx4wYu61gdczO4vhidzdKL
	 wOvo9idC2o5o2n7y32s7tV/3Qvrz2Nb3vXafDLBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Chao Wei <chao.wei@sophgo.com>,
	Chen Wang <unicorn_wang@outlook.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2150/2857] dt-bindings: vendor-prefixes: add milkv/sophgo
Date: Wed, 18 Nov 2026 15:53:04 +0100
Message-ID: <20261118150318.810182376@linuxfoundation.org>
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

From: Chen Wang <unicorn_wang@outlook.com>

[ Upstream commit 07f9b764062904f0c0fd6e54e58535f34ac3ac6f ]

Add new vendor strings to dt bindings.
These new vendor strings are used by
- SOPHGO's SG2042 SoC [1]
- Milk-V Pioneer board [2], which uses SG2042 chip.

Link: https://en.sophgo.com/product/introduce/sg2042.html [1]
Link: https://milkv.io/pioneer [2]

Reviewed-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Chao Wei <chao.wei@sophgo.com>
Signed-off-by: Chen Wang <unicorn_wang@outlook.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Stable-dep-of: 538f8ec6b9c7 ("dt-bindings: vendor-prefixes: Add Sophos")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 3746f6e01aa75..25e3309a8567f 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -843,6 +843,8 @@ patternProperties:
     description: MikroElektronika d.o.o.
   "^mikrotik,.*":
     description: MikroTik
+  "^milkv,.*":
+    description: MilkV Technology Co., Ltd
   "^miniand,.*":
     description: Miniand Tech
   "^minix,.*":
@@ -1247,6 +1249,8 @@ patternProperties:
     description: Solomon Systech Limited
   "^sony,.*":
     description: Sony Corporation
+  "^sophgo,.*":
+    description: Sophgo Technology Inc.
   "^sourceparts,.*":
     description: Source Parts Inc.
   "^spansion,.*":
-- 
2.53.0



