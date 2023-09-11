Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88E411710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE3BC433C7;
	Mon, 11 Sep 2023 15:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445187;
	bh=oaHC+6dO3Vp3g+kzoIWTICjOHgi1J2V1+4GRXmm7N+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nw7v2MSJEIWEadf5ECelPI7oDN5HhHFLjb+EU8b9UJlxhK7/3SZPVhq7s79KhZbnO
	 f1is21/xk8+Y4O7D63HIttvXADPiCGFMPr8RGuT9aHTGD0WohComF1RKtfG4We2agd
	 i3iY6H2v66vfsp4T25uMgXroBg6WThoEpCMvHHoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 259/600] arm64: tegra: Fix HSUART for Smaug
Date: Mon, 11 Sep 2023 15:44:52 +0200
Message-ID: <20230911134641.254251038@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>

[ Upstream commit 590bfe51838f6345a6a3288507661dc9b7208464 ]

After commit 71de0a054d0e ("arm64: tegra: Drop serial clock-names and
reset-names") was applied, the HSUART failed to probe and the following
error is seen:

 serial-tegra 70006300.serial: Couldn't get the reset
 serial-tegra: probe of 70006300.serial failed with error -2

Commit 71de0a054d0e ("arm64: tegra: Drop serial clock-names and
reset-names") is correct because the "reset-names" property is not
needed for 8250 UARTs. However, the "reset-names" is required for the
HSUART and should have been populated as part of commit a63c0cd83720c
("arm64: dts: tegra: smaug: Add Bluetooth node") that enabled the HSUART
for the Pixel C. Fix this by populating the "reset-names" property for
the HSUART on the Pixel C.

Fixes: a63c0cd83720 ("arm64: dts: tegra: smaug: Add Bluetooth node")
Signed-off-by: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra210-smaug.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra210-smaug.dts b/arch/arm64/boot/dts/nvidia/tegra210-smaug.dts
index 7c569695b7052..2b4dbfac84a70 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-smaug.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra210-smaug.dts
@@ -1312,6 +1312,7 @@ serial@70006000 {
 
 	uartd: serial@70006300 {
 		compatible = "nvidia,tegra30-hsuart";
+		reset-names = "serial";
 		status = "okay";
 
 		bluetooth {
-- 
2.40.1



