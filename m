Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD9A4EB853;
	Wed, 23 Sep 2026 14:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172617; cv=none; b=QCNMrPXZMHC0+NIMAUMPHA91Y/2EDRZSb4tZDIe+fce5zztQsnStaNUx3XkMSLhBaxYNtkaqApECDM5T1yqPGxW30sAkpEcSDPOu7rsk71pfa7yJnkJ01nuWh5XRzxwZx/Uac9JE8jERdfxJsdSjvdDYXdxO1gbejvqqjeW6MIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172617; c=relaxed/simple;
	bh=ylWFkkdt+bOOEnDhhfQB4yz7ht2e06EtxZRZJUeAn+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcwLY6yWh896caN5FgsS80GrXE39ur276lwe3j1hP1JEhRBe2zHQPghL42qEPx31R1sB51lc+1s7L10Mwi0/IaUuU+CbsnRQNYuVtYJ79V47Xu5ISGB31347Hjkmo4YKkuDo5ckRJZi9/9+daSXlzi9PFyqkh4+o1wY8M2fnMEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0cUMvD7g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0cUMvD7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926C71F000FF;
	Wed, 23 Sep 2026 14:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172616;
	bh=SGsG5KpzffhBAhyVdaZHbgVY4dogEVifuDSzHKEtnx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0cUMvD7gnUX9hlcOL4uVbXRMbNjwB/EhposG67Gw8mZ1Ze9Ny8E+8JVL1nKslx2E2
	 yJ4DtDI633MP4tPUh87fQQEjWC945nv4Dxr5O6UOmGNQUtoIzA5K6RYj6pTRiA6qGD
	 LQMeTAzzJoILE03iuiTgB7BrkRG8OtVFWMfBtCEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tanure <tanure@linux.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 012/438] arm64: dts: amlogic: t7: khadas-vim4: allow the SD card to be power cycled
Date: Wed, 23 Sep 2026 16:00:33 +0200
Message-ID: <20260923140645.092328177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Tanure <tanure@linux.com>

[ Upstream commit c793a084ab3088744516aef437b4239d0d98623f ]

SD cards start at 3.3V and switch to 1.8V to reach UHS-I speeds. Some
cards refuse that switch, and the SD specification says the only way
to recover is to power the card off and start again.

SD_3V3 is marked regulator-always-on, so the supply never goes off,
the card stays stuck half way through the switch, and the MMC core
retries forever:

  mmc1: error -95 whilst initialising SD card

Drop regulator-always-on. regulator-boot-on still turns the supply on
at boot, and a card that refuses the switch now falls back to high
speed instead of failing to initialise.

Fixes: 8c45bf9ae4ef ("arm64: dts: amlogic: t7: khadas-vim4: Add power regulators")
Signed-off-by: Lucas Tanure <tanure@linux.com>
Assisted-by: Claude:claude-fable-5
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260823115335.102219-3-tanure@linux.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts b/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts
index 75d81ad6830df..c94afaaf8826e 100644
--- a/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts
+++ b/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts
@@ -71,7 +71,6 @@ sd_3v3: regulator-sdcard-3v3 {
 		vin-supply = <&vddao_3v3>;
 		gpio = <&gpio GPIOD_11 GPIO_ACTIVE_LOW>;
 		regulator-boot-on;
-		regulator-always-on;
 	};
 
 	sdio_pwrseq: sdio-pwrseq {
-- 
2.53.0



