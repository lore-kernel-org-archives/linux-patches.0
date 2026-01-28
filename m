Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CAB2F3618;
	Wed, 28 Jan 2026 15:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615123; cv=none; b=M9ETqK2CJZlHL7WJQITcIg4ZDtPxQEKct56JAUSmr5WkHQSrWDlZGdCijVEZJUGSfq+ZJXyGKvXEUNuKGCyOcR3FhAVodLHxPyYqrkRHgNA0qRQeOwssBZB7dlLAwFMvzn4Y6HG/eDQDc+HCLWaefJh/Y/Y5s8x2B/lrAN5lc9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615123; c=relaxed/simple;
	bh=UWVwbfB1f+rfn2L8QFPTihKFppJeLq4YQmGfRh6KN5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ept/o6oWfchyejHc9hzPMT16pGQtlZFCLWOFpjPvmzZSycJh27N2ZXXb0DBKqKsYFo7OjVKXZcLTOdp0EYjBkvZl84tR+LN/StOB+xhQdzktp+yStLMfNRIeO51yQ3jOgSxaD9aQZShvVSKjDdXO42iftZgChV43GnvmfyBFFQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zaN39HnJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zaN39HnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15CDC4CEF1;
	Wed, 28 Jan 2026 15:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615123;
	bh=UWVwbfB1f+rfn2L8QFPTihKFppJeLq4YQmGfRh6KN5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zaN39HnJBXEYYGkJft3TpP8AXyJurXkL7yEG8CgBEiWZgAqSqWsGtyxJEK7qoDt8u
	 o/E3KXgjwnH6kJZvsBk1ftrhJzexnCqUccYc+W2C321tSrFCaV6THSCw8nPjmxXMaJ
	 vcgMb6y1p9PPr+/Zh+FZdztdW2dFDT2qPS4rGTbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Jirman <megi@xff.cz>,
	Rudraksha Gupta <guptarud@gmail.com>,
	Pavel Machek <pavel@ucw.cz>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.12 053/169] arm64: dts: rockchip: Fix voltage threshold for volume keys for Pinephone Pro
Date: Wed, 28 Jan 2026 16:22:16 +0100
Message-ID: <20260128145335.923339393@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ondrej Jirman <megi@xff.cz>

commit 5497ffe305b2ea31ae62d4a311d7cabfb671f54a upstream.

Previously sometimes pressing the volume-down button would register as
a volume-up button. Match the thresholds as shown in the Pinephone Pro
schematic.

Tests:

~ $ evtest
    // Mashed the volume down ~100 times with varying intensity
    Event: time xxx, type 1 (EV_KEY), code 114 (KEY_VOLUMEDOWN), value 1
    Event: time xxx, type 1 (EV_KEY), code 114 (KEY_VOLUMEDOWN), value 0
    // Mashed the volume up ~100 times with varying intensity
    Event: time xxx, type 1 (EV_KEY), code 115 (KEY_VOLUMEUP), value 1
    Event: time xxx, type 1 (EV_KEY), code 115 (KEY_VOLUMEUP), value 0

Fixes: d3150ed53580 ("arm64: dts: rockchip: Add support for volume keys to rk3399-pinephone-pro")
Cc: stable@vger.kernel.org
Signed-off-by: Ondrej Jirman <megi@xff.cz>
Signed-off-by: Rudraksha Gupta <guptarud@gmail.com>
Reviewed-by: Pavel Machek <pavel@ucw.cz>
Link: https://patch.msgid.link/20251124-ppp_light_accel_mag_vol-down-v5-4-f9a10a0a50eb@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts
@@ -40,13 +40,13 @@
 		button-up {
 			label = "Volume Up";
 			linux,code = <KEY_VOLUMEUP>;
-			press-threshold-microvolt = <100000>;
+			press-threshold-microvolt = <2000>;
 		};
 
 		button-down {
 			label = "Volume Down";
 			linux,code = <KEY_VOLUMEDOWN>;
-			press-threshold-microvolt = <600000>;
+			press-threshold-microvolt = <300000>;
 		};
 	};
 


