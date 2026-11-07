Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064080;
	b=n/evZKUkkuZvku1dmzu/ADFZ1kUpqk+l8T3knIVsNGn493VYT0+f025CahK4bj4JfGB0
	 yafl95gX++v6I9C5jS/DLdm2mekGsiXpiPKZEAxJL91ND3u28VJpDpDYcQxx1rdEsLZer
	 mtXbEx3Jw5h3OSEFZ5RsqbAzIClmmtXdZL9RoF81fsdZArUbgnE8b6iGvQsm+oV1mGCQH
	 HoPC7MKPRiLV/NODlPGMEcD6gSgBNrmQNm++ipS4ENqAMwWqVw79nQHjHrs4TlqY7Y4ll
	 v1C2utUsZk3ssJCcTD1l6L/Z3P7wOBHfOnpz/81xoWi3ljINw/7bW3zJx3PgCuCcUaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vRbCxOePjlicgHfS+P2GbOQgUFYIfL4ol2aIlu4DJCY=;
	b=OwMXl5fM/dna9waQDC3VdNZHjYL9uCPh1zhgYYJXbdFmZAv7K8X0U1nmqy0uxZrdniGF
	 8eBkkcv4v2HvRU7sqL8jxvc3avzd90dbT5ZuEPuP7k18HYgDgnGs4N6y7d+d1LZJEWWCa
	 wDQgT9XQBTcD/YLC3w0tN2T5YB0oQIH4GK1oYsmfpD3v/4cgPPZLjqmtMRa2y8A72fWtc
	 trI3d2K31IU1E3LKQ+7+1BAQlJzKpbQktzrYVe9iqnlCteECNUCHd6DXqt3a61cHbS2nX
	 xER94i/bhlz2747ckI1QM63xbWuPEf4Bjadv2Bkk93lZ+YSyznGtyQhdCi5/66mugcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W1VhY31s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819F3606A9E4;
	Sat,  7 Nov 2026 15:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W1VhY31s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85AC1F0089F;
	Sat,  7 Nov 2026 15:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064080;
	bh=vRbCxOePjlicgHfS+P2GbOQgUFYIfL4ol2aIlu4DJCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W1VhY31s2sy3ta49lQzJNZyh+zKxCaU/5FTQt8KmrDBVxGCAm6DfawjL14RtSmAIe
	 YJqBgKVm7EEeN6mFVDj8bhbWK9SWJSxBqCv6nyBMZmTyMrFTF3Dlf3mCPo8AGOcEGr
	 c+Ci+92JcVyqTSui0kibZM/hCKTNR6zeahUCRYaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0245/1257] arm64: dts: ti: k3-am62p5-verdin: build zinnia dtbs
Date: Sat,  7 Nov 2026 08:42:21 -0500
Message-ID: <20261107134946.279130503@linuxfoundation.org>
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

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit 237fda81c2b4984c2212f0d3f510405aad8b25db ]

Add the zinnia dtbs to the Makefile, they were forgotten when zinnia
support was added and were therefore never built.

Fixes: 71c2a8124527 ("arm64: dts: ti: k3-am62p-verdin: Add Zinnia")
Cc: stable@vger.kernel.org
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20260914174651.6195-1-francesco@dolcini.it
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/Makefile b/arch/arm64/boot/dts/ti/Makefile
index 795978e962ee8..ec03d594f23a6 100644
--- a/arch/arm64/boot/dts/ti/Makefile
+++ b/arch/arm64/boot/dts/ti/Makefile
@@ -91,6 +91,7 @@ dtb-$(CONFIG_ARCH_K3) += k3-am62p5-verdin-nonwifi-dev.dtb
 dtb-$(CONFIG_ARCH_K3) += k3-am62p5-verdin-nonwifi-ivy.dtb
 dtb-$(CONFIG_ARCH_K3) += k3-am62p5-verdin-nonwifi-mallow.dtb
 dtb-$(CONFIG_ARCH_K3) += k3-am62p5-verdin-nonwifi-yavia.dtb
+dtb-$(CONFIG_ARCH_K3) += k3-am62p5-verdin-nonwifi-zinnia.dtb
 dtb-$(CONFIG_ARCH_K3) += k3-am62p5-verdin-ov5640-24mhz.dtbo
 dtb-$(CONFIG_ARCH_K3) += k3-am62p5-verdin-ov5640.dtbo
 dtb-$(CONFIG_ARCH_K3) += k3-am62p5-verdin-wifi-dahlia.dtb
@@ -98,6 +99,7 @@ dtb-$(CONFIG_ARCH_K3) += k3-am62p5-verdin-wifi-dev.dtb
 dtb-$(CONFIG_ARCH_K3) += k3-am62p5-verdin-wifi-ivy.dtb
 dtb-$(CONFIG_ARCH_K3) += k3-am62p5-verdin-wifi-mallow.dtb
 dtb-$(CONFIG_ARCH_K3) += k3-am62p5-verdin-wifi-yavia.dtb
+dtb-$(CONFIG_ARCH_K3) += k3-am62p5-verdin-wifi-zinnia.dtb
 
 # Common overlays for SK-AM62* family of boards
 dtb-$(CONFIG_ARCH_K3) += k3-am62x-sk-csi2-ov5640.dtbo
-- 
2.53.0



