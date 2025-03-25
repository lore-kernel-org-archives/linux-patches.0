Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF69D25C6E0;
	Tue, 25 Mar 2025 12:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906430; cv=none; b=afBc09S9/ZpgLjS0ipxcgsGYt6NvxalAqW8tLcQ29tMqd+V/LQNyD9xKcI0i3lYPPlZaiMGcs4IoMSjjfwyTDKT1HtNOO4J76D5g+NojAiFxzv46jgVmBcFhGr9etH8KyiUIogKsu/yr9veqcCgWqwhw1qLPxvvFiNXcjb91Yzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906430; c=relaxed/simple;
	bh=eGJKxyNuojzrlzR1iVPwlGX6IS6mg4R313BXpYB77UQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCvvH1KoCsPm5lugXc5kPhGWxUVe40mZ2wwbp8t4odJzKf/gvPqvmh978E2DYDFvc2BOeCFQuh4Tzs/qXwdkx/V03owPOIBTmou482ri+iIUshANVq0YVBLoeRNGH8XWAF8RIgxc9iLgpkzrO2s34j7kvUxDEKpBdgV82359tbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3BaS7UW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3BaS7UW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93437C4CEE4;
	Tue, 25 Mar 2025 12:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906429;
	bh=eGJKxyNuojzrlzR1iVPwlGX6IS6mg4R313BXpYB77UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3BaS7UW4S/AnpWnZ4hNS7M4253r6ZyyldSJLxRkjqXBTlDz18a4iXaN+y0mULil7
	 3Q/Mn2npaPDhMvsbL+/qb0LvLrU/W1AAES46PS6dmPttw65ktXOkScqMsG3Phe1xct
	 /pvUaAT4Bqoikvhnk9yQmD+RoJDxSS3jri4URpkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Klaassen <justin@tidylabs.net>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.12 114/116] arm64: dts: rockchip: fix u2phy1_host status for NanoPi R4S
Date: Tue, 25 Mar 2025 08:23:21 -0400
Message-ID: <20250325122152.120574856@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

From: Justin Klaassen <justin@tidylabs.net>

commit 38f4aa34a5f737ea8588dac320d884cc2e762c03 upstream.

The u2phy1_host should always have the same status as usb_host1_ehci
and usb_host1_ohci, otherwise the EHCI and OHCI drivers may be
initialized for a disabled usb port.

Per the NanoPi R4S schematic, the phy-supply for u2phy1_host is set to
the vdd_5v regulator.

Fixes: db792e9adbf8 ("rockchip: rk3399: Add support for FriendlyARM NanoPi R4S")
Cc: stable@vger.kernel.org
Signed-off-by: Justin Klaassen <justin@tidylabs.net>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Link: https://lore.kernel.org/r/20250225170420.3898-1-justin@tidylabs.net
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4s.dts
@@ -117,7 +117,7 @@
 };
 
 &u2phy1_host {
-	status = "disabled";
+	phy-supply = <&vdd_5v>;
 };
 
 &uart0 {


