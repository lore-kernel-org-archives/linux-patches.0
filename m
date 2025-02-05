Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D6515198D;
	Wed,  5 Feb 2025 14:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764893; cv=none; b=KIqYuzYN4aW70zqptieL6Vls07UUsNPDIWXlj21GpG+wNJ3G6WiXbPP6eTUk0SKEsxUSn5r/aK0EXjnAzBkALVdY/cxXkOq5KmCUksRQcofrTsV6br36hka+dKrxb8Vr8pAzSNCBN26XM2DYiqvp38+wTWCt1l/gMRd0KFVRRFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764893; c=relaxed/simple;
	bh=og9EooFdLSn5ioKfFlnBrSC3MS77VlfDQTbjM7eiB6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Is4vK+GfT6F6G0lh3YajBt7ciI62Kb4iy9EoRajKTztPj+2kZ8Yf2dVxXgoU1WF929IzWzCDVmh5eSq1E+ak1GPTFlOkQEZI/HFLMAN2SlMXeQ0kZz+v+zgCJFyI4lq7JT96RAcreC/0JVFkh9CnX66ZRwtbbflGgs1pK+nMz7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AtJGUayN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AtJGUayN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B39BC4CED1;
	Wed,  5 Feb 2025 14:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764892;
	bh=og9EooFdLSn5ioKfFlnBrSC3MS77VlfDQTbjM7eiB6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AtJGUayNg1og+SiVvBu7n9OieU7VRTRBpigbWkBpxZEC5DerzXj6LlIwoy+7xiDhS
	 N+4Rq7v8q4ddUMA+3iPL0pU72f4nTCMvW/5VRYM98JAN1y1X5zE8KHPjrsW4y4bwYQ
	 Nenm+MJgnUwVrYF6mlnYtHKmPTxsglPuMnswToF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricky CX Wu <ricky.cx.wu.wiwynn@gmail.com>,
	Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 213/393] ARM: dts: aspeed: yosemite4: Add required properties for IOE on fan boards
Date: Wed,  5 Feb 2025 14:42:12 +0100
Message-ID: <20250205134428.449560664@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ac15fee7245a1..e9eaffa9b504e 100644
--- a/arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-yosemite4.dts
+++ b/arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-yosemite4.dts
@@ -463,6 +463,8 @@
 			gpio@22{
 				compatible = "ti,tca6424";
 				reg = <0x22>;
+				gpio-controller;
+				#gpio-cells = <2>;
 			};
 
 			pwm@23{
@@ -513,6 +515,8 @@
 			gpio@22{
 				compatible = "ti,tca6424";
 				reg = <0x22>;
+				gpio-controller;
+				#gpio-cells = <2>;
 			};
 
 			pwm@23{
-- 
2.39.5



