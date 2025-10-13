Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50733112D6;
	Mon, 13 Oct 2025 15:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368096; cv=none; b=CLWC2b1cTbZrXI7civ1OuWDv7RqV0vsDZBAmVHtlkiiBv+w7jpb0YafRer0kNL2mVmAT3EXHxUt6/Uwd9kMY3DVlziDxlO7az6MPN9JVrSUt0EyqK9pFEKcK5tOPy+a8PaBUG/+JDZxTlPOmAKJsDvkThzkBBK/cIqx8xN/p8Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368096; c=relaxed/simple;
	bh=RM+j3yzKG6tvvMNK/eLU3F5RXuFkjNlKlpi78kMhRtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DUg/phRf/ZKT27IBagP7AUA63lm4opUH0xsLY2GincAesRtzZ6lxNWy+lCrC6N+34G4PkNEPZkT8UMfwZZdkzeoqGDXXfiipg5lVzpbT+sVEvEQbCUwbCuhghOkqfaMR5xdps1b/1163kSaI/gCS7SUift+phLdE6RnXnoY9bWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QOHhzqbn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QOHhzqbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF46C4CEE7;
	Mon, 13 Oct 2025 15:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368096;
	bh=RM+j3yzKG6tvvMNK/eLU3F5RXuFkjNlKlpi78kMhRtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOHhzqbnkL8C9p6vgK4wfSsJdbGBF7syQkCB6uLtPBootbKciWHxvTWlRVeHKnJBX
	 oV00iw0mg4QRkFGcUMjFsrpHZPxoG+/M6F+VFvu8f04cXIWFsXnVRGDudS4tp9XurN
	 iLKjXxW5A7pGEvf+05P1h6HwXvA4hCTy7+/IB5Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/262] ARM: dts: ti: omap: am335x-baltos: Fix ti,en-ck32k-xtal property in DTS to use correct boolean syntax
Date: Mon, 13 Oct 2025 16:43:05 +0200
Message-ID: <20251013144327.682464142@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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
index a4beb718559c4..9ee9e7a1343c4 100644
--- a/arch/arm/boot/dts/ti/omap/am335x-baltos.dtsi
+++ b/arch/arm/boot/dts/ti/omap/am335x-baltos.dtsi
@@ -270,7 +270,7 @@ &tps {
 	vcc7-supply = <&vbat>;
 	vccio-supply = <&vbat>;
 
-	ti,en-ck32k-xtal = <1>;
+	ti,en-ck32k-xtal;
 
 	regulators {
 		vrtc_reg: regulator@0 {
-- 
2.51.0



