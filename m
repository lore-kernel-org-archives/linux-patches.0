Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C60208C2
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7JPCpHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88173C433C8;
	Tue, 31 Oct 2023 17:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774353;
	bh=tmBHz4lOrqlaSCaevJD8m8A+E+lcTSa3zQix3chgSGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7JPCpHXD/g3L0nTtmiM4iIACNT7zIXCghN9w+i4w+GVUr/xJMXiYHBvPnxxKknIV
	 9KhzvQ8eevuqZPbjPpV9qAsemO5P/NjaRaJt3bvuFBeMluq6H5MdUZzKhtLdpv/KeQ
	 wcVDuYWGc31plSk8NvMU5yzHH10/0TvLuk5sZhyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ermin Sunj <ermin.sunj@theobroma-systems.com>,
	Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.5 017/112] arm64: dts: rockchip: use codec as clock master on px30-ringneck-haikou
Date: Tue, 31 Oct 2023 18:00:18 +0100
Message-ID: <20231031165901.852765272@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ermin Sunj <ermin.sunj@theobroma-systems.com>

commit 84fa1865edbb3800f3344e2a5bc73c187adf42d0 upstream.

If the codec is not the clock master, the MCLK needs to be
synchronous to both I2S_SCL ans I2S_LRCLK. We do not have that
on Haikou, causing distorted audio.

Before:

 Running an audio test script on Ringneck, 1kHz
 output sine wave is not stable and shows distortion.

After:

 10h audio test script loop failed only one time.
 That is 0.00014% failure rate.

Cc: stable@vger.kernel.org
Fixes: c484cf93f61b ("arm64: dts: rockchip: add PX30-µQ7 (Ringneck) SoM with Haikou baseboard")
Signed-off-by: Ermin Sunj <ermin.sunj@theobroma-systems.com>
Signed-off-by: Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>
Link: https://lore.kernel.org/r/20230907151725.198347-1-jakob.unterwurzacher@theobroma-systems.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/px30-ringneck-haikou.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/px30-ringneck-haikou.dts b/arch/arm64/boot/dts/rockchip/px30-ringneck-haikou.dts
index 08a3ad3e7ae9..8792fae50257 100644
--- a/arch/arm64/boot/dts/rockchip/px30-ringneck-haikou.dts
+++ b/arch/arm64/boot/dts/rockchip/px30-ringneck-haikou.dts
@@ -68,15 +68,15 @@ i2s0-sound {
 		simple-audio-card,format = "i2s";
 		simple-audio-card,name = "Haikou,I2S-codec";
 		simple-audio-card,mclk-fs = <512>;
+		simple-audio-card,frame-master = <&sgtl5000_codec>;
+		simple-audio-card,bitclock-master = <&sgtl5000_codec>;
 
-		simple-audio-card,codec {
+		sgtl5000_codec: simple-audio-card,codec {
 			clocks = <&sgtl5000_clk>;
 			sound-dai = <&sgtl5000>;
 		};
 
 		simple-audio-card,cpu {
-			bitclock-master;
-			frame-master;
 			sound-dai = <&i2s0_8ch>;
 		};
 	};
-- 
2.42.0



