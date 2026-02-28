Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21214ADDA5;
	Sat, 28 Feb 2026 17:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301320; cv=none; b=WUejpzBomB167TbDpjEcOmNPZ8+qcquRLkVXbFLGKmKPcRPq9o2Mc1MBcYer0RRlhrAmi2uCcKvrnhie4/S21xTr8yVSnv8KMMkxgwqUkTd7M1SbSU2LpkU9wReOwkzHhU7OjZTZnjhzV3MJim5vfX0iOssYwEboHJpiMgC2FN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301320; c=relaxed/simple;
	bh=n0VniU4APJKLrJCnBIPdgoAwN0WnPU4AK3Ij7JCIl2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMuq7dItfPwIz5s9yqziwwN1XFS+Me175qZm/EiTmmtmhyp8PmGeqxJC7mo7uMwktCZrKxRYwmAomcopABttg4VE/H20GD9aHMt3MYtunl6YDw53SRP4i4VtE3BcrEx/XmOuRYmeX4tX1xk/jeAts+O9DDOk8UnD36RdrlRadF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JhopiDjW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JhopiDjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C084C116D0;
	Sat, 28 Feb 2026 17:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301319;
	bh=n0VniU4APJKLrJCnBIPdgoAwN0WnPU4AK3Ij7JCIl2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JhopiDjW8YHbEr7yiefDMqnNWffytPK1GErHDGY8VbiJ+nQY3rEiiPfp/DzGa1b0f
	 QCNbI9NYv9ZXxjPu8nsOfr1HTQP0cz89yO7m0QfzoH0fQ7cdfWAgirz3Lh1lylE3R2
	 ia3FHG+5GQCTxOYlFyhSQHf/HP5OMFVq03isH8W6F3XKdjoK2DFG69BcJJsgJC7e+/
	 81xgYnZnysX/rSQczl3VuDrm2B7XNqX3FcB3Bbf93VbyCos2R81JvV5onjGjMBq/ic
	 G/qyn54opkgNS2SESyAVgSkkIioZIPdyhO7L/12zi7tdYJNnu7ueAQWMstyN5imkCh
	 LYYLKfTuzafHw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Janne Grunau <j@jannau.net>,
	stable@vger.kernel.org,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 506/752] arm64: dts: apple: t8112-j473: Keep the HDMI port powered on
Date: Sat, 28 Feb 2026 12:43:37 -0500
Message-ID: <20260228174750.1542406-506-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Janne Grunau <j@jannau.net>

[ Upstream commit 3e4e729325131fe6f7473a0673f7d8cdde53f5a0 ]

Add the display controller and DPTX phy power-domains to the framebuffer
node to keep the framebuffer and display out working after device probing
finished.
The OS has more control about the display pipeline used for the HDMI
output on M2 based devices. The HDMI output is driven by an integrated
DisplayPort to HDMI converter (Parade PS190). The DPTX phy is now
controlled by the OS and no longer by firmware running on the display
co-processor. This allows using the second display controller on the
second USB type-c port or tunneling 2 DisplayPort connections over
USB4/Thunderbolt.
The m1n1 bootloader uses the second display controller to drive the HDMI
output. Adjust for this difference compared to the notebooks as well.

Fixes: 2d5ce3fbef32 ("arm64: dts: apple: t8112: Initial t8112 (M2) device trees")
Cc: stable@vger.kernel.org
Signed-off-by: Janne Grunau <j@jannau.net>
Link: https://patch.msgid.link/20260108-apple-dt-pmgr-fixes-v1-1-cfdce629c0a8@jannau.net
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/apple/t8112-j473.dts | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/boot/dts/apple/t8112-j473.dts b/arch/arm64/boot/dts/apple/t8112-j473.dts
index 06fe257f08be4..4ae1ce919dafc 100644
--- a/arch/arm64/boot/dts/apple/t8112-j473.dts
+++ b/arch/arm64/boot/dts/apple/t8112-j473.dts
@@ -21,6 +21,25 @@ aliases {
 	};
 };
 
+/*
+ * Keep the power-domains used for the HDMI port on.
+ */
+&framebuffer0 {
+	power-domains = <&ps_dispext_cpu0>, <&ps_dptx_ext_phy>;
+};
+
+/*
+ * The M2 Mac mini uses dispext for the HDMI output so it's not necessary to
+ * keep disp0 power-domains always-on.
+ */
+&ps_disp0_sys {
+	/delete-property/ apple,always-on;
+};
+
+&ps_disp0_fe {
+	/delete-property/ apple,always-on;
+};
+
 /*
  * Force the bus number assignments so that we can declare some of the
  * on-board devices and properties that are populated by the bootloader
-- 
2.51.0

