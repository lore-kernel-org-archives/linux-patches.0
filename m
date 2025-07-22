Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82622EA163;
	Tue, 22 Jul 2025 14:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193312; cv=none; b=HABrsJyUfnbpeSq2LaIM+Jdn6aQ5NWlUFPNtxU+K44WLRf1N7jnd+UVM0fYps4qoWrpCrW4djgwDfXZANJOZhDH/h2YCuAxh27+dXzLNgG79kkmPdMHJVYfG2WmetEIIT2gst2ncyWHRoTtHCQfKK0hJ7JNkMiLOkwyW2vv+Zpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193312; c=relaxed/simple;
	bh=7R41QrnUHuxXiBCenTe/zWt9Ml/3v0G0JDhVIiVGnAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4KR56lsITq83GYH5QgUaViYeiV4Fxst2kPDnJNJTSgA8iIQ4Xbc6SdG8AI8S3dxZkKEamRq10tBkCgC7Dltw+Yb7+8fqe9wC344uzRs1qmuyQ8zwEqBIa6x7ChDoVZZTPYyGzqByp73pu9ttvLIV9Qh+WykbWKjc3VVj1Gt/Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNQfgyOR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNQfgyOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBCEC4CEEB;
	Tue, 22 Jul 2025 14:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193312;
	bh=7R41QrnUHuxXiBCenTe/zWt9Ml/3v0G0JDhVIiVGnAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNQfgyOR0pXOVlWloWDj5Q54YVfL/CiUpJNHnNfeKO7rr99ftgW6/HmqYzdph4vMc
	 uCgNvrHMaJwL4xl3ovZuE2Jp+QCge9OrkrJNzM5hCxVO6uiGbYV+OQYkEIPcHg90aA
	 E7AySAt4L6VnrRYYtdCDXFzLkcRozR/5aob9DF7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.15 054/187] arm64: dts: imx8mp-venice-gw73xx: fix TPM SPI frequency
Date: Tue, 22 Jul 2025 15:43:44 +0200
Message-ID: <20250722134347.774427482@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Harvey <tharvey@gateworks.com>

commit 1fc02c2086003c5fdaa99cde49a987992ff1aae4 upstream.

The IMX8MPDS Table 37 [1] shows that the max SPI master read frequency
depends on the pins the interface is muxed behind with ECSPI2
muxed behind ECSPI2 supporting up to 25MHz.

Adjust the spi-max-frequency based on these findings.

[1] https://www.nxp.com/webapp/Download?colCode=IMX8MPIEC

Fixes: 2b3ab9d81ab4 ("arm64: dts: imx8mp-venice-gw73xx: add TPM device")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-venice-gw73xx.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mp-venice-gw73xx.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-venice-gw73xx.dtsi
@@ -122,7 +122,7 @@
 	tpm@1 {
 		compatible = "atmel,attpm20p", "tcg,tpm_tis-spi";
 		reg = <0x1>;
-		spi-max-frequency = <36000000>;
+		spi-max-frequency = <25000000>;
 	};
 };
 


