Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17981170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F36C433C8;
	Mon, 11 Sep 2023 14:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440975;
	bh=8h8x9x0spwTkrVwfiiJGLQWYchtYi+VlFVGTExybF1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uDavieyfKJqIru6pAZgYkOSr1F8crRiipKMGCnTM38C4aGwMTNhsfS2CkW/mzt6sN
	 5C6Lbysh5qMlaD/+T/fx40GSPXbUG8TG+bPWT0BHbNyh5gic8fd3GjYhmkDsUfStcW
	 Kg9r0d0xfaC5GpYSY7/ZekgRcN2bf9rusGEMvnac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 251/739] arm64: tegra: Fix HSUART for Jetson AGX Orin
Date: Mon, 11 Sep 2023 15:40:50 +0200
Message-ID: <20230911134658.164753762@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit 861dbb2b15b1049113887fb95e856f7123eea0cc ]

After commit 71de0a054d0e ("arm64: tegra: Drop serial clock-names and
reset-names") was applied, the HSUART failed to probe and the following
error is seen:

 serial-tegra 3100000.serial: Couldn't get the reset
 serial-tegra: probe of 3100000.serial failed with error -2

Commit 71de0a054d0e ("arm64: tegra: Drop serial clock-names and
reset-names") is correct because the "reset-names" property is not
needed for 8250 UARTs. However, the "reset-names" is required for the
HSUART and should have been populated as part of commit ff578db7b693
("arm64: tegra: Enable UART instance on 40-pin header") that
enabled the HSUART for Jetson AGX Orin. Fix this by populating the
"reset-names" property for the HSUART on Jetson AGX Orin.

Fixes: ff578db7b693 ("arm64: tegra: Enable UART instance on 40-pin header")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts b/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts
index cd13cf2381dde..513cc2cd0b668 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dts
@@ -2010,6 +2010,7 @@ interrupt-controller@2a40000 {
 
 		serial@3100000 {
 			compatible = "nvidia,tegra194-hsuart";
+			reset-names = "serial";
 			status = "okay";
 		};
 
-- 
2.40.1



