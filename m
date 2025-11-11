Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74469257824;
	Tue, 11 Nov 2025 01:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822908; cv=none; b=sT7Nm6XpJGDRnc2A7a3aBOwGgaQcCvdNgiasanp6YnmLNnPFynOtg+6a94dWGEz0/cg4ED1VgzCmVcfIffuWg2X8ywAWytbZat4/zPRk4uMpdZarnpkuthMBWcaWXg5B2zP+Gx8Khhw1hW0fpHclhWpjH/LvOA/WC6xeuNmTJHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822908; c=relaxed/simple;
	bh=T/Z29BmDaJoxT95gM2cVlqBaFg/rQXS7pCYjE6pkllY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UnnB1e9S1TdRkiGU7pctQbHpMxpf7SMjYhGXTdVbg/AHW+6HKj13KgDIWPHp74qWMhwszsi7OG/pLMUba7Q1pETQifl95Xm5PKs7KkVAGZTJaSLDHnKcwlXsKSL43Uit/0pxbmL/pswZeG68SWpNc2nmXPcUObWiYW9MwuBWs3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VxiQdesi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VxiQdesi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10574C4CEFB;
	Tue, 11 Nov 2025 01:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822908;
	bh=T/Z29BmDaJoxT95gM2cVlqBaFg/rQXS7pCYjE6pkllY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VxiQdesi7+lxHJFk7gGwzqAAoQzulfnKSIgriyw7jcvKjhUEDOXcNwM9DR5uGjemh
	 TnFNsIlTe6ow9cFrmjvo7VNjHE7KLGAXBHuruo1SvokTDkTlbyaZLtoomJ0RIKPYL5
	 RbwATxH0l5HmsbVUwUOgRMoK1JpTZXomx6/n5QQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	Winona Schroeer-Smith <wolfizen@wolfizen.net>,
	Antoni Aloy Torrens <aaloytorrens@gmail.com>
Subject: [PATCH 6.12 131/565] ARM: tegra: transformer-20: fix audio-codec interrupt
Date: Tue, 11 Nov 2025 09:39:47 +0900
Message-ID: <20251111004529.897460272@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 676ed51aa2cee..f0e7284fa7c36 100644
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



