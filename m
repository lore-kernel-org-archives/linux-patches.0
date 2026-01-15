Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CDE25228D;
	Thu, 15 Jan 2026 16:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496196; cv=none; b=OGGN09HcMtq1RhDUMfxxnxXDL0lAKeykPMBhxESTZfpYRaYHQg1sTu0TDLntikiDpcyM9Asoj534zJ+Su66WhiXc+Og3qcXwVJ0Yt0YZx1qX1iJH1tb1ubWbtYcT1DA3G8tIaeji/gTqsYRLrRCnnSUmucR8hZJRH6cO7rx6/cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496196; c=relaxed/simple;
	bh=HkcZrj+MvADzAJ4u6iZSebbx3f7qv0BCpfFYg1CQuvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GShHjUAltqx+gK6nv1pmqWr0cVhhNAzh99HWpNwFlbpgCqH091WVjW0vhD7TTx2PbRFXRAWHytXL5qxJ5kp/0Q+0Zn5iO2pjGaEoEF35BtbY4+xz9BUzlCnc0fk5RVxvGgt/5Dz8OkIqD7X6YxxzqmIQIJ2DwOM1odwKKB6bFKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7EqTIa2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7EqTIa2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF153C116D0;
	Thu, 15 Jan 2026 16:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496196;
	bh=HkcZrj+MvADzAJ4u6iZSebbx3f7qv0BCpfFYg1CQuvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7EqTIa2uPeA5DGANZZCkWlI4ilyxsjv0VMbY2K2WdGixXCdvu6UnDXfIrGAtl8ld
	 nl31aI6DqyamRj4a/Dibyy2Ox+2kENL+jCojPM51yS1k6ZIJjsgA54m4tsIptNoCBi
	 Y//vGLSlp73xBBHXeoBEQcalLC84ZdUbOmp3ZX1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 079/181] arm64: dts: imx8qm-mek: correct the light sensor interrupt type to low level
Date: Thu, 15 Jan 2026 17:46:56 +0100
Message-ID: <20260115164205.180209181@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit e0d8678c2f09dca22e6197321f223fa9a0ca2839 ]

light sensor isl29023 share the interrupt with lsm303arg, but these
two devices use different interrupt type. According to the datasheet
of these two devides, both support low level trigger type, so correct
the interrupt type here to avoid the following error log:

  irq: type mismatch, failed to map hwirq-11 for gpio@5d0c0000!

Fixes: 9918092cbb0e ("arm64: dts: imx8qm-mek: add i2c0 and children devices")
Fixes: 1d8a9f043a77 ("arm64: dts: imx8: use defines for interrupts")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8qm-mek.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
index 9c0b6b8d6459d..d4b13cfd87a92 100644
--- a/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qm-mek.dts
@@ -560,7 +560,7 @@ light-sensor@44 {
 		compatible = "isil,isl29023";
 		reg = <0x44>;
 		interrupt-parent = <&lsio_gpio4>;
-		interrupts = <11 IRQ_TYPE_EDGE_FALLING>;
+		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
 	};
 
 	pressure-sensor@60 {
-- 
2.51.0



