Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADC969317;
	Wed, 21 Feb 2024 14:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525369; cv=none; b=PerFfaFRIv0FCLtFi0gK7xoE+o+yBGWAaul7bNM3YbDpAi8udZFunwwh8zsDvvJBUYt0wWDjWxBZyryMswHOStyoY8MiONG4UPDCbrqo6J0XYR9b5bDTVgtMcbXMO8B7SJajhcUmsXObMLWgLfiK9GoSVCdoAWngqM6BQv8NqUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525369; c=relaxed/simple;
	bh=cXHTTruDdyyQB74mEREzvjhX/wnL8GatO+Y62IgcQPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=basp1fqpV5z6r9v/vHy0FUkSM65f6bG3VbN7xg/WAUgzYrq8uioN+8ELNdhm8UzXBu37mMVmv1gSY3SITgRZi8GBpMe7kfo4PaYY/AR8PL0nh/dOx6C30iUwg+tB5qsiVSND3+46CGt2GNXZZhcn8fPHjmSxrxpxMZgAM88Az4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RMbGDHRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMbGDHRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171F9C433C7;
	Wed, 21 Feb 2024 14:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525369;
	bh=cXHTTruDdyyQB74mEREzvjhX/wnL8GatO+Y62IgcQPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RMbGDHRCxBN2udVHvS//5ikh0IoaNJ+gSpq8fMRi2S/CQEPyDk/bokqdkTdYY3Lph
	 7VHsjjodoY2OBhDFT9sLAGsIyT3QBZQDJBCp415oQCmGj2Nn152ey71wLnd4uGa7q4
	 GRN6lBEhw0UOAhoPFY8GaEnfBZt02g32OsucxAck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 107/267] ARM: dts: imx27: Fix sram node
Date: Wed, 21 Feb 2024 14:07:28 +0100
Message-ID: <20240221125943.299799883@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit 2fb7b2a2f06bb3f8321cf26c33e4e820c5b238b6 ]

Per sram.yaml, address-cells, size-cells and ranges are mandatory.

Pass them to fix the following dt-schema warnings:

Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx27.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/imx27.dtsi b/arch/arm/boot/dts/imx27.dtsi
index 3652f5556b29..eb0dac710044 100644
--- a/arch/arm/boot/dts/imx27.dtsi
+++ b/arch/arm/boot/dts/imx27.dtsi
@@ -588,6 +588,9 @@
 		iram: iram@ffff4c00 {
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



