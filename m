Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624B9189521;
	Tue, 30 Jul 2024 16:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355686; cv=none; b=WF4Z+RGxwbiaZDg4/ln5Cil+VQIVM9ZeZ0j6Sk3q7pSed0mTmuwf+qzU1/GdvKhs/Du1NCevW+CMTXHlPYSzOkNqsVFMSninIwb361u/VogwpuIGdiX6lUkPUw6p1J0yqx0W5VW5OyrMTh+0GHNj+NOsWTsqfJfVKPiYj5P3c9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355686; c=relaxed/simple;
	bh=hSxY7RvKq1dyWqsf6Fe2dssZbOrxNB2QPK9TkJHwDEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOPy2RK04WFS4JO/GH146qvT36uguUf3i6NT19z6UPR37tjaxauZEiLPDxXIMqld0AXYJzK0ttH8GFwANDAJJ628/NCvzKV1E9mR3SdbU6QEjJZIIhAx/SEsftRwGNQhkwbK7oAyUxZMiC6Cua0aXZ6/nHEk9npD3mKgXcA+pHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDs9Uj3h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDs9Uj3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8129C32782;
	Tue, 30 Jul 2024 16:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355686;
	bh=hSxY7RvKq1dyWqsf6Fe2dssZbOrxNB2QPK9TkJHwDEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yDs9Uj3hVf0Rro+L4hWSa2Deg/dz/3wM2lBezMPFOoDXa2HCrPjZtJrCRqvOIB8Kd
	 VbpyOWI9gpyFuipNPYYvNyijv0vWdvuDFaAx2d7sN0Oo2n7q5WCH3K1QNB8KsQA3yw
	 089orEHwZdNLqreKqFj3jTu7Xiaev96UUMGnhAe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/568] arm64: dts: rockchip: Fix mic-in-differential usage on rk3566-roc-pc
Date: Tue, 30 Jul 2024 17:43:08 +0200
Message-ID: <20240730151643.026638775@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit e643e4eb4bef6a2f95bf0c61a20c991bccecb212 ]

The 'mic-in-differential' DT property supported by the RK809/RK817 audio
codec driver is actually valid if prefixed with 'rockchip,':

  DTC_CHK arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dtb
  rk3566-roc-pc.dtb: pmic@20: codec: 'mic-in-differential' does not match any of the regexes: 'pinctrl-[0-9]+'
	from schema $id: http://devicetree.org/schemas/mfd/rockchip,rk809.yaml#

Make use of the correct property name.

Fixes: a8e35c4bebe4 ("arm64: dts: rockchip: add audio nodes to rk3566-roc-pc")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20240622-rk809-fixes-v2-4-c0db420d3639@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts b/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
index 938092fce1866..68a72ac24cd4b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
@@ -268,7 +268,7 @@ rk809: pmic@20 {
 		vcc9-supply = <&vcc3v3_sys>;
 
 		codec {
-			mic-in-differential;
+			rockchip,mic-in-differential;
 		};
 
 		regulators {
-- 
2.43.0



