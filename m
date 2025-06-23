Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386DC2628C;
	Mon, 23 Jun 2025 21:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713597; cv=none; b=a13DQwc6Hgm2TZxrkcjfW/6IbN2qsKlzzd9AsS+bKVa9zN7oOYvZtUW8KupOM0fti09EeQ63SRVHvsSEMHMfxEMfvjt3Lnb+0nf+eZw8AEl0dGKxpiFiAvcYFhMIag6KgS0Bj+aQDhNZanYndEbEIKWJk/aKXMvPWwk8X8LWqU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713597; c=relaxed/simple;
	bh=EWOOqxPZRcfJISl/hHmmbhmXRA8sdFEw03/510R7sQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ntb8ja1+A88GaMGozuc87jvTzgKAdhYgEmyZ8TlcDUu3ri20VBsjN8zR4NzgJPlT8Kj2DXLy+fHS7X/05qvbeUIA9lX+lWjt4Avir3RfgRwzqhjUdpwWgDbfa2Obndgbe34JEoZRkCDbvny5OrUlrYWiGT8vfyOrB0xByNy5gA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2pVzP/1p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2pVzP/1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3EDBC4CEEA;
	Mon, 23 Jun 2025 21:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713597;
	bh=EWOOqxPZRcfJISl/hHmmbhmXRA8sdFEw03/510R7sQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2pVzP/1pdtVzQM09CpyiURU8YOq4LhjmMijt5N80U0IkNy7jpEUZJ77wo128xL1/l
	 yr+FQjHngnpdIcRSDG7H/EWzgrtCV2BtcXjq6aWAPfkv3EzUPjk84mDNSjpkuRZUqn
	 HQ7nEWAPeIjteGluOd2M495OL8mmiEtqMyk7QxRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 112/508] arm64: dts: imx8mn-beacon: Fix RTC capacitive load
Date: Mon, 23 Jun 2025 15:02:37 +0200
Message-ID: <20250623130648.051904062@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

[ Upstream commit c3f03bec30efd5082b55876846d57b5d17dae7b9 ]

Although not noticeable when used every day, the RTC appears to drift when
left to sit over time.  This is due to the capacitive load not being
properly set. Fix RTC drift by correcting the capacitive load setting
from 7000 to 12500, which matches the actual hardware configuration.

Fixes: 36ca3c8ccb53 ("arm64: dts: imx: Add Beacon i.MX8M Nano development kit")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
index 1133cded9be2f..c4b1c6029c9a9 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
@@ -240,6 +240,7 @@
 	rtc: rtc@51 {
 		compatible = "nxp,pcf85263";
 		reg = <0x51>;
+		quartz-load-femtofarads = <12500>;
 	};
 };
 
-- 
2.39.5



