Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976532E6127;
	Fri, 20 Jun 2025 18:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750443928; cv=none; b=gh02E83l4OzdyTnYp3Em5UgfQB5tBY38mKAlOZGdV9zw2KImFZO+wLwXASG4ocWb8y2UoyHJZuOrOzoBZdy9UIBCYlO8uNi4dvfQB1tnHjZIELZQTsGkSWg1UYqew005hGqDzgx0KcrSvY4f4JPdJkYUVgDnK7bwOOjObapUaB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750443928; c=relaxed/simple;
	bh=wJ1/5xGnbBYa9//GKBplYzMZXFE09kIONiXVBQVPuuE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=KY6/Odgii167Nm0lXjrHhV3/WiiRliVC1EeP7fthEGojmGq1Y/kGRN1J/zJbyWb3ByL28y9R/36wXl1qdCmWVEBPFFcZ3uoJHOec7KsqrkY/5n4KnLcAlrrmAUPVgBxvxmRIYA5ccKP89iMA8x1ih31Qlj6sjMiLRYLHa3HOZHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NGJ9o6Gz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NGJ9o6Gz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156D1C4CEE3;
	Fri, 20 Jun 2025 18:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750443928;
	bh=wJ1/5xGnbBYa9//GKBplYzMZXFE09kIONiXVBQVPuuE=;
	h=From:Date:Subject:To:Cc:From;
	b=NGJ9o6GzUoyabGg1d6q7m11bzHcvxRXNZ7xdRR9ePphH60jug5P6+ueVzJY51nH4x
	 nGpNalm49XDQzWSUk7A28JeoSosM57yFUzcCG49enTMORMOUO1MdzfK0RQQuD5J6EY
	 YuKizT2Iggq067WGcXayTjUeJGXHnPTcLM1cQ3YT06K63xw7Y3Ist1hY0jdbLCeXe9
	 byRT9N2NWuKGdylvGZ0u9wnLQu6zktYnruTqE46yoo3U0DfG7q6BfZ6je4DYBKYFEG
	 7bodjp7PM3FuidIP6yRi7T4fH9hlQ1z8PWc+YF4OxlO1PBDPWSG+XcdIfsnsFwMLxu
	 oaRnQ8T9+KbAA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 20 Jun 2025 11:25:22 -0700
Subject: [PATCH] mmc: rtsx_usb_sdmmc: Fix clang -Wimplicit-fallthrough in
 sd_set_power_mode()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250620-mmc-rtsx-usb-sdmmc-fix-clang-implicit-fallthrough-v1-1-4031d11159c0@kernel.org>
X-B4-Tracking: v=1; b=H4sIAJGnVWgC/x3NSwqDMBAG4KvIrDuQpqZCr1K6iHE0A4nKTBRBv
 HvTLj/4HycoCZPCqzlBaGflZa643xoI0c8TIQ/VYI115mkN5hxQih64aY86/DjygSHVMHJeEwc
 uOPqUSpRlmyJ2D+td1zrX9gbq7ipUG//P9+e6vutbygiDAAAA
X-Change-ID: 20250620-mmc-rtsx-usb-sdmmc-fix-clang-implicit-fallthrough-732a574554b0
To: Ulf Hansson <ulf.hansson@linaro.org>, Ricky Wu <ricky_wu@realtek.com>
Cc: linux-mmc@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1696; i=nathan@kernel.org;
 h=from:subject:message-id; bh=wJ1/5xGnbBYa9//GKBplYzMZXFE09kIONiXVBQVPuuE=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBmhy6clJt5fJKP1/E/e00NTXwi0nryT5rL5gtnzkjjv+
 T8PPldZ3FHKwiDGxSArpshS/Vj1uKHhnLOMN05NgpnDygQyhIGLUwAmku3D8E+J66hzz8TeeA2R
 gsaDrq4LLuaFX+82ee+V8vBF3EWmphMMf/g3tsw0/yW0M6j014Z7Vnu1Zp5a9CjFQWQWy79t6Zy
 m6fwA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR=y):

  drivers/mmc/host/rtsx_usb_sdmmc.c:1042:2: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
   1042 |         case MMC_POWER_UNDEFINED:
        |         ^
  drivers/mmc/host/rtsx_usb_sdmmc.c:1042:2: note: insert 'break;' to avoid fall-through
   1042 |         case MMC_POWER_UNDEFINED:
        |         ^
        |         break;

Clang is a little more pedantic than GCC, which does not warn when
falling through to a case that is just break or return. Clang's version
is more in line with the kernel's own stance in deprecated.rst, which
states that all switch/case blocks must end in either break,
fallthrough, continue, goto, or return. Add the missing break to silence
the warning.

Fixes: 2c3809bd6f65 ("mmc: rtsx_usb_sdmmc: Add 74 clocks in poweron flow")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/mmc/host/rtsx_usb_sdmmc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mmc/host/rtsx_usb_sdmmc.c b/drivers/mmc/host/rtsx_usb_sdmmc.c
index 591d37206654..c5f6b9df066b 100644
--- a/drivers/mmc/host/rtsx_usb_sdmmc.c
+++ b/drivers/mmc/host/rtsx_usb_sdmmc.c
@@ -1039,6 +1039,8 @@ static void sd_set_power_mode(struct rtsx_usb_sdmmc *host,
 	case MMC_POWER_ON:
 		/* stop to send the clock signals */
 		rtsx_usb_write_register(ucr, SD_BUS_STAT, SD_CLK_TOGGLE_EN, 0x00);
+		break;
+
 	case MMC_POWER_UNDEFINED:
 		break;
 

---
base-commit: f5c755ef810009b85350884c483705bd04365370
change-id: 20250620-mmc-rtsx-usb-sdmmc-fix-clang-implicit-fallthrough-732a574554b0

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

