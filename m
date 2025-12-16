Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF99033B961;
	Tue, 16 Dec 2025 11:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883961; cv=none; b=kPIZx/rJ6fqkUuaikCQb+CFUCJ/dwfNaXxoKDvrm1KLoMFwZTXK5PlKSRnmkp5ZQX5GKSCufU7xDmmIdznH2fhZzx9h33rkGPpIOtKTH7Sk60vMKPrQfSX/l3GxbznK4WccyHOab7zV/6XNRlWKMWiZuoabqV7XAZUjS0jb7U5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883961; c=relaxed/simple;
	bh=NOwY75yUrXSjg+iFdp0ZiU9ir0ItlavmU75pVKdPpHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNg/9uAHs9o/Vo1UqfK6QuN7O3EfLVa4//LkqHUJ0m26OazJArUvL8+W46TdqUcptyxetIwgIEg3gx2IxoJ/vW/VmH1DJPEwN/LMMq7mA7Uw9UcH5/B6g23TFgas6S0BGtUSeApy7cWYO+hif2y43eXuui0wOnHQZQd6i8t4yyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UhZaTviQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UhZaTviQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC71C4CEF1;
	Tue, 16 Dec 2025 11:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883961;
	bh=NOwY75yUrXSjg+iFdp0ZiU9ir0ItlavmU75pVKdPpHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UhZaTviQ+kYJ/zo00SGo/Z7F5hD/8N38yMjOPpJhSgnmWCSHaDWwQFRJxCyZ+Z9dK
	 /d7QnOWAJ6C39euawW9vJCReXQtcmabPt+98jn1tIKPcXbEsKxegwROdonqrreZKjN
	 gDE9JyXQcat0GLypyAB0YgX8rJVQdxEHoIxV89CY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/354] arm64: dts: freescale: imx8mp-venice-gw7905-2x: remove duplicate usdhc1 props
Date: Tue, 16 Dec 2025 12:10:17 +0100
Message-ID: <20251216111322.729489503@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit 8b7e58ab4a02601a0e86e9f9701d4612038d8b29 ]

Remove the un-intended duplicate properties from usdhc1.

Fixes: 0d5b288c2110e ("arm64: dts: freescale: Add imx8mp-venice-gw7905-2x")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi
index 6c75a5ecf56bb..45c7082c9df71 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw702x.dtsi
@@ -421,9 +421,6 @@ &usdhc1 {
 	bus-width = <4>;
 	non-removable;
 	status = "okay";
-	bus-width = <4>;
-	non-removable;
-	status = "okay";
 };
 
 /* eMMC */
-- 
2.51.0



