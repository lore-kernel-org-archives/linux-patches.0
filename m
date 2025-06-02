Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5D21401B;
	Mon,  2 Jun 2025 13:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872663; cv=none; b=czykDECoeLuMrgbxSryUkS7360ttIYl+NuV9IPBzHYEExNe5aCdhijDQ0NgWgVn3077QB375f7rDKolo8O+2iAxZD0uMkblOzszYpDHlZzUZJjb7s3cF6aFU+d3f+uGcZ4MykvMZiz/+/JYu2LXnHzqBK76DYh2YmkYGfpHm778=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872663; c=relaxed/simple;
	bh=84XTny/KZKQqD9epOYc0d3ZD3fd4pr6blHLdqxwxqtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItWPaih//AyAF2ZuKENK7q+f09ZpQHTf3YAs6HGLMJ4w5pfjgK5BuYqicfB5cJ/+QonNzfPeP3z9iwYXgq1NMLt2MvA1fasBXxvfQB4X/gKtc9y3BcungtzRx/foGQw/i5M7cxVj17djR2mO8AjrvphAax7s4kC37ERxsNp5aek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DlnbYNhg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DlnbYNhg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5F1C4CEEB;
	Mon,  2 Jun 2025 13:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872662;
	bh=84XTny/KZKQqD9epOYc0d3ZD3fd4pr6blHLdqxwxqtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DlnbYNhg2fs5XGZr0GmbGjhpCqOx6LL2dPH/LmsZhZyisNavzLJMawtKMWg8359+9
	 4nrV4XDeX7NGvd4FqJGm53HsTkyaw1hZX7qQ6T/szKDMYpop67bIqY8QuDVCTZw6wt
	 92dwqxR77lqLTjxYr968HW/ntrmrmP5O/z2vnqKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Neha Malcom Francis <n-francis@ti.com>,
	Jai Luthra <jai.luthra@linux.dev>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.14 31/73] arm64: dts: ti: k3-am62x: Rename I2C switch to I2C mux in IMX219 overlay
Date: Mon,  2 Jun 2025 15:47:17 +0200
Message-ID: <20250602134242.925946058@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>

commit 7b75dd2029ee01a8c11fcf4d97f3ccebbef9f8eb upstream.

The IMX219 device tree overlay incorrectly defined an I2C switch
instead of an I2C mux. According to the DT bindings, the correct
terminology and node definition should use "i2c-mux" instead of
"i2c-switch". Hence, update the same to avoid dtbs_check warnings.

Fixes: 4111db03dc05 ("arm64: dts: ti: k3-am62x: Add overlay for IMX219")
Cc: stable@vger.kernel.org
Signed-off-by: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
Reviewed-by: Neha Malcom Francis <n-francis@ti.com>
Reviewed-by: Jai Luthra <jai.luthra@linux.dev>
Link: https://lore.kernel.org/r/20250415111328.3847502-7-y-abhilashchandra@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62x-sk-csi2-imx219.dtso |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-am62x-sk-csi2-imx219.dtso
+++ b/arch/arm64/boot/dts/ti/k3-am62x-sk-csi2-imx219.dtso
@@ -22,7 +22,7 @@
 	#size-cells = <0>;
 	status = "okay";
 
-	i2c-switch@71 {
+	i2c-mux@71 {
 		compatible = "nxp,pca9543";
 		#address-cells = <1>;
 		#size-cells = <0>;


