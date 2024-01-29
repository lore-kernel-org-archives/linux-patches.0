Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDB915703C;
	Mon, 29 Jan 2024 17:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548064; cv=none; b=i5LpmARdHb167bjOtrGrjKVNj/BJ+MTVPPahvNgt43SE4c4ux5QdPge/5FhnjQkmo4F1GXjjjn0ziKp/im80pDJCs2x/O/LP5NTHV387WHGH7VT5x810Mj/fopCU8yutITpxEs8ePWk91nhfCWWB0+x2KlpZSPJr0Y3NForVfhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548064; c=relaxed/simple;
	bh=24OHfNmjq72p4JymnyT3z8IOhm9D+/ARnclOEXhLyqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQ8R83xI92fvL/t5vtP3AMEyhFJllal7njsPOtgl4FeXFYUScua5572GIcvjh2DrLiqsKEevuZ1W0XSGAmof2tpUlvBzrxle6+vMHf1s/9j4t+XkTw+Lv8B0sqD5DsjPjlCZH3y6ELfL8Gk/MZF85NpAxZv3O2QdITL2bmbcM78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K/VtyY9S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K/VtyY9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F38C43390;
	Mon, 29 Jan 2024 17:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548063;
	bh=24OHfNmjq72p4JymnyT3z8IOhm9D+/ARnclOEXhLyqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/VtyY9Su8IRlWkQnJiuOCMqwpI6y/z1l8e0dGDj+pDBmWt3wualBEt2pTkaYPXGm
	 LKupx0NVLK6S8vMDiMjvrb3eZDG6GYPOlDwZJmbV9LW+84ukBKY5iWea4gJsBZRJnc
	 4BqGNw/Y8CPTu2JBNmQWWJ7EdlKO1xnBszVXeEdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cixi Geng <cixi.geng1@unisoc.com>,
	Chunyan Zhang <chunyan.zhang@unisoc.com>
Subject: [PATCH 6.7 070/346] arm64: dts: sprd: fix the cpu node for UMS512
Date: Mon, 29 Jan 2024 09:01:41 -0800
Message-ID: <20240129170018.446182489@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cixi Geng <cixi.geng1@unisoc.com>

commit 2da4f4a7b003441b80f0f12d8a216590f652a40f upstream.

The UMS512 Socs have 8 cores contains 6 a55 and 2 a75.
modify the cpu nodes to correct information.

Fixes: 2b4881839a39 ("arm64: dts: sprd: Add support for Unisoc's UMS512")
Cc: stable@vger.kernel.org
Signed-off-by: Cixi Geng <cixi.geng1@unisoc.com>
Link: https://lore.kernel.org/r/20230711162346.5978-1-cixi.geng@linux.dev
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/sprd/ums512.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/sprd/ums512.dtsi
+++ b/arch/arm64/boot/dts/sprd/ums512.dtsi
@@ -96,7 +96,7 @@
 
 		CPU6: cpu@600 {
 			device_type = "cpu";
-			compatible = "arm,cortex-a55";
+			compatible = "arm,cortex-a75";
 			reg = <0x0 0x600>;
 			enable-method = "psci";
 			cpu-idle-states = <&CORE_PD>;
@@ -104,7 +104,7 @@
 
 		CPU7: cpu@700 {
 			device_type = "cpu";
-			compatible = "arm,cortex-a55";
+			compatible = "arm,cortex-a75";
 			reg = <0x0 0x700>;
 			enable-method = "psci";
 			cpu-idle-states = <&CORE_PD>;


