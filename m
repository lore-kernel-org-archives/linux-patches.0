Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D73154BF5;
	Fri,  6 Dec 2024 15:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498026; cv=none; b=MeRzEiXZzjbeAMwDU704T45hmLNopJ86um4OlqhX6l2h1bj/U79dm3GNCtF968GQwjDRF3LtUBqKQcSoiH359YKkfzu/BAMsickeXIp130cW1e0S4wXRrwC81cgu2WKERT3LXo4bgnzBNB6MHUX+XZCaxACmVcdW8/ozyFEOJks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498026; c=relaxed/simple;
	bh=oB4HdyBAhu9+NLhTPd1jW8BhmfymcNR+dvA14Q1nC4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNJ/3S0PJKxSZv4DWu4Qyo/9vdRVLDQ01lnRkm+DqL4kuuwmgIv0Dmu5mpMgRRU7odkCyCa6IVrioQCQfv8FZWDcY51nL2iyHvZIKvwz2cALbNenhr12S1thcTUx8FwvFpXUPaBTC4yDFYaSWKMr6YYp0OTxZxqupJF/wiaoPwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dA0AooWO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dA0AooWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DBEC4CEDC;
	Fri,  6 Dec 2024 15:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498026;
	bh=oB4HdyBAhu9+NLhTPd1jW8BhmfymcNR+dvA14Q1nC4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dA0AooWOnfJ0YL3M869FkNa+WGUVqxZ7Dpxx5ZSuDjbS66qjcmSn0jZZIuFC8QgS9
	 Tl601m+QrYo6ZuzMGIEWAbd/gyaAogy50Siug0PSZm0KTM4FxiSzug+nzxvr9q1lMW
	 CThjpmEX2jhsqulXAJivaxWyIIkmgO3w1R84aqGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <koichiro.den@canonical.com>,
	Chen-Yu Tsai <wenst@chromium.org>
Subject: [PATCH 6.6 465/676] Revert "arm64: dts: mediatek: mt8195-cherry: Mark USB 3.0 on xhci1 as disabled"
Date: Fri,  6 Dec 2024 15:34:44 +0100
Message-ID: <20241206143711.530900550@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

This reverts commit 090386dbedbc2f099c44a0136eb8eb8713930072.

The hunk was applied to the wrong device node when the commit was
backported to the 6.6 stable branch.

Revert it to re-do the backport correctly.

Reported-by: Koichiro Den <koichiro.den@canonical.com>
Closes: https://lore.kernel.org/stable/6itvivhxbjlpky5hn6x2hmc3kzz4regcvmsk226t6ippjad7yk@26xug5lrdqdw/
Fixes: 090386dbedbc ("arm64: dts: mediatek: mt8195-cherry: Mark USB 3.0 on xhci1 as disabled")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
@@ -1312,7 +1312,6 @@
 	usb2-lpm-disable;
 	vusb33-supply = <&mt6359_vusb_ldo_reg>;
 	vbus-supply = <&usb_vbus>;
-	mediatek,u3p-dis-msk = <1>;
 };
 
 #include <arm/cros-ec-keyboard.dtsi>


