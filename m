Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F7D35AC18
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302685; cv=none; b=SNQCaa9ZrksIYCWQQBjQg56RjEPB6+cHBg2ELifsGLg67urwwqfuIQB/O3w6mEXdZKzlB4l0OyUZIcqpzfY1AH2gxeIz4Qp2or9E5yGUQ7T22iqR01dPscfRLObdrzR4vx0vmm8EiXxxstnvJNu4BTHJ1fFMWt3mHn/QtnO+ZEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302685; c=relaxed/simple;
	bh=fJAUufCRKcleQ2idj0zudljddEuuneFi/X3xaB3hJ/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OcS9g3C1EWmNkbh5IZD33RvKTYY9/eM+5RVEtmsd8FocL343L5jn3MAybHH7Nqx4b2vVOe2fQWoa49BwFCk8hGy+P6otWVR4WIf3UtpgWQTP5qzL19o9B67mRRLNBijmkX7g6iIXZm/7y+ZLCaJHQqC5gO73utqJsq3Mqm9Lx1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LmLT+VOu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LmLT+VOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3AA9C19423;
	Sat, 28 Feb 2026 18:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302685;
	bh=fJAUufCRKcleQ2idj0zudljddEuuneFi/X3xaB3hJ/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LmLT+VOuvBTnOy4wONjsp8UQz14Ylvihpms2ftIXoZXiFNGQqqEm7RfF96ucsKxBp
	 B+S7E9RaI/tuhRHTojQ2iJoyZsSkm2i6DKTCQ3D/AIALWq0UAtvu8A892g7ReySnHV
	 0VVNhKT2XUXc8j0kzcTRu7j7whJZIut8EoGO/BgtVw1ioCIixTjMFVKiMHzYo7I0FY
	 1lXNDfiqRG6COnKsl2BPQ7zAB9uNnWu/QfU2EW6TX+UszS2fV6wV4lnKPkm05tO0LW
	 mp7a3hWM3JiN9nHaAYHpP7ARjFGlTcwCtJQqgJI/LILfwXRaedaLF+p/yyH3w8roZU
	 UgYzUTgbV6xXQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/147] ARM: dts: allwinner: sun5i-a13-utoo-p66: delete "power-gpios" property
Date: Sat, 28 Feb 2026 13:15:45 -0500
Message-ID: <20260228181736.1605592-37-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chen-Yu Tsai <wens@kernel.org>

[ Upstream commit 0b2761eb1287bd9f62367cccf6626eb3107cef6f ]

The P66's device tree includes the reference design dtsi files, which
defines a node and properties for the touchpanel in the common design.
The P66 dts file then overrides all the properties to match its own
design, but as the touchpanel model is different, a different schema
is matched. This other schema uses a different name for the GPIO.

The original submission added the correct GPIO property, but did not
delete the one inherited from the reference design, causing validation
errors.

Explicitly delete the incorrect GPIO property.

Fixes: 2a53aff27236 ("ARM: dts: sun5i: Enable touchscreen on Utoo P66")
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20251225103616.3203473-4-wens@kernel.org
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun5i-a13-utoo-p66.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/sun5i-a13-utoo-p66.dts b/arch/arm/boot/dts/sun5i-a13-utoo-p66.dts
index be486d28d04fa..428cab5a0e906 100644
--- a/arch/arm/boot/dts/sun5i-a13-utoo-p66.dts
+++ b/arch/arm/boot/dts/sun5i-a13-utoo-p66.dts
@@ -102,6 +102,7 @@ &touchscreen {
 	/* The P66 uses a different EINT then the reference design */
 	interrupts = <6 9 IRQ_TYPE_EDGE_FALLING>; /* EINT9 (PG9) */
 	/* The icn8318 binding expects wake-gpios instead of power-gpios */
+	/delete-property/ power-gpios;
 	wake-gpios = <&pio 1 3 GPIO_ACTIVE_HIGH>; /* PB3 */
 	touchscreen-size-x = <800>;
 	touchscreen-size-y = <480>;
-- 
2.51.0

