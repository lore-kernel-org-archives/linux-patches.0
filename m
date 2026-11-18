Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061361;
	b=CzRxBO2REjlN1q6SDVsl1Ge4KAoYYoA/zUTTv1jLyJ30saG50Hg9Eo8sWnWdhy8c5fPH
	 GvbE27D52U4ID5y4BovmlJxHFqCyACFiQglTqnkbO7Wr6Z/1UU0hW92nLiSsv58Rktt5s
	 RM8bessoerq9uKxCKjW2W5WFwzBB2ADh/3ZJxtcQno/R3NrIDTe1ETQyJnguXad5iespP
	 yEAgxKFoMbgb4ycxsmGIe6b39tq/4mHHJYX4fY8F+MAUZuAT9/UL+o07G1b13aSPoEaEM
	 Oz3iHh9eDZ2WfHZTDagIzSD+VFZaIblfp+/ekHzlirnaGtr9ahdfIWLKs8tynqRERew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oLz9ltabK2fPeNTybjG9T9Rpzzckb3NwiuhKo6UBrgk=;
	b=3oaKTL5ajobXdjKMwOPo+lWkElqSPBuB4CAgVxfFIldGtT5WhuByBWZv+POggXe3mkFQ
	 900SeN3bBNcRrDWjJk00bZKEOmrwWcDVZA0PlnOQfMbkvTn5VPfRosT2kTZ09ixVd5I1f
	 UIp4GMYvbCCZ8MKWRmXdn2XdqEF5vV+ipNUbXOcneTDWdGLg7TXBMBm/pKVdHJikBA9+f
	 aBZCCvsxnOe+4K2RnjC2yhM4FYV/npkVLS67AXgliiNi129kT67NnZ16ooVFYCs/yYN35
	 RtCnhYBHUytzmGkivV4Oez2WtjHPToFgBac5+0h3GwU3xTtYG88rGvN5UlJ+SzoMSMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qjn8krhr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B98C606A32C;
	Thu, 19 Nov 2026 04:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qjn8krhr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6661F000C5;
	Thu, 19 Nov 2026 04:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061361;
	bh=oLz9ltabK2fPeNTybjG9T9Rpzzckb3NwiuhKo6UBrgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qjn8krhrJ4AKR8nnvSy5Krc8ia6s5qOQvRflEb0WlcxIoItC8x6fZmclsvZfphW7H
	 yRrdOVhnK5OPyBbLnS4cnK9TbuLHv5ajrQdDwoB2iMMfuF1+vfEkgCCb7dmUZW6r5/
	 2Hlapbw9qSpWgDwbAxgEyvMxbwDU2hE1COcOEXOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1508/1848] arm64: dts: allwinner: sun50i-h6: Add missing SRAM region for video engine
Date: Wed, 18 Nov 2026 15:59:06 +0100
Message-ID: <20261118150022.455059587@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wens@kernel.org>

[ Upstream commit d7287d940f3cd8d5945009076058a8120281744b ]

The SRAM C region contains a partial alias to the VE SRAM already
referenced by the video engine. To avoid access through this alias
window, the region should also be claimed by the video engine.

Add a reference to the SRAM C region to the video engine node.

Fixes: b542570e5605 ("arm64: dts: allwinner: h6: Add Video Engine node")
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20260712030011.3778169-6-wens@kernel.org
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
index 4592fb7a6161d..44b69c3dd77cb 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
@@ -161,7 +161,7 @@ video-codec@1c0e000 {
 			clock-names = "ahb", "mod", "ram";
 			resets = <&ccu RST_BUS_VE>;
 			interrupts = <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>;
-			allwinner,sram = <&ve_sram 1>;
+			allwinner,sram = <&ve_sram 1>, <&de2_sram 1>;
 			iommus = <&iommu 3>;
 		};
 
-- 
2.53.0



