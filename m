Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8315328C6;
	Wed, 23 Sep 2026 14:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172746; cv=none; b=Qi51Yccn16MFdzvY90Mk0lXV9BdtNVGM28t9QeD+sYx6Bu/vBB5/yFIJaLETrIRFmDTsT1EUgKME6fZD3zqOhghnquaXLgf2162GGMdmGadSNSJz9O4DxDtQ1KdjCJlmfK+0TSaILHQIsqZx/bGDQsz1iySs0MIRx2STixxxypk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172746; c=relaxed/simple;
	bh=kaEKn6RoqD5eeVDHiBHv4927Jx7gS30A4ieUohe7faY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rh2dsAPTCf9WduEG+EGT/TKq2luaV7cwFyT1fEJTfG4Oz3dsknTmzhBbXqPljiEny+q6dEWLkk8gdD05mDiYYYDEuRc//fg9ziKODAfuByCSRwSPFmFvzyGl3AFlmuXyAKe39UyPp0wEV6bkGSjF22uZvYd3fZZif2k7H6/iDEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qTHHDsnh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qTHHDsnh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6629F1F000FF;
	Wed, 23 Sep 2026 14:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172745;
	bh=Z4zOxgIWsOnPpnwdJpAbWFbdBJFCr6oVPqmd4EajtJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qTHHDsnhkqFf58bX2sZyvFAIxyHzOJTIGAcW+ScfaG+QLQjyYREB/3h4xU6iVEmwn
	 iml94UJ0KXXFVCsEbt+etgI6ipv01EFnBcx4dn19tZNJ+jjnVk0heu54CKFSw7T3XZ
	 WIveghP6HicUK649GHYHoCqntQ+NXAcCKkFgIlYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tanure <tanure@linux.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 013/438] arm64: dts: amlogic: t7: fix the pin groups of two PWM outputs
Date: Wed, 23 Sep 2026 16:00:34 +0200
Message-ID: <20260923140645.118479142@linuxfoundation.org>
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

[ Upstream commit ae7be5c58a819259e5eb98a3abfa60842478f2ae ]

Two of the PWM outputs can each appear on more than one pin, but the
description named a single group that does not exist, so anything using
it refused to start.

Name the real groups instead, one entry per pin, the same way the other
multi-pin PWM output is already described.

Fixes: 2a2a7b9701a7 ("arm64: dts: amlogic: t7: Add PWM pinctrl nodes")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Lucas Tanure <tanure@linux.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260829094758.23248-3-tanure@linux.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi | 32 ++++++++++++++++++---
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi b/arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi
index cc371fcd18967..66605b200b708 100644
--- a/arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi
+++ b/arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi
@@ -458,9 +458,25 @@ mux {
 					};
 				};
 
-				pwm_ao_g_pins: pwm-ao-g {
+				pwm_ao_g_d11_pins: pwm-ao-g-d11 {
 					mux {
-						groups = "pwm_ao_g";
+						groups = "pwm_ao_g_d11";
+						function = "pwm_ao_g";
+						bias-disable;
+					};
+				};
+
+				pwm_ao_g_d7_pins: pwm-ao-g-d7 {
+					mux {
+						groups = "pwm_ao_g_d7";
+						function = "pwm_ao_g";
+						bias-disable;
+					};
+				};
+
+				pwm_ao_g_e_pins: pwm-ao-g-e {
+					mux {
+						groups = "pwm_ao_g_e";
 						function = "pwm_ao_g";
 						bias-disable;
 					};
@@ -474,9 +490,17 @@ mux {
 					};
 				};
 
-				pwm_ao_h_pins: pwm-ao-h {
+				pwm_ao_h_d5_pins: pwm-ao-h-d5 {
+					mux {
+						groups = "pwm_ao_h_d5";
+						function = "pwm_ao_h";
+						bias-disable;
+					};
+				};
+
+				pwm_ao_h_d10_pins: pwm-ao-h-d10 {
 					mux {
-						groups = "pwm_ao_h";
+						groups = "pwm_ao_h_d10";
 						function = "pwm_ao_h";
 						bias-disable;
 					};
-- 
2.53.0



