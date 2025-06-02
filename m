Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF922153CB;
	Mon,  2 Jun 2025 14:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872870; cv=none; b=uVY/M/Juk8ixGNkwka2Jz6FsZA24rzSIvOm3S7nSCovVqkLUDuP1Gd/LTJUYN2X4AHAFuRs0JiZUI03TI/iM4ZcruJgjHHm/ztE/Ee/k4KZPUfdaaexM+4VhitempSMl0by1jPDz0OPcWCsZcCcTz5qD8WZWVycJ092AqD6VwKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872870; c=relaxed/simple;
	bh=OkCP4hXjH4E5MLABl+/UVJS7tZ4kNUyQAff06a+afdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoVb021Qjr4YlhFkYktEoey0wVOxWzF5Y4JVRhsmWi7uflSRu4RPuLG2Z7ZNF5or/84Dwo4v+03whbc9koT7CbSO19QVP7Z4Vxw7Br4Bt5ATfMh48DeoPKMOnIHOGXF84Fc1/1+wgKechpql/QpX0j+7t58U929LfO3c0OcugfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kn48JH3l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kn48JH3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDCCC4CEF2;
	Mon,  2 Jun 2025 14:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872870;
	bh=OkCP4hXjH4E5MLABl+/UVJS7tZ4kNUyQAff06a+afdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kn48JH3lMSzRkMU+tSRy3kz6bPiHh7+pYbjuxIQq9NA4vw5QSKmG0ZRwIWnJAUnBA
	 8eR+Zg/OoPKyC6qHOVae3evyssPAvk6OyjeG/q7hbOZcFqapvGfMmDcrM7DsoDscUd
	 ZNVEWtcej38udujY7+MJTOa97hnVYVn7R+/o1Bes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.12 21/55] arm64: dts: ti: k3-am65-main: Add missing taps to sdhci0
Date: Mon,  2 Jun 2025 15:47:38 +0200
Message-ID: <20250602134239.113111254@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
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

From: Judith Mendez <jm@ti.com>

commit f55c9f087cc2e2252d44ffd9d58def2066fc176e upstream.

For am65x, add missing ITAPDLYSEL values for Default Speed and High
Speed SDR modes to sdhci0 node according to the device datasheet [0].

[0] https://www.ti.com/lit/gpn/am6548

Fixes: eac99d38f861 ("arm64: dts: ti: k3-am654-main: Update otap-del-sel values")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://lore.kernel.org/r/20250429173009.33994-1-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -449,6 +449,8 @@
 		ti,otap-del-sel-mmc-hs = <0x0>;
 		ti,otap-del-sel-ddr52 = <0x5>;
 		ti,otap-del-sel-hs200 = <0x5>;
+		ti,itap-del-sel-legacy = <0xa>;
+		ti,itap-del-sel-mmc-hs = <0x1>;
 		ti,itap-del-sel-ddr52 = <0x0>;
 		dma-coherent;
 		status = "disabled";


