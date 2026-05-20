Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA23331A575;
	Wed, 20 May 2026 16:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295656; cv=none; b=t1RdI1rpk7euRCBKOf4zzaGwMsyzeZXg2gGcqFi0eH/+mHcCT6hpIUUYuIdRc6uAcvtOHLAO7NRv7fuOYxoBGEm9Zx6VkTvKc6ulxVlDJklpUBsIK9FZVMorEpG52WDvfNeZ0J30qiBaQXrVkhTOe6n1ihD1lp4+qt3GHzBJqWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295656; c=relaxed/simple;
	bh=YA2cHZeFdXr+2CK2zY+/wmjFqPJ3qCRZBSnh4NDPLgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XrWtqHA6D2IbNhnu1dBqmE5nAYDwEz36ubb65XB0vmBVIbTc/bpiU5AdG4yEhKU5S8YBgTZVjfVNOS19k/9AHmVUEnloE5YiVCwgvz/ahpko0FDb8K0Q+DbU/3O2VfEV0Ulylah9Rd54v8h+MyTBHYPMB1JrQbAE1RGXGbMf6nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DPLniiPF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPLniiPF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC7E1F000E9;
	Wed, 20 May 2026 16:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295655;
	bh=Bpred82wrVWRZNe6T34gcliCCDqYsH5g0spnSlR5NCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DPLniiPF1R0PsZSZYFHcPmBnqtWAaC9ms7QYDyyyjYPP3TLUF2lACBpvzWnmFOeft
	 K/Lr2bWxLHmoqmh9ZywRpg801ElnmKyoiuOem6RLjEcq/siKIOjZcohBaUnUsbkj2L
	 qXqL5MrU0dmIUdgBBLLIvAYpvfHKmmItCvyBvnQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sydarn <sydarn@proton.me>,
	Chris Morgan <macromorgan@hotmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0501/1146] arm64: dts: rockchip: Correct Joystick Axes on Gameforce Ace
Date: Wed, 20 May 2026 18:12:31 +0200
Message-ID: <20260520162159.528318328@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Morgan <macromorgan@hotmail.com>

[ Upstream commit c337c1b561c1c3016d30776d7dc2032ea4979334 ]

The Gameforce Ace's joystick axes were set incorrectly initially,
getting the X/Y and RX/RY axes backwards. Additionally, correct the
RY axis so that it is inverted.

All axes tested with evtest and outputting correct values.

Fixes: 4e946c447a04 ("arm64: dts: rockchip: Add GameForce Ace")
Reported-by: sydarn <sydarn@proton.me>
Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
Link: https://patch.msgid.link/20260310134919.550023-1-macroalpha82@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts b/arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts
index 59d2494c45100..89618394c0bfb 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts
@@ -60,8 +60,8 @@ axis@0 {
 			reg = <0>;
 			abs-flat = <40>;
 			abs-fuzz = <30>;
-			abs-range = <0 4095>;
-			linux,code = <ABS_RX>;
+			abs-range = <4095 0>;
+			linux,code = <ABS_RY>;
 		};
 
 		axis@1 {
@@ -69,7 +69,7 @@ axis@1 {
 			abs-flat = <40>;
 			abs-fuzz = <30>;
 			abs-range = <0 4095>;
-			linux,code = <ABS_RY>;
+			linux,code = <ABS_RX>;
 		};
 
 		axis@2 {
@@ -77,7 +77,7 @@ axis@2 {
 			abs-flat = <40>;
 			abs-fuzz = <30>;
 			abs-range = <0 4095>;
-			linux,code = <ABS_Y>;
+			linux,code = <ABS_X>;
 		};
 
 		axis@3 {
@@ -85,7 +85,7 @@ axis@3 {
 			abs-flat = <40>;
 			abs-fuzz = <30>;
 			abs-range = <0 4095>;
-			linux,code = <ABS_X>;
+			linux,code = <ABS_Y>;
 		};
 	};
 
-- 
2.53.0



