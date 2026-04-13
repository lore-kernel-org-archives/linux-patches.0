Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4778024E4AF;
	Mon, 13 Apr 2026 16:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096728; cv=none; b=m++bIget4HMITFVAirKkucXB8Ur2Aaqb/1oKTGlPcb+wJWqX0nKt7uD2IUE6q1UC5W3TsM4S9hHq8019YGmLDffJAagVLvwhZGGzKyRMuZQiiSRDMyaH/P/dOxstQgCb+FKP4yjy/sd0mH7El780gTjyY4YCUExNoIFf7J//Uig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096728; c=relaxed/simple;
	bh=Wkt39H278s1q/7UTX1FyW4bYlYegBjQKEQG8GnsYCOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKfiswzz28DguH7EKcTcVeiER4Q2mDPVGjk8REXrpVhfHHEYLFsxZWyvGV8YfSO32rf+ZRl44I8bPV2lWsa+Bookk33zXe93TGAOga3asVNeTAAFS4ZCHGJJVoRwq85tXgvfrc/BFERwWqY1H92u4w09M296HHgRuGVNMj4fUo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rTVu4KTc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rTVu4KTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1717C2BCAF;
	Mon, 13 Apr 2026 16:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096728;
	bh=Wkt39H278s1q/7UTX1FyW4bYlYegBjQKEQG8GnsYCOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rTVu4KTc+ZNNrEN9WaMwGLIpkmHrqion/WLFm3mQChk6KXym6a2QB9bfmsnNf2od3
	 +wa4q+M8Y/d8PlixGzZAYmkY+1rmdh6zRH9vZDXi6f7NojgsMER5H7Fzua/jOwYNGM
	 wCKl0CsUiOxKVe5C7qU6htksbV4M4LvuZnDm8eYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shawnguo@kernel.org>,
	Wei Xu <xuwei5@hisilicon.com>
Subject: [PATCH 6.12 39/70] arm64: dts: hisilicon: poplar: Correct PCIe reset GPIO polarity
Date: Mon, 13 Apr 2026 18:00:34 +0200
Message-ID: <20260413155729.639364686@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
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

From: Shawn Guo <shawnguo@kernel.org>

commit c1f2b0f2b5e37b2c27540a175aea2755a3799433 upstream.

The PCIe reset GPIO on Poplar is actually active low.  The active high
worked before because kernel driver didn't respect the setting from DT.
This is changed since commit 1d26a55fbeb9 ("PCI: histb: Switch to using
gpiod API"), and thus PCIe on Poplar got brken since then.

Fix the problem by correcting the polarity.

Fixes: 32fa01761bd9 ("arm64: dts: hi3798cv200: enable PCIe support for poplar board")
Cc: stable@vger.kernel.org
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/hisilicon/hi3798cv200-poplar.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/hisilicon/hi3798cv200-poplar.dts
+++ b/arch/arm64/boot/dts/hisilicon/hi3798cv200-poplar.dts
@@ -179,7 +179,7 @@
 };
 
 &pcie {
-	reset-gpios = <&gpio4 4 GPIO_ACTIVE_HIGH>;
+	reset-gpios = <&gpio4 4 GPIO_ACTIVE_LOW>;
 	vpcie-supply = <&reg_pcie>;
 	status = "okay";
 };


