Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE5E1D8DFB;
	Mon,  2 Jun 2025 14:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872860; cv=none; b=gu5FWCA6T34p9JmfsvmZnQz77Zizt3Qj0KLjfLUd6+Vr1OEM9UgnVNgn9vq7lmF8p+XFnHzWQJkerL6LqLrDu83NgTilaKIaNKR2PvPWqW0eahvLYyiw91z+X87ZldE+xacu5wyjil+NQ2UVCKqvTYd41Bbkr+NnYiW8wMSeJw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872860; c=relaxed/simple;
	bh=19O+b9yMRuLRIGtt+vzNf2mZSLE6GHG9e5FmACkrDbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBq6dKoFhKralTRUYWhyOs+8kG28kGL0oBs2nu55/dlaBM+iH0Z1NhlxQF2zzqVJJ1EGKMbErerdOMJXGmG8Jz5FCQ0IoOv1qsfRyvnlFIRn29Vw5+e7d47NMrI7T/Ucl60rC+d3hM4PQgrC/glabmnHl1/IIbYjonUhDvnMGpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjGQEKdP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjGQEKdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD9AC4CEEB;
	Mon,  2 Jun 2025 14:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872860;
	bh=19O+b9yMRuLRIGtt+vzNf2mZSLE6GHG9e5FmACkrDbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjGQEKdPI6wpBRCUkQ6xVYZRrCF7ZW5hnZ4Jek8p7fMfdTZy6KS6T7EBcILkFJRfh
	 DwXfODX1hPGXSJsaP7SEhmNCzhm6XN8VZaAHgkr9l3XzE5wRmom3oLIuQ+spu1CwL1
	 LvPjHZv6HlH5eYwD0SL/Ohgt8r+X3viaZ/VurBXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Neha Malcom Francis <n-francis@ti.com>,
	Jai Luthra <jai.luthra@linux.dev>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.12 19/55] arm64: dts: ti: k3-am62x: Rename I2C switch to I2C mux in IMX219 overlay
Date: Mon,  2 Jun 2025 15:47:36 +0200
Message-ID: <20250602134239.038815369@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


