Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B75023FC41;
	Tue, 11 Nov 2025 00:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822791; cv=none; b=crq6nhBCcLaOX7nCDqMqf73QgV+lJYswauFfJNE0xzLNjuH+5s/dqNEqGQHsSJ0/u9y/eW1C9T7jl/5ZLA8zHWwin89wjhYXlnQEkDP6RW4/HqhOWYnRNl4UIrA++8vxN5Eo/PwbayWNOxnZmRTXCQdMKcUnWyTUM+u+H1to//g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822791; c=relaxed/simple;
	bh=PALLMKo/56UDUE4qVlVelMGCVEoFdHzUEZThhonwWGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1jIzz5mJt3zSjLpBb7ui50QxXs327kckIMIMrQ6wOYqLVozS+MgxNgSiA4gpzBqoR5k9zMwQNzLvxiP1RhK8Lnp3UVNvpyhpZbCjhes9ntmnaiutDZYbJljEaeEKylUlAdE94ObsL+zpNNynx9rWhyNiQbc8qgleXEgdDRyyOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nn0GPdr8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nn0GPdr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D28C19422;
	Tue, 11 Nov 2025 00:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822790;
	bh=PALLMKo/56UDUE4qVlVelMGCVEoFdHzUEZThhonwWGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nn0GPdr81AnzK9Y0TkVwPiPNvMhmHR9Ui6PHniV0tWmqZQ/cpcNA8VClcMsX5m91D
	 ccJU6FS/0ppFDcKhVB54tj6XAUKyNqkMkVVGMKVRM+KkzEF21chTw9x+Dv/wp33Deq
	 ZO8EBih1oDYGTiskX2D/hcMZOWBiwqGgEcODOXVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	Winona Schroeer-Smith <wolfizen@wolfizen.net>,
	Antoni Aloy Torrens <aaloytorrens@gmail.com>
Subject: [PATCH 6.17 172/849] ARM: tegra: transformer-20: fix audio-codec interrupt
Date: Tue, 11 Nov 2025 09:35:42 +0900
Message-ID: <20251111004540.594734782@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit 3f973d78d176768fa7456def97f0b9824235024f ]

Correct audio-codec interrupt should be PX3 while PX1 is used for external
microphone detection.

Tested-by: Winona Schroeer-Smith <wolfizen@wolfizen.net> # ASUS SL101
Tested-by: Antoni Aloy Torrens <aaloytorrens@gmail.com> # ASUS TF101
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts b/arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts
index 39008816fe5ee..efd8838f9644f 100644
--- a/arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts
+++ b/arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts
@@ -518,7 +518,7 @@
 			reg = <0x1a>;
 
 			interrupt-parent = <&gpio>;
-			interrupts = <TEGRA_GPIO(X, 1) IRQ_TYPE_EDGE_BOTH>;
+			interrupts = <TEGRA_GPIO(X, 3) IRQ_TYPE_EDGE_BOTH>;
 
 			gpio-controller;
 			#gpio-cells = <2>;
-- 
2.51.0



