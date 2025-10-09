Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331A81C3306;
	Thu,  9 Oct 2025 16:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025618; cv=none; b=hXHldVYKVFSYMB5gsALmVuyuNG82sg1Zcjb5J8JtOi3jBKZyHh/KY/0uC1wJBl9p0uvCMwaAigzZkxL7P6SQPcQA6ZCObZPZULSrvVFmPKNOSCvdNKbTZfZD6eefMs7NrnIuO//EbmANq3THHHzifwGQ/ZfJwbXvolmUtlQMDwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025618; c=relaxed/simple;
	bh=lUqNOWkVStVFvNhRoMTl1bChPXBkXJIKJJfWe4tv+hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kITZkrPGY/nBQqyz9XBPJ+tSdwbcholX4J86u6XwEFLRO+S/S++5FA4tTqR9b/zpXZBnIAcPn32hjxD2XZomLEEf3+7Y6rqIsFk3AUn6H37CTAcVVfGzkfKxOgl6OMDeEfBTSZf6JmPvYcRrIrY54bt1ViIeoJ5DCwNer2hbOAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YJpvXp82; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YJpvXp82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3204C4CEE7;
	Thu,  9 Oct 2025 16:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025618;
	bh=lUqNOWkVStVFvNhRoMTl1bChPXBkXJIKJJfWe4tv+hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJpvXp82PcTLGHDYlCOFEsxQACE0uir5Fn3jIiypJaUh63k3xX0fjIdGIJA0eFfep
	 99IgluaqKcL/lAVTsfprLi+PINppSU0sOIW6hDpLnp6tT5baSTVVyyRF/OE0v8nZPf
	 11R3bedfEgpwz3Lm2AwtPaCJ3XeviqaaTQmF5kwfLT8DRv1DzKdnK47vmqS6on61Am
	 Njybmw+txAtrwQ4ZI4ePrqtrTIdRRrjAos0+cm1kvmezXEf80cqvU5X4Jxaq/q3DbR
	 wbZOSc17G38Xd7TU0wgkRkfBAFlGzEyXJWpMliiQ0UnxqC85G2HSdJirpFr6pK3f7q
	 LPnWmdE36e8zA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Svyatoslav Ryhel <clamor95@gmail.com>,
	Winona Schroeer-Smith <wolfizen@wolfizen.net>,
	Antoni Aloy Torrens <aaloytorrens@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	thierry.reding@gmail.com,
	jonathanh@nvidia.com,
	linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.6] ARM: tegra: transformer-20: add missing magnetometer interrupt
Date: Thu,  9 Oct 2025 11:55:43 -0400
Message-ID: <20251009155752.773732-77-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit cca41614d15ce2bbc2c661362d3eafe53c9990af ]

Add missing interrupt to magnetometer node.

Tested-by: Winona Schroeer-Smith <wolfizen@wolfizen.net> # ASUS SL101
Tested-by: Antoni Aloy Torrens <aaloytorrens@gmail.com> # ASUS TF101
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – wiring the AK8974’s data‑ready interrupt into the TF101 device
tree fixes a real functional gap with minimal risk.

- `arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts:503` gains the
  missing `interrupt-parent`/`interrupts` pair, finally describing the
  DRDY line that the hardware routes to GPIO N5; other Tegra20 boards
  with the same magnetometer already do this (see
  `arch/arm/boot/dts/nvidia/tegra20-acer-a500-picasso.dts:532`), so the
  change aligns the TF101 description with established practice.
- The AK8974 driver switches to an interrupt-driven path whenever
  `i2c->irq` is populated (`drivers/iio/magnetometer/ak8974.c:300`
  through `drivers/iio/magnetometer/ak8974.c:347`); without this
  property the TF101 falls back to a tight 6 ms polling loop
  (`drivers/iio/magnetometer/ak8974.c:350`–`361`), which is both power-
  inefficient and prone to `-ETIMEDOUT` errors under heavier sampling
  loads—exactly the kind of user-visible malfunction stable trees aim to
  eliminate.
- Because the patch only adds two DT properties, it is completely
  localized to this board, has no dependency on newer frameworks, keeps
  the ABI intact, and has already been validated on real ASUS TF101 and
  SL101 hardware (`Tested-by` tags in the commit).
- No conflicting pinmux or GPIO consumers were found in the TF101 tree,
  so backporting will not disturb other peripherals, and older stable
  kernels already ship the same driver behaviour—meaning the fix drops
  in cleanly.

Given the tangible reliability improvement for existing devices, the
tiny scope, and demonstrated hardware testing, this is a solid stable
backport candidate.

 arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts b/arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts
index 67764afeb0136..39008816fe5ee 100644
--- a/arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts
+++ b/arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts
@@ -502,6 +502,9 @@ magnetometer@e {
 			compatible = "asahi-kasei,ak8974";
 			reg = <0xe>;
 
+			interrupt-parent = <&gpio>;
+			interrupts = <TEGRA_GPIO(N, 5) IRQ_TYPE_EDGE_RISING>;
+
 			avdd-supply = <&vdd_3v3_sys>;
 			dvdd-supply = <&vdd_1v8_sys>;
 
-- 
2.51.0

