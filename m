Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B61A38AC9A;
	Sat, 12 Sep 2026 12:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214503; cv=none; b=jokUZd7wljhHcWtL6PYMNLX4iVccwV0an3lXoVZFmfhqIMTfMQ0dNO/TR0vZx/n/m+TJOz+5NTquD/CRau0GIXfy7K2GdAtTlVn5DMXqgi/SncmmOWWlPxgwbYaf5THHvwK7IzKkTShNA26IEyrfWFhyCV/vgjRivRYY8ob8B0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214503; c=relaxed/simple;
	bh=SURSLzc99uaTdM03YfPlxy85479CfyjO0xovk16/99s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4hzq9gbpmbpUZ7A0hsy/NtfUuY0jqmpZvV7d6FSwRAmSiYv7xJ5j5asGHmg2VTW2i7Rq87051vxzFHJ7bzIW5ak0WaAfmVYwQL/SICNS40XecCLyX5+OM41Rz25K0G27eJkDxsHBgiwhiOj7aeoMOpus382GMYKQ2iIbSFZN7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBX7gT/7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBX7gT/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F091F000FF;
	Sat, 12 Sep 2026 12:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214501;
	bh=zB0lVe6EwZ6G0YLf75rGGtR5vcuguNAZmaGIzv5j65s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NBX7gT/7vUx/jH3xROj7OTDZUKQtdGeKOQWiTIVAf3GHGPfOQWpZlIx0LxdiuwRJn
	 ix6QJuCq6JzCm61vVMvMRp73rZ21CIopoDv+GUJnj9QLb5HZK8ViIznGW1PPeqKcnS
	 xy1lijP4g999WGsW/EtNu1jw2GtKjfCtpngYBj3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0340/1376] arm64: dts: imx93-kontron: set memory node to 0x80000000/1GiB
Date: Sat, 12 Sep 2026 08:46:06 +0200
Message-ID: <20260912065615.128945350@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frieder Schrempf <frieder.schrempf@kontron.de>

[ Upstream commit 9c269fe7eae8cb60d8d6c326dd8955818722fae9 ]

The start address of the DRAM area is 0x80000000. The minimal size of the
DDR on the SoM is 1 GiB.

Fixes: 2b52fd6035b7 ("arm64: dts: Add support for Kontron i.MX93 OSM-S SoM and BL carrier board")
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93-kontron-osm-s.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93-kontron-osm-s.dtsi b/arch/arm64/boot/dts/freescale/imx93-kontron-osm-s.dtsi
index 47c1363a2f99a..dd5da2789bc70 100644
--- a/arch/arm64/boot/dts/freescale/imx93-kontron-osm-s.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx93-kontron-osm-s.dtsi
@@ -15,9 +15,9 @@ aliases {
 		rtc1 = &bbnsm_rtc;
 	};
 
-	memory@40000000 {
+	memory@80000000 {
 		device_type = "memory";
-		reg = <0x0 0x40000000 0 0x80000000>;
+		reg = <0x0 0x80000000 0 0x40000000>;
 	};
 
 	chosen {
-- 
2.53.0



