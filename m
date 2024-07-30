Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3C11A4B4C;
	Tue, 30 Jul 2024 16:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355724; cv=none; b=fEp6U89w8OdOSkXm4JuJKcx+EawhbZ+wOBjbkLAAbcVAUThabO64zK2XzmEBt/auUF1zlwkVzY21l/bDX4jgjc5Wf6Cl7OqEHrv16W4x/aTH9VSisyRpv8SULtWtVwl6vCmUjMz3Jz04gyPCoojsUd+psY4ZjBKw5h8i4T7sSLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355724; c=relaxed/simple;
	bh=cG5uwKxjpJXrKeSEhmaeI2z6n1ImmeI9nQDBOHhRrMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/nayCej5Yv0ztkvvnNL9bOPpQKg8+UmKYwMgearyMGzRDHffXL7cZoxzeUliXQ4p9vdZSXiyt/Rm8upfsvg1u2xyqoQUp1OKb19ucE5pAcqS/4hav1UOukk/irjE2DGc7FCj3X01RXsAQFW5UgqY5LaezYyBklZiYW0jipgDmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xirSU5W6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xirSU5W6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BE1C32782;
	Tue, 30 Jul 2024 16:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355724;
	bh=cG5uwKxjpJXrKeSEhmaeI2z6n1ImmeI9nQDBOHhRrMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xirSU5W6wjWxmptkhrXi8XVFkaoMfyhua1qH1GH04hdCjIXqDmjuDEWTuubJ6t6BC
	 wFGspaWxrmHsi0p2LJSirgxBHiDmHfHXRZz4YfiDw4RVXT82EcEs2kBGvsT/WZWJUB
	 NzCiHJE+O17Xw6JWMqvoRyQotqs1NZYPXHnpihPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jai Luthra <j-luthra@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 083/809] arm64: dts: ti: k3-am625-beagleplay: Drop McASP AFIFOs
Date: Tue, 30 Jul 2024 17:39:19 +0200
Message-ID: <20240730151727.917277327@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jai Luthra <j-luthra@ti.com>

[ Upstream commit 3b4a03357aee07a32a44a49bb6a71f5e82b1ecc1 ]

McASP AFIFOs are not necessary with UDMA-P/BCDMA as there is buffering
on the DMA IP. Drop these for better audio latency.

Fixes: 1f7226a5e52c ("arm64: dts: ti: k3-am625-beagleplay: Add HDMI support")
Signed-off-by: Jai Luthra <j-luthra@ti.com>
Link: https://lore.kernel.org/r/20240606-mcasp_fifo_drop-v2-4-8c317dabdd0a@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts b/arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts
index 18e3070a86839..70de288d728e4 100644
--- a/arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts
+++ b/arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts
@@ -924,6 +924,4 @@ &mcasp1 {
 	       0 0 0 0
 	       0 0 0 0
 	>;
-	tx-num-evt = <32>;
-	rx-num-evt = <32>;
 };
-- 
2.43.0



