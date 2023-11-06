Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E936A208BD
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6MxwVDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B3CC433C8;
	Mon,  6 Nov 2023 13:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276743;
	bh=/15aIqyeJFNo0X5tCUafy/N2Q6N/4tVXWv24UiPCeWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6MxwVDbK49EF8+eEsnZ5q2/hViaO/3m56G6/jPFANpj/jFqmNhVTExMHUYnYojcA
	 RZ6aLkrTvnHh8jtt7rY4oTriQUThVxV3+2jlxufvOrZTToi9ZWx/hssNtN52I4cJYJ
	 oUxv7ZQZgF2BwsIfwRPxvBbAwvTeyPhtbRSSMnBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Drew Fustini <dfustini@baylibre.com>,
	Guo Ren <guoren@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 53/88] riscv: dts: thead: set dma-noncoherent to soc bus
Date: Mon,  6 Nov 2023 14:03:47 +0100
Message-ID: <20231106130307.779341093@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>
References: <20231106130305.772449722@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 759426c758c7053a941a4c06c7571461439fcff6 ]

riscv select ARCH_DMA_DEFAULT_COHERENT by default, and th1520 isn't
dma coherent, so set dma-noncoherent to reflect this fact.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Tested-by: Drew Fustini <dfustini@baylibre.com>
Reviewed-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/thead/th1520.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/boot/dts/thead/th1520.dtsi b/arch/riscv/boot/dts/thead/th1520.dtsi
index 56a73134b49e6..58108f0eb3fdc 100644
--- a/arch/riscv/boot/dts/thead/th1520.dtsi
+++ b/arch/riscv/boot/dts/thead/th1520.dtsi
@@ -139,6 +139,7 @@
 		interrupt-parent = <&plic>;
 		#address-cells = <2>;
 		#size-cells = <2>;
+		dma-noncoherent;
 		ranges;
 
 		plic: interrupt-controller@ffd8000000 {
-- 
2.42.0



