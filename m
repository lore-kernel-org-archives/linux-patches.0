Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047718;
	b=cd4fvhcIAUaxf7+BtjJdPHzUtaUqf7xA0xLLwBjNvNL9hwvoFhvNFzTRBLCydb/pCvwj
	 4cz3CwBc/cjTTyNhQZ7zCkD9e6t/LclgBbyLVBuFp3EKWgIE+gKd7/a95IsmMvinKecmg
	 DCTBo9hjQNXziNHHM6mu3A4UqoJyUQDDsIHZiiiOZGCjCbLrCQXYVDlMlvIKphXsxaaMX
	 nGJZbjT1/IpLLHsh5vIrf57aHUeXXCGCuwT1nfrhNyd1Lq4MKi9ZrGavihPNp6y0QDFPK
	 YO1SnkTX10rlFlbsFAnMZ85u96hWex6Wy9IT1qRo1c+WmL/+MZf1nxiNK9mmAw8Fcbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047718;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ksnvmz9s2K908NjsZry/zmcRR4Ap0uH/OJGxDq4OVgg=;
	b=Mya63b2jXSCiQG0uK9Csl6mxNQ9g+v1DjFxdChXLbmZpWhVuNEjWIJcrnc6VY/RHKBhx
	 NVN14p1YnXTb8KVRNodTU6VmvOzJYlWokAfh4XPnTrVxmhaA3lE4u+u6KL9H4Bu2xRQmx
	 6otONEJQ3wfhqevuw2KzmzLE0rqHG+/MccRgzBsIAhnV2S4VgJ/BhbdUGI1Kewiu8TXd5
	 V2ie5WijXZ3zBUW2EY6U/hGqx8jIrzIh352jAmwcfqC6J6G0dM0AUWeBDx4cQGM/DQBzD
	 5e/l9+DsHYRtArLxzMZVyPDmcdP9DErvqZHz7bzxVfHZhNGFrWhRO7WJX9GXsVyGtpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q8e4Cd26;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09EE606A320;
	Thu, 19 Nov 2026 00:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q8e4Cd26
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4FE1F000CC;
	Thu, 19 Nov 2026 00:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047718;
	bh=ksnvmz9s2K908NjsZry/zmcRR4Ap0uH/OJGxDq4OVgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q8e4Cd26MZBMJxf6BogCl1xHYnC9eIagGvfn8KvgOXY2wbbNveuYzGAFHU3mqnrXO
	 npqUT+obQnPV+dvFzxNjn0JD5SN7Px3R47byutlt/bane8j4/XhrY4GFeuD9DTWL8z
	 BucR/PoOyXMV6IEyaVJyr3KdsP1dq3NozeieSPmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1740/2857] ARM: dts: armada-395-gp: drop unsupported SDHCI clock-frequency
Date: Wed, 18 Nov 2026 15:46:14 +0100
Message-ID: <20261118150303.953862730@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit a56183c7f15215d804290808a2b5a1fa997aa9cd ]

The SDHCI node carries a "clock-frequency" property, but the
marvell,armada-380-sdhci binding does not define it and dtbs_check
rejects the node as a result. No driver consumes it either: only a
few other sdhci-pltfm based drivers (imx, mcf, iproc, arasan,
dwcmshc, xenon) read that property, while sdhci-pxav3 derives the
maximum clock from the io clock rate.

Remove the property.

Fixes: 356645123581 ("ARM: dts: mvebu: armada-395-gp: add support for the Armada 395 GP Board")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-395-gp.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-395-gp.dts b/arch/arm/boot/dts/armada-395-gp.dts
index 6dd9e9077f842..9ea447cd35a85 100644
--- a/arch/arm/boot/dts/armada-395-gp.dts
+++ b/arch/arm/boot/dts/armada-395-gp.dts
@@ -59,7 +59,6 @@ sata@a8000 {
 
 			/* CON18 */
 			sdhci@d8000 {
-				clock-frequency = <200000000>;
 				broken-cd;
 				wp-inverted;
 				bus-width = <8>;
-- 
2.53.0



