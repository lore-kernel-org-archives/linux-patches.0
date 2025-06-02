Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB3D1F5846;
	Mon,  2 Jun 2025 13:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872659; cv=none; b=n33zAB7ifePsYKn7pNoe+Ubi0H4AtHCrNDygrj4jGwmaWgIS/VzSla1DwvY5IRxJCHxhCrwPxA4hMKSKouKTZdQ4M2EZggTtMXSdXMEHSZ2BdQZOYMu7GMREDrKXdE7/GydnU2btRKqvv10gfXhFPGp7oXqihZFV5T46kDRU0Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872659; c=relaxed/simple;
	bh=bGhuNCg1AbBrh64RnGU7ZCMxRxhmumvNoMPsgU0dFdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cr4tpdmUgynoNFccLmVXiP23Pli5jl7gitmHjPlWxkLAPJNuF8fVgqAOgdKf7Nh2pPMJN0DcZBb5oEY6rVrclhPBMGBmfnuBPpYfRTqiOpgIgdBAX4IYvUhO/cP/InvYqDaqAJcpzkAaCWwtFuI0MXtXz2VeFf85D15pE1JBPF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gUeVNHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gUeVNHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F7BC4CEEB;
	Mon,  2 Jun 2025 13:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872659;
	bh=bGhuNCg1AbBrh64RnGU7ZCMxRxhmumvNoMPsgU0dFdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0gUeVNHGgCw6FSbbASMW9sQqscbO7v4u0U1fW32nIR3SwkDxLfgIS3q+sj0tFIfIL
	 DG8GV/oa7hJpwLwD8rdqhXnovZn1EjKNfCBJUeW0f2XGFSVwiJAsM7lPEZIUI7ePWp
	 cl6fvTNpxzOtyTy3YT+iJFh1iMQko8IX285dSVZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Neha Malcom Francis <n-francis@ti.com>,
	Jai Luthra <jai.luthra@linux.dev>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.14 30/73] arm64: dts: ti: k3-am62x: Remove clock-names property from IMX219 overlay
Date: Mon,  2 Jun 2025 15:47:16 +0200
Message-ID: <20250602134242.886578352@linuxfoundation.org>
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

commit c68ab54a89a8c935732589a35ea2596e2329f167 upstream.

The IMX219 sensor device tree bindings do not include a clock-names
property. Remove the incorrectly added clock-names entry to avoid
dtbs_check warnings.

Fixes: 4111db03dc05 ("arm64: dts: ti: k3-am62x: Add overlay for IMX219")
Cc: stable@vger.kernel.org
Signed-off-by: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
Reviewed-by: Neha Malcom Francis <n-francis@ti.com>
Reviewed-by: Jai Luthra <jai.luthra@linux.dev>
Link: https://lore.kernel.org/r/20250415111328.3847502-6-y-abhilashchandra@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62x-sk-csi2-imx219.dtso |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-am62x-sk-csi2-imx219.dtso
+++ b/arch/arm64/boot/dts/ti/k3-am62x-sk-csi2-imx219.dtso
@@ -39,7 +39,6 @@
 				reg = <0x10>;
 
 				clocks = <&clk_imx219_fixed>;
-				clock-names = "xclk";
 
 				reset-gpios = <&exp1 13 GPIO_ACTIVE_HIGH>;
 


