Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D442DFF1D;
	Tue, 17 Jun 2025 15:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175466; cv=none; b=ZukrNS+Ls6Aa3gMfZ1hyIDe5mM4wwJ2DZFQDpCflhbAn6tX24IUgovBJvPeAyNJINApurInWAGxum7gaJYov8/FyGfP8PAHQIsrOIjTcTvKiv8eSMTjSCj7bIiyA0LVJKShXGTqjsVOyvCyMoieNM7zZT5cuj04BEB+pZPpsXb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175466; c=relaxed/simple;
	bh=Y6Am4dWHTvLa7rpBYWFy82Uc69I7DtxPJSOuI3tM0LA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPrtMNEGeUBzfVhBabF7A+nK09bUlEq7DKACiK5jqCujB5rIkVmyIkuXxAeKh1UZNwWC02mcoldxR9huCCzJysCJ1/HaBxm+TyS3F44Xm8s3qWTgevgOXulTIbp0FWQoxB9+YwgqBmN+w8Fs+w8+Xy8nSWk+f3NDUhlJVmP1eJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1JryE5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1JryE5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F7EC4CEE7;
	Tue, 17 Jun 2025 15:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175466;
	bh=Y6Am4dWHTvLa7rpBYWFy82Uc69I7DtxPJSOuI3tM0LA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o1JryE5iRWZxeLSFkufeC3vyAehg2wwHdCHcuKaWSo+7ThA54ZN7Ksr5ZxN7ul4L9
	 rb3GMBSqNlll6DxausTT7TqfeJN8mHjnriUVtSX3mvTbOR9tnbywmQJvx34ttFiE0f
	 uSS1TRdz5oNpuuuGK0Ptb0yOKuCoIPJHYoRkgpFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasanth Babu Mantena <p-mantena@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 179/356] arm64: dts: ti: k3-j721e-common-proc-board: Enable OSPI1 on J721E
Date: Tue, 17 Jun 2025 17:24:54 +0200
Message-ID: <20250617152345.421084380@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prasanth Babu Mantena <p-mantena@ti.com>

[ Upstream commit 6b8deb2ff0d31848c43a73f6044e69ba9276b3ec ]

J721E SoM has MT25QU512AB Serial NOR flash connected to
OSPI1 controller. Enable ospi1 node in device tree.

Fixes: 73676c480b72 ("arm64: dts: ti: k3-j721e: Enable OSPI nodes at the board level")
Signed-off-by: Prasanth Babu Mantena <p-mantena@ti.com>
Link: https://lore.kernel.org/r/20250507050701.3007209-1-p-mantena@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
index fe5207ac7d85d..90ae8e948671d 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
+++ b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
@@ -557,6 +557,7 @@
 &ospi1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&mcu_fss0_ospi1_pins_default>;
+	status = "okay";
 
 	flash@0 {
 		compatible = "jedec,spi-nor";
-- 
2.39.5



