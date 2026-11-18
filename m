Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038641;
	b=QM868lAF67LtcKnKU5s+Cz/wnGiRxQ9IVyol3RZnKWn+HDCPODs1BOyQTAYIpIRNsi0O
	 wBCk5p1AfIyn7VGVDzTYgY05qeRW8S7I44+TTF1snvFb+vR2EDmma5uq/DYCfFocTIzHR
	 r5dGPdJQfnzYFqfrp50tWNnyS7Zo3rRiFtPTLlGhBS8iQUlomjh8N6sVoPozAiWXlyOcx
	 yiM4okG9lhIZITlNruWa84mLf/79lxUI4XTYFYvGv8o96QjuAqkFB/V4tMeWAW8fXWmMw
	 6cKRp8Xnjfniu5MmD9D1h5+qUKEP/e3MtEL5dK8NyIx9Xzamyj8YJp9Y7GNWQfpWz+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038641;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=koPK/yw/mn27IBqQAZp72jI/MXNbiW3zT1aCoByGiIc=;
	b=mTAEWBR5qoTzAga/U+AiHI4pXKmFkAVWFH4ayrVAkFVq6vCJnELw9PuVueRzST6kWvQ+
	 PMV/R15bPoCu0qcM0v/723i1n1DiO0jMqU0QZv6iObqNftbfMT0t3VDBwVUOXMzExcSFj
	 lDfE9kCYAw0Ve97W6cGvD2Y3sJ7piqvl7rawUt8XLp+fMwWVYHuTDnxCmfBn6kwE2aUJI
	 YJ4QCs/eNVgRdAnuu+kmiTcvOXbFH443HqDVT5pO2X2k03G1zTfEUH02dNdEhz2QWLbJ/
	 fF1J8OKzsx8m2pzGV3zm5P/QOU0b4cdN0wiHd1FEEMrXLgnoQKV8IiNePHOPEaXQ+Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c6PdpTJJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27710606A31C;
	Wed, 18 Nov 2026 21:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c6PdpTJJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B581F000C4;
	Wed, 18 Nov 2026 21:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038641;
	bh=koPK/yw/mn27IBqQAZp72jI/MXNbiW3zT1aCoByGiIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c6PdpTJJyeaunqBtNFiMB4m7Qre6ucZXWCcGOZx848rh5Mj9v/GfrYhT0mMov0irr
	 o6O1r+236AEwR3a90AKdFE1lS4QCQQ4iSJBQZnV5YBmzNXXFt/Bbx+d8dgDt8voBi7
	 iK1tMrf0vQKtKkNGSk0b6I8n49Q8+LvPydMNuW6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1814/3318] dt-bindings: clock: ma35d1: Add missing WDT/WWDT parent clocks
Date: Wed, 18 Nov 2026 15:40:36 +0100
Message-ID: <20261118150416.278213286@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 8c7453cb0b01bee47ec2f902a9ac1872d3b77f3d ]

The WDT and WWDT muxes have PCLK3/4096 and PCLK4/4096 among their
possible parents, but these fixed factor clocks are currently not
defined, even though they are needed to properly describe the clock
tree. Add them to the bindings.

Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20260930-perso-ma35d1-upstream-clk-v6-4-48937ee6c9bb@bootlin.com
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Stable-dep-of: 1dc3871ce7ec ("clk: nuvoton: ma35d1: Add missing WDT/WWDT parent clocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/nuvoton,ma35d1-clk.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/dt-bindings/clock/nuvoton,ma35d1-clk.h b/include/dt-bindings/clock/nuvoton,ma35d1-clk.h
index 2d6a44a7e55c4..764d837d6162a 100644
--- a/include/dt-bindings/clock/nuvoton,ma35d1-clk.h
+++ b/include/dt-bindings/clock/nuvoton,ma35d1-clk.h
@@ -248,5 +248,7 @@
 #define ADC_GATE	233
 #define EADC_DIV	234
 #define EADC_GATE	235
+#define PCLK3_DIV4096	236
+#define PCLK4_DIV4096	237
 
 #endif /* __DT_BINDINGS_CLOCK_NUVOTON_MA35D1_CLK_H */
-- 
2.53.0



