Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E1D36C9D2;
	Wed, 20 May 2026 17:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298382; cv=none; b=ukOzr+I7nrciAFlFKWaXz5IP7kR4LKPJj94sikHTr8JTVotY64nYr+p1BIgFzb9yay7K3siqgzB3//znpjcc6mAgYfpuR7ZhznUjQ+8uGayxHRqq2hYgs+NRz1tPcI8yp9kEl5Aaja+t1zK5kK9xVs9jRg9RffdJWS62GCNiUDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298382; c=relaxed/simple;
	bh=S0CXRPXfaGyadFfDi8gcAMx+P/CIF92+HT7iND9R/Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qw61IaO3FeokP4c9LF9ANOicmmj8wViRdurNoGc/Hha7pNRBKrM93sre0vYoePaJz8BpAg0XjSOjnMPI56E7CIKAYHJFlweffrseABHOpGYLRY9GhlbCOGnamEF8SyA04TkmsTT+EShLgUiG3L+puimJQ2hoKYh8jQWdONLg/yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=107lVdV2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="107lVdV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33DF1F000E9;
	Wed, 20 May 2026 17:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298381;
	bh=vAA+D7AIRBMHiaZiXvjl8wkwWt6aMD20qQvjN0fmWNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=107lVdV2pvMHimypZCAryI4KwtyfQitNnPoNmR753Akp2bFb+5h5Tq72xYOt28EjA
	 8FuNv3JKuPZfSMS8fdc5NvCb7wfb4grcQUwOss0TKmRv6zYt7BXUz2rsRN0O6tQ03e
	 WXMkHt+OBZ+FhHboHm/KQ+5GoJoPpCX4bdwiV7nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sydarn <sydarn@proton.me>,
	Chris Morgan <macromorgan@hotmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 388/957] arm64: dts: rockchip: Correct Joystick Axes on Gameforce Ace
Date: Wed, 20 May 2026 18:14:31 +0200
Message-ID: <20260520162142.941820740@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index ef8805219ea16..afac54ba58318 100644
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



