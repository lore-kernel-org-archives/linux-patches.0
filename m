Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6770D3F8707;
	Wed, 20 May 2026 18:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300710; cv=none; b=tnJxeHaTGhQO64KbYrIGPpw4Kq5kLexSSItbtuR30X2uc7FkpN3vsFxNMG3u71Bm7u6798JOZ7OR6vU1gILoWaz9uLKq18ekR1oy6DoqOFFjyEhgSAXkKdn/Z9RP27XZeTgA4eohh0eKcFyWTGoCXDCKXRVT6rndIRLbQVo/4oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300710; c=relaxed/simple;
	bh=/ELOZQXim7Jf+M3VTpqiCJW9i2TXV9aLa4Ie/YXs6AI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYW8jaXP1i8dFEtQxSUWQEjYMQOoJidzrceZyNiVujDzyR5g76mSc4+3BZ4R/gePDVuozxUMtn2V9YW98VoVH331mhSiHkgQrlgRLdsBTl8ZT2qXgaFX/c9sebbLrk9S38uCcmmRr3EhB1tFlvofaUCjuR+D64OESCJ0kRc3Mwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gLm3hljh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gLm3hljh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE32E1F000E9;
	Wed, 20 May 2026 18:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300709;
	bh=NcdpxGqzkPRoevkFx3e3538KkLTlaEuada8SgHJ+Gpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gLm3hljhFpXfQrr5z+DBC6O5buqMRnXoVvRtX9rERdle42sD8mFiRUFpbZFADMuqR
	 +qq2f/Fs0f4tW9SQ7j/271VOk/PVr62xGtTNuHA2HUDqvgFx067KkaYCWGasXdYVph
	 JZ3G2aHUSuT4IIwhZu0TS9BVTOQV5Itk3CSC8KXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sydarn <sydarn@proton.me>,
	Chris Morgan <macromorgan@hotmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 278/666] arm64: dts: rockchip: Correct Joystick Axes on Gameforce Ace
Date: Wed, 20 May 2026 18:18:09 +0200
Message-ID: <20260520162117.238150989@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
index dc1639574f367..b9a17108e1acd 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts
@@ -59,8 +59,8 @@ axis@0 {
 			reg = <0>;
 			abs-flat = <40>;
 			abs-fuzz = <30>;
-			abs-range = <0 4095>;
-			linux,code = <ABS_RX>;
+			abs-range = <4095 0>;
+			linux,code = <ABS_RY>;
 		};
 
 		axis@1 {
@@ -68,7 +68,7 @@ axis@1 {
 			abs-flat = <40>;
 			abs-fuzz = <30>;
 			abs-range = <0 4095>;
-			linux,code = <ABS_RY>;
+			linux,code = <ABS_RX>;
 		};
 
 		axis@2 {
@@ -76,7 +76,7 @@ axis@2 {
 			abs-flat = <40>;
 			abs-fuzz = <30>;
 			abs-range = <0 4095>;
-			linux,code = <ABS_Y>;
+			linux,code = <ABS_X>;
 		};
 
 		axis@3 {
@@ -84,7 +84,7 @@ axis@3 {
 			abs-flat = <40>;
 			abs-fuzz = <30>;
 			abs-range = <0 4095>;
-			linux,code = <ABS_X>;
+			linux,code = <ABS_Y>;
 		};
 	};
 
-- 
2.53.0



