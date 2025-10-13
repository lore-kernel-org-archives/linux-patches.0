Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7C630C617;
	Mon, 13 Oct 2025 15:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369104; cv=none; b=dRw5aDQy149dbKMMsdZFTELIYUdM+E2qp/GXAcc93gnW+DSLiwDnkwThGQfkZtK2SN2flLiS5coFDV1uzh+ud9IBMXo7wO0dOOBGIUuZSOxiuYnnFZ9twFq6kosCZlMAuQWYfsrJoBvNGImBLn5pGCquaMsHrxQGEEcrQOtgErY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369104; c=relaxed/simple;
	bh=xBTUM34ZwpHWfbIdfvzXgJFVncYk8NPf8w0UJlDZOfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYM6S+/Vi6uYbvFZCnxsmVtvTtO2Dsexqwg7bHmTp97BctOPcN1esdEIuUUO4NcfsBqV+HgYY+flQAhD9CGIHEANOYTaeiXRYX/dxU8TZiDHF4qlejXflpxTcPr2Ee6IZY9PAkZbiXlRNPZAqGhpNp6RR4Frbuvxn5+Vv1INB80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h8s8i2Ir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h8s8i2Ir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D5EC4CEE7;
	Mon, 13 Oct 2025 15:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369104;
	bh=xBTUM34ZwpHWfbIdfvzXgJFVncYk8NPf8w0UJlDZOfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h8s8i2IrSGCCAqs2+2pEHyDiWiHnKh8TuxOD9hIqnNoAWSKm1XeOuD7ifo1ii+2Di
	 AVF88EPltRqnSvxlDzkj4vrkj4Nz+eg3t69woaQ0xtKw0kB+k2G1tDbiO3b7jA6FMJ
	 CumwYIHUck+TwgKfNcXEQNeo2fpE14RRwRhLXHBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 096/563] ARM: dts: ti: omap: am335x-baltos: Fix ti,en-ck32k-xtal property in DTS to use correct boolean syntax
Date: Mon, 13 Oct 2025 16:39:17 +0200
Message-ID: <20251013144414.773436270@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Jihed Chaibi <jihed.chaibi.dev@gmail.com>

[ Upstream commit 9658a92fad1889ff92fa4bd668cd61052687245a ]

The ti,en-ck32k-xtal property, defined as a boolean in the Device Tree
schema, was incorrectly assigned a value (<1>) in the DTS file, causing
a validation error: "size (4) error for type flag". The driver uses
of_property_read_bool(), expecting a boolean. Remove the value to fix
the dtbs_check error.

Fixes: 262178b6b8e5 ("ARM: dts: split am335x-baltos-ir5221 into dts and dtsi files")
Signed-off-by: Jihed Chaibi <jihed.chaibi.dev@gmail.com>
Link: https://lore.kernel.org/all/20250822222530.113520-1-jihed.chaibi.dev@gmail.com/
Link: https://lore.kernel.org/r/20250822222530.113520-1-jihed.chaibi.dev@gmail.com
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ti/omap/am335x-baltos.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/ti/omap/am335x-baltos.dtsi b/arch/arm/boot/dts/ti/omap/am335x-baltos.dtsi
index ae2e8dffbe049..ea47f9960c356 100644
--- a/arch/arm/boot/dts/ti/omap/am335x-baltos.dtsi
+++ b/arch/arm/boot/dts/ti/omap/am335x-baltos.dtsi
@@ -269,7 +269,7 @@ &tps {
 	vcc7-supply = <&vbat>;
 	vccio-supply = <&vbat>;
 
-	ti,en-ck32k-xtal = <1>;
+	ti,en-ck32k-xtal;
 
 	regulators {
 		vrtc_reg: regulator@0 {
-- 
2.51.0



