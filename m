Received: from hall.aurel32.net (hall.aurel32.net [195.154.113.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E39F267735;
	Tue, 11 Feb 2025 22:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.154.113.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739312320; cv=none; b=dPDnslOAyucarboSgBhFadAkU53+ymbYt+0bn3z6xXyiPZ9iFK2ZhPh/rfF8DGt4/NhSVcuowmeUWFEY4u7k4wjCRrBY6Yjo0OXdixsjs7H7pWL+mGkQfg1OGzIA3GhRsy9CG3/fpnw23tXtG3bkXBXm9NvTUuOikcGuVbVPD8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739312320; c=relaxed/simple;
	bh=fg+mdDs/1hxV8xrps0GKi/M2rnTsDoaggfZkwa0Y7Dw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bjuYwr3UNaSZtBj0FMvUEwKQS1yk1y7HE6c6wn5wRfNlWQMPynQQWemMjW1XCmCHq+SrZUevP37Uj+VDa4qbBP6uEz60nHUYt3feMdpneGFXzZD2m19HT/5jDmbwZZJI8GKNuafT0fFtcFZMvipHnn+0zX5vHaUkuVpBtdXl8Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aurel32.net; spf=pass smtp.mailfrom=aurel32.net; dkim=pass (2048-bit key) header.d=aurel32.net header.i=@aurel32.net header.b=b+TUNzpp; arc=none smtp.client-ip=195.154.113.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aurel32.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aurel32.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aurel32.net header.i=@aurel32.net header.b="b+TUNzpp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=aurel32.net
	; s=202004.hall; h=In-Reply-To:Content-Type:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Content-Transfer-Encoding:From:Reply-To:
	Subject:Content-ID:Content-Description:X-Debbugs-Cc;
	bh=qDrZkc0qPpSqWL5jahZOhNW47jDrNmc5iD9eUvdSGT0=; b=b+TUNzpplgqHMDLrvchwqjOBSP
	OrVNYOwYvJcZQ4UfJmrtOGlIU796xsh/bOMu1u/hSLbVbgdqYkOar0Vm6/Z6iWV0vJuLBCZI631PV
	bU6fgHoHV5oiqKcDv8ErJfwYQ+EiBr2YsRo9M0ez/uRNGJdIvYUTaveY7EvHh34uS0nZdfqSEXO4O
	XP32NYXHPdvbAik+q9w5gH3hQrIHeyjxQ0O75bQKrHqzwE5sd+HEu/wTMep0Jxs5NF5g2C8AFw6bd
	hCtn4vWuTR3Jj16rwuIuJzpSTIFR7miB/72hnXg1J6adcL5uKOgD5RWaiXNZxNhTVWeOyLPF2XWCy
	skyJn96Q==;
Received: from [2a01:e34:ec5d:a741:1ee1:92ff:feb4:5ec0] (helo=ohm.rr44.fr)
	by hall.aurel32.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <aurelien@aurel32.net>)
	id 1thyaD-00EdMB-2u;
	Tue, 11 Feb 2025 23:18:21 +0100
Date: Tue, 11 Feb 2025 23:18:21 +0100
From: Aurelien Jarno <aurelien@aurel32.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Michael Zimmermann <sigmaepsilon92@gmail.com>,
	Chukun Pan <amadeus@jmu.edu.cn>, Heiko Stuebner <heiko@sntech.de>,
	Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH 6.12 026/114] phy: rockchip: naneng-combphy: fix phy reset
Message-ID: <Z6vMrX2-rhE1r1E4@aurel32.net>
References: <20241230154218.044787220@linuxfoundation.org>
 <20241230154219.070199198@linuxfoundation.org>
 <Z6itgi4kAoNWi0y_@aurel32.net>
 <2025021128-untrimmed-city-0ead@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="f8+tZLrNsWWEuN1a"
Content-Disposition: inline
In-Reply-To: <2025021128-untrimmed-city-0ead@gregkh>
User-Agent: Mutt/2.2.13 (2024-03-09)


