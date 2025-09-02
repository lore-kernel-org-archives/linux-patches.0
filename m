Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21133043A0;
	Tue,  2 Sep 2025 13:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819432; cv=none; b=s4c3Q2SoYNjO+sabkvLsOmoxWJZkn67GN8NWSrvZ72RdnzMLyYh54o55tZaOvfADTc3wURMQNJV0KB/bvbV8P9+LPchpbeRMbxKAg1EgFChysXxfTjNGKVGGzOaRmWaHF8NKxU5cFyO6wCm7WVvW6touA0eGYnNv+xssCDlu2zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819432; c=relaxed/simple;
	bh=vjY9/Bmb62TnrYo+1qxR3b6DE7k38i5koEfYvem5/58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9s+oLUzQjV5Z42IrAUeupbYv99IfgGYw3yj7b0TIbrmlsDp+K4/G1OPEW1rYYGgtAM+Z05g8q34ttPyTFmObOSrPWrAYC0TMJs/Fzpnd0lQS5Fs7M6NvvqHrgbyM7IeqwPsVvIjnM7UBGc1ER8s5cMj/xHOYvsalYwxRrycbIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=trA0v1Fl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trA0v1Fl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D907C4CEED;
	Tue,  2 Sep 2025 13:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819431;
	bh=vjY9/Bmb62TnrYo+1qxR3b6DE7k38i5koEfYvem5/58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=trA0v1FlMfaxh9hIy03og/W/yS7HT/v+j8yKRBg7KvPA5GWAyFt88rqfIkdI2nzah
	 g3DM7XemC1ueoqruHkb4oNBi01fFlzBqYmDCOpX9TMcN0tqIs3DEg+VeENhydm055p
	 09a0cWr6qXhw0alDt06APqtL/kCVhxmw0AqD7NbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 009/142] mips: dts: lantiq: danube: add missing burst length property
Date: Tue,  2 Sep 2025 15:18:31 +0200
Message-ID: <20250902131948.513433644@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



