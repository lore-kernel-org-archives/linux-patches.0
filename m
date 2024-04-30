Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED29E12C530;
	Tue, 30 Apr 2024 10:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473937; cv=none; b=ot3PSLqnMErzRWs4Oy6E481XUKBn2/MrgosnBRkl7EBUKFeC7GXOdbhdY4hAn9ToCDvF5b/FeAc1SThgmnq9hOq/9zlSknkNNkVD4+EM/2TpH8nWtfoYVdoOfDf5FwycpvG8vQ/MRoj9JMGtkK+9FYUIJk3Bbm2LjBEEA8fIjQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473937; c=relaxed/simple;
	bh=4ob+cX1eYPbM8rN5mYsoKyQ6SK4VSQVAHIegH094vYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkjZV5XeftmfffLSl+vBIyUbTX6GXvdoVMJ3UFHGvrW1G4xNz96YBoyjjAna8bR4J7MOR1Kn7y1AhbBz4FvmqL+baXrhhISszmKHbNjxMryQdsFW2grnU5lCozQB2aguWcSh/9rMOTZIjIQcBembL7UHbi00IbCwwnhQFzmAgpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7cbsZ31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7cbsZ31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B6EC2BBFC;
	Tue, 30 Apr 2024 10:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473936;
	bh=4ob+cX1eYPbM8rN5mYsoKyQ6SK4VSQVAHIegH094vYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N7cbsZ31m+KPVCnx/Rru0MzphCsPkvBxCWBWWr7ztn43pXpKvPOCvNtRWyIIo8pCg
	 yZXXeaaGUv5DOeSwudnD6ciGru2ZdGXZA42v5iiEEiIk6DJrb0qj5ATQFmtuDOG0aE
	 EfslVZdySSSK7iB731Q9q2jX39Ufuap/+IwrWw10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 011/228] arm64: dts: rockchip: Remove unsupported node from the Pinebook Pro dts
Date: Tue, 30 Apr 2024 12:36:29 +0200
Message-ID: <20240430103104.140468555@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragan Simic <dsimic@manjaro.org>

[ Upstream commit 43853e843aa6c3d47ff2b0cce898318839483d05 ]

Remove a redundant node from the Pine64 Pinebook Pro dts, which is intended
to provide a value for the delay in PCI Express enumeration, but that isn't
supported without additional out-of-tree kernel patches.

There were already efforts to upstream those kernel patches, because they
reportedly make some PCI Express cards (such as LSI SAS HBAs) usable in
Pine64 RockPro64 (which is also based on the RK3399);  otherwise, those PCI
Express cards fail to enumerate.  However, providing the required background
and explanations proved to be a tough nut to crack, which is the reason why
those patches remain outside of the kernel mainline for now.

If those out-of-tree patches eventually become upstreamed, the resulting
device-tree changes will almost surely belong to the RK3399 SoC dtsi.  Also,
the above-mentioned unusable-without-out-of-tree-patches PCI Express devices
are in all fairness not usable in a Pinebook Pro without some extensive
hardware modifications, which is another reason to delete this redundant
node.  When it comes to the Pinebook Pro, only M.2 NVMe SSDs can be installed
out of the box (using an additional passive adapter PCB sold separately by
Pine64), which reportedly works fine with no additional patches.

Fixes: 5a65505a6988 ("arm64: dts: rockchip: Add initial support for Pinebook Pro")
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Link: https://lore.kernel.org/r/0f82c3f97cb798d012270d13b34d8d15305ef293.1711923520.git.dsimic@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
index 054c6a4d1a45f..294eb2de263de 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
@@ -779,7 +779,6 @@
 };
 
 &pcie0 {
-	bus-scan-delay-ms = <1000>;
 	ep-gpios = <&gpio2 RK_PD4 GPIO_ACTIVE_HIGH>;
 	num-lanes = <4>;
 	pinctrl-names = "default";
-- 
2.43.0



