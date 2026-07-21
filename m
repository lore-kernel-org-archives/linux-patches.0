Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B853B3C0A;
	Tue, 21 Jul 2026 20:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665962; cv=none; b=AnyK2A5ED9G3R0KwtsOn6gNbuG2L9Yn3KPVi5Edyz7bYfptjVxs7wRNtfZVhl8LjbbNJU95XsJ1rIdjef+6sArmmrJHZwk7n3EenqSndErqCcktKJVccLf1L3j1Kz/IOUVhcbKQwRckQra4EWBIjAJLgZziGdukqdMy91AUBML4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665962; c=relaxed/simple;
	bh=hpEds/ccqKWaOsWrKxQ7eNqoeqm9op3KEyPZ/zSipms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUhGTOgwsL0usIzz7M96eQ/WnUYgpcNqCFYRuwa1vLJRO7GLharGefZDjBbWZMXqv7uNjp+dIaUfsNWJrFqM1CWBF0UirXhAnDSmO2MN4QZtgP5bG4V1gLFGb5BFQHQY+si9QzZbTRfhlUDX61JBOLhu+C9Obka+OUi1T+W3DVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wljRC4/n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wljRC4/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985781F000E9;
	Tue, 21 Jul 2026 20:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665961;
	bh=M94UVBpjH28U43X+0y/RQ4dh8Y13NL9nynbim1Erj8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wljRC4/nBgiFpbyUFu07FhmS3QpFl/2YJKUAxvoNSXLQvM38Wa57bqTtLBJAbk58P
	 /LMAUlZdJGcQ6ml2oMSwaK0GqTKt6j888y6/10CeNjQCuwk+5nvNA+XAOqMKrAlup6
	 iYCvtUKPyMHPUPPl+e7SWkhLacAwzH4DucLccqF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0500/1266] arm64: dts: tqma8mpql-mba8mpxl: configure sai clock in audio codec as well
Date: Tue, 21 Jul 2026 17:15:37 +0200
Message-ID: <20260721152453.029794209@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 748835fcb2eb2120234aef9556d282272501b96b ]

With deferrable card binding the sound card driver tries to
get the mclk configuration before it is setup in sai3 node.
Fix this by setting the sai clock config for the audio codec as well.

Fixes: d8f9d8126582 ("arm64: dts: imx8mp: Add analog audio output on i.MX8MP TQMa8MPxL/MBa8MPxL")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
index 5430b62a3b2827..8dc8d2e12a7aff 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mpxl.dts
@@ -473,6 +473,9 @@ tlv320aic3x04: audio-codec@18 {
 		reset-gpios = <&gpio4 29 GPIO_ACTIVE_LOW>;
 		iov-supply = <&reg_vcc_1v8>;
 		ldoin-supply = <&reg_vcc_3v3>;
+		assigned-clocks = <&clk IMX8MP_CLK_SAI3>;
+		assigned-clock-parents = <&clk IMX8MP_AUDIO_PLL1_OUT>;
+		assigned-clock-rates = <12288000>;
 	};
 
 	se97_1c: temperature-sensor@1c {
-- 
2.53.0



