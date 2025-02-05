Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6FC15198D;
	Wed,  5 Feb 2025 14:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764882; cv=none; b=hh2oAnel7jg2fYVE28NdFsGpLpRMHPBZdeTYRxH148rvMC2fRoO9y1tZaSJ3z2f2Fv63HDLG7VvMjb7lYGPCsQeF48LuA9GluM6oeyt5enAr5DyH4SlFZK/V+aeJokWkDQ1xjli/KdLJGCJTgGLQPNuBp26hu8XCLZvfPtXlTb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764882; c=relaxed/simple;
	bh=gnEmQbnR/XZaMvjABwhBr5TRBsace5RFmZA8pojcCP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emWyWT1xcn8D/nJ4QY1RYguu2T1r78NkXD6CHGLZjYWfpj/2VJMHLsqlBTHVSvYET6qKi6zaWXGi9vu2qHQ83R6zl/K6R7O9zdBGXun80b5x3VzLxlPav7MQbImWqdgHq3xrK3cSgPrYZA9Y07gnjhOWowekv+75EuG3uiJbfmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLpQzcBb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLpQzcBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381C7C4CED1;
	Wed,  5 Feb 2025 14:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764882;
	bh=gnEmQbnR/XZaMvjABwhBr5TRBsace5RFmZA8pojcCP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLpQzcBb749de717TtiBLxQLoU2Z9JYE2zwef5gv31+uyTquO2lh8IT7MYJdXR/Pr
	 bxhnP5rRC8XIlqomN0x2TLq4Gb+mgFwlqsxOkuoLFfd6ZQ4l/yCOJBqcc0+HBDNuJc
	 Y63rn6z3yyrdp8QXnm6cU4Qd8GhUT9BNG9kq0GdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricky CX Wu <ricky.cx.wu.wiwynn@gmail.com>,
	Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 212/393] ARM: dts: aspeed: yosemite4: correct the compatible string of adm1272
Date: Wed,  5 Feb 2025 14:42:11 +0100
Message-ID: <20250205134428.411196383@linuxfoundation.org>
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

[ Upstream commit ece3e20e3389ec8a32944ad44746ee379bf1d3eb ]

Remove the space in the compatible string of adm1272 to match the
pattern of compatible.

Fixes: 2b8d94f4b4a4 ("ARM: dts: aspeed: yosemite4: add Facebook Yosemite 4 BMC")
Signed-off-by: Ricky CX Wu <ricky.cx.wu.wiwynn@gmail.com>
Signed-off-by: Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>
Fixes: 2b8d94f4b4a4765d ("ARM: dts: aspeed: yosemite4: add Facebook Yosemite 4 BMC")
Reviewed-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Link: https://patch.msgid.link/20240927085213.331127-1-Delphine_CC_Chiu@wiwynn.com
Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-yosemite4.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-yosemite4.dts b/arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-yosemite4.dts
index 64075cc41d927..ac15fee7245a1 100644
--- a/arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-yosemite4.dts
+++ b/arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-yosemite4.dts
@@ -284,12 +284,12 @@
 &i2c11 {
 	status = "okay";
 	power-sensor@10 {
-		compatible = "adi, adm1272";
+		compatible = "adi,adm1272";
 		reg = <0x10>;
 	};
 
 	power-sensor@12 {
-		compatible = "adi, adm1272";
+		compatible = "adi,adm1272";
 		reg = <0x12>;
 	};
 
-- 
2.39.5



