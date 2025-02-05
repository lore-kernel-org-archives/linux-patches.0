Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22F116DED2;
	Wed,  5 Feb 2025 14:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767082; cv=none; b=U+4tpy0CJrfq45JwGGBJPwdxgTboveSyhokHowFeFPsCGAWqltIYuQfq/aUEDeqEnFblNfSDLFNegW6ooS2g9LNiXNwqA1NJMAqo6I6jn02cjmGQbNy/VFQs+PW8pqgp/Cz4qL/En621xujiOy9o9/14+WaJwVz4emWDbHlD68c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767082; c=relaxed/simple;
	bh=pZ+ZCykIz7Z+WBet3EJDrsXWpnKhsXsyNe0bijr7SQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyGHSMLw4SUH85meDZMi306/3lG99vTaBB2k9ZDqx6IuTzIafWecxCAu+Bg/dHlKJe1wR2Mn7e0Lw8f6SUS4n6ggREsSVHd/mkaCWO8ivlWwzl1HU+q6l69TTw89n6OmQ3bqB/0r8DjdiglisMueZapJNBn5RQtLg6vj6EU3LvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JT2ex5Ue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JT2ex5Ue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CEC7C4CED6;
	Wed,  5 Feb 2025 14:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767082;
	bh=pZ+ZCykIz7Z+WBet3EJDrsXWpnKhsXsyNe0bijr7SQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JT2ex5UeHyATRRR07j6BLTI7DanW2NyOSlyUBbJabeU5hoG3XYuhOxOcmvJdfsvu2
	 W0wmkfnh9FUyNNA1v2vphEQQaxop/iJ+i391ppPt3HOkGfLIECK3ytPWKiKd4GC+RU
	 Y7CYWNEfo8FOj75xLH+fQx5WnMrjaX84p1FFYhWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricky CX Wu <ricky.cx.wu.wiwynn@gmail.com>,
	Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 354/623] ARM: dts: aspeed: yosemite4: correct the compatible string of adm1272
Date: Wed,  5 Feb 2025 14:41:36 +0100
Message-ID: <20250205134509.769430044@linuxfoundation.org>
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
index 98477792aa005..7ed76cd4fd2d0 100644
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



