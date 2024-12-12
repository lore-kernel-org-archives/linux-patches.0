Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE91215762;
	Thu, 12 Dec 2024 16:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020123; cv=none; b=YniVS6yQqvEYYgUPwmt3un1r2enGXBMv0pzBfqlqznswruGXQI2tbHyjwTQESJVCOA2wY7mvimdaMh0+faILlj66hK5derMScc3bL+JSPpQCgPW/W4Mkm60o3n7WfB9MsYzwFL+eIA4pIHmVrj/TkFaQGBh9aF9RcfMHruJfXvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020123; c=relaxed/simple;
	bh=6g2n7ij6fIfboOYcJTlqU14qImLuz9ZPiqCeFZhNbbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nt8mGCWzGoySYgNSe/6S8JssOe8R8m1gaEgoUBX17jaByK5/A1EaiZiCqzn96zXMS7TtsvC8lo+2orrwgVDbZrh55qDNvd6buf5Wcx5zUNYJCljMzIWCNcjruKfAybbCEwAyl3r2bJ0SY1y31VatgCLmC1zT/evPjxFCHO5wSfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMFOPuVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMFOPuVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF5AC4CECE;
	Thu, 12 Dec 2024 16:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020123;
	bh=6g2n7ij6fIfboOYcJTlqU14qImLuz9ZPiqCeFZhNbbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMFOPuVq05BSXcscXM5Y/M0UvmNdSvSwUodIRVLGNlZHk157UTUqtw4rEW01dMPsv
	 nxV6tZ8QIZkKGlm4g/Z61lhC6csz5VWzNQyfCUUB+tOA/eEZtf413sIoEgjZlnL1Q1
	 d/awYF5+eV/r51kzkcMwi/VWQRuKBDtZO1y09SaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <koichiro.den@canonical.com>,
	Chen-Yu Tsai <wenst@chromium.org>
Subject: [PATCH 6.1 356/772] Revert "arm64: dts: mediatek: mt8195-cherry: Mark USB 3.0 on xhci1 as disabled"
Date: Thu, 12 Dec 2024 15:55:01 +0100
Message-ID: <20241212144404.620563684@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

This reverts commit edca00ad79aa1dfd1b88ace1df1e9dfa21a3026f.

The hunk was applied to the wrong device node when the commit was
backported to the 6.1 stable branch.

Revert it to re-do the backport correctly.

Reported-by: Koichiro Den <koichiro.den@canonical.com>
Closes: https://lore.kernel.org/stable/6itvivhxbjlpky5hn6x2hmc3kzz4regcvmsk226t6ippjad7yk@26xug5lrdqdw/
Fixes: edca00ad79aa ("arm64: dts: mediatek: mt8195-cherry: Mark USB 3.0 on xhci1 as disabled")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
@@ -922,7 +922,6 @@
 	usb2-lpm-disable;
 	vusb33-supply = <&mt6359_vusb_ldo_reg>;
 	vbus-supply = <&usb_vbus>;
-	mediatek,u3p-dis-msk = <1>;
 };
 
 #include <arm/cros-ec-keyboard.dtsi>


