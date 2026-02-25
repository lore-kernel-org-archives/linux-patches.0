Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFDE251793;
	Wed, 25 Feb 2026 01:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982998; cv=none; b=F0ev0nVW2jY4ZADTR5NU2mO6w9cVf+g2of/xEHiNXmyf9gaXpu31niJlIVuz/ec3LrPAtZMz+eyQIcUCwVcWkqNx7aGEtdAq1tsrGE88Ne9syRjwfpLWlAu0m20TQQ23TyMTa1t5yt5LJaQoA/FR8aaV6L6aZLcb/iMooP5KbU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982998; c=relaxed/simple;
	bh=WS5iJCRYFlL1Ca9i43PPfJ9pJCVkVljcoqUqxOkD1jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORzkOwsREOmlWACKFyT7KvgTP9rh2v3G0K3rTCvzdVivWerwMKklqPTmvgQxraaVvghH+r8uDgyiOcr2x4h01KcWY3te1/B1f4YbB/dEOalBm8rS6PzcqqNKPmbelhH7mPdZZhq6RDvu6AoKTVp2nt/HUKanAl7DLWRkQOPDvPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HC3lzpJT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HC3lzpJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3930C116D0;
	Wed, 25 Feb 2026 01:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982997;
	bh=WS5iJCRYFlL1Ca9i43PPfJ9pJCVkVljcoqUqxOkD1jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HC3lzpJTQrTtY70KgPJ8hznaevva0w3yPTQHa8XSmhSWux4WyMa6dOHNXUqcaiw+4
	 fPGCX9M466XzDZgeU5uXl3MZ0HXa5AnumsF8xxmgGzkpiq3jxuk4IUwujNoeQlvUq1
	 zcpsVsxxDMwMrtdKf8mH1XBlo2B7LFv4TkvhofGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Xie <nick@khadas.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 169/781] arm64: dts: amlogic: s4: assign mmc b clock to 24MHz
Date: Tue, 24 Feb 2026 17:14:38 -0800
Message-ID: <20260225012403.795442020@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 86124a8becb43eed3103f2459399daee8af2c99d ]

The amlogic MMC driver operate with the assumption that MMC clock
is configured to provide 24MHz. It uses this path for low
rates such as 400kHz.

This assumption did hold true until but it now, but it is apparently
not the case with s4. The clock has been reported to provide 1GHz
instead. This is most likely due to how the bootloader is using the MMC
clock on this platform.

Regardless of why the MMC clock rate is 1GHz, if the MMC driver expects
24MHz, the clock should be properly assigned, so assign it.

Reported-by: Nick Xie <nick@khadas.com>
Closes: https://lore.kernel.org/linux-amlogic/20260113011931.40424-1-nick@khadas.com/
Fixes: 3ab9d54b5d84 ("arm64: dts: amlogic: enable some device nodes for S4")
Tested-by: Nick Xie <nick@khadas.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260114-amlogic-s4-mmc-fixup-v3-1-a4d3e136b3f2@baylibre.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-s4.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
index 9d99ed2994dfa..f314f07062abe 100644
--- a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
@@ -838,6 +838,9 @@ sd: mmc@fe08a000 {
 			clock-names = "core", "clkin0", "clkin1";
 			resets = <&reset RESET_SD_EMMC_B>;
 			status = "disabled";
+
+			assigned-clocks = <&clkc_periphs CLKID_SD_EMMC_B>;
+			assigned-clock-rates = <24000000>;
 		};
 
 		emmc: mmc@fe08c000 {
-- 
2.51.0



