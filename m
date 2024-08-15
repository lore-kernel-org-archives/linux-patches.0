Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518A518CBE1;
	Thu, 15 Aug 2024 14:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732022; cv=none; b=twxqIIrn5a+k4svSFzv1T6EIGnAvYNUq9Qo12lQkwaLzWmirke26D9v3CFYGincB/BQvEjfkLkwiayO/Bl9yp5nUPCw6RK5baKgMl4DXcICug6mik0bap6T3ZAq7VJFNJK7j6EOpyjNWpzwZA+Fw3JUpPB9v8TErk0WVDdDDeG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732022; c=relaxed/simple;
	bh=XUK0neeHmiJlIshBW/r/rKhAs1DHLSLDGGxxz6anwhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ufu3wJN9ELtHFEKVlAB56Y/o7oag+nG98Uoe88KE7XC+1NtkwFNqvO4bsqdNSjSfWwPgev/ctKkxwd7KX7rdZJbv+pP6dk70KSrYEWsnaabIgP2wnbIR1Oj0GgEuY6MKPGZc2LVi4OJ3JjVQ1oUWluNJVT/xFtGHFziG6jLhy7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UOcY6hK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UOcY6hK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDDFC32786;
	Thu, 15 Aug 2024 14:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732021;
	bh=XUK0neeHmiJlIshBW/r/rKhAs1DHLSLDGGxxz6anwhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UOcY6hK7hjRRuqx2nLhp00179SreX9QMKwZ3TDdiHH/CJovpvMnvJ3HNCJwImaSov
	 Dk5NHjYNEav08ojhwI7xetefyeVCTAZFy9YKc6xoyQJ8xXmzg8tPapmrlbi5sHYMmY
	 ojHWYUbUBQm8bQpimfdF5wVDo1O3NqhOf5WQvJnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/352] arm64: dts: rockchip: Increase VOP clk rate on RK3328
Date: Thu, 15 Aug 2024 15:21:25 +0200
Message-ID: <20240815131919.959609298@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 0f2ddb128fa20f8441d903285632f2c69e90fae1 ]

The VOP on RK3328 needs to run at a higher rate in order to produce a
proper 3840x2160 signal.

Change to use 300MHz for VIO clk and 400MHz for VOP clk, same rates used
by vendor 4.4 kernel.

Fixes: 52e02d377a72 ("arm64: dts: rockchip: add core dtsi file for RK3328 SoCs")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20240615170417.3134517-2-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index 10df6636a6b6c..3c6398e98f767 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -811,8 +811,8 @@ cru: clock-controller@ff440000 {
 			<0>, <24000000>,
 			<24000000>, <24000000>,
 			<15000000>, <15000000>,
-			<100000000>, <100000000>,
-			<100000000>, <100000000>,
+			<300000000>, <100000000>,
+			<400000000>, <100000000>,
 			<50000000>, <100000000>,
 			<100000000>, <100000000>,
 			<50000000>, <50000000>,
-- 
2.43.0



