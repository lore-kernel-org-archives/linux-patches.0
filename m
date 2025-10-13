Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6385B27815D;
	Mon, 13 Oct 2025 14:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367572; cv=none; b=V2SIJy2Sfh/MasgMxYXRWJtXcvhXuiqmJfphrQ5r37RpxvhvM58o/RIq/BzQzDUkuqkTmZAdwai08Ze2q9JtP3W9LzWdw8JDfdnpJesyrGWdLzgoQ8VhsVLBEdPfXQjTX/8rQ5bLEGjsYgKVyNNDtEifFDjcMHc6p+qGBOPq7i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367572; c=relaxed/simple;
	bh=V+Lrfl/+0q4D3mfEQcr7p90DkwwV+lAIMQvzBMaTmb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6vwu4UE7dFqmu1m6rdpEwz2obcpmc5f4rK4lMkG8riXcK1c1QOMineqUeZn4xSyn3m7Kqi2j/uo239zNtm31LuuOlX6F7f5AXm+/pRAw4lRJxUcUonUrFGrbkycBMwYiEXxf6KKcTI89WTT8uF41/ZRz9ValDurx4IGzcRZfOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YINelSBe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YINelSBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA0FC113D0;
	Mon, 13 Oct 2025 14:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367572;
	bh=V+Lrfl/+0q4D3mfEQcr7p90DkwwV+lAIMQvzBMaTmb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YINelSBe2iO+pAn1DOy3L4lfUvVU+0uOhNJvgz10fMjAY13GotKbZ8o3PLRKoDZB8
	 W5g3lbJSedvE05AEQT38QLaQ/kswkOCFfPylJh5R+IwGbb0HdeMbMCKn6+PEvy9xJL
	 6bN7E/V8PYOOBzsbMQcwLfwAFdPRvuWkOExCANe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/196] ARM: dts: ti: omap: am335x-baltos: Fix ti,en-ck32k-xtal property in DTS to use correct boolean syntax
Date: Mon, 13 Oct 2025 16:43:42 +0200
Message-ID: <20251013144316.323228908@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c14d5b70c72f6..56f704082f94a 100644
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



