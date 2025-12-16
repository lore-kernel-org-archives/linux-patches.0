Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD2036C58F;
	Tue, 16 Dec 2025 12:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887448; cv=none; b=hO4j3xi+cbre49Y4wVjbA0CO9oKriPRfsc11tLGqT7+8M1h55FDrVKqc46JtM0nHSWWkv9+CRiCGlQqhTQah9/bLzYAGvakUdrZ7uTlrvY5kwq2Peihsw5vzHEVvkknYpAC9/wEHlamWEqMDt/PKB+SyPNDoy71PCsCvSeFJq60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887448; c=relaxed/simple;
	bh=ks4fZMqCmHHTyWm/UMo7/fXUKGwGV8v+7i0DXKeldqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDwRlj1K5HaXLNBjs5LizbVPepqYM9xRYbV3vcMgVk30QfIQkXhqqRa4JsHhpY4PXskxU41U18MH95WDse2mG7aiAcYLIZ4Z60XNzIiC6ktxaPXIyq1Piaag1ovX9Cc1ukUCReYnMn4aIMoAc74J2R/zXmfi+vi5PGvbe+7E9qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FosIubp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FosIubp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449FAC16AAE;
	Tue, 16 Dec 2025 12:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887448;
	bh=ks4fZMqCmHHTyWm/UMo7/fXUKGwGV8v+7i0DXKeldqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FosIubp+AicgLXpy1mYYKITk9zkLVR9GjRrRAofQrD8q8qmjkfmiNa4APtk6B6Mzu
	 QCt9GPgO8xJGgq/FexuBaBD9B3eUy4MtIfWrxB5a4T2xAtc6Ilu99Qteu4nHOy99LM
	 Gf7ePFDWxYJnsMX3h0al1sSLwRWMP8JTZYc0AY7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 206/614] ARM: dts: omap3: n900: Correct obsolete TWL4030 power compatible
Date: Tue, 16 Dec 2025 12:09:33 +0100
Message-ID: <20251216111408.840014884@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jihed Chaibi <jihed.chaibi.dev@gmail.com>

[ Upstream commit 3862123e9b56663c7a3e4a308e6e65bffe44f646 ]

The "ti,twl4030-power-n900" compatible string is obsolete and is not
supported by any in-kernel driver. Currently, the kernel falls back to
the second entry, "ti,twl4030-power-idle-osc-off", to bind a driver to
this node.

Make this fallback explicit by removing the obsolete board-specific
compatible. This preserves the existing functionality while making the
DTS compliant with the new, stricter 'ti,twl.yaml' binding.

Fixes: daebabd578647 ("mfd: twl4030-power: Fix PM idle pin configuration to not conflict with regulators")
Signed-off-by: Jihed Chaibi <jihed.chaibi.dev@gmail.com>
Link: https://lore.kernel.org/r/20250914192516.164629-4-jihed.chaibi.dev@gmail.com
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ti/omap/omap3-n900.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/ti/omap/omap3-n900.dts b/arch/arm/boot/dts/ti/omap/omap3-n900.dts
index c50ca572d1b9b..7db73d9bed9e4 100644
--- a/arch/arm/boot/dts/ti/omap/omap3-n900.dts
+++ b/arch/arm/boot/dts/ti/omap/omap3-n900.dts
@@ -508,7 +508,7 @@ twl_audio: audio {
 	};
 
 	twl_power: power {
-		compatible = "ti,twl4030-power-n900", "ti,twl4030-power-idle-osc-off";
+		compatible = "ti,twl4030-power-idle-osc-off";
 		ti,use_poweroff;
 	};
 };
-- 
2.51.0



