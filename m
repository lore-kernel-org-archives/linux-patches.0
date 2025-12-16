Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E945341645;
	Tue, 16 Dec 2025 11:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884198; cv=none; b=qUR+ZSAht4074BPDQVvpGtfiJo7YJSQaQGDojGyBAoa2ffpdaPq9E8P18qBbf+nOw0EWmOVTpyLCB6hrpa8jamaPrT3J96+RT1SOgxSGezpGdfp2+iMW/4NwynuFZ/94gCfnQb95+PL1b/HAUdecpTVpMPouv8YuvV5L/mZrvuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884198; c=relaxed/simple;
	bh=uCx3f8in0jRKsi3DNtV4woD17VLeFpY9gGX6n4Y0mwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJhxZBfrBd35U2aite5kSUMpBE05u6iIglFqlm3/ZpEf66UWCEg14h9mOubp8iICVRt7IUcKQbvCJHS+EdViSws7veQ66tboVhVrflVBHCIBAdviIoxsk5bI8OT9HypskniK8t887EmZxIGl1ggvz0TLbs/WVia/BvgvztLE1ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Dkhfrck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Dkhfrck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EC1C4CEF1;
	Tue, 16 Dec 2025 11:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884198;
	bh=uCx3f8in0jRKsi3DNtV4woD17VLeFpY9gGX6n4Y0mwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Dkhfrck0GbehzzuhdLYcFdf8KcX210m9+feo8i4N8K7OjgbK/n9k2CmIprRhLFsP
	 5W4mMoGrTQJOVPdqpkiqS1FgdG2KCvfOBpWQwxppLhNyljkjdjAsnvg5YORfYTd4qt
	 LUkDbAzlFZ+N9xYPXJ3UYaNQqvIv/XxPkdKmCX0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 121/354] ARM: dts: omap3: n900: Correct obsolete TWL4030 power compatible
Date: Tue, 16 Dec 2025 12:11:28 +0100
Message-ID: <20251216111325.308135539@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index 4bde3342bb959..598a4885094d3 100644
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