--f8+tZLrNsWWEuN1a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On 2025-02-11 11:29, Greg Kroah-Hartman wrote:
> On Sun, Feb 09, 2025 at 02:28:34PM +0100, Aurelien Jarno wrote:
> > On 2024-12-30 16:42, Greg Kroah-Hartman wrote:
> > > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > It probably comes a bit late, but this patch broke usb and pcie on
> > rk356x. The other commit from the same series, commit 8b9c12757f91
> > ("arm64: dts: rockchip: add reset-names for combphy on rk3568"), also
> > needs to be backported.
> 
> That commit does not apply, can you please provide a working backport
> for us to queue up?

That sounds strange, it applies fine against v6.12.13 here, and I do not
see any changes to the two files it modifies in queue-6.12.

Anyway please find a backport attached, i can also send it directly to
the list if you prefer.

Thanks
Aurelien

-- 
Aurelien Jarno                          GPG: 4096R/1DDD8C9B
aurelien@aurel32.net                     http://aurel32.net

--f8+tZLrNsWWEuN1a
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-arm64-dts-rockchip-add-reset-names-for-combphy-on-rk.patch"
Content-Transfer-Encoding: quoted-printable

=46rom e04594d6a86171593ede97987c9f99bfe51a74de Mon Sep 17 00:00:00 2001
=46rom: Chukun Pan <amadeus@jmu.edu.cn>
Date: Fri, 22 Nov 2024 15:30:05 +0800
Subject: [PATCH] arm64: dts: rockchip: add reset-names for combphy on rk3568

commit 8b9c12757f919157752646faf3821abf2b7d2a64 upstream.

The reset-names of combphy are missing, add it.

Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Fixes: fd3ac6e80497 ("dt-bindings: phy: rockchip: rk3588 has two reset line=
s")
Link: https://lore.kernel.org/r/20241122073006.99309-1-amadeus@jmu.edu.cn
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
---
 arch/arm64/boot/dts/rockchip/rk3568.dtsi | 1 +
 arch/arm64/boot/dts/rockchip/rk356x.dtsi | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568.dtsi b/arch/arm64/boot/dts=
/rockchip/rk3568.dtsi
index 0946310e8c124..6fd67ae271174 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
@@ -262,6 +262,7 @@ combphy0: phy@fe820000 {
 		assigned-clocks =3D <&pmucru CLK_PCIEPHY0_REF>;
 		assigned-clock-rates =3D <100000000>;
 		resets =3D <&cru SRST_PIPEPHY0>;
+		reset-names =3D "phy";
 		rockchip,pipe-grf =3D <&pipegrf>;
 		rockchip,pipe-phy-grf =3D <&pipe_phy_grf0>;
 		#phy-cells =3D <1>;
diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi b/arch/arm64/boot/dts=
/rockchip/rk356x.dtsi
index 0ee0ada6f0ab0..bc0f57a26c2ff 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
@@ -1762,6 +1762,7 @@ combphy1: phy@fe830000 {
 		assigned-clocks =3D <&pmucru CLK_PCIEPHY1_REF>;
 		assigned-clock-rates =3D <100000000>;
 		resets =3D <&cru SRST_PIPEPHY1>;
+		reset-names =3D "phy";
 		rockchip,pipe-grf =3D <&pipegrf>;
 		rockchip,pipe-phy-grf =3D <&pipe_phy_grf1>;
 		#phy-cells =3D <1>;
@@ -1778,6 +1779,7 @@ combphy2: phy@fe840000 {
 		assigned-clocks =3D <&pmucru CLK_PCIEPHY2_REF>;
 		assigned-clock-rates =3D <100000000>;
 		resets =3D <&cru SRST_PIPEPHY2>;
+		reset-names =3D "phy";
 		rockchip,pipe-grf =3D <&pipegrf>;
 		rockchip,pipe-phy-grf =3D <&pipe_phy_grf2>;
 		#phy-cells =3D <1>;
--=20
2.45.2


--f8+tZLrNsWWEuN1a--
