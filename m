Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18ACC238C3A;
	Thu,  9 Oct 2025 16:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025653; cv=none; b=MCzC8rEH3mwaXEsSwsFTad+Ym5kbfEjk3wT6k21BuQqyKFXlGPEvo8BrpKyTUE7NjK46nnNnoOQF1B/JflxJvT2mobbAv+4cl10i9JAHArNPB+dp/WD8ljsUPQVFebfLbRCPF8uRATSToW08/dfo9HWhQ2KWEksxTDd3BQ8kPkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025653; c=relaxed/simple;
	bh=MVoBzAEYlPRnNMLBLiTkWbNSSGr6diM4mluzmcJguo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tVTKy9aMQJqc2huYEKavrGvE6yC8jT9CaafnLTXfnWrI8rew7IB0+JX/mRNtmoNnS3E1NFNiXDPVeFv3n6b9L9tOzLLOmLrw3RL154ra5GXFxxiv2j69Sf147AsdZDb7FC887XB773lI43V1Bi4Ze4tqfqcgRthN9cXfG9jBHnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ltamw5L9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ltamw5L9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB749C4CEF7;
	Thu,  9 Oct 2025 16:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025653;
	bh=MVoBzAEYlPRnNMLBLiTkWbNSSGr6diM4mluzmcJguo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltamw5L9ec+p54tglftuCnNWQlnagdgol6lXlxSYFDyyIqYGHhTQEhj1C2HKBqgjK
	 wZlvyElrTkbR5geZCUCMwME5fN47xU2+3/12vuNRryiG1aqh+iA4aDVC3p91UVQ+Fs
	 6aQxRXhex46jSiD4QKZ3ou2TnX6DX+1zIRNtn2plZnH1tHeJN/J56uojsznCWjbL2p
	 akBbTAfXvGXGhlqQE0mwUfnXOdy+m1yAS86s58dxTldzBaLUQuH7jTH+EWzBsqLc3l
	 kT8UqjFGL5Fzu2/LodtULJ594JJ/4c0r7cVQQozsbYdUbHZWPCgQaiKqKRES75+/Ij
	 jLRKuOzm2ZVNw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Jonas=20Schw=C3=B6bel?= <jonasschwoebel@yahoo.de>,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	thierry.reding@gmail.com,
	jonathanh@nvidia.com,
	linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] ARM: tegra: p880: set correct touchscreen clipping
Date: Thu,  9 Oct 2025 11:56:02 -0400
Message-ID: <20251009155752.773732-96-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Transfer-Encoding: 8bit

From: Jonas Schwöbel <jonasschwoebel@yahoo.de>

[ Upstream commit b49a73a08100ab139e07cfa7ca36e9b15787d0ab ]

Existing touchscreen clipping is too small and causes problems with
touchscreen accuracy.

Signed-off-by: Jonas Schwöbel <jonasschwoebel@yahoo.de>
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – raising the Synaptics clip limits stops the driver from clipping
real touch coordinates on the LG P880 and restores edge accuracy.

- **Bug impact**: The DTS currently caps the touchscreen to 1110×1973
  (`arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts:111-112`), below what
  the Synaptics S3203B actually reports, so touches near the screen
  edges get clamped, matching the commit message’s “accuracy” complaint.
- **How the fix helps**: The rmi4 stack takes these values to bound
  `sensor->max_x/y` (`drivers/input/rmi4/rmi_2d_sensor.c:147-154`);
  increasing them to 1440×2560 lets the driver expose the full hardware
  range while still clamping against the real controller limits,
  eliminating the compression.
- **Historical context**: The limiting values came from the original
  board bring-up (`ea5e97e9ce0466`), and no later commits touch this
  area; P895 already uses larger limits
  (`arch/arm/boot/dts/nvidia/tegra30-lg-p895.dts:109-110`), so the new
  numbers align with existing practice.
- **Risk assessment**: Change is confined to two DTS constants; no
  bindings or drivers change, and higher clip limits cannot harm because
  the driver already min()s them with the hardware-reported maxima. No
  regressions expected beyond the targeted board.
- **Backport fit**: Clear user-visible bug fix, self-contained, no
  functional dependencies, and consistent with stable policy for
  correcting board descriptions.

Suggested follow-up: Once merged, verify on-device that touches now
reach the physical bezel across both axes.

 arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts b/arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts
index 2f7754fd42a16..c6ef0a20c19f3 100644
--- a/arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts
+++ b/arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts
@@ -108,8 +108,8 @@ sub-mic-ldo {
 	i2c@7000c400 {
 		touchscreen@20 {
 			rmi4-f11@11 {
-				syna,clip-x-high = <1110>;
-				syna,clip-y-high = <1973>;
+				syna,clip-x-high = <1440>;
+				syna,clip-y-high = <2560>;
 
 				touchscreen-inverted-y;
 			};
-- 
2.51.0

