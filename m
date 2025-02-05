Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B20416CD1D;
	Wed,  5 Feb 2025 14:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767089; cv=none; b=A+ARCGv7uem4V5sBTNHWeu2s1W7635V6QznVaHMCsFtgVFxv253fK9yABTvnFl03df9H71YGBuuj8C/Meg1zLURJz7O47rNTwCp9dIyg2vuR7r6aMn+v1fJSTTgpn/6OmOxmDdAM/s1ZyDrWaq5/+/kLvI0Yr78NxcqBWvp2v0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767089; c=relaxed/simple;
	bh=vQIDfsskSjDItqdWd6+vgxIGWjhaS6vplW63VITOP8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j01iph6QeObb8F+nBsMXdB7+sQ9jblxZmEYD4xDO5Xm+/oVlbPLpH3hMF7EfEQlYKoyxEdiC6cJsVHxODiMiO2CvZ1OLGvgK93r1SAd/00fMyielVQ0ajeG10DfCO/XsTkfg0hAuralLRSh5qMimD/uqOLwcd6rQbHGtII+aWPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sh9Qxozt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sh9Qxozt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC95C4CED6;
	Wed,  5 Feb 2025 14:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767089;
	bh=vQIDfsskSjDItqdWd6+vgxIGWjhaS6vplW63VITOP8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sh9Qxoztof30s5yrrvQrvJNQCaMQ889QUQBL6OupkFzoaTezSKn+kTGoRpeSnPqMh
	 2BrEySTykPBowgXH1urYSPw3K4gTUaoNjwXWdGkodqDvQqCFQnFRu+0iP5JQXRLSuM
	 IjO3fwALyvs06eFTxkSppodNj0EVajBcdvjDHk7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricky CX Wu <ricky.cx.wu.wiwynn@gmail.com>,
	Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 355/623] ARM: dts: aspeed: yosemite4: Add required properties for IOE on fan boards
Date: Wed,  5 Feb 2025 14:41:37 +0100
Message-ID: <20250205134509.807328040@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricky CX Wu <ricky.cx.wu.wiwynn@gmail.com>

[ Upstream commit c64ac96f8f8d957cdc6ec3c93dd9a6c4e6d78506 ]

Add the required properties for IO expander on fan boards.

Fixes: 2b8d94f4b4a4 ("ARM: dts: aspeed: yosemite4: add Facebook Yosemite 4 BMC")
Signed-off-by: Ricky CX Wu <ricky.cx.wu.wiwynn@gmail.com>
Signed-off-by: Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>
Link: https://patch.msgid.link/20241003074251.3818101-5-Delphine_CC_Chiu@wiwynn.com
Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-yosemite4.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-yosemite4.dts b/arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-yosemite4.dts
index 7ed76cd4fd2d0..331578b24c204 100644
--- a/arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-yosemite4.dts
+++ b/arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-yosemite4.dts
@@ -470,6 +470,8 @@
 			gpio@22{
 				compatible = "ti,tca6424";
 				reg = <0x22>;
+				gpio-controller;
+				#gpio-cells = <2>;
 			};
 
 			pwm@23{
@@ -520,6 +522,8 @@
 			gpio@22{
 				compatible = "ti,tca6424";
 				reg = <0x22>;
+				gpio-controller;
+				#gpio-cells = <2>;
 			};
 
 			pwm@23{
-- 
2.39.5



