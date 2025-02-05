Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD1A1E89C;
	Wed,  5 Feb 2025 14:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767572; cv=none; b=n3JxxRLrsI/qnIasy+hhHmQOd/CsRzvheNcs+dj1EOZoM68Mp6SWYhd8V22dM5Tah0a2ep4zi1dfBygAf6FX+irVMroxfVvwb9BnKn1q6Zqf9Y7T+urVsU2E2jMLWMoZB4eYZ6zvAgtkyIsJZAX6L4MHvlUIB49mxv4EINewuiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767572; c=relaxed/simple;
	bh=LyEX7EDOdhypdYyclk46CgFfWpn1H+sz5gQOL+faujs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tX5OH9YzDkOP9Ic0S+tsnVPPJHCg0L6n5kC1x9UW58tmIvRWC456sll8M/yqgYzJY18v1kxPPirJjU3cDPzxIfznapj/tCQ+oVvD/JPggh5DTQmI0cVBgjmKS0AJuYyXVNaxWyud5npVnAlk005RrYenjKq1ybEKFJuLmbftKe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSRsiU74; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSRsiU74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EDBAC4CEE4;
	Wed,  5 Feb 2025 14:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767571;
	bh=LyEX7EDOdhypdYyclk46CgFfWpn1H+sz5gQOL+faujs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSRsiU746h69c97q2tiHph3K+4HWhVSGRdRSEFqres4kDdI0MHW1cxAuyEzNmcnms
	 p22VdaswPpUodd0GrGsdQenO4L51bhROoz214goj98Yf7xWxqFhiyCwVZFsXPw87jN
	 6Ugl1nz86iRWz6Ebv8B/2/LZssqpROI8mFI+JxjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 423/623] arm64: dts: ti: Makefile: Fix typo "k3-j7200-evm-pcie1-ep.dtbo"
Date: Wed,  5 Feb 2025 14:42:45 +0100
Message-ID: <20250205134512.408205453@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit a7543eaeb31544b9c3f6248cac8189aa1480c0f5 ]

The list of "dtbs" should contain the resultant "dtb" formed by applying
the "dtbo" overlay on the base "dtb", rather than the "dtbo" itself.

Hence, change "k3-j7200-evm-pcie1-ep.dtbo" to "k3-j7200-evm-pcie1-ep.dtb"
in the list of "dtbs".

Fixes: f43ec89bbc83 ("arm64: dts: ti: k3-j7200-evm: Add overlay for PCIE1 Endpoint Mode")
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Link: https://lore.kernel.org/r/20241205105041.749576-2-s-vadapalli@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/Makefile b/arch/arm64/boot/dts/ti/Makefile
index f71360f14f233..379bfa4425d49 100644
--- a/arch/arm64/boot/dts/ti/Makefile
+++ b/arch/arm64/boot/dts/ti/Makefile
@@ -230,7 +230,7 @@ dtb- += k3-am625-beagleplay-csi2-ov5640.dtb \
 	k3-am642-tqma64xxl-mbax4xxl-wlan.dtb \
 	k3-am68-sk-base-board-csi2-dual-imx219.dtb \
 	k3-am69-sk-csi2-dual-imx219.dtb \
-	k3-j7200-evm-pcie1-ep.dtbo \
+	k3-j7200-evm-pcie1-ep.dtb \
 	k3-j721e-common-proc-board-infotainment.dtb \
 	k3-j721e-evm-pcie0-ep.dtb \
 	k3-j721e-sk-csi2-dual-imx219.dtb \
-- 
2.39.5



