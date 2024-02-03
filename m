Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6011C2BD;
	Sat,  3 Feb 2024 04:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933825; cv=none; b=rzqn7h1+kxuMnIJ5EvUvglTv/yeKNqF0q3kauXyjz5595pHMqNBDOZGSOdTuaw0GfwGiGEz0byH5O/ulQcnrJcnhoskxBv4yXyg5zdchb5CAhIusp2xjoGGGQGwlXJ7KlHdenUx12DkQ04dJTuMax1LOEtxKUF36I/aqtVDn1yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933825; c=relaxed/simple;
	bh=vQC3UKYxMtcx1oYb8JtzRO+M1/OT7jwxfWCosF6rdvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=scZKfAIvH090vVhjStzzLu0CSTMcjPEdZrn+Oxy69wRGr/dTJ2IJBJy1+gyiMC5ZQKz2aBTO1atg1KuMnq3a1WLpcGPwOARSPbJIgf7r7sGhCftLTTbv7ZrQ5nsnxW6EaHHo+PDb99XTNRUcZU+y/TV7/dgf+caHJt1vVLec+TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2RQdM5w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2RQdM5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E202C433F1;
	Sat,  3 Feb 2024 04:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933825;
	bh=vQC3UKYxMtcx1oYb8JtzRO+M1/OT7jwxfWCosF6rdvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2RQdM5wl9cn94fR2xCMZ04iIXhFluCVNhLt3agIbFUpOkJOgEVcknevXDvI5dttR
	 Ir+m5pXt9RJcbNNn3wUMXBLgq6p7AldIv8iTuMqlY5l9MbSY+GsGJjoBmYfSfYJoeE
	 +HZaaErWZ8CqmH/7fgrS1V4H9NpqbyTXT8zBKMp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 112/353] ARM: dts: imx27: Fix sram node
Date: Fri,  2 Feb 2024 20:03:50 -0800
Message-ID: <20240203035407.299576506@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit 2fb7b2a2f06bb3f8321cf26c33e4e820c5b238b6 ]

Per sram.yaml, address-cells, size-cells and ranges are mandatory.

Pass them to fix the following dt-schema warnings:

Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx27.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/nxp/imx/imx27.dtsi b/arch/arm/boot/dts/nxp/imx/imx27.dtsi
index faba12ee7465..cac4b3d68986 100644
--- a/arch/arm/boot/dts/nxp/imx/imx27.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx27.dtsi
@@ -588,6 +588,9 @@
 		iram: sram@ffff4c00 {
 			compatible = "mmio-sram";
 			reg = <0xffff4c00 0xb400>;
+			ranges = <0 0xffff4c00 0xb400>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 		};
 	};
 };
-- 
2.43.0



