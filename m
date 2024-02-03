Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6373A125BF;
	Sat,  3 Feb 2024 04:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933356; cv=none; b=a6US9r/PqguOlHZ5YUNfzLzF/hKU1NtY4p2Pv/J2vhFLUx57i1GWUJQ9q6O5djN6ej64EKQPV9vgiAXcMODm/fgMWtuDuayM68v3MLRalQS3nPJfKrqs5yA/L3UnRQNKOf/PQ7T7tMNilcztFaUpr5nMUPRpB1kRtgu4L8sYG4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933356; c=relaxed/simple;
	bh=piBN4nJawsqj/5DWdOnfWUMVS88+6o6bksvt5TlaR70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJFB9olcvQ8mda/rNYLlRgcAZn/1uHmTj3bXk2/nje7fuFKKnZGnI9CIrSj+uptw26p6x9EFHBhTIUuDNgXyUm6ZO0AwHv2Efr72zqQpqdS5U/91TeZW8GkeFlbTS3xkBkwjWGPVCBZCzAjrmOEhcGMm12oSsGjfNuB+NWGAKpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kgt8Apku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kgt8Apku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC4DC433C7;
	Sat,  3 Feb 2024 04:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933356;
	bh=piBN4nJawsqj/5DWdOnfWUMVS88+6o6bksvt5TlaR70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kgt8ApkuNuokSfXoteTfumFGZEcEd1qwfYT/Ccr9i1w2q91hTrozYYqHZoK6fDjr2
	 9WiDlIs7tXv3iiG/3yZ8GnyFFD4Bi/viYvTg7oDD1itcpaSni98Ak+5zi5oXKkq5Je
	 cuqeQkHAYJkds/BSrllILFK/1V4ayMT5j8fA0nww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/219] ARM: dts: imx7s: Fix lcdif compatible
Date: Fri,  2 Feb 2024 20:03:52 -0800
Message-ID: <20240203035325.273482933@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 5f55da4cc37051cda600ea870ce8cf29f1297715 ]

imx7d-lcdif is compatible to imx6sx-lcdif. MXSFB_V6 supports overlay
by using LCDC_AS_CTRL register. This registers used by overlay plane:
* LCDC_AS_CTRL
* LCDC_AS_BUF
* LCDC_AS_NEXT_BUF
are listed in i.MX7D RM as well.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7s.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 7c153c3e8238..44085ef27977 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -818,7 +818,7 @@
 			};
 
 			lcdif: lcdif@30730000 {
-				compatible = "fsl,imx7d-lcdif", "fsl,imx28-lcdif";
+				compatible = "fsl,imx7d-lcdif", "fsl,imx6sx-lcdif";
 				reg = <0x30730000 0x10000>;
 				interrupts = <GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks IMX7D_LCDIF_PIXEL_ROOT_CLK>,
-- 
2.43.0



