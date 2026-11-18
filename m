Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033414;
	b=rUreGSRsriKtVUeoAYULe33H3USJ2OIA5YKkQ7GlCvPB/AwnLPaTeGZPzmk47QHE1YZ4
	 8X/gLlO/oENcoGyPuLT2ekx/pFDnUqrtylfd0m82NgyAIIxTWvIWQ2bUbIHM3ifJuh4jq
	 OnDhQcx+c3uWVChObHC11lI9lfrxXZE+drFDFz3HPJAc958bl5UAuPC1swpjIOQQsUKaH
	 0nmaynOaSaOcpIHG3FlvgnX8rYr4eFZeTBPH90RrO1X9rsZOZXo9MicexzE0aNECJDgyk
	 BluuYHdvE0pjVGhSkgOwkL2EiT7k72ZkPja5DOaMTY3yCJrjWARKlDLMe3afvJ3+AfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1FVBqC5r/4jIu+Ka8mGxs81nwjKLSgyKOBHd+uM1di0=;
	b=kPI7AZlXSwNm3BhvpDiStiYU48YV6F+JHwtgsSyUk8vLs19Miejqn/HRIzxBcbO9Gfrt
	 pbmsn6BPn5YfSXzCaiCkiBIeiHgZc65e6BsKVG4MZnsRuUQiDuPva8ZV9uuB+pI7HaGuO
	 p++iDUHPonIPRzSaoFrKyY5n4wewmbHaHsey1lx5sWCSBk4V/jTkH2qtcOpeFW4XLOoIg
	 rg/aMvzW1AmYaVYNxwAYWf7LlpjeU2vHMvAeD9uCX4rsV2WD6Jx9+VLH7KsHEVhP/reNC
	 I49d6WsVSPeVZQd5OV2N8QuNR7+kizQ7QkGdW/PlwPpUXKWsHhaF5lspyLDv79mr4fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cXSzH5o6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE461606A31C;
	Wed, 18 Nov 2026 20:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cXSzH5o6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5411F000C4;
	Wed, 18 Nov 2026 20:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033414;
	bh=1FVBqC5r/4jIu+Ka8mGxs81nwjKLSgyKOBHd+uM1di0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cXSzH5o6UPiSuqyoXfzFZu/Dje3sb+YhW1wc/TnT4pnS6CVT/gV1uVPWGuihhkRBI
	 e774qk+LS0zJmJRRZTibZbWn/89zoATykPvHrBmpdTOjGJP80fdcnklNe0tbf48EgL
	 ZPlwOHjhRrSwwxwhjAeBzievVIA6+OP+Ymkift8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Bruel <christian.bruel@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.12 1742/1756] arm64: dts: st: Adjust interrupt-controller for stm32mp23 SoCs
Date: Wed, 18 Nov 2026 16:04:29 +0100
Message-ID: <20261118150118.891043263@linuxfoundation.org>
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

From: Christian Bruel <christian.bruel@foss.st.com>

commit 3a1e1082097b8fa2e5d420de105f4cce804c38b2 upstream.

Use gic-400 compatible and remove address-cells = <1> for aarch64

Fixes: e9b03ef21386e ("arm64: dts: st: introduce stm32mp23 SoCs family")
Signed-off-by: Christian Bruel <christian.bruel@foss.st.com>
Link: https://lore.kernel.org/r/20250415111654.2103767-6-christian.bruel@foss.st.com
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/st/stm32mp231.dtsi |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/st/stm32mp231.dtsi
+++ b/arch/arm64/boot/dts/st/stm32mp231.dtsi
@@ -1201,13 +1201,12 @@
 		};
 
 		intc: interrupt-controller@4ac10000 {
-			compatible = "arm,cortex-a7-gic";
+			compatible = "arm,gic-400";
 			reg = <0x4ac10000 0x1000>,
 			      <0x4ac20000 0x2000>,
 			      <0x4ac40000 0x2000>,
 			      <0x4ac60000 0x2000>;
 			#interrupt-cells = <3>;
-			#address-cells = <1>;
 			interrupt-controller;
 		};
 	};


