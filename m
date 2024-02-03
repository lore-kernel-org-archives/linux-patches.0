Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014C7107B4;
	Sat,  3 Feb 2024 04:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933560; cv=none; b=Gb8EryyQIW5FTpK4gWYN28yPjsGRT9vTKqZHgWIr43HwxraD5bYIwNV7knAo7/kctgLMhBlboE36B5rBvW8GTgSikhW9riC2CJU9uSJ3V1lMFEPvRXI6W7s3VrGiK5I1XM2v64ag4tjl71YsEfgtSiyVsUr080Fgs8cXLqB9rws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933560; c=relaxed/simple;
	bh=leHHh/hYaa+QTcaywmzkJlZ/2AHl+9R891z7VA9oO/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ea+nMzZ9p9b+05AbdHerCOcxFxn3eA0Oi2TjMmwEMRX80gFVLE2AVfXAWEDKt3oud/sB2l+LtzhFtQIdZNQLAE3jtM6hAW5XWeRf4Bdl06BKF09Fe+9YS+LRPgbAMnHCs0caXvgG3N+i4tor8XnTW1KdRwky3CmqWpB44CqqnrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GfoQpBrz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GfoQpBrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5C8C433F1;
	Sat,  3 Feb 2024 04:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933559;
	bh=leHHh/hYaa+QTcaywmzkJlZ/2AHl+9R891z7VA9oO/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GfoQpBrz6TQSrOgG4fCfAZH9IkkIhSuyQzbIpNQhwBkX+sG5z4oFHEGonb53V1+Ey
	 F9+ywME3qI0rYE+9sw7ZuIGk+V7TBahIiv/csPde//hSWqXq87YXJcyU+4EbctWYmQ
	 iBp0242S+ss0gMCqOPxDdUauHyoWH1Hd2D3N4NuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 113/322] ARM: dts: imx27: Fix sram node
Date: Fri,  2 Feb 2024 20:03:30 -0800
Message-ID: <20240203035402.790706723@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



