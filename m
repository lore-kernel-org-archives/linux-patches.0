Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CF22C3247;
	Mon,  2 Jun 2025 13:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872203; cv=none; b=ZNvuCGjb7OcBp+Xx08+S8OCTqrTBQ1ByF9Pa8CJwq99AxJt+P9sVVRJL5Qn04j9DJaUOv4HUhio8mfwIo7VfphCZ4vMsbCWLvs96GMg7LRDxsfQ4jns/d6HysvqAh9icJ9tp8M4tezBG3bHa57Go4mVlwOkYkC5O5H1lDaHAKNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872203; c=relaxed/simple;
	bh=OYt3may60t9tXeS4/zFzyArs/O5qyjUKh8uxkA1GHYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inQPb4scQqu2LuOa1QqHZjwIZ2GJomUr6fV6FfP++yc1cvvtI+IXDe23V7ny51VxNW9uxSM83W5nqEqDTSVPkUO6Grw3HaNXJdaBU8RUuU9AwAyr6CnPyPwX+Hfa+vzp/qZ0V+8fcKd3f5cfdvP0FHjbjiDzt4rqMla3xI9m0Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mwWMCaP+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mwWMCaP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC62C4CEEB;
	Mon,  2 Jun 2025 13:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872202;
	bh=OYt3may60t9tXeS4/zFzyArs/O5qyjUKh8uxkA1GHYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mwWMCaP+FqyNuGKY490K+b32Olo/MuO9dlVdkl4DrN3mAOdgI1h9ChiRUF5VUdRzG
	 9/nZjSGVXDObkEVBOqb+p6uCSb8abG5V3z1kUyJ9iquLsNNY0yJkFxcFsd4ildcMXb
	 jVj/hI/Z7hgqSvyUf0LXpllj83WvbWNenEKTSb68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.15 33/49] arm64: dts: ti: k3-am65-main: Add missing taps to sdhci0
Date: Mon,  2 Jun 2025 15:47:25 +0200
Message-ID: <20250602134239.244562677@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
References: <20250602134237.940995114@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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


