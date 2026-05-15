Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2F93FF1A2;
	Fri, 15 May 2026 16:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862762; cv=none; b=nc+t/NAL142TVvl8OeDPagQTAdhA3ujut9WjIeJfpmpB5QJ0w/CBzQITmDenF7rJze6sEmuMNg1ilT3WAhFcY8vmzwBp3uc3D2XqprMt8MkJbmn/ZXhAQxoSth+eZ/xW9puOF7948hiqgKcqWmp/oG2tgiVMp1GtQ5CYZwDYffc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862762; c=relaxed/simple;
	bh=fW3ZlVDnvXJIH7HGyqToQrj1gpfZMntFoOkn9CxJcfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oE4htIGGURlWZA1MJpEKoyJZY8XHM/1W40JhLq67GWjw6zc9n+GFaGVtZzoc2+JlXj+1oz+IMCe4TSY1wf9YVNTHFUM9/B0fOFY+HR6RNzL9llioS23Jbf8/B7LgvTCai2fDeLHmAaWSGMjWygAZxNnQlV49DZCcmREoBTByBzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AI6Apc27; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AI6Apc27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F53C2BCB0;
	Fri, 15 May 2026 16:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862762;
	bh=fW3ZlVDnvXJIH7HGyqToQrj1gpfZMntFoOkn9CxJcfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AI6Apc27e9+h9CLo0ToBbQkPJbLhj9wGjqhef7HGbDV8M2T1aNRdbbqvebPNq7MSw
	 IDYfuqGG9Wz49I63iLERkulV1C9Hmlc2uIAworx6nG6BIDrfMuOSZMr3pGyHgpKIsH
	 0RXfDzYXHPQROAOjWtl/abVZj92nCl1vi/SUt+Tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Franz Schnyder <franz.schnyder@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 7.0 171/201] arm64: dts: ti: k3-am69-aquila-dev: Fix DP regulator enable GPIO
Date: Fri, 15 May 2026 17:49:49 +0200
Message-ID: <20260515154702.276297831@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Franz Schnyder <franz.schnyder@toradex.com>

commit 222191225e69711089ecade3b98d79757d51e907 upstream.

Correct the DP regulator enable GPIO to index 21.
The 3.3V DP regulator was not being enabled by the assigned GPIO, as it
is routed to GPIO index 21 and not 37, which was causing instability
with displays connected over DP or via an active DP-to-HDMI adapter.

Fixes: 39ac6623b1d8 ("arm64: dts: ti: Add Aquila AM69 Support")
Cc: stable@vger.kernel.org
Signed-off-by: Franz Schnyder <franz.schnyder@toradex.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20260202083604.325060-2-fra.schnyder@gmail.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am69-aquila-dev.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am69-aquila-dev.dts b/arch/arm64/boot/dts/ti/k3-am69-aquila-dev.dts
index f48601ae38b7..d3677c2c2547 100644
--- a/arch/arm64/boot/dts/ti/k3-am69-aquila-dev.dts
+++ b/arch/arm64/boot/dts/ti/k3-am69-aquila-dev.dts
@@ -33,7 +33,7 @@ reg_3v3_dp: regulator-3v3-dp {
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_gpio_21_dp>;
 		/* Aquila GPIO_21_DP (AQUILA B57) */
-		gpio = <&main_gpio0 37 GPIO_ACTIVE_HIGH>;
+		gpio = <&main_gpio0 21 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 		regulator-max-microvolt = <3300000>;
 		regulator-min-microvolt = <3300000>;
-- 
2.54.0



