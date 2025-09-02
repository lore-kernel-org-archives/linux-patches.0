Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3922C15A3;
	Tue,  2 Sep 2025 13:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819899; cv=none; b=lUPIbyHOuQ6emcGQyusrWoKpwDt8901x8JrPaP0avYTpBrGai6LiA5gR2CzGcgjyg/UT9UygGX9UrrVdKtuCxmrplovhFuRp2oOtUQj+ott4pCFMmadzotkbfBWdNaFk+TuU4uCuLiqTcXJpMj5N/cek/h0NqJXLVZt1SBIQ1ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819899; c=relaxed/simple;
	bh=4cGydD2YgFlOAoWPYvKDi889gI4dRzMR2d5X9vhTctE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GaKmKVjdRmbeyF/8bm5PrVDD8RXw7NGFAhgVtthvb027afDniFk3mpoFUMl8s5ZOg/JH+Dwpw7WwpWHMa3/fxt8nccrltb9al3B3KSdO1bG397Xp4CHmBlRl+UB2m4sbrG+sPKxG+g8b9dnSikCHjdK7z1jAR6jSktD86Uwv6Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DBxSas6P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DBxSas6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE63C4CEED;
	Tue,  2 Sep 2025 13:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819899;
	bh=4cGydD2YgFlOAoWPYvKDi889gI4dRzMR2d5X9vhTctE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DBxSas6PJ4VA5kMbVHSOO4ZKZrBWYn4cR2U5Fsi/Bs3Jlht+ba3+IvcFflZv+TI91
	 F6O8NCo7BcnBJx4YUQzM9D5gxv8dYPZIiyPcYar33L1i5U10wFftQuhN2SzrqgRHFq
	 OU2Nj40mA16Qo7Khtf6TPT5wRSE9Dc/K9soWTcqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 06/95] mips: dts: lantiq: danube: add missing burst length property
Date: Tue,  2 Sep 2025 15:19:42 +0200
Message-ID: <20250902131939.856207117@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 7b28232921782aa38048249132899c337405eaa8 ]

The upstream dts lacks the lantiq,{rx/tx}-burst-length property. Other
issues were also fixed:
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: etop@e180000 (lantiq,etop-xway): 'interrupt-names' is a required property
	from schema $id: http://devicetree.org/schemas/net/lantiq,etop-xway.yaml#
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: etop@e180000 (lantiq,etop-xway): 'lantiq,tx-burst-length' is a required property
	from schema $id: http://devicetree.org/schemas/net/lantiq,etop-xway.yaml#
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: etop@e180000 (lantiq,etop-xway): 'lantiq,rx-burst-length' is a required property
	from schema $id: http://devicetree.org/schemas/net/lantiq,etop-xway.yaml#

Fixes: 14d4e308e0aa ("net: lantiq: configure the burst length in ethernet drivers")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/lantiq/danube_easy50712.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/mips/boot/dts/lantiq/danube_easy50712.dts b/arch/mips/boot/dts/lantiq/danube_easy50712.dts
index 1ce20b7d05cb8..d8b3cd69eda3c 100644
--- a/arch/mips/boot/dts/lantiq/danube_easy50712.dts
+++ b/arch/mips/boot/dts/lantiq/danube_easy50712.dts
@@ -87,8 +87,11 @@ etop@e180000 {
 			reg = <0xe180000 0x40000>;
 			interrupt-parent = <&icu0>;
 			interrupts = <73 78>;
+			interrupt-names = "tx", "rx";
 			phy-mode = "rmii";
 			mac-address = [ 00 11 22 33 44 55 ];
+			lantiq,rx-burst-length = <4>;
+			lantiq,tx-burst-length = <4>;
 		};
 
 		stp0: stp@e100bb0 {
-- 
2.50.1



