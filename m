Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6945929408;
	Tue, 23 Jan 2024 01:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974738; cv=none; b=Qq7Q5VxadlaRdaDgn5vkJjvmb2YrpPdiNhddN4/mYN8vhjJ67tCoz80CY6YqygQ0TVbEl/3H0VHjiM7+m8LLjujoU25PpMxe7YLo8Xvu+bWLK36j3tvEQU/qJLXCw/6lhVak7+HXFGH1/ehjQdyjs6wUXn9plhIwjEXtsoQhVss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974738; c=relaxed/simple;
	bh=wmkeVO1w56XztlyThIXnzsvKSA/QrRb4FJFZuglpfoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVbhFu0BrSS12HOLh+aULAnWcvbnuqpXgJDCOJDES+oplZrXuL6Vh6SpgokzEygfP6qTJr6rpzSKnOPxWzDkq+L+o8tIkaCNBTgHdZptQf/gu5FfbT7U90xk+ZKfNXJ1J9M674+Rv8o/p/ruxXH1wH0EXtvdSrT+1f58oZz3XXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3S3r/k0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3S3r/k0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDE8C43394;
	Tue, 23 Jan 2024 01:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974738;
	bh=wmkeVO1w56XztlyThIXnzsvKSA/QrRb4FJFZuglpfoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3S3r/k0QO2tdz32ZkzoPtsmIqXMBz0wMM2KBPgHcmUy2aRl6gRoNrihWvpxbw2F9
	 637OPc/gareCYgnywbVDHT5WFTHgFK2ASIZOHOvhJ1BzImdHSSqmSYDV51+6a7IOVo
	 DCxrPB8SowVj+jh9/+MAPK+5CNIGgeNQeZpS+y7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <eugen.hristev@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 150/583] arm64: dts: mediatek: mt8186: fix address warning for ADSP mailboxes
Date: Mon, 22 Jan 2024 15:53:21 -0800
Message-ID: <20240122235816.661744040@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugen Hristev <eugen.hristev@collabora.com>

[ Upstream commit 840e341bed3c4331061031dc9db0aff04abafb4b ]

Fix warnings reported by dtbs_check :

arch/arm64/boot/dts/mediatek/mt8186.dtsi:1163.35-1168.5: Warning (simple_bus_reg):
 /soc/mailbox@10686000: simple-bus unit address format error, expected "10686100"
arch/arm64/boot/dts/mediatek/mt8186.dtsi:1170.35-1175.5: Warning (simple_bus_reg):
 /soc/mailbox@10687000: simple-bus unit address format error, expected "10687100"

by having the right bus address as node name.

Fixes: 379cf0e639ae ("arm64: dts: mediatek: mt8186: Add ADSP mailbox nodes")
Signed-off-by: Eugen Hristev <eugen.hristev@collabora.com>
Link: https://lore.kernel.org/r/20231204135533.21327-1-eugen.hristev@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8186.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8186.dtsi b/arch/arm64/boot/dts/mediatek/mt8186.dtsi
index 021397671099..2fec6fd1c1a7 100644
--- a/arch/arm64/boot/dts/mediatek/mt8186.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8186.dtsi
@@ -1160,14 +1160,14 @@ adsp: adsp@10680000 {
 			status = "disabled";
 		};
 
-		adsp_mailbox0: mailbox@10686000 {
+		adsp_mailbox0: mailbox@10686100 {
 			compatible = "mediatek,mt8186-adsp-mbox";
 			#mbox-cells = <0>;
 			reg = <0 0x10686100 0 0x1000>;
 			interrupts = <GIC_SPI 361 IRQ_TYPE_LEVEL_HIGH 0>;
 		};
 
-		adsp_mailbox1: mailbox@10687000 {
+		adsp_mailbox1: mailbox@10687100 {
 			compatible = "mediatek,mt8186-adsp-mbox";
 			#mbox-cells = <0>;
 			reg = <0 0x10687100 0 0x1000>;
-- 
2.43.0



